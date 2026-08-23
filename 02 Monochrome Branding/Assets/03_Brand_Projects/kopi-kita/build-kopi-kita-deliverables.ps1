Set-StrictMode -Version Latest
Add-Type -AssemblyName System.Drawing

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path -LiteralPath (Join-Path $ScriptRoot "..\..\..")
$FinalDir = Join-Path $RepoRoot "Final - Kopi Kita"
$AssetDir = Join-Path $FinalDir "assets"
$MotionDir = Join-Path $ScriptRoot "03_Motion_Assets\kopi-kita-pour-motion"
$MotionFrames = Join-Path $MotionDir "final\keyframes-alpha"
$Primary = Join-Path $ScriptRoot "01_Identity_Assets\identity-delivery\kopi-kita-primary-illustration-alpha.png"
$Moodboard = Join-Path $ScriptRoot "02_Portfolio_Direction\kopi-kita-moodboard.png"

New-Item -ItemType Directory -Force -Path $AssetDir | Out-Null
New-Item -ItemType Directory -Force -Path $MotionFrames | Out-Null

$Ink = [System.Drawing.ColorTranslator]::FromHtml("#16130F")
$Kopi = [System.Drawing.ColorTranslator]::FromHtml("#38241A")
$Paper = [System.Drawing.ColorTranslator]::FromHtml("#EBE1CF")
$PaperDeep = [System.Drawing.ColorTranslator]::FromHtml("#E2D6BF")
$Transfer = [System.Drawing.ColorTranslator]::FromHtml("#2F4131")
$Steel = [System.Drawing.ColorTranslator]::FromHtml("#978881")
$Line = [System.Drawing.Color]::FromArgb(75, 22, 19, 15)

function Brush($color) { New-Object System.Drawing.SolidBrush($color) }
function PenX($color, [float]$width) {
  $p = New-Object System.Drawing.Pen($color, $width)
  $p.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $p.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $p.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  return $p
}
function FontX([string]$family, [float]$size, [System.Drawing.FontStyle]$style = [System.Drawing.FontStyle]::Regular) {
  New-Object System.Drawing.Font($family, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}
function Draw-Text([System.Drawing.Graphics]$g, [string]$text, [System.Drawing.Font]$font, [System.Drawing.Brush]$brush, [float]$x, [float]$y) {
  $rect = [System.Drawing.RectangleF]::new([single]$x, [single]$y, 5000, 500)
  $g.DrawString($text, $font, $brush, $rect)
}
function Draw-LetterSpaced([System.Drawing.Graphics]$g, [string]$text, [System.Drawing.Font]$font, [System.Drawing.Brush]$brush, [float]$x, [float]$y, [float]$track) {
  Draw-Text $g $text $font $brush $x $y
}
function LetterSpaced-Width([System.Drawing.Graphics]$g, [string]$text, [System.Drawing.Font]$font, [float]$track) {
  return $g.MeasureString($text, $font).Width
}
function Save-Png($bmp, [string]$path) {
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}
function New-Board([int]$w, [int]$h, [System.Drawing.Color]$bg) {
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear($bg)
  return @{ Bitmap = $bmp; Graphics = $g; W = $w; H = $h }
}
function Finish-Board($ctx, [string]$path) {
  $ctx.Graphics.Dispose()
  Save-Png $ctx.Bitmap $path
}
function Draw-Meta($g, [string]$left, [string]$right, [int]$w) {
  $f = FontX "Arial" 17 ([System.Drawing.FontStyle]::Bold)
  Draw-LetterSpaced $g $left.ToUpperInvariant() $f (Brush $Ink) 58 54 5
  $rightWidth = LetterSpaced-Width $g $right.ToUpperInvariant() $f 5
  Draw-LetterSpaced $g $right.ToUpperInvariant() $f (Brush $Ink) ($w - 58 - $rightWidth) 54 5
}
function Add-Grain($g, [int]$w, [int]$h) {
  $rand = New-Object System.Random 42
  $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(10, 22, 19, 15), 1)
  for ($i = 0; $i -lt 900; $i++) {
    $x = $rand.Next(0, $w)
    $y = $rand.Next(0, $h)
    $g.DrawLine($pen, $x, $y, $x + 1, $y)
  }
  $pen.Dispose()
}
function Draw-TileGrid($g, [int]$x, [int]$y, [int]$w, [int]$h) {
  $g.FillRectangle((Brush $PaperDeep), $x, $y, $w, $h)
  $p = PenX $Line 1
  for ($ix = $x; $ix -le ($x + $w); $ix += 80) { $g.DrawLine($p, $ix, $y, $ix, $y + $h) }
  for ($iy = $y; $iy -le ($y + $h); $iy += 80) { $g.DrawLine($p, $x, $iy, $x + $w, $iy) }
  $p.Dispose()
}
function Draw-Primary($g, [int]$x, [int]$y, [int]$w, [int]$h) {
  $img = [System.Drawing.Image]::FromFile($Primary)
  $scale = [Math]::Min($w / $img.Width, $h / $img.Height)
  $dw = [int]($img.Width * $scale)
  $dh = [int]($img.Height * $scale)
  $dx = $x + [int](($w - $dw) / 2)
  $dy = $y + [int](($h - $dh) / 2)
  $g.DrawImage($img, $dx, $dy, $dw, $dh)
  $img.Dispose()
}
function Draw-CoverImage($g, [string]$path, [int]$x, [int]$y, [int]$w, [int]$h) {
  $img = [System.Drawing.Image]::FromFile($path)
  $scale = [Math]::Max($w / $img.Width, $h / $img.Height)
  $sw = [int]($w / $scale)
  $sh = [int]($h / $scale)
  $sx = [int](($img.Width - $sw) / 2)
  $sy = [int](($img.Height - $sh) / 2)
  $src = [System.Drawing.Rectangle]::new($sx, $sy, $sw, $sh)
  $dest = [System.Drawing.Rectangle]::new($x, $y, $w, $h)
  $g.DrawImage($img, $dest, $src, [System.Drawing.GraphicsUnit]::Pixel)
  $img.Dispose()
}
function CupPath([float]$x, [float]$y, [float]$s) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddBezier($x + 74*$s, $y + 98*$s, $x + 80*$s, $y + 172*$s, $x + 100*$s, $y + 204*$s, $x + 160*$s, $y + 206*$s)
  $path.AddBezier($x + 160*$s, $y + 206*$s, $x + 220*$s, $y + 204*$s, $x + 240*$s, $y + 172*$s, $x + 246*$s, $y + 98*$s)
  return $path
}
function Draw-SmallMark($g, [float]$x, [float]$y, [float]$s, [System.Drawing.Color]$stroke, [System.Drawing.Color]$paper, [bool]$fillCup = $true) {
  $penOuter = PenX $stroke (9*$s)
  $penInner = PenX $stroke (4*$s)
  $fill = Brush $paper
  $cup = CupPath $x $y $s
  if ($fillCup) { $g.FillPath($fill, $cup) }
  $g.DrawPath($penOuter, $cup)
  $g.DrawEllipse($penOuter, $x + 64*$s, $y + 84*$s, 192*$s, 34*$s)
  $g.DrawArc($penOuter, $x + 232*$s, $y + 120*$s, 60*$s, 62*$s, -70, 245)
  $g.DrawEllipse($penOuter, $x + 32*$s, $y + 205*$s, 256*$s, 42*$s)
  $g.DrawEllipse($penInner, $x + 78*$s, $y + 211*$s, 164*$s, 23*$s)
  $g.DrawBezier($penOuter, $x + 164*$s, $y + 28*$s, $x + 178*$s, $y + 72*$s, $x + 175*$s, $y + 96*$s, $x + 176*$s, $y + 113*$s)
  $g.DrawBezier($penInner, $x + 108*$s, $y + 162*$s, $x + 138*$s, $y + 174*$s, $x + 184*$s, $y + 174*$s, $x + 214*$s, $y + 162*$s)
  foreach ($pt in @(@(132,156),@(160,162),@(188,156))) {
    $g.FillEllipse((Brush $stroke), $x + ($pt[0]-5)*$s, $y + ($pt[1]-5)*$s, 10*$s, 10*$s)
  }
  $cup.Dispose(); $penOuter.Dispose(); $penInner.Dispose(); $fill.Dispose()
}
function Draw-Wordmark($g, [string]$mode, [float]$x, [float]$y, [float]$size, [System.Drawing.Color]$color) {
  $font = FontX "Arial Black" $size ([System.Drawing.FontStyle]::Bold)
  $b = Brush $color
  if ($mode -eq "stacked") {
    Draw-Text $g "KOPI" $font $b $x $y
    Draw-Text $g "KITA" $font $b $x ($y + $size * .78)
  } else {
    Draw-LetterSpaced $g "KOPI KITA" $font $b $x $y 2
  }
  $font.Dispose(); $b.Dispose()
}
function Draw-HorizontalLockup($g, [float]$x, [float]$y, [float]$s, [System.Drawing.Color]$color, [System.Drawing.Color]$field) {
  Draw-SmallMark $g $x $y (.42*$s) $color $field $true
  Draw-Wordmark $g "horizontal" ($x + 150*$s) ($y + 31*$s) (42*$s) $color
  $f = FontX "Arial" (10*$s) ([System.Drawing.FontStyle]::Bold)
  Draw-LetterSpaced $g "KOPITIAM SINCE -".ToUpperInvariant() $f (Brush $color) ($x + 154*$s) ($y + 91*$s) (2.5*$s)
  $f.Dispose()
}
function Draw-StackedLockup($g, [float]$x, [float]$y, [float]$s, [System.Drawing.Color]$color, [System.Drawing.Color]$field) {
  Draw-SmallMark $g ($x + 48*$s) $y (.52*$s) $color $field $true
  Draw-Wordmark $g "stacked" $x ($y + 146*$s) (38*$s) $color
}
function Write-SvgAssets {
  $small = @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 260" role="img" aria-label="Kopi Kita small mark: cup, saucer, and single pour line">
  <g fill="#EBE1CF" stroke="#16130F" stroke-linecap="round" stroke-linejoin="round">
    <path d="M74 98 C80 172 100 204 160 206 C220 204 240 172 246 98" stroke-width="9"/>
    <ellipse cx="160" cy="101" rx="96" ry="17" stroke-width="9"/>
    <path d="M232 120 C285 107 303 176 246 182" fill="none" stroke-width="9"/>
    <ellipse cx="160" cy="226" rx="128" ry="21" stroke-width="9"/>
    <ellipse cx="160" cy="222" rx="82" ry="11.5" fill="none" stroke-width="4"/>
    <path d="M164 28 C178 72 175 96 176 113" fill="none" stroke="#38241A" stroke-width="9"/>
    <path d="M108 162 C138 174 184 174 214 162" fill="none" stroke-width="4"/>
    <circle cx="132" cy="156" r="5" fill="#16130F" stroke="none"/>
    <circle cx="160" cy="162" r="5" fill="#16130F" stroke="none"/>
    <circle cx="188" cy="156" r="5" fill="#16130F" stroke="none"/>
  </g>
</svg>
'@
  $horizontal = @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 170" role="img" aria-label="Kopi Kita horizontal lockup">
  <rect width="760" height="170" fill="#EBE1CF"/>
  <g transform="translate(20 18) scale(.52)" fill="#EBE1CF" stroke="#16130F" stroke-linecap="round" stroke-linejoin="round">
    <path d="M74 98 C80 172 100 204 160 206 C220 204 240 172 246 98" stroke-width="9"/>
    <ellipse cx="160" cy="101" rx="96" ry="17" stroke-width="9"/>
    <path d="M232 120 C285 107 303 176 246 182" fill="none" stroke-width="9"/>
    <ellipse cx="160" cy="226" rx="128" ry="21" stroke-width="9"/>
    <ellipse cx="160" cy="222" rx="82" ry="11.5" fill="none" stroke-width="4"/>
    <path d="M164 28 C178 72 175 96 176 113" fill="none" stroke="#38241A" stroke-width="9"/>
    <path d="M108 162 C138 174 184 174 214 162" fill="none" stroke-width="4"/>
    <circle cx="132" cy="156" r="5" fill="#16130F" stroke="none"/>
    <circle cx="160" cy="162" r="5" fill="#16130F" stroke="none"/>
    <circle cx="188" cy="156" r="5" fill="#16130F" stroke="none"/>
  </g>
  <text x="210" y="82" fill="#16130F" font-family="Archivo, Arial Black, Arial, sans-serif" font-size="54" font-weight="900" letter-spacing="2">KOPI KITA</text>
  <text x="214" y="122" fill="#16130F" font-family="Archivo, Arial, sans-serif" font-size="15" font-weight="800" letter-spacing="5">KOPITIAM SINCE -</text>
</svg>
'@
  $stacked = @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 520" role="img" aria-label="Kopi Kita stacked lockup">
  <rect width="420" height="520" fill="#EBE1CF"/>
  <g transform="translate(54 28) scale(.98)" fill="#EBE1CF" stroke="#16130F" stroke-linecap="round" stroke-linejoin="round">
    <path d="M74 98 C80 172 100 204 160 206 C220 204 240 172 246 98" stroke-width="9"/>
    <ellipse cx="160" cy="101" rx="96" ry="17" stroke-width="9"/>
    <path d="M232 120 C285 107 303 176 246 182" fill="none" stroke-width="9"/>
    <ellipse cx="160" cy="226" rx="128" ry="21" stroke-width="9"/>
    <ellipse cx="160" cy="222" rx="82" ry="11.5" fill="none" stroke-width="4"/>
    <path d="M164 28 C178 72 175 96 176 113" fill="none" stroke="#38241A" stroke-width="9"/>
    <path d="M108 162 C138 174 184 174 214 162" fill="none" stroke-width="4"/>
    <circle cx="132" cy="156" r="5" fill="#16130F" stroke="none"/>
    <circle cx="160" cy="162" r="5" fill="#16130F" stroke="none"/>
    <circle cx="188" cy="156" r="5" fill="#16130F" stroke="none"/>
  </g>
  <text x="52" y="358" fill="#16130F" font-family="Archivo, Arial Black, Arial, sans-serif" font-size="72" font-weight="900" letter-spacing="-1">KOPI</text>
  <text x="52" y="430" fill="#16130F" font-family="Archivo, Arial Black, Arial, sans-serif" font-size="72" font-weight="900" letter-spacing="-1">KITA</text>
  <text x="56" y="468" fill="#16130F" font-family="Archivo, Arial, sans-serif" font-size="14" font-weight="800" letter-spacing="5">KOPITIAM SINCE -</text>
</svg>
'@
  Set-Content -LiteralPath (Join-Path $AssetDir "kopi-kita-small-mark.svg") -Value $small -Encoding utf8
  Set-Content -LiteralPath (Join-Path $AssetDir "kopi-kita-lockup-horizontal.svg") -Value $horizontal -Encoding utf8
  Set-Content -LiteralPath (Join-Path $AssetDir "kopi-kita-lockup-stacked.svg") -Value $stacked -Encoding utf8
}
function Build-Opening([int]$w, [int]$h, [string]$out) {
  $ctx = New-Board $w $h $Paper
  $g = $ctx.Graphics
  Add-Grain $g $w $h
  Draw-Meta $g "Kopi Kita / Identity Study" "Opening / 01" $w
  $sceneY = [int]($h * .10); $sceneH = [int]($h * .57)
  Draw-CoverImage $g $Moodboard 0 $sceneY $w $sceneH
  $g.FillRectangle((Brush ([System.Drawing.Color]::FromArgb(135, 56, 36, 26))), 0, $sceneY, $w, $sceneH)
  $g.FillRectangle((Brush ([System.Drawing.Color]::FromArgb(26, 235, 225, 207))), 0, $sceneY, $w, $sceneH)
  $pSteel = PenX $Steel 18
  $g.DrawLine($pSteel, 95, $sceneY + 90, $w - 95, $sceneY + 90)
  $g.DrawLine($pSteel, 95, $sceneY + 90, 95, $sceneY + $sceneH - 70)
  $g.DrawLine($pSteel, $w - 95, $sceneY + 90, $w - 95, $sceneY + $sceneH - 70)
  $g.DrawLine($pSteel, 95, $sceneY + $sceneH - 70, $w - 95, $sceneY + $sceneH - 70)
  $pSteel.Dispose()
  $sign = [System.Drawing.RectangleF]::new(124, $sceneY + 118, [Math]::Min(560, $w - 248), 160)
  $g.FillRectangle((Brush $Paper), $sign)
  $g.DrawRectangle((PenX $Ink 5), [int]$sign.X, [int]$sign.Y, [int]$sign.Width, [int]$sign.Height)
  Draw-HorizontalLockup $g ($sign.X + 28) ($sign.Y + 26) .9 $Ink $Paper
  $board = [System.Drawing.RectangleF]::new($w - 340, $sceneY + 150, 230, 270)
  $g.FillRectangle((Brush $Paper), $board)
  $g.DrawRectangle((PenX $Ink 4), [int]$board.X, [int]$board.Y, [int]$board.Width, [int]$board.Height)
  $fMenu = FontX "Arial Black" 35 ([System.Drawing.FontStyle]::Bold)
  Draw-Text $g "MENU" $fMenu (Brush $Ink) ($board.X + 28) ($board.Y + 25)
  $fItem = FontX "Arial" 18 ([System.Drawing.FontStyle]::Bold)
  foreach ($row in @(@("KOPI O","2.00"),@("KOPI C","2.20"),@("KAYA TOAST","5.00"))) {
    $yy = $board.Y + 95 + 46 * [array]::IndexOf(@("KOPI O","KOPI C","KAYA TOAST"), $row[0])
    Draw-Text $g $row[0] $fItem (Brush $Ink) ($board.X + 28) $yy
    Draw-Text $g $row[1] $fItem (Brush $Ink) ($board.X + 170) $yy
  }
  Draw-SmallMark $g ($w - 284) ($sceneY + $sceneH - 234) .62 $Paper $Kopi $false
  $copyY = $sceneY + $sceneH + 58
  Draw-Wordmark $g "stacked" 58 $copyY 88 $Ink
  $serif = FontX "Georgia" 29 ([System.Drawing.FontStyle]::Regular)
  Draw-Text $g "A present-day kopi counter for the familiar," $serif (Brush $Kopi) 62 ($copyY + 210)
  Draw-Text $g "in-between part of the day." $serif (Brush $Kopi) 62 ($copyY + 248)
  $f = FontX "Arial" 17 ([System.Drawing.FontStyle]::Bold)
  Draw-LetterSpaced $g "KOPI, TOAST, NO FUSS." $f (Brush $Ink) 62 ($h - 98) 5
  $g.DrawLine((PenX $Line 2), 62, $h - 135, $w - 62, $h - 135)
  Finish-Board $ctx $out
}
function Build-Identity([int]$w, [int]$h, [string]$out) {
  $ctx = New-Board $w $h $Paper
  $g = $ctx.Graphics
  Add-Grain $g $w $h
  Draw-Meta $g "Kopi Kita" "Brand Identity / 02" $w
  Draw-Wordmark $g "stacked" 58 150 98 $Ink
  Draw-Primary $g 30 370 575 520
  $serif = FontX "Georgia" 27 ([System.Drawing.FontStyle]::Regular)
  Draw-Text $g "A hand tilts a stainless-steel kopi kettle," $serif (Brush $Kopi) 62 950
  Draw-Text $g "pouring dark kopi into a floral porcelain cup." $serif (Brush $Kopi) 62 986
  $x = [int]($w * .57)
  $label = FontX "Arial" 16 ([System.Drawing.FontStyle]::Bold)
  Draw-LetterSpaced $g "LOCKUPS" $label (Brush $Steel) $x 158 5
  Draw-HorizontalLockup $g $x 205 .82 $Ink $Paper
  Draw-StackedLockup $g ($x + 52) 378 .84 $Ink $Paper
  Draw-LetterSpaced $g "RITUAL SENTENCE" $label (Brush $Steel) $x 752 5
  Draw-Text $g "Cup and saucer / one pour /" $serif (Brush $Ink) $x 792
  Draw-Text $g "kopitiam table cue." $serif (Brush $Ink) $x 830
  Draw-LetterSpaced $g "PALETTE" $label (Brush $Steel) $x 872 5
  $sw = @(@("INK","#16130F",$Ink),@("KOPI","#38241A",$Kopi),@("PAPER","#EBE1CF",$PaperDeep),@("TRANSFERWARE","#2F4131",$Transfer))
  for ($i=0; $i -lt 4; $i++) {
    $xx = $x + (($i % 2) * 190); $yy = 914 + ([Math]::Floor($i / 2) * 95)
    $g.FillRectangle((Brush $sw[$i][2]), $xx, $yy, 170, 70)
    $g.DrawRectangle((PenX $Line 1), $xx, $yy, 170, 70)
    $txtColor = if ($i -eq 2) { $Ink } else { $Paper }
    $sf = FontX "Arial" 13 ([System.Drawing.FontStyle]::Bold)
    Draw-Text $g $sw[$i][0] $sf (Brush $txtColor) ($xx + 12) ($yy + 13)
    Draw-Text $g $sw[$i][1] $sf (Brush $txtColor) ($xx + 12) ($yy + 35)
  }
  Finish-Board $ctx $out
}
function Build-World([int]$w, [int]$h, [string]$out) {
  $ctx = New-Board $w $h $Paper
  $g = $ctx.Graphics
  Add-Grain $g $w $h
  Draw-Meta $g "Kopi Kita" "Brand World / 03" $w
  $leftW = [int]($w * .38)
  $g.FillRectangle((Brush $Kopi), 0, 0, $leftW, $h)
  Draw-Wordmark $g "stacked" 58 160 76 $Paper
  $serif = FontX "Georgia" 24 ([System.Drawing.FontStyle]::Bold)
  Draw-Text $g "Operational objects" $serif (Brush $Paper) 62 405
  Draw-Text $g "become the system:" $serif (Brush $Paper) 62 440
  Draw-Text $g "cup, menu, receipt stamp," $serif (Brush $Paper) 62 500
  Draw-Text $g "and enamel saucer." $serif (Brush $Paper) 62 535
  $x0 = $leftW + 52
  Draw-TileGrid $g $x0 126 360 450
  Draw-Primary $g ($x0 + 20) 174 318 325
  $g.DrawLine((PenX $Line 2), $x0, 695, $w - 65, 695)
  # takeaway cup
  $cupX = $leftW + 64; $cupY = [int]($h - 450)
  $cupPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $cupPath.AddPolygon(@(
    [System.Drawing.Point]::new($cupX, $cupY),
    [System.Drawing.Point]::new($cupX + 205, $cupY),
    [System.Drawing.Point]::new($cupX + 178, $cupY + 315),
    [System.Drawing.Point]::new($cupX + 28, $cupY + 315)
  ))
  $g.FillPath((Brush $PaperDeep), $cupPath)
  $g.DrawPath((PenX $Ink 5), $cupPath)
  Draw-SmallMark $g ($cupX + 48) ($cupY + 92) .38 $Ink $PaperDeep $true
  Draw-LetterSpaced $g "KOPI KITA" (FontX "Arial" 15 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) ($cupX + 42) ($cupY + 232) 3
  # menu
  $menuX = $leftW + 340; $menuY = [int]($h - 505)
  $g.FillRectangle((Brush ([System.Drawing.ColorTranslator]::FromHtml("#F6EEDC"))), $menuX, $menuY, 270, 330)
  $g.DrawRectangle((PenX $Ink 3), $menuX, $menuY, 270, 330)
  Draw-Text $g "Order" (FontX "Arial Black" 40 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) ($menuX + 24) ($menuY + 24)
  Draw-Text $g "Sheet" (FontX "Arial Black" 40 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) ($menuX + 24) ($menuY + 66)
  $items = @('KOPI O   $2.00','KOPI C   $2.20','TEH O    $1.80','KAYA TOAST SET   $5.00')
  for ($i=0; $i -lt $items.Count; $i++) {
    $yy = $menuY + 150 + $i*40
    $g.DrawLine((PenX $Line 2), $menuX + 28, $yy + 22, $menuX + 264, $yy + 22)
    Draw-Text $g $items[$i] (FontX "Arial" 15 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) ($menuX + 24) $yy
  }
  # receipt stamp
  $stampX = $menuX + 70; $stampY = $menuY + 355
  $g.DrawEllipse((PenX $Transfer 5), $stampX, $stampY, 130, 130)
  Draw-SmallMark $g ($stampX + 29) ($stampY + 18) .22 $Transfer $Paper $false
  Draw-LetterSpaced $g "POURED" (FontX "Arial" 13 ([System.Drawing.FontStyle]::Bold)) (Brush $Transfer) ($stampX + 34) ($stampY + 100) 2
  # saucer
  $g.DrawEllipse((PenX $Ink 6), $w - 302, 220, 210, 62)
  $g.DrawEllipse((PenX $Ink 3), $w - 257, 235, 120, 32)
  Draw-LetterSpaced $g "COUNTER TILE / CUP / MENU / RECEIPT" (FontX "Arial" 16 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) ($leftW + 65) ($h - 86) 4
  Finish-Board $ctx $out
}
function Build-Core([int]$w, [int]$h, [string]$out) {
  $ctx = New-Board $w $h $Paper
  $g = $ctx.Graphics
  Add-Grain $g $w $h
  Draw-Meta $g "Kopi Kita" "Core Illustration / 04" $w
  $isSquare = $h -le 1100
  $primaryH = if ($isSquare) { 560 } else { 660 }
  $dividerY = if ($isSquare) { 710 } else { 795 }
  $proofY = if ($isSquare) { 755 } else { 890 }
  $proofScale = if ($isSquare) { .55 } else { .8 }
  $reverseX = if ($isSquare) { 350 } else { 380 }
  $reverseY = if ($isSquare) { 735 } else { 874 }
  $reverseSize = if ($isSquare) { 210 } else { 250 }
  $labelY = if ($isSquare) { 735 } else { 835 }
  Draw-Primary $g 70 110 ($w - 140) $primaryH
  $g.DrawLine((PenX $Line 2), 58, $dividerY, $w - 58, $dividerY)
  Draw-LetterSpaced $g "REDUCED SMALL MARK" (FontX "Arial" 15 ([System.Drawing.FontStyle]::Bold)) (Brush $Steel) 62 $labelY 5
  Draw-SmallMark $g 84 $proofY $proofScale $Ink $Paper $true
  $revX = $reverseX; $revY = $reverseY
  $g.FillRectangle((Brush $Kopi), $revX, $revY, $reverseSize, $reverseSize)
  Draw-SmallMark $g ($revX + 0) ($revY + 12) ($proofScale * .96) $Paper $Kopi $false
  Draw-LetterSpaced $g "REVERSED" (FontX "Arial" 14 ([System.Drawing.FontStyle]::Bold)) (Brush $Paper) ($revX + 35) ($revY + $reverseSize - 34) 4
  $testX = if ($isSquare) { 690 } else { 690 }
  $testY = if ($isSquare) { 760 } else { 866 }
  Draw-LetterSpaced $g "48 PX" (FontX "Arial" 14 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) $testX $testY 4
  Draw-SmallMark $g ($testX + 10) ($testY + 38) .15 $Ink $Paper $true
  Draw-LetterSpaced $g "24 PX / 20 MM" (FontX "Arial" 14 ([System.Drawing.FontStyle]::Bold)) (Brush $Ink) $testX ($testY + 145) 4
  Draw-SmallMark $g ($testX + 14) ($testY + 183) .075 $Ink $Paper $true
  $serif = FontX "Georgia" 28 ([System.Drawing.FontStyle]::Italic)
  if (-not $isSquare) {
    Draw-Text $g "Full ritual stays expressive. Small mark reduces to cup, saucer, and one pour." $serif (Brush $Kopi) 62 ($h - 105)
  }
  Finish-Board $ctx $out
}
function Build-All([int]$w, [int]$h, [string]$suffix) {
  Build-Opening $w $h (Join-Path $FinalDir "01-opening$suffix.png")
  Build-Identity $w $h (Join-Path $FinalDir "02-brand-identity$suffix.png")
  Build-World $w $h (Join-Path $FinalDir "03-brand-world$suffix.png")
  Build-Core $w $h (Join-Path $FinalDir "04-core-illustration$suffix.png")
}
function Write-MotionDemo {
  $base = Get-Content -LiteralPath (Join-Path $AssetDir "kopi-kita-small-mark.svg") -Raw
  for ($i=0; $i -lt 4; $i++) {
    $frame = $base -replace 'aria-label="[^"]+"', ('aria-label="Kopi Kita pour motion state K' + $i + '"')
    Set-Content -LiteralPath (Join-Path $MotionFrames ("K{0}.svg" -f $i)) -Value $frame -Encoding utf8
  }
  $demo = @'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Kopi Kita - Pour Motion Demo</title>
<style>
  :root { --paper:#EBE1CF; --ink:#16130F; --kopi:#38241A; }
  * { box-sizing:border-box; }
  body { margin:0; min-height:100vh; display:grid; place-items:center; background:var(--paper); color:var(--ink); font-family:Arial, sans-serif; }
  main { width:min(920px, 92vw); aspect-ratio:1/1; display:grid; place-items:center; position:relative; }
  .brand { position:absolute; left:0; top:0; font-weight:900; font-size:clamp(42px, 9vw, 96px); line-height:.84; letter-spacing:-.04em; }
  .stage { width:60%; translate:0 8%; }
  svg { width:100%; height:auto; overflow:visible; }
  .pour { transform-origin:164px 28px; animation: pour 4.8s steps(4,end) infinite; }
  .caption { position:absolute; left:0; right:0; bottom:0; display:flex; justify-content:space-between; border-top:1px solid rgba(22,19,15,.2); padding-top:18px; font-size:12px; letter-spacing:.24em; font-weight:800; text-transform:uppercase; }
  @keyframes pour {
    0% { transform:translateY(-30px) scaleY(.15); opacity:.25; }
    25% { transform:translateY(-14px) scaleY(.45); opacity:.65; }
    50% { transform:translateY(0) scaleY(1); opacity:1; }
    75%,100% { transform:translateY(0) scaleY(1); opacity:1; }
  }
  @media (prefers-reduced-motion: reduce) { .pour { animation:none; } }
</style>
</head>
<body>
<main>
  <div class="brand">Kopi<br>Kita.</div>
  <div class="stage">
    <svg viewBox="0 0 320 260" aria-label="Kopi Kita four-state reduced pour motion">
      <g fill="#EBE1CF" stroke="#16130F" stroke-linecap="round" stroke-linejoin="round">
        <path d="M74 98 C80 172 100 204 160 206 C220 204 240 172 246 98" stroke-width="9"/>
        <ellipse cx="160" cy="101" rx="96" ry="17" stroke-width="9"/>
        <path d="M232 120 C285 107 303 176 246 182" fill="none" stroke-width="9"/>
        <ellipse cx="160" cy="226" rx="128" ry="21" stroke-width="9"/>
        <ellipse cx="160" cy="222" rx="82" ry="11.5" fill="none" stroke-width="4"/>
        <path class="pour" d="M164 28 C178 72 175 96 176 113" fill="none" stroke="#38241A" stroke-width="9"/>
        <path d="M108 162 C138 174 184 174 214 162" fill="none" stroke-width="4"/>
        <circle cx="132" cy="156" r="5" fill="#16130F" stroke="none"/>
        <circle cx="160" cy="162" r="5" fill="#16130F" stroke="none"/>
        <circle cx="188" cy="156" r="5" fill="#16130F" stroke="none"/>
      </g>
    </svg>
  </div>
  <div class="caption"><span>Approach / Contact / Pour / Resolved</span><span>Reduced mark source</span></div>
</main>
</body>
</html>
'@
  Set-Content -LiteralPath (Join-Path $MotionDir "demo.html") -Value $demo -Encoding utf8
}

Write-SvgAssets
Build-All 1080 1350 ""
Build-All 1080 1080 "-square"
Write-MotionDemo
