Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$Root = "C:\Users\angdo\ActiveProjects\Carousel Design Studio\02 Monochrome Branding"
$FinalDir = Join-Path $Root "Final - Bagel Portfolio"
$MotionDir = Join-Path $Root "Assets\03_Brand_Projects\bagel-brand\03_Motion_Assets\whiteboard-source\open-for-bagels"
$MasterPath = Join-Path $Root "Assets\01_Approved_Illustrations\fnb-logo-02-open-for-bagels.png"
$ContextPath = Join-Path $FinalDir "open-for-bagels-generated-context.png"
$AlphaPath = Join-Path $FinalDir "open-for-bagels-primary-alpha.png"
$FrameDir = Join-Path $MotionDir "motion-frames"

New-Item -ItemType Directory -Force -Path $FinalDir | Out-Null
New-Item -ItemType Directory -Force -Path $FrameDir | Out-Null

$Ink = [System.Drawing.ColorTranslator]::FromHtml("#111111")
$Paper = [System.Drawing.ColorTranslator]::FromHtml("#F7F5EF")
$Warm = [System.Drawing.ColorTranslator]::FromHtml("#E8D9C7")
$Terracotta = [System.Drawing.ColorTranslator]::FromHtml("#B55339")
$TerracottaDark = [System.Drawing.ColorTranslator]::FromHtml("#6F2F24")
$SoftInk = [System.Drawing.ColorTranslator]::FromHtml("#4A3A34")
$White = [System.Drawing.Color]::White

function New-Canvas($w, $h, $bg) {
  $bmp = [System.Drawing.Bitmap]::new($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear($bg)
  return @{ Bitmap = $bmp; Graphics = $g }
}

function New-FontSafe($name, $size, $style) {
  try {
    return [System.Drawing.Font]::new($name, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
  } catch {
    return [System.Drawing.Font]::new("Arial", $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
  }
}

function Save-Png($canvas, $path) {
  $canvas.Graphics.Dispose()
  $canvas.Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $canvas.Bitmap.Dispose()
}

function Draw-Text($g, $text, $x, $y, $w, $h, $font, $brush, $align = "Near") {
  $format = [System.Drawing.StringFormat]::new()
  $format.Alignment = [System.Drawing.StringAlignment]::$align
  $format.LineAlignment = [System.Drawing.StringAlignment]::Near
  $g.DrawString($text, $font, $brush, [System.Drawing.RectangleF]::new($x, $y, $w, $h), $format)
  $format.Dispose()
}

function Draw-Tracked($g, $text, $x, $y, $font, $brush, $tracking) {
  $cursor = [float]$x
  foreach ($ch in $text.ToCharArray()) {
    $s = [string]$ch
    $g.DrawString($s, $font, $brush, $cursor, $y)
    $cursor += $g.MeasureString($s, $font).Width + $tracking
  }
}

function Draw-Centered($g, $text, $x, $y, $w, $h, $font, $brush) {
  $format = [System.Drawing.StringFormat]::new()
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $format.LineAlignment = [System.Drawing.StringAlignment]::Center
  $g.DrawString($text, $font, $brush, [System.Drawing.RectangleF]::new($x, $y, $w, $h), $format)
  $format.Dispose()
}

function Draw-SmallMark($g, $cx, $cy, $size, $fg, $bg) {
  $r = $size / 2.0
  $outer = [System.Drawing.RectangleF]::new($cx - $r, $cy - $r, $size, $size)
  $hole = [System.Drawing.RectangleF]::new($cx - $size * 0.18, $cy - $size * 0.18, $size * 0.36, $size * 0.36)
  $fgBrush = [System.Drawing.SolidBrush]::new($fg)
  $bgBrush = [System.Drawing.SolidBrush]::new($bg)
  $g.FillEllipse($fgBrush, $outer)
  $g.FillEllipse($bgBrush, $hole)
  $pen = [System.Drawing.Pen]::new($bg, [Math]::Max(2, $size * 0.055))
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawArc($pen, [System.Drawing.RectangleF]::new($cx - $size * 0.28, $cy - $size * 0.33, $size * 0.55, $size * 0.55), -64, 42)
  $fgBrush.Dispose()
  $bgBrush.Dispose()
  $pen.Dispose()
}

function Draw-AwningBand($g, $x, $y, $w, $h, $accent, $ground) {
  $accentBrush = [System.Drawing.SolidBrush]::new($accent)
  $groundBrush = [System.Drawing.SolidBrush]::new($ground)
  $inkPen = [System.Drawing.Pen]::new($Ink, 5)
  $g.FillRectangle($groundBrush, [System.Drawing.RectangleF]::new($x, $y, $w, $h * 0.66))
  $g.FillRectangle($accentBrush, [System.Drawing.RectangleF]::new($x, $y, $w, $h * 0.38))
  $g.DrawLine($inkPen, $x, $y + $h * 0.66, $x + $w, $y + $h * 0.66)
  $scallops = 7
  $sw = $w / $scallops
  for ($i = 0; $i -lt $scallops; $i++) {
    $brush = if ($i % 2 -eq 0) { $accentBrush } else { $groundBrush }
    $g.FillPie($brush, [float]($x + $i * $sw), [float]($y + $h * 0.48), [float]$sw, [float]($h * 0.44), [float]0, [float]180)
    $g.DrawArc($inkPen, [float]($x + $i * $sw), [float]($y + $h * 0.48), [float]$sw, [float]($h * 0.44), [float]0, [float]180)
  }
  $g.DrawRectangle($inkPen, [int]$x, [int]$y, [int]$w, [int]($h * 0.66))
  $accentBrush.Dispose()
  $groundBrush.Dispose()
  $inkPen.Dispose()
}

function Draw-Wordmark($g, $x, $y, $scale, $accent = $Terracotta) {
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushAccent = [System.Drawing.SolidBrush]::new($accent)
  $font = New-FontSafe "Arial Rounded MT Bold" (72 * $scale) ([System.Drawing.FontStyle]::Bold)
  $line = 68 * $scale
  $g.DrawString("OPEN FOR", $font, $brushInk, $x, $y)
  $g.DrawString("BAGELS", $font, $brushAccent, $x, $y + $line)
  $font.Dispose()
  $brushInk.Dispose()
  $brushAccent.Dispose()
}

function Draw-HorizontalLockup($g, $x, $y, $w, $h) {
  Draw-AwningBand $g $x $y $w ($h * 0.24) $Terracotta $Paper
  Draw-SmallMark $g ($x + $h * 0.40) ($y + $h * 0.64) ($h * 0.48) $Ink $Paper
  $font = New-FontSafe "Arial Rounded MT Bold" ($h * 0.22) ([System.Drawing.FontStyle]::Bold)
  $sub = New-FontSafe "Arial" ($h * 0.060) ([System.Drawing.FontStyle]::Regular)
  $brush = [System.Drawing.SolidBrush]::new($Ink)
  $accent = [System.Drawing.SolidBrush]::new($Terracotta)
  $g.DrawString("OPEN FOR BAGELS", $font, $brush, $x + $h * 0.78, $y + $h * 0.42)
  Draw-Tracked $g "MORNING BAGELS / HANGING SIGN RITUAL" ($x + $h * 0.79) ($y + $h * 0.72) $sub $accent 2
  $font.Dispose()
  $sub.Dispose()
  $brush.Dispose()
  $accent.Dispose()
}

function Draw-BadgeLockup($g, $cx, $cy, $size, $bg) {
  $r = $size / 2.0
  $pen = [System.Drawing.Pen]::new($Ink, [Math]::Max(3, $size * 0.025))
  $brush = [System.Drawing.SolidBrush]::new($Ink)
  $accent = [System.Drawing.SolidBrush]::new($Terracotta)
  $font = New-FontSafe "Arial Rounded MT Bold" ($size * 0.075) ([System.Drawing.FontStyle]::Bold)
  $sub = New-FontSafe "Arial" ($size * 0.034) ([System.Drawing.FontStyle]::Regular)
  $g.DrawEllipse($pen, [System.Drawing.RectangleF]::new($cx - $r, $cy - $r, $size, $size))
  $g.DrawEllipse($pen, [System.Drawing.RectangleF]::new($cx - $r + $size * 0.07, $cy - $r + $size * 0.07, $size * 0.86, $size * 0.86))
  Draw-SmallMark $g $cx ($cy - $size * 0.06) ($size * 0.34) $Ink $bg
  Draw-Centered $g "OPEN FOR" ($cx - $size * 0.38) ($cy + $size * 0.17) ($size * 0.76) ($size * 0.09) $font $brush
  Draw-Centered $g "BAGELS" ($cx - $size * 0.38) ($cy + $size * 0.27) ($size * 0.76) ($size * 0.09) $font $accent
  Draw-Centered $g "TURN MORNING ON" ($cx - $size * 0.38) ($cy + $size * 0.385) ($size * 0.76) ($size * 0.055) $sub $brush
  $pen.Dispose()
  $brush.Dispose()
  $accent.Dispose()
  $font.Dispose()
  $sub.Dispose()
}

function Draw-PrimaryAlpha($g, $path, $x, $y, $w, $h) {
  $img = [System.Drawing.Image]::FromFile($path)
  try {
    $g.DrawImage($img, [System.Drawing.RectangleF]::new($x, $y, $w, $h))
  } finally {
    $img.Dispose()
  }
}

function Draw-SimpleBadgeStamp($g, $cx, $cy, $size, $bg) {
  $pen = [System.Drawing.Pen]::new($Ink, [Math]::Max(3, $size * 0.028))
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushAccent = [System.Drawing.SolidBrush]::new($Terracotta)
  $font = New-FontSafe "Arial Rounded MT Bold" ($size * 0.082) ([System.Drawing.FontStyle]::Bold)
  $r = $size / 2
  $g.DrawEllipse($pen, [System.Drawing.RectangleF]::new($cx - $r, $cy - $r, $size, $size))
  $g.DrawEllipse($pen, [System.Drawing.RectangleF]::new($cx - $r + $size * 0.075, $cy - $r + $size * 0.075, $size * 0.85, $size * 0.85))
  Draw-SmallMark $g $cx ($cy - $size * 0.08) ($size * 0.34) $Ink $bg
  Draw-Centered $g "OPEN FOR" ($cx - $size * 0.34) ($cy + $size * 0.16) ($size * 0.68) ($size * 0.08) $font $brushInk
  Draw-Centered $g "BAGELS" ($cx - $size * 0.34) ($cy + $size * 0.25) ($size * 0.68) ($size * 0.08) $font $brushAccent
  $pen.Dispose()
  $brushInk.Dispose()
  $brushAccent.Dispose()
  $font.Dispose()
}

function Make-AlphaMaster {
  $src = [System.Drawing.Bitmap]::FromFile($MasterPath)
  $dst = [System.Drawing.Bitmap]::new($src.Width, $src.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  for ($yy = 0; $yy -lt $src.Height; $yy++) {
    for ($xx = 0; $xx -lt $src.Width; $xx++) {
      $p = $src.GetPixel($xx, $yy)
      if ($p.R -gt 242 -and $p.G -gt 242 -and $p.B -gt 242) {
        $dst.SetPixel($xx, $yy, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
      } else {
        $a = [Math]::Max($p.A, 210)
        $v = [Math]::Min($p.R, [Math]::Min($p.G, $p.B))
        $dst.SetPixel($xx, $yy, [System.Drawing.Color]::FromArgb($a, $v, $v, $v))
      }
    }
  }
  $dst.Save($AlphaPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $src.Dispose()
  $dst.Dispose()
}

function Draw-BoardFooter($g, $num, $label, $w, $h) {
  $small = New-FontSafe "Arial" 18 ([System.Drawing.FontStyle]::Regular)
  $brush = [System.Drawing.SolidBrush]::new($TerracottaDark)
  Draw-Tracked $g "$num / $label" 80 ($h - 72) $small $brush 3
  $small.Dispose()
  $brush.Dispose()
}

function Draw-OpeningBoard($path, $w, $h) {
  $c = New-Canvas $w $h $Paper
  $g = $c.Graphics
  $context = [System.Drawing.Image]::FromFile($ContextPath)
  try {
    $scale = [Math]::Max($w / $context.Width, $h / $context.Height)
    $dw = $context.Width * $scale
    $dh = $context.Height * $scale
    $dx = ($w - $dw) / 2
    $dy = ($h - $dh) / 2
    $g.DrawImage($context, [System.Drawing.RectangleF]::new($dx, $dy, $dw, $dh))
  } finally {
    $context.Dispose()
  }
  $shade = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(182, 247, 245, 239))
  $g.FillRectangle($shade, [System.Drawing.RectangleF]::new(0, $h - 352, $w, 352))
  $shade.Dispose()
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushSoft = [System.Drawing.SolidBrush]::new($SoftInk)
  $brushAccent = [System.Drawing.SolidBrush]::new($Terracotta)
  $eyebrow = New-FontSafe "Arial" 18 ([System.Drawing.FontStyle]::Regular)
  $headline = New-FontSafe "Georgia" 92 ([System.Drawing.FontStyle]::Bold)
  $body = New-FontSafe "Arial" 24 ([System.Drawing.FontStyle]::Regular)
  Draw-SmallMark $g 185 238 72 $Ink $Paper
  Draw-Wordmark $g 240 205 0.20 $Terracotta
  Draw-SimpleBadgeStamp $g 760 635 175 $Paper
  Draw-Tracked $g "01 / THE OPENING" 80 ($h - 286) $eyebrow $brushSoft 5
  $g.FillEllipse($brushAccent, [System.Drawing.RectangleF]::new(292, $h - 283, 16, 16))
  $g.DrawString("Open for", $headline, $brushInk, 76, $h - 250)
  $g.DrawString("Bagels", $headline, $brushInk, 76, $h - 162)
  Draw-Text $g "A hand turns a hanging bagel sign beneath a single terracotta awning." 640 ($h - 236) 330 116 $body $brushSoft
  Draw-Text $g "OPEN FOR BAGELS / STREET VIEW" 610 ($h - 86) 360 30 $eyebrow $brushSoft
  $eyebrow.Dispose()
  $headline.Dispose()
  $body.Dispose()
  $brushInk.Dispose()
  $brushSoft.Dispose()
  $brushAccent.Dispose()
  Save-Png $c $path
}

function Draw-IdentityBoard($path, $w, $h) {
  $c = New-Canvas $w $h $Paper
  $g = $c.Graphics
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushSoft = [System.Drawing.SolidBrush]::new($SoftInk)
  $brushAccent = [System.Drawing.SolidBrush]::new($Terracotta)
  $eyebrow = New-FontSafe "Arial" 18 ([System.Drawing.FontStyle]::Regular)
  $body = New-FontSafe "Arial" 26 ([System.Drawing.FontStyle]::Regular)
  $label = New-FontSafe "Arial" 16 ([System.Drawing.FontStyle]::Bold)
  Draw-Tracked $g "OPEN FOR BAGELS" 80 70 $eyebrow $brushInk 7
  Draw-Tracked $g "IDENTITY / 02" ($w - 300) 70 $eyebrow $brushSoft 5
  Draw-Wordmark $g 80 148 0.98 $Terracotta
  Draw-Text $g "Morning bagels, freshly turned on." 84 338 540 48 $body $brushSoft
  Draw-Text $g "Ritual: a hand turns a hanging bagel sign beneath an awning. The expressive master carries the opening gesture; the compact system reduces to the circle sign, center hole, and one twist cue." 84 412 535 210 $body $brushSoft
  Draw-PrimaryAlpha $g $AlphaPath 680 208 275 275
  Draw-HorizontalLockup $g 82 690 620 172
  Draw-BadgeLockup $g 840 750 230 $Paper
  Draw-Tracked $g "PALETTE" 86 940 $label $brushSoft 4
  $swatches = @(
    @{ Name = "INK"; Color = $Ink },
    @{ Name = "PAPER"; Color = $Paper },
    @{ Name = "TERRACOTTA"; Color = $Terracotta },
    @{ Name = "WARM BOX"; Color = $Warm }
  )
  $sx = 86
  foreach ($s in $swatches) {
    $b = [System.Drawing.SolidBrush]::new($s.Color)
    $g.FillRectangle($b, [System.Drawing.RectangleF]::new($sx, 982, 104, 104))
    $g.DrawRectangle([System.Drawing.Pen]::new($Ink, 2), $sx, 982, 104, 104)
    Draw-Centered $g $s.Name ($sx - 34) 1110 172 30 $eyebrow $brushSoft
    $sx += 222
    $b.Dispose()
  }
  Draw-BoardFooter $g "02" "IDENTITY RATIONALE" $w $h
  $eyebrow.Dispose()
  $body.Dispose()
  $label.Dispose()
  $brushInk.Dispose()
  $brushSoft.Dispose()
  $brushAccent.Dispose()
  Save-Png $c $path
}

function Draw-WorldBoard($path, $w, $h) {
  $c = New-Canvas $w $h $Paper
  $g = $c.Graphics
  $context = [System.Drawing.Image]::FromFile($ContextPath)
  try {
    $src = [System.Drawing.Rectangle]::new(0, 150, $context.Width, 820)
    $dest = [System.Drawing.RectangleF]::new(0, 0, $w, 540)
    $g.DrawImage($context, $dest, $src, [System.Drawing.GraphicsUnit]::Pixel)
  } finally {
    $context.Dispose()
  }
  $overlay = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(160, 247, 245, 239))
  $g.FillRectangle($overlay, [System.Drawing.RectangleF]::new(0, 0, $w, 540))
  $overlay.Dispose()
  Draw-HorizontalLockup $g 88 84 600 166
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushSoft = [System.Drawing.SolidBrush]::new($SoftInk)
  $brushAccent = [System.Drawing.SolidBrush]::new($Terracotta)
  $headline = New-FontSafe "Arial Rounded MT Bold" 42 ([System.Drawing.FontStyle]::Bold)
  $body = New-FontSafe "Arial" 22 ([System.Drawing.FontStyle]::Regular)
  $label = New-FontSafe "Arial" 17 ([System.Drawing.FontStyle]::Regular)
  Draw-Text $g "A working morning system." 82 632 520 110 $headline $brushInk
  Draw-Text $g "The circle sign becomes the storefront anchor, a box deboss, a bag stamp, and an opening-hours window decal. No secondary paper-bag logo appears in the final system." 84 775 500 132 $body $brushSoft
  $boxBrush = [System.Drawing.SolidBrush]::new($Warm)
  $bagBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#D7B98E"))
  $receiptBrush = [System.Drawing.SolidBrush]::new($White)
  $g.FillRectangle($boxBrush, [System.Drawing.RectangleF]::new(645, 660, 290, 210))
  $g.DrawRectangle([System.Drawing.Pen]::new($Ink, 4), 645, 660, 290, 210)
  Draw-SmallMark $g 790 742 88 $Ink $Warm
  Draw-Centered $g "BAKERY BOX" 665 822 250 24 $label $brushSoft
  $bagPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $bagPath.AddPolygon(@(
    [System.Drawing.PointF]::new(618, 965),
    [System.Drawing.PointF]::new(880, 935),
    [System.Drawing.PointF]::new(920, 1215),
    [System.Drawing.PointF]::new(575, 1215)
  ))
  $g.FillPath($bagBrush, $bagPath)
  $g.DrawPath([System.Drawing.Pen]::new($Ink, 4), $bagPath)
  Draw-SimpleBadgeStamp $g 746 1080 185 ([System.Drawing.ColorTranslator]::FromHtml("#D7B98E"))
  $g.FillRectangle($receiptBrush, [System.Drawing.RectangleF]::new(132, 940, 300, 250))
  $g.DrawRectangle([System.Drawing.Pen]::new($Ink, 3), 132, 940, 300, 250)
  Draw-Centered $g "OPENING HOURS" 154 972 256 32 $label $brushInk
  Draw-Centered $g "7 AM - 2 PM" 154 1020 256 42 (New-FontSafe "Arial Rounded MT Bold" 30 ([System.Drawing.FontStyle]::Bold)) $brushAccent
  Draw-SmallMark $g 282 1120 74 $Ink $White
  Draw-BoardFooter $g "03" "PRACTICAL BRAND WORLD" $w $h
  $headline.Dispose()
  $body.Dispose()
  $label.Dispose()
  $brushInk.Dispose()
  $brushSoft.Dispose()
  $brushAccent.Dispose()
  $boxBrush.Dispose()
  $bagBrush.Dispose()
  $receiptBrush.Dispose()
  $bagPath.Dispose()
  Save-Png $c $path
}

function Draw-CoreBoard($path, $w, $h) {
  $c = New-Canvas $w $h $White
  $g = $c.Graphics
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushSoft = [System.Drawing.SolidBrush]::new($SoftInk)
  $brushAccent = [System.Drawing.SolidBrush]::new($Terracotta)
  $eyebrow = New-FontSafe "Arial" 18 ([System.Drawing.FontStyle]::Regular)
  $label = New-FontSafe "Arial" 20 ([System.Drawing.FontStyle]::Bold)
  $body = New-FontSafe "Arial" 21 ([System.Drawing.FontStyle]::Regular)
  Draw-Tracked $g "04 / CORE ILLUSTRATION + REDUCTION" 76 68 $eyebrow $brushSoft 5
  Draw-PrimaryAlpha $g $AlphaPath 140 150 520 520
  Draw-Text $g "Expressive master" 180 690 320 36 $label $brushInk
  Draw-Text $g "Full ritual: awning, two chains, hand, and turning sign. Used large only." 180 728 440 62 $body $brushSoft
  Draw-SmallMark $g 830 286 190 $Ink $White
  Draw-Text $g "Derived small mark" 718 420 300 32 $label $brushInk
  Draw-Text $g "Circle sign + center hole + one twist cue. No hand, no awning, no chain detail." 700 462 310 88 $body $brushSoft
  $g.FillRectangle([System.Drawing.SolidBrush]::new($Terracotta), [System.Drawing.RectangleF]::new(700, 604, 260, 160))
  Draw-SmallMark $g 830 684 98 $Paper $Terracotta
  Draw-Text $g "Reversed" 780 790 150 28 $label $brushInk
  Draw-SmallMark $g 188 945 48 $Ink $White
  Draw-Text $g "48px" 148 990 100 28 $body $brushSoft
  Draw-SmallMark $g 304 957 24 $Ink $White
  Draw-Text $g "24px" 268 990 100 28 $body $brushSoft
  $g.FillRectangle([System.Drawing.SolidBrush]::new($Ink), [System.Drawing.RectangleF]::new(450, 910, 220, 140))
  Draw-SmallMark $g 560 980 82 $White $Ink
  Draw-Text $g "Solid/reverse proof" 430 1080 260 28 $body $brushSoft
  Draw-HorizontalLockup $g 104 1145 640 150
  Draw-BadgeLockup $g 890 1218 160 $White
  Draw-BoardFooter $g "04" "REDUCTION PROOF" $w $h
  $eyebrow.Dispose()
  $label.Dispose()
  $body.Dispose()
  $brushInk.Dispose()
  $brushSoft.Dispose()
  $brushAccent.Dispose()
  Save-Png $c $path
}

function Draw-MotionFrame($path, $w, $h, $stage) {
  $c = New-Canvas $w $h $Paper
  $g = $c.Graphics
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushSoft = [System.Drawing.SolidBrush]::new($SoftInk)
  $brushAccent = [System.Drawing.SolidBrush]::new($Terracotta)
  Draw-AwningBand $g 250 140 580 135 $Terracotta $Paper
  $pen = [System.Drawing.Pen]::new($Ink, 8)
  $chainX1 = 445 + $stage * 3
  $chainX2 = 635 - $stage * 3
  $g.DrawLine($pen, $chainX1, 272, $chainX1, 425)
  $g.DrawLine($pen, $chainX2, 272, $chainX2, 425)
  $angleOffset = (-28 + $stage * 18)
  $state = $g.Save()
  $g.TranslateTransform(540, 552)
  $g.RotateTransform($angleOffset)
  Draw-SmallMark $g 0 0 300 $Ink $Paper
  $g.Restore($state)
  if ($stage -gt 0) {
    $handPen = [System.Drawing.Pen]::new($Ink, 9)
    $handPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $handPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawBezier($handPen, 308, 760, 390, 692, 420, 652, 475, 610)
    $g.DrawLine($handPen, 450, 646, 498, 668)
    $handPen.Dispose()
  }
  $label = New-FontSafe "Arial Rounded MT Bold" 34 ([System.Drawing.FontStyle]::Bold)
  $small = New-FontSafe "Arial Rounded MT Bold" 28 ([System.Drawing.FontStyle]::Bold)
  $names = @("01 APPROACH", "02 CONTACT", "03 TURN", "04 OPEN")
  Draw-Centered $g $names[$stage] 0 960 $w 52 $label $brushInk
  Draw-Centered $g "OPEN FOR BAGELS" 0 1032 $w 48 $small $brushSoft
  $label.Dispose()
  $small.Dispose()
  $pen.Dispose()
  $brushInk.Dispose()
  $brushSoft.Dispose()
  $brushAccent.Dispose()
  Save-Png $c $path
}

function Draw-MotionBoard($path, $w, $h) {
  $c = New-Canvas $w $h $Paper
  $g = $c.Graphics
  $brushInk = [System.Drawing.SolidBrush]::new($Ink)
  $brushSoft = [System.Drawing.SolidBrush]::new($SoftInk)
  $eyebrow = New-FontSafe "Arial" 18 ([System.Drawing.FontStyle]::Regular)
  $headline = New-FontSafe "Arial Rounded MT Bold" 56 ([System.Drawing.FontStyle]::Bold)
  Draw-Tracked $g "05 / MOTION STUDY" 76 68 $eyebrow $brushSoft 5
  Draw-Text $g "The sign turns open." 76 122 860 72 $headline $brushInk
  for ($i = 0; $i -lt 4; $i++) {
    $frame = Join-Path $FrameDir ("K{0}.png" -f $i)
    $img = [System.Drawing.Image]::FromFile($frame)
    try {
      $col = $i % 2
      $row = [Math]::Floor($i / 2)
      $x = 88 + $col * 468
      $y = 238 + $row * 438
      $g.DrawImage($img, [System.Drawing.RectangleF]::new($x, $y, 392, 490))
      $g.DrawRectangle([System.Drawing.Pen]::new($Ink, 3), $x, $y, 392, 490)
    } finally {
      $img.Dispose()
    }
  }
  Draw-Text $g "K0-K3 / SAME CIRCLE-SIGN MARK" 88 1206 430 32 (New-FontSafe "Arial" 18 ([System.Drawing.FontStyle]::Regular)) $brushSoft
  Draw-BoardFooter $g "05" "OPEN-FOR-BAGELS MOTION ASSETS" $w $h
  $eyebrow.Dispose()
  $headline.Dispose()
  $brushInk.Dispose()
  $brushSoft.Dispose()
  Save-Png $c $path
}

function Save-SquareCrop($srcPath, $destPath) {
  $src = [System.Drawing.Bitmap]::FromFile($srcPath)
  $dst = [System.Drawing.Bitmap]::new(1080, 1080)
  $g = [System.Drawing.Graphics]::FromImage($dst)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.Clear($Paper)
  $scale = [Math]::Min(([double]1080 / [double]$src.Width), ([double]1080 / [double]$src.Height))
  $dw = $src.Width * $scale
  $dh = $src.Height * $scale
  $dx = (1080 - $dw) / 2
  $dy = (1080 - $dh) / 2
  $g.DrawImage($src, [System.Drawing.RectangleF]::new($dx, $dy, $dw, $dh), [System.Drawing.RectangleF]::new(0, 0, $src.Width, $src.Height), [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()
  $dst.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $dst.Dispose()
  $src.Dispose()
}

function Write-SvgAssets {
  $small = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" role="img" aria-label="Open for Bagels small mark">
  <rect width="256" height="256" fill="#F7F5EF"/>
  <circle cx="128" cy="128" r="96" fill="#111111"/>
  <circle cx="128" cy="128" r="36" fill="#F7F5EF"/>
  <path d="M142 70 C164 74 177 88 181 108" fill="none" stroke="#F7F5EF" stroke-width="14" stroke-linecap="round"/>
</svg>
"@
  $horizontal = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 260" role="img" aria-label="Open for Bagels horizontal lockup">
  <rect width="900" height="260" fill="#F7F5EF"/>
  <rect x="40" y="32" width="820" height="48" fill="#B55339" stroke="#111111" stroke-width="6"/>
  <path d="M40 80 h820" stroke="#111111" stroke-width="6"/>
  <path d="M40 80 q58 58 116 0 q58 58 116 0 q58 58 116 0 q58 58 116 0 q58 58 116 0 q58 58 116 0 q58 58 124 0" fill="#F7F5EF" stroke="#111111" stroke-width="6"/>
  <circle cx="140" cy="162" r="54" fill="#111111"/>
  <circle cx="140" cy="162" r="20" fill="#F7F5EF"/>
  <path d="M148 125 C161 127 171 136 174 149" fill="none" stroke="#F7F5EF" stroke-width="8" stroke-linecap="round"/>
  <text x="230" y="158" font-family="Arial Rounded MT Bold, Arial, sans-serif" font-size="54" font-weight="800" fill="#111111">OPEN FOR BAGELS</text>
  <text x="234" y="202" font-family="Arial, sans-serif" font-size="18" letter-spacing="4" fill="#B55339">MORNING BAGELS / HANGING SIGN RITUAL</text>
</svg>
"@
  $badge = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400" role="img" aria-label="Open for Bagels badge lockup">
  <rect width="400" height="400" fill="#F7F5EF"/>
  <circle cx="200" cy="200" r="170" fill="none" stroke="#111111" stroke-width="10"/>
  <circle cx="200" cy="200" r="145" fill="none" stroke="#111111" stroke-width="5"/>
  <circle cx="200" cy="164" r="60" fill="#111111"/>
  <circle cx="200" cy="164" r="23" fill="#F7F5EF"/>
  <path d="M210 126 C225 128 236 139 239 153" fill="none" stroke="#F7F5EF" stroke-width="9" stroke-linecap="round"/>
  <text x="200" y="255" text-anchor="middle" font-family="Arial Rounded MT Bold, Arial, sans-serif" font-size="32" font-weight="800" fill="#111111">OPEN FOR</text>
  <text x="200" y="294" text-anchor="middle" font-family="Arial Rounded MT Bold, Arial, sans-serif" font-size="34" font-weight="800" fill="#B55339">BAGELS</text>
  <text x="200" y="324" text-anchor="middle" font-family="Arial, sans-serif" font-size="13" letter-spacing="2" fill="#111111">TURN MORNING ON</text>
</svg>
"@
  Set-Content -LiteralPath (Join-Path $FinalDir "open-for-bagels-small-mark.svg") -Value $small -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $FinalDir "open-for-bagels-horizontal-lockup.svg") -Value $horizontal -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $FinalDir "open-for-bagels-badge-lockup.svg") -Value $badge -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $MotionDir "open-for-bagels-small-mark.svg") -Value $small -Encoding UTF8
}

function Write-Demo {
  $html = @"
<!doctype html>
<html lang="en">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Open for Bagels - Identity Demo</title>
<style>
  :root { --ink:#111111; --paper:#F7F5EF; --accent:#B55339; --warm:#E8D9C7; }
  * { box-sizing:border-box; }
  body { margin:0; background:var(--paper); color:var(--ink); font-family:Arial, sans-serif; }
  main { min-height:100vh; display:grid; grid-template-columns:0.85fr 1.15fr; }
  section { padding:clamp(28px,6vw,86px); }
  .intro { display:flex; flex-direction:column; justify-content:space-between; border-right:1px solid rgba(17,17,17,.18); }
  .eyebrow { letter-spacing:.26em; font-size:12px; text-transform:uppercase; }
  h1 { font-family:"Arial Rounded MT Bold", Arial, sans-serif; font-size:clamp(54px,9vw,116px); line-height:.9; margin:.5em 0 .25em; }
  h1 span { color:var(--accent); display:block; }
  p { max-width:36rem; font-size:18px; line-height:1.55; color:#4A3A34; }
  .wall { display:grid; gap:24px; align-content:center; }
  .lockups { display:grid; grid-template-columns:1fr 260px; gap:20px; align-items:center; }
  img { width:100%; height:auto; display:block; }
  .board { border-top:1px solid rgba(17,17,17,.2); padding-top:20px; }
  .frames { display:grid; grid-template-columns:repeat(4,1fr); gap:10px; }
  @media (max-width:850px) { main { grid-template-columns:1fr; } .intro { border-right:0; border-bottom:1px solid rgba(17,17,17,.18); } .lockups { grid-template-columns:1fr; } .frames { grid-template-columns:repeat(2,1fr); } }
</style>
<main>
  <section class="intro">
    <div>
      <div class="eyebrow">Open for Bagels / Hanging Sign Ritual</div>
      <h1>Open for <span>Bagels</span></h1>
      <p>A compact identity system built from one ritual: a hand turns a round bagel sign beneath a terracotta awning. The final mark drops the hand and awning for small use while keeping the circle, center hole, and twist cue.</p>
    </div>
    <img src="open-for-bagels-horizontal-lockup.svg" alt="Open for Bagels horizontal lockup">
  </section>
  <section class="wall">
    <div class="lockups">
      <img src="04-core-logo-illustration.png" alt="Open for Bagels reduction proof board">
      <img src="open-for-bagels-badge-lockup.svg" alt="Open for Bagels badge lockup">
    </div>
    <div class="board">
      <div class="eyebrow">Motion frames</div>
      <div class="frames">
        <img src="../Assets/03_Brand_Projects/bagel-brand/03_Motion_Assets/whiteboard-source/open-for-bagels/motion-frames/K0.png" alt="Motion frame K0">
        <img src="../Assets/03_Brand_Projects/bagel-brand/03_Motion_Assets/whiteboard-source/open-for-bagels/motion-frames/K1.png" alt="Motion frame K1">
        <img src="../Assets/03_Brand_Projects/bagel-brand/03_Motion_Assets/whiteboard-source/open-for-bagels/motion-frames/K2.png" alt="Motion frame K2">
        <img src="../Assets/03_Brand_Projects/bagel-brand/03_Motion_Assets/whiteboard-source/open-for-bagels/motion-frames/K3.png" alt="Motion frame K3">
      </div>
    </div>
  </section>
</main>
</html>
"@
  Set-Content -LiteralPath (Join-Path $FinalDir "open-for-bagels-site.html") -Value $html -Encoding UTF8
}

Make-AlphaMaster
Write-SvgAssets

for ($i = 0; $i -lt 4; $i++) {
  Draw-MotionFrame (Join-Path $FrameDir ("K{0}.png" -f $i)) 1080 1350 $i
  Save-SquareCrop (Join-Path $FrameDir ("K{0}.png" -f $i)) (Join-Path $FrameDir ("K{0}-square.png" -f $i))
}

Draw-OpeningBoard (Join-Path $FinalDir "01-opening-storyboard.png") 1080 1350
Draw-IdentityBoard (Join-Path $FinalDir "02-brand-identity-description.png") 1080 1350
Draw-WorldBoard (Join-Path $FinalDir "03-storefront-and-sticker-set.png") 1080 1350
Draw-CoreBoard (Join-Path $FinalDir "04-core-logo-illustration.png") 1080 1350
Draw-MotionBoard (Join-Path $FinalDir "05-motion-study.png") 1080 1350

Save-SquareCrop (Join-Path $FinalDir "01-opening-storyboard.png") (Join-Path $FinalDir "01-opening-storyboard-square.png")
Save-SquareCrop (Join-Path $FinalDir "02-brand-identity-description.png") (Join-Path $FinalDir "02-brand-identity-description-square.png")
Save-SquareCrop (Join-Path $FinalDir "03-storefront-and-sticker-set.png") (Join-Path $FinalDir "03-storefront-and-sticker-set-square.png")
Save-SquareCrop (Join-Path $FinalDir "04-core-logo-illustration.png") (Join-Path $FinalDir "04-core-logo-illustration-square.png")
Save-SquareCrop (Join-Path $FinalDir "05-motion-study.png") (Join-Path $FinalDir "05-motion-study-square.png")

Copy-Item -LiteralPath (Join-Path $MotionDir "scene-01-open-for-bagels-whiteboard.mp4") -Destination (Join-Path $FinalDir "05-bagel-storyboard.mp4") -Force
Copy-Item -LiteralPath (Join-Path $MotionDir "scene-01-open-for-bagels-whiteboard.mp4") -Destination (Join-Path $FinalDir "05-open-for-bagels-whiteboard.mp4") -Force
Write-Demo

Get-ChildItem -LiteralPath $FinalDir | Sort-Object Name | Select-Object Name, Length
