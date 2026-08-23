$ErrorActionPreference = 'Stop'

$projectDir = $PSScriptRoot
$workspaceDir = Split-Path -Parent $projectDir
$envPath = Join-Path $workspaceDir '.env'
$source = Join-Path $projectDir 'final\video\K4-gimbap-roll-start.png'
$output = Join-Path $projectDir 'final\video\K4-gimbap-roll-wan-720p.mp4'
$statusPath = Join-Path $projectDir 'final\video\K4-wan-generation-status.json'

$falLine = Get-Content -LiteralPath $envPath | Where-Object { $_ -match '^\s*FAL_KEY\s*=' } | Select-Object -First 1
if (-not $falLine) { throw 'FAL_KEY was not found in the workspace .env file.' }
$falKey = (($falLine -split '=', 2)[1]).Trim().Trim('"').Trim("'")
if (-not $falKey) { throw 'FAL_KEY is empty.' }

$status = [ordered]@{
  status = 'running'
  model = 'fal-ai/wan-25-preview/image-to-video'
  resolution = '720p'
  duration = 5
  input = (Split-Path $source -Leaf)
  output = (Split-Path $output -Leaf)
  startedAt = (Get-Date).ToString('o')
}
$status | ConvertTo-Json | Set-Content -LiteralPath $statusPath -Encoding utf8

try {
  $imageData = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($source))
  $payload = @{
    image_url = "data:image/png;base64,$imageData"
    prompt = 'Preserve the exact hand-drawn monochrome ink illustration, gimbap roll, bamboo mat, composition, and warm paper background. The gimbap and mat stay completely still. The separate round gimbap brand mark in the upper right performs one clear, intentional beat: lift gently upward, arc left in a small smooth semicircle, grow slightly, then settle softly back into its original upper-right position and hold. Smooth deliberate editorial ink animation. Locked camera. No audio.'
    negative_prompt = 'gimbap rolling or moving, mat movement, camera movement, zoom, pan, new objects, hands, text, labels, warped food, morphing, jitter, distortion, background changes'
    resolution = '720p'
    duration = '5'
    enable_prompt_expansion = $false
  } | ConvertTo-Json -Compress

  $response = Invoke-RestMethod -Uri 'https://fal.run/fal-ai/wan-25-preview/image-to-video' -Method Post -Headers @{ Authorization = "Key $falKey" } -ContentType 'application/json' -Body $payload -TimeoutSec 900
  $videoUrl = $response.video.url
  if (-not $videoUrl) { $videoUrl = $response.data.video.url }
  if (-not $videoUrl) { throw "fal returned no video URL. Response keys: $($response.PSObject.Properties.Name -join ', ')" }

  Invoke-WebRequest -Uri $videoUrl -OutFile $output -TimeoutSec 900
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
