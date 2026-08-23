$ErrorActionPreference = 'Stop'

$projectDir = $PSScriptRoot
$clipDir = Join-Path $projectDir 'final\story-clips'
$frameDir = Join-Path $projectDir 'final\story-frames'
$ffmpegRoot = 'C:\Users\angdo\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe'
$ffmpeg = Get-ChildItem -LiteralPath $ffmpegRoot -Recurse -Filter 'ffmpeg.exe' -File | Select-Object -First 1 -ExpandProperty FullName
if (-not $ffmpeg) { throw 'ffmpeg.exe was not found.' }

New-Item -ItemType Directory -Force -Path $frameDir | Out-Null
$clips = @('01-mat-to-placement.mp4', '02-placement-to-roll.mp4', '03-roll-to-finished.mp4')

for ($index = 0; $index -lt $clips.Count; $index++) {
  $clip = Join-Path $clipDir $clips[$index]
  if (-not (Test-Path -LiteralPath $clip)) { throw "Missing story clip: $clip" }
  $offset = $index * 40
  $output = Join-Path $frameDir 'F%03d.webp'
  & $ffmpeg -hide_banner -loglevel error -i $clip -vf 'fps=8,scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih):0xf3efe6' -frames:v 40 -start_number $offset -c:v libwebp -quality 88 -y $output
}

$frames = Get-ChildItem -LiteralPath $frameDir -Filter 'F*.webp' -File | Sort-Object Name
if ($frames.Count -ne 120) { throw "Expected 120 extracted frames, found $($frames.Count)." }
[pscustomobject]@{ FrameCount = $frames.Count; Directory = $frameDir; First = $frames[0].Name; Last = $frames[-1].Name } | Format-List
