$ErrorActionPreference = 'Stop'

$projectDir = $PSScriptRoot
$workspaceDir = Split-Path -Parent $projectDir
$envPath = Join-Path $workspaceDir '.env'
$source = Join-Path $projectDir 'final\video\K4-gimbap-roll-start.png'
$output = Join-Path $projectDir 'final\video\K4-gimbap-roll.mp4'
$statusPath = Join-Path $projectDir 'final\video\K4-generation-status.json'

$falLine = Get-Content -LiteralPath $envPath | Where-Object { $_ -match '^\s*FAL_KEY\s*=' } | Select-Object -First 1
if (-not $falLine) { throw 'FAL_KEY was not found in the workspace .env file.' }
$falKey = (($falLine -split '=', 2)[1]).Trim().Trim('"').Trim("'")
if (-not $falKey) { throw 'FAL_KEY is empty.' }

$status = [ordered]@{
  status = 'running'
  model = 'fal-ai/stable-video'
  input = (Split-Path $source -Leaf)
  output = (Split-Path $output -Leaf)
  startedAt = (Get-Date).ToString('o')
}
$status | ConvertTo-Json | Set-Content -LiteralPath $statusPath -Encoding utf8

try {
  $imageData = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($source))
  $payload = @{
    image_url = "data:image/png;base64,$imageData"
    motion_bucket_id = 20
    cond_aug = 0.01
    fps = 24
  } | ConvertTo-Json -Compress

  $response = Invoke-RestMethod -Uri 'https://fal.run/fal-ai/stable-video' -Method Post -Headers @{ Authorization = "Key $falKey" } -ContentType 'application/json' -Body $payload -TimeoutSec 600
  $videoUrl = $response.video.url
  if (-not $videoUrl) { $videoUrl = $response.data.video.url }
  if (-not $videoUrl) { throw "fal returned no video URL. Response keys: $($response.PSObject.Properties.Name -join ', ')" }

  Invoke-WebRequest -Uri $videoUrl -OutFile $output -TimeoutSec 600
  $status.status = 'completed'
  $status.completedAt = (Get-Date).ToString('o')
  $status.bytes = (Get-Item -LiteralPath $output).Length
} catch {
  $status.status = 'failed'
  $status.completedAt = (Get-Date).ToString('o')
  $status.error = $_.Exception.Message
  exit 1
} finally {
  $status | ConvertTo-Json | Set-Content -LiteralPath $statusPath -Encoding utf8
}
