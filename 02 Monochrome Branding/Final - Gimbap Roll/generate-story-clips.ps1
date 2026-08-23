$ErrorActionPreference = 'Stop'

$projectDir = $PSScriptRoot
$workspaceDir = Split-Path -Parent $projectDir
$envPath = Join-Path $workspaceDir '.env'
$sourceDir = Join-Path $projectDir 'final\story-source'
$outputDir = Join-Path $projectDir 'final\story-clips'
$statusPath = Join-Path $outputDir 'generation-status.json'
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$falLine = Get-Content -LiteralPath $envPath | Where-Object { $_ -match '^\s*FAL_KEY\s*=' } | Select-Object -First 1
if (-not $falLine) { throw 'FAL_KEY was not found in the workspace .env file.' }
$falKey = (($falLine -split '=', 2)[1]).Trim().Trim('"').Trim("'")
if (-not $falKey) { throw 'FAL_KEY is empty.' }

$beats = @(
  [ordered]@{
    id = '01-mat-to-placement'
    start = 'K0.png'
    end = 'K1.png'
    prompt = 'Locked three-quarter camera, hand-drawn monochrome ink illustration on warm paper. Start with the empty bamboo rolling mat. A single outlined hand enters calmly from the upper left and places the loose gimbap horizontally onto the center of the mat. End exactly with the hand resting gently on the roll. Keep the bamboo mat, black nori, rice, and small muted-red accents faithful to the supplied end frame. Deliberate, readable food-making motion. No camera movement.'
  },
  [ordered]@{
    id = '02-placement-to-roll'
    start = 'K1.png'
    end = 'K2.png'
    prompt = 'Locked three-quarter camera, hand-drawn monochrome ink illustration on warm paper. Continue the exact supplied gimbap scene. The same hand lifts the near edge of the bamboo mat and rolls it smoothly forward around the gimbap. The mat visibly curls in a clean arc, then reaches the supplied mid-roll pose. Preserve the hand, nori texture, rice, filling, mat proportions, and muted-red cords. One clear rolling action only. No camera movement.'
  },
  [ordered]@{
    id = '03-roll-to-finished'
    start = 'K2.png'
    end = 'K3.png'
    prompt = 'Locked three-quarter camera, hand-drawn monochrome ink illustration on warm paper. Finish the gimbap roll: the bamboo mat opens flat, the hand lifts away and exits upward-left, and the completed roll settles horizontally at center. The round gimbap brand mark appears cleanly at upper right and holds. End exactly on the supplied final frame. Preserve the ink linework, black nori texture, rice, muted-red accents, composition, and background. No camera movement, no extra props.'
  }
)

$status = [ordered]@{
  status = 'running'
  model = 'fal-ai/kling-video/v3/pro/image-to-video'
  clips = @()
  startedAt = (Get-Date).ToString('o')
}
$status | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $statusPath -Encoding utf8

try {
  foreach ($beat in $beats) {
    $startPath = Join-Path $sourceDir $beat.start
    $endPath = Join-Path $sourceDir $beat.end
    $outputPath = Join-Path $outputDir "$($beat.id).mp4"
    $startData = "data:image/png;base64,$([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($startPath)))"
    $endData = "data:image/png;base64,$([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($endPath)))"
    $payload = @{
      start_image_url = $startData
      end_image_url = $endData
      prompt = $beat.prompt
      negative_prompt = 'camera movement, zoom, panning, scene change, extra hands, extra rolls, extra food, text, labels, watermark, photorealism, blur, distortion, morphing, jitter'
      duration = '5'
      generate_audio = $false
      cfg_scale = 0.7
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri 'https://fal.run/fal-ai/kling-video/v3/pro/image-to-video' -Method Post -Headers @{ Authorization = "Key $falKey" } -ContentType 'application/json' -Body $payload -TimeoutSec 900
    $videoUrl = $response.video.url
    if (-not $videoUrl) { $videoUrl = $response.data.video.url }
    if (-not $videoUrl) { throw "fal returned no video URL for $($beat.id). Response keys: $($response.PSObject.Properties.Name -join ', ')" }
    Invoke-WebRequest -Uri $videoUrl -OutFile $outputPath -TimeoutSec 900
    $status.clips += [ordered]@{ id = $beat.id; status = 'completed'; output = (Split-Path $outputPath -Leaf); bytes = (Get-Item -LiteralPath $outputPath).Length }
    $status | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $statusPath -Encoding utf8
  }
  $status.status = 'completed'
  $status.completedAt = (Get-Date).ToString('o')
} catch {
  $status.status = 'failed'
  $status.completedAt = (Get-Date).ToString('o')
  $status.error = $_.Exception.Message
  exit 1
} finally {
  $status | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $statusPath -Encoding utf8
}
