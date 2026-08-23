Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$Out = Join-Path $Root "Final - First Crumb"
$Study = Join-Path $Root "Assets/02_Logo_Explorations/02_Rebuilt_Studies/first-crumb-cookie-ritual-v2.png"
$BrandAssets = Join-Path $Root "Assets/03_Brand_Projects/first-crumb/01_Identity_Assets"

New-Item -ItemType Directory -Force $Out | Out-Null
New-Item -ItemType Directory -Force $BrandAssets | Out-Null

$Paper = "#F8F1E4"
$PaperDeep = "#E8D6BD"
$Ink = "#17120E"
$Cocoa = "#7A4A2E"
$Milk = "#C8A379"
$Cream = "#FFF9EE"
$Line = "#D9C5A9"
$Muted = "#6F5B4B"

function C($hex) {
  return [System.Drawing.ColorTranslator]::FromHtml($hex)
}

function Brush($hex) {
  return [System.Drawing.SolidBrush]::new((C $hex))
}

function PenC($hex, $w) {
  $p = [System.Drawing.Pen]::new((C $hex), $w)
  $p.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  $p.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $p.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  return $p
}

function NewCanvas($w, $h, $bg) {
  $bmp = [System.Drawing.Bitmap]::new($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.Clear((C $bg))
  return @($bmp, $g)
}

function SaveCanvas($bmp, $g, $path) {
  $g.Dispose()
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

function FontF($name, $size, $style = [System.Drawing.FontStyle]::Regular) {
  return [System.Drawing.Font]::new($name, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}

function DrawText($g, $text, $font, $hex, $x, $y) {
  $g.DrawString($text, $font, (Brush $hex), [single]$x, [single]$y)
}

function DrawTrackingText($g, $text, $font, $hex, $x, $y, $tracking) {
  $cx = [single]$x
  $b = Brush $hex
  foreach ($ch in $text.ToCharArray()) {
    $s = [string]$ch
    $g.DrawString($s, $font, $b, $cx, [single]$y)
    $cx += $g.MeasureString($s, $font).Width + $tracking
  }
  $b.Dispose()
}

function DrawWrapped($g, $text, $font, $hex, $x, $y, $w, $lineH) {
  $words = $text -split " "
  $line = ""
  $cy = $y
  foreach ($word in $words) {
    $try = if ($line.Length -eq 0) { $word } else { "$line $word" }
    if ($g.MeasureString($try, $font).Width -gt $w -and $line.Length -gt 0) {
      DrawText $g $line $font $hex $x $cy
      $line = $word
      $cy += $lineH
    } else {
      $line = $try
    }
  }
  if ($line.Length -gt 0) { DrawText $g $line $font $hex $x $cy }
}

function DrawImageContain($g, $imgPath, $x, $y, $w, $h) {
  $img = [System.Drawing.Image]::FromFile($imgPath)
  $scale = [Math]::Min($w / $img.Width, $h / $img.Height)
  $dw = $img.Width * $scale
  $dh = $img.Height * $scale
  $dx = $x + ($w - $dw) / 2
  $dy = $y + ($h - $dh) / 2
  $g.DrawImage($img, [System.Drawing.RectangleF]::new($dx, $dy, $dw, $dh))
  $img.Dispose()
}

function DrawHeader($g, $label, $num, $w) {
  $mono = FontF "Arial" 19 ([System.Drawing.FontStyle]::Bold)
  DrawTrackingText $g "FIRST CRUMB" $mono $Ink 72 48 5
  DrawTrackingText $g ("BRAND IDENTITY / " + $num) $mono $Muted ($w - 376) 48 4
  $mono.Dispose()
}

function DrawSmallMark($g, $x, $y, $s, $reverse = $false) {
  $stroke = if ($reverse) { $Cream } else { $Ink }
  $fill = if ($reverse) { $Cocoa } else { $Paper }
  $p = PenC $stroke ([Math]::Max(2, $s * .035))
  $thin = PenC $stroke ([Math]::Max(1, $s * .018))
  $b = Brush $fill
  $chip = Brush $stroke
  $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
  [System.Drawing.PointF[]]$pts = @(
    [System.Drawing.PointF]::new($x + .18*$s, $y + .20*$s),
    [System.Drawing.PointF]::new($x + .74*$s, $y + .10*$s),
    [System.Drawing.PointF]::new($x + .91*$s, $y + .34*$s),
    [System.Drawing.PointF]::new($x + .80*$s, $y + .73*$s),
    [System.Drawing.PointF]::new($x + .46*$s, $y + .88*$s),
    [System.Drawing.PointF]::new($x + .37*$s, $y + .70*$s),
    [System.Drawing.PointF]::new($x + .45*$s, $y + .60*$s),
    [System.Drawing.PointF]::new($x + .36*$s, $y + .49*$s),
    [System.Drawing.PointF]::new($x + .44*$s, $y + .38*$s),
    [System.Drawing.PointF]::new($x + .30*$s, $y + .30*$s)
  )
  $path.AddClosedCurve($pts, .38)
  $g.FillPath($b, $path)
  $g.DrawPath($p, $path)
  $g.FillEllipse($chip, $x + .58*$s, $y + .31*$s, .13*$s, .11*$s)
  $g.FillEllipse($chip, $x + .61*$s, $y + .61*$s, .11*$s, .10*$s)
  $g.DrawLine($thin, $x + .08*$s, $y + .94*$s, $x + .84*$s, $y + .97*$s)
  $g.DrawLine($thin, $x + .20*$s, $y + .88*$s, $x + .96*$s, $y + .92*$s)
  $path.Dispose(); $p.Dispose(); $thin.Dispose(); $b.Dispose(); $chip.Dispose()
}

function DrawLockup($g, $x, $y, $scale = 1) {
  DrawSmallMark $g $x $y (120*$scale)
  $serif = FontF "Georgia" (64*$scale) ([System.Drawing.FontStyle]::Bold)
  DrawTrackingText $g "FIRST CRUMB" $serif $Ink ($x + 146*$scale) ($y + 18*$scale) (1.4*$scale)
  $dot = Brush $Cocoa
  $g.FillEllipse($dot, $x + 398*$scale, $y + 16*$scale, 12*$scale, 12*$scale)
  $dot.Dispose()
  $sans = FontF "Arial" (16*$scale) ([System.Drawing.FontStyle]::Bold)
  DrawTrackingText $g "COOKIES / SLEEVES / AFTERNOON SNAP" $sans $Muted ($x + 150*$scale) ($y + 92*$scale) (3*$scale)
  $serif.Dispose(); $sans.Dispose()
}

function DrawSleeveBadge($g, $x, $y, $w, $h) {
  $p = PenC $Ink 4
  $b = Brush $Cream
  [System.Drawing.PointF[]]$pts = @(
    [System.Drawing.PointF]::new($x + .08*$w, $y + .13*$h),
    [System.Drawing.PointF]::new($x + .88*$w, $y + .06*$h),
    [System.Drawing.PointF]::new($x + .95*$w, $y + .83*$h),
    [System.Drawing.PointF]::new($x + .18*$w, $y + .94*$h)
  )
  $g.FillPolygon($b, $pts)
  $g.DrawPolygon($p, $pts)
  $g.DrawLine((PenC $Line 3), $x + .16*$w, $y + .75*$h, $x + .92*$w, $y + .66*$h)
  DrawSmallMark $g ($x + .40*$w) ($y + .18*$h) (.23*$w)
  $badgeType = [Math]::Min((.105*$w), (.18*$h))
  $serif = FontF "Georgia" $badgeType ([System.Drawing.FontStyle]::Bold)
  DrawTrackingText $g "FIRST" $serif $Ink ($x + .26*$w) ($y + .45*$h) 1.5
  DrawTrackingText $g "CRUMB" $serif $Ink ($x + .24*$w) ($y + .57*$h) 1.5
  $sans = FontF "Arial" ([Math]::Max(7, (.022*$w))) ([System.Drawing.FontStyle]::Bold)
  DrawTrackingText $g "ONE COOKIE / ONE BREAK" $sans $Muted ($x + .22*$w) ($y + .76*$h) 0
  $p.Dispose(); $b.Dispose(); $serif.Dispose(); $sans.Dispose()
}

function DrawHandSimple($g, $x, $y, $s) {
  $p = PenC $Ink ([Math]::Max(2, $s * .025))
  $b = Brush $Cream
  $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
  [System.Drawing.PointF[]]$pts = @(
    [System.Drawing.PointF]::new($x + .06*$s, $y + .20*$s),
    [System.Drawing.PointF]::new($x + .40*$s, $y + .10*$s),
    [System.Drawing.PointF]::new($x + .70*$s, $y + .20*$s),
    [System.Drawing.PointF]::new($x + .92*$s, $y + .40*$s),
    [System.Drawing.PointF]::new($x + .76*$s, $y + .58*$s),
    [System.Drawing.PointF]::new($x + .42*$s, $y + .48*$s),
    [System.Drawing.PointF]::new($x + .12*$s, $y + .36*$s)
  )
  $path.AddClosedCurve($pts, .28)
  $g.FillPath($b, $path)
  $g.DrawPath($p, $path)
  $g.DrawLine((PenC $Ink ([Math]::Max(2, $s * .016))), $x + .46*$s, $y + .18*$s, $x + .38*$s, $y + .50*$s)
  $g.DrawLine((PenC $Ink ([Math]::Max(2, $s * .014))), $x + .58*$s, $y + .22*$s, $x + .55*$s, $y + .52*$s)
  $g.DrawLine((PenC $Ink ([Math]::Max(2, $s * .014))), $x + .70*$s, $y + .28*$s, $x + .68*$s, $y + .54*$s)
  $path.Dispose(); $p.Dispose(); $b.Dispose()
}

function DrawSleeveSimple($g, $x, $y, $w, $h) {
  [System.Drawing.PointF[]]$pts = @(
    [System.Drawing.PointF]::new($x, $y + .22*$h),
    [System.Drawing.PointF]::new($x + .87*$w, $y),
    [System.Drawing.PointF]::new($x + $w, $y + .76*$h),
    [System.Drawing.PointF]::new($x + .12*$w, $y + $h)
  )
  $g.FillPolygon((Brush $Cream), $pts)
  $g.DrawPolygon((PenC $Ink 4), $pts)
  $g.DrawLine((PenC $Line 3), $x + .08*$w, $y + .76*$h, $x + .96*$w, $y + .58*$h)
}

function DrawCookieFull($g, $cx, $cy, $r, $crack = $false) {
  $p = PenC $Ink ([Math]::Max(3, $r * .09))
  $thin = PenC $Ink ([Math]::Max(1, $r * .025))
  $g.FillEllipse((Brush $Paper), $cx - $r, $cy - $r*.86, $r*2, $r*1.72)
  $g.DrawEllipse($p, $cx - $r, $cy - $r*.86, $r*2, $r*1.72)
  $chips = @(
    @(-.42,-.22), @(.38,-.28), @(-.22,.34), @(.34,.26)
  )
  foreach ($ch in $chips) {
    $g.FillEllipse((Brush $Ink), $cx + $ch[0]*$r, $cy + $ch[1]*$r, $r*.16, $r*.14)
  }
  if ($crack) {
    $jag = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $jag.AddLines([System.Drawing.PointF[]]@(
      [System.Drawing.PointF]::new($cx - .03*$r, $cy - .80*$r),
      [System.Drawing.PointF]::new($cx + .07*$r, $cy - .50*$r),
      [System.Drawing.PointF]::new($cx - .04*$r, $cy - .18*$r),
      [System.Drawing.PointF]::new($cx + .08*$r, $cy + .12*$r),
      [System.Drawing.PointF]::new($cx - .02*$r, $cy + .52*$r),
      [System.Drawing.PointF]::new($cx + .06*$r, $cy + .82*$r)
    ))
    $g.DrawPath((PenC $Ink ([Math]::Max(4, $r * .07))), $jag)
    $jag.Dispose()
  } else {
    $g.DrawArc($thin, $cx - .50*$r, $cy - .45*$r, $r*.50, $r*.28, 180, 80)
    $g.DrawArc($thin, $cx + .10*$r, $cy + .12*$r, $r*.52, $r*.28, 20, 90)
  }
  $p.Dispose(); $thin.Dispose()
}

function DrawRitualState($g, $x, $y, $w, $h, $stateIndex) {
  DrawSleeveSimple $g ($x + .12*$w) ($y + .58*$h) (.76*$w) (.24*$h)
  DrawHandSimple $g ($x + .20*$w) ($y + .07*$h) (.58*$w)
  if ($stateIndex -eq 0) {
    DrawCookieFull $g ($x + .50*$w) ($y + .55*$h) (.19*$w) $false
  } elseif ($stateIndex -eq 1) {
    DrawCookieFull $g ($x + .50*$w) ($y + .55*$h) (.19*$w) $true
    DrawText $g "*" (FontF "Georgia" ([int](.12*$w)) ([System.Drawing.FontStyle]::Bold)) $Cocoa ($x + .49*$w) ($y + .46*$h)
  } elseif ($stateIndex -eq 2) {
    DrawSmallMark $g ($x + .25*$w) ($y + .39*$h) (.19*$w)
    DrawSmallMark $g ($x + .57*$w) ($y + .39*$h) (.19*$w)
    $g.FillEllipse((Brush $Cocoa), $x + .49*$w, $y + .58*$h, .028*$w, .028*$w)
  } else {
    DrawSmallMark $g ($x + .29*$w) ($y + .50*$h) (.17*$w)
    DrawSmallMark $g ($x + .54*$w) ($y + .51*$h) (.17*$w)
  }
}

function RenderMotionFrame($path, $stateIndex, $label) {
  $cv = NewCanvas 1080 1080 $Paper
  $bmp = $cv[0]; $g = $cv[1]
  DrawTrackingText $g "FIRST CRUMB" (FontF "Arial" 20 ([System.Drawing.FontStyle]::Bold)) $Ink 66 52 5
  DrawTrackingText $g $label (FontF "Arial" 20 ([System.Drawing.FontStyle]::Bold)) $Muted 740 52 4
  DrawRitualState $g 110 140 860 780 $stateIndex
  SaveCanvas $bmp $g $path
}

function DrawMenuBoard($g, $x, $y, $w, $h) {
  $g.FillRectangle((Brush $Cream), $x, $y, $w, $h)
  $g.DrawRectangle((PenC $Ink 4), $x, $y, $w, $h)
  $serif = FontF "Georgia" ([Math]::Max(28, [int]($w * .10))) ([System.Drawing.FontStyle]::Bold)
  DrawText $g "Fresh Today" $serif $Ink ($x + 34) ($y + 32)
  $sans = FontF "Arial" ([Math]::Max(14, [int]($w * .046))) ([System.Drawing.FontStyle]::Bold)
  $items = @(
    @("Choc Chip Cookie", "3.80"),
    @("Salt Cookie", "4.20"),
    @("Sleeve of Two", "7.00"),
    @("Cold Milk", "2.50")
  )
  $cy = $y + 122
  foreach ($it in $items) {
    DrawText $g $it[0] $sans $Ink ($x + 34) $cy
    DrawText $g ("$" + $it[1]) $sans $Ink ($x + $w - 80) $cy
    $g.DrawLine((PenC $Line 2), $x + 38, $cy + 36, $x + $w - 38, $cy + 36)
    $cy += 58
  }
  DrawTrackingText $g "FIRST CRUMB" (FontF "Arial" ([Math]::Max(11, [int]($w * .034))) ([System.Drawing.FontStyle]::Bold)) $Cocoa ($x + 34) ($y + $h - 52) 3
  $serif.Dispose(); $sans.Dispose()
}

function RenderOpening($path, $w, $h) {
  $cv = NewCanvas $w $h $Paper
  $bmp = $cv[0]; $g = $cv[1]
  DrawHeader $g "First Crumb" "01" $w
  $serif = FontF "Georgia" ([int]($w*.108)) ([System.Drawing.FontStyle]::Bold)
  DrawText $g "First" $serif $Ink 72 145
  DrawText $g "Crumb." $serif $Ink 72 ([int](145 + $w*.105))
  $italic = FontF "Georgia" 37 ([System.Drawing.FontStyle]::Italic)
  DrawWrapped $g "A soft afternoon bakery identity built around the exact moment a warm cookie snaps open." $italic $Cocoa 76 ([int]($h*.34)) ([int]($w*.48)) 52
  $g.FillRectangle((Brush $PaperDeep), [int]($w*.08), [int]($h*.57), [int]($w*.84), [int]($h*.26))
  DrawSleeveBadge $g ([int]($w*.18)) ([int]($h*.59)) ([int]($w*.26)) ([int]($h*.19))
  DrawMenuBoard $g ([int]($w*.53)) ([int]($h*.55)) ([int]($w*.30)) ([int]($h*.24))
  DrawLockup $g 76 ([int]($h*.88)) .52
  $serif.Dispose(); $italic.Dispose()
  SaveCanvas $bmp $g $path
}

function RenderIdentity($path, $w, $h) {
  $cv = NewCanvas $w $h $Paper
  $bmp = $cv[0]; $g = $cv[1]
  DrawHeader $g "First Crumb" "02" $w
  DrawImageContain $g $Study 66 150 ([int]($w*.44)) ([int]($h*.45))
  DrawLockup $g ([int]($w*.53)) 168 .43
  DrawSleeveBadge $g ([int]($w*.63)) 332 ([int]($w*.24)) ([int]($h*.18))
  $serif = FontF "Georgia" 41 ([System.Drawing.FontStyle]::Italic)
  DrawWrapped $g "A hand breaks one chocolate-chip cookie over a folded wax-paper sleeve." $serif $Ink 72 ([int]($h*.65)) ([int]($w*.42)) 54
  $sans = FontF "Arial" 17 ([System.Drawing.FontStyle]::Bold)
  DrawTrackingText $g "COLOUR SYSTEM" $sans $Muted ([int]($w*.55)) ([int]($h*.58)) 4
  $swatches = @(
    @("INK", $Ink),
    @("COCOA", $Cocoa),
    @("WAX PAPER", $PaperDeep),
    @("COOKIE MILK", $Milk)
  )
  $sx = [int]($w*.55); $sy = [int]($h*.62); $sw = [int]($w*.16); $sh = 92
  for ($i = 0; $i -lt $swatches.Count; $i++) {
    $cx = $sx + (($i % 2) * ($sw + 22))
    $cy = $sy + ([Math]::Floor($i / 2) * ($sh + 20))
    $g.FillRectangle((Brush $swatches[$i][1]), $cx, $cy, $sw, $sh)
    $col = if ($i -eq 2 -or $i -eq 3) { $Ink } else { $Cream }
    DrawTrackingText $g $swatches[$i][0] $sans $col ($cx + 18) ($cy + 34) 2
  }
  DrawTrackingText $g "TYPE: EDITORIAL SERIF" $sans $Muted ([int]($w*.55)) ([int]($h*.84)) 3
  DrawTrackingText $g "HAND-STAMPED SERVICE TEXT" $sans $Muted ([int]($w*.55)) ([int]($h*.875)) 3
  $serif.Dispose(); $sans.Dispose()
  SaveCanvas $bmp $g $path
}

function RenderWorld($path, $w, $h) {
  $cv = NewCanvas $w $h $Paper
  $bmp = $cv[0]; $g = $cv[1]
  DrawHeader $g "First Crumb" "03" $w
  $serif = FontF "Georgia" 66 ([System.Drawing.FontStyle]::Bold)
  DrawText $g "Open tomorrow:" $serif $Ink 74 136
  $italic = FontF "Georgia" 31 ([System.Drawing.FontStyle]::Italic)
  DrawWrapped $g "sleeves on the counter, a pastry box for the walk home, and a small stamp card for the next break." $italic $Cocoa 78 222 ([int]($w*.62)) 43
  $g.FillRectangle((Brush $Cocoa), 0, [int]($h*.40), [int]($w*.45), [int]($h*.60))
  DrawText $g "First Crumb" (FontF "Georgia" 60 ([System.Drawing.FontStyle]::Bold)) $Cream 72 ([int]($h*.49))
  DrawWrapped $g "Operational objects become the system: wax paper, chip dots, folded sleeves, and one warm cookie ritual." (FontF "Georgia" 34 ([System.Drawing.FontStyle]::Italic)) $Cream 78 ([int]($h*.61)) ([int]($w*.33)) 46
  DrawSleeveBadge $g ([int]($w*.50)) ([int]($h*.36)) ([int]($w*.32)) ([int]($h*.22))
  DrawSleeveBadge $g ([int]($w*.58)) ([int]($h*.58)) ([int]($w*.25)) ([int]($h*.17))
  DrawMenuBoard $g ([int]($w*.68)) ([int]($h*.15)) ([int]($w*.24)) ([int]($h*.27))
  $g.FillRectangle((Brush $Cream), [int]($w*.50), [int]($h*.80), [int]($w*.38), [int]($h*.10))
  $g.DrawRectangle((PenC $Ink 3), [int]($w*.50), [int]($h*.80), [int]($w*.38), [int]($h*.10))
  DrawSmallMark $g ([int]($w*.53)) ([int]($h*.815)) 72
  DrawTrackingText $g "SNAP CARD" (FontF "Arial" 24 ([System.Drawing.FontStyle]::Bold)) $Ink ([int]($w*.62)) ([int]($h*.835)) 4
  for ($i = 0; $i -lt 5; $i++) {
    DrawSmallMark $g ([int]($w*.61 + $i*.045*$w)) ([int]($h*.875)) 34
  }
  $serif.Dispose(); $italic.Dispose()
  SaveCanvas $bmp $g $path
}

function RenderCore($path, $w, $h) {
  $cv = NewCanvas $w $h $Cream
  $bmp = $cv[0]; $g = $cv[1]
  DrawHeader $g "First Crumb" "04" $w
  DrawImageContain $g $Study 88 132 ([int]($w*.58)) ([int]($h*.58))
  $g.FillRectangle((Brush $Cocoa), [int]($w*.70), 165, [int]($w*.22), [int]($h*.23))
  DrawSmallMark $g ([int]($w*.75)) 210 ([int]($w*.12)) $true
  DrawTrackingText $g "REVERSE" (FontF "Arial" 17 ([System.Drawing.FontStyle]::Bold)) $Cream ([int]($w*.74)) ([int]($h*.34)) 4
  DrawSmallMark $g ([int]($w*.71)) ([int]($h*.46)) 120
  DrawTrackingText $g "48 PX" (FontF "Arial" 16 ([System.Drawing.FontStyle]::Bold)) $Muted ([int]($w*.72)) ([int]($h*.585)) 3
  DrawSmallMark $g ([int]($w*.84)) ([int]($h*.49)) 62
  DrawTrackingText $g "24 PX" (FontF "Arial" 16 ([System.Drawing.FontStyle]::Bold)) $Muted ([int]($w*.835)) ([int]($h*.585)) 3
  DrawWrapped $g "Reduction rule: one cookie half, two chips, one sleeve fold. The hand and dense crumb shading do not enter the small mark." (FontF "Georgia" 32 ([System.Drawing.FontStyle]::Italic)) $Ink 82 ([int]($h*.77)) ([int]($w*.72)) 43
  SaveCanvas $bmp $g $path
}

function RenderMotion($path, $w, $h) {
  $cv = NewCanvas $w $h $Paper
  $bmp = $cv[0]; $g = $cv[1]
  DrawHeader $g "First Crumb" "05" $w
  DrawText $g "Derived snap study" (FontF "Georgia" 66 ([System.Drawing.FontStyle]::Bold)) $Ink 72 132
  DrawWrapped $g "Icon sequence derived from the approved cookie-break ritual; the primary illustration remains the continuity anchor." (FontF "Georgia" 28 ([System.Drawing.FontStyle]::Italic)) $Cocoa 76 212 ([int]($w*.58)) 39
  DrawImageContain $g $Study ([int]($w*.72)) 135 ([int]($w*.19)) ([int]($h*.18))
  DrawTrackingText $g "APPROVED RITUAL" (FontF "Arial" 11 ([System.Drawing.FontStyle]::Bold)) $Muted ([int]($w*.725)) ([int]($h*.245)) 1.8
  $labels = @("K0 / HELD", "K1 / SNAP", "K2 / APART", "K3 / SLEEVE")
  for ($i = 0; $i -lt 4; $i++) {
    $x = 78 + (($i % 2) * [int]($w*.45))
    $y = [int]($h*.37) + ([Math]::Floor($i / 2) * [int]($h*.23))
    $g.FillRectangle((Brush $Cream), $x, $y, [int]($w*.36), [int]($h*.17))
    $g.DrawRectangle((PenC $Line 2), $x, $y, [int]($w*.36), [int]($h*.17))
    DrawRitualState $g ($x + 22) ($y + 36) ([int]($w*.32)) ([int]($h*.12)) $i
    DrawTrackingText $g ($labels[$i] + " / DERIVED") (FontF "Arial" 13 ([System.Drawing.FontStyle]::Bold)) $Muted ($x + 24) ($y + 20) 2
  }
  SaveCanvas $bmp $g $path
}

function WriteSmallMarkSvg($path) {
@"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 140" role="img" aria-labelledby="title">
  <title id="title">First Crumb small mark</title>
  <path d="M36 28 C68 6 126 10 152 44 C172 70 154 116 104 128 C78 134 64 119 70 101 C76 86 67 78 78 65 C66 55 72 41 54 38 C45 36 39 33 36 28Z" fill="#F8F1E4" stroke="#17120E" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M75 38 C66 51 78 57 68 70 C80 81 68 91 73 105" fill="none" stroke="#17120E" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M106 46 C116 40 127 48 124 59 C117 65 103 60 106 46Z" fill="#17120E"/>
  <path d="M112 90 C123 83 134 92 129 103 C120 109 108 101 112 90Z" fill="#17120E"/>
  <path d="M18 133 C58 124 111 124 164 132" fill="none" stroke="#17120E" stroke-width="4" stroke-linecap="round"/>
</svg>
"@ | Set-Content -Encoding utf8 $path
}

function WriteLockupSvg($path) {
@"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 160" role="img" aria-labelledby="title">
  <title id="title">First Crumb horizontal lockup</title>
  <g transform="translate(8 8) scale(.95)">
    <path d="M36 28 C68 6 126 10 152 44 C172 70 154 116 104 128 C78 134 64 119 70 101 C76 86 67 78 78 65 C66 55 72 41 54 38 C45 36 39 33 36 28Z" fill="#F8F1E4" stroke="#17120E" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M75 38 C66 51 78 57 68 70 C80 81 68 91 73 105" fill="none" stroke="#17120E" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M106 46 C116 40 127 48 124 59 C117 65 103 60 106 46Z" fill="#17120E"/>
    <path d="M112 90 C123 83 134 92 129 103 C120 109 108 101 112 90Z" fill="#17120E"/>
    <path d="M18 133 C58 124 111 124 164 132" fill="none" stroke="#17120E" stroke-width="4" stroke-linecap="round"/>
  </g>
  <text x="190" y="86" font-family="Georgia, 'Times New Roman', serif" font-size="58" font-weight="700" letter-spacing="1.5" fill="#17120E">FIRST CRUMB</text>
  <circle cx="396" cy="34" r="6" fill="#7A4A2E"/>
  <text x="194" y="124" font-family="Arial, sans-serif" font-size="16" font-weight="700" letter-spacing="4" fill="#6F5B4B">COOKIES / SLEEVES / AFTERNOON SNAP</text>
</svg>
"@ | Set-Content -Encoding utf8 $path
}

function WriteBadgeSvg($path) {
@"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 520 420" role="img" aria-labelledby="title">
  <title id="title">First Crumb sleeve badge lockup</title>
  <path d="M48 70 L456 40 L486 348 L96 390 Z" fill="#FFF9EE" stroke="#17120E" stroke-width="8" stroke-linejoin="round"/>
  <path d="M82 316 C206 296 338 294 466 280" fill="none" stroke="#D9C5A9" stroke-width="5" stroke-linecap="round"/>
  <g transform="translate(184 76) scale(.82)">
    <path d="M36 28 C68 6 126 10 152 44 C172 70 154 116 104 128 C78 134 64 119 70 101 C76 86 67 78 78 65 C66 55 72 41 54 38 C45 36 39 33 36 28Z" fill="#F8F1E4" stroke="#17120E" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M75 38 C66 51 78 57 68 70 C80 81 68 91 73 105" fill="none" stroke="#17120E" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M106 46 C116 40 127 48 124 59 C117 65 103 60 106 46Z" fill="#17120E"/>
    <path d="M112 90 C123 83 134 92 129 103 C120 109 108 101 112 90Z" fill="#17120E"/>
    <path d="M18 133 C58 124 111 124 164 132" fill="none" stroke="#17120E" stroke-width="4" stroke-linecap="round"/>
  </g>
  <text x="129" y="245" font-family="Georgia, 'Times New Roman', serif" font-size="66" font-weight="700" letter-spacing="2" fill="#17120E">FIRST</text>
  <text x="106" y="315" font-family="Georgia, 'Times New Roman', serif" font-size="66" font-weight="700" letter-spacing="2" fill="#17120E">CRUMB</text>
  <text x="150" y="358" font-family="Arial, sans-serif" font-size="15" font-weight="700" letter-spacing="4" fill="#6F5B4B">ONE COOKIE / ONE BREAK</text>
</svg>
"@ | Set-Content -Encoding utf8 $path
}

function WriteSite($path) {
@"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>First Crumb - Brand Identity</title>
<style>
:root{--paper:#F8F1E4;--cream:#FFF9EE;--ink:#17120E;--cocoa:#7A4A2E;--milk:#C8A379;--line:#D9C5A9;--muted:#6F5B4B}
*{box-sizing:border-box}body{margin:0;background:var(--paper);color:var(--ink);font-family:Arial,sans-serif}header,section,footer{padding:34px clamp(22px,5vw,72px)}.hud{display:flex;justify-content:space-between;font-size:12px;font-weight:700;letter-spacing:.24em;text-transform:uppercase;color:var(--muted)}h1,h2{font-family:Georgia,serif;letter-spacing:0;margin:0}h1{font-size:clamp(72px,13vw,172px);line-height:.88;margin:12vh 0 24px}h2{font-size:clamp(42px,7vw,90px);line-height:.95}.voice{font:italic clamp(22px,3vw,34px) Georgia,serif;color:var(--cocoa);max-width:26ch;line-height:1.35}.hero{min-height:100vh}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:28px;margin-top:48px}.plate{background:var(--cream);border:1px solid var(--line);padding:20px}.plate img{width:100%;display:block}.motion{position:relative;display:grid;place-items:center;min-height:580px;background:var(--cream);border-top:1px solid var(--line);border-bottom:1px solid var(--line)}.motion img{width:min(74vw,620px);max-height:70vh;object-fit:contain}.state{position:absolute;left:36px;bottom:28px;font-size:12px;font-weight:700;letter-spacing:.24em;text-transform:uppercase;color:var(--muted)}button{appearance:none;border:1px solid var(--ink);background:var(--ink);color:var(--cream);padding:12px 18px;font-weight:700;letter-spacing:.16em;text-transform:uppercase;cursor:pointer}footer{display:flex;justify-content:space-between;border-top:1px solid var(--line);font-size:11px;font-weight:700;letter-spacing:.2em;text-transform:uppercase;color:var(--muted)}@media(max-width:800px){.grid{grid-template-columns:1fr}footer{display:block;line-height:2}}
</style>
</head>
<body>
<main>
<section class="hero">
<div class="hud"><span>First Crumb</span><span>Brand Identity / 01</span></div>
<h1>First<br>Crumb.</h1>
<p class="voice">A hand breaks one chocolate-chip cookie over a folded wax-paper sleeve.</p>
</section>
<section>
<div class="hud"><span>Identity</span><span>02-04</span></div>
<h2>One break. One sleeve. One small mark.</h2>
<div class="grid">
<figure class="plate"><img src="02-brand-identity.png" alt="First Crumb identity board"></figure>
<figure class="plate"><img src="03-brand-world.png" alt="First Crumb brand world board"></figure>
<figure class="plate"><img src="04-core-illustration.png" alt="First Crumb reduction board"></figure>
<figure class="plate"><img src="05-snap-motion.png" alt="First Crumb snap motion board"></figure>
</div>
</section>
<section>
<div class="hud"><span>Motion Demo</span><span>05</span></div>
<h2>Derived snap states.</h2>
<p class="voice">The motion demo cycles a simplified icon sequence derived from the approved cookie-break illustration.</p>
<div class="motion">
<img id="frame" src="motion-k0.png" alt="First Crumb snap motion keyframe">
<div class="state" id="state">K0 / held</div>
</div>
<p><button id="next">Advance State</button></p>
</section>
</main>
<footer><span>First Crumb - Brand Identity</span><span>Monochrome Branding / Carousel Design Studio</span><span>2026</span></footer>
<script>
const frame=document.getElementById('frame');const state=document.getElementById('state');const src=['motion-k0.png','motion-k1.png','motion-k2.png','motion-k3.png'];const labels=['K0 / held','K1 / snap','K2 / apart','K3 / sleeve'];let i=0;function apply(){frame.src=src[i];state.textContent=labels[i]}document.getElementById('next').onclick=()=>{i=(i+1)%4;apply()};setInterval(()=>{i=(i+1)%4;apply()},1800);apply();
</script>
</body>
</html>
"@ | Set-Content -Encoding utf8 $path
}

Copy-Item -LiteralPath $Study -Destination (Join-Path $Out "first-crumb-primary-illustration.png") -Force
Copy-Item -LiteralPath $Study -Destination (Join-Path $BrandAssets "first-crumb-primary-illustration-v2.png") -Force

WriteSmallMarkSvg (Join-Path $Out "first-crumb-small-mark.svg")
WriteSmallMarkSvg (Join-Path $BrandAssets "first-crumb-small-mark.svg")
WriteLockupSvg (Join-Path $Out "first-crumb-horizontal-lockup.svg")
WriteLockupSvg (Join-Path $BrandAssets "first-crumb-horizontal-lockup.svg")
WriteBadgeSvg (Join-Path $Out "first-crumb-sleeve-badge-lockup.svg")
WriteBadgeSvg (Join-Path $BrandAssets "first-crumb-sleeve-badge-lockup.svg")
WriteSite (Join-Path $Out "first-crumb-site.html")
WriteSite (Join-Path $Out "first-crumb-snap-demo.html")

RenderOpening (Join-Path $Out "01-opening.png") 1080 1350
RenderIdentity (Join-Path $Out "02-brand-identity.png") 1080 1350
RenderWorld (Join-Path $Out "03-brand-world.png") 1080 1350
RenderCore (Join-Path $Out "04-core-illustration.png") 1080 1350
RenderMotion (Join-Path $Out "05-snap-motion.png") 1080 1350
RenderMotionFrame (Join-Path $Out "motion-k0.png") 0 "K0 / HELD"
RenderMotionFrame (Join-Path $Out "motion-k1.png") 1 "K1 / SNAP"
RenderMotionFrame (Join-Path $Out "motion-k2.png") 2 "K2 / APART"
RenderMotionFrame (Join-Path $Out "motion-k3.png") 3 "K3 / SLEEVE"
Copy-Item -LiteralPath (Join-Path $Out "motion-k0.png") -Destination (Join-Path $BrandAssets "motion-k0.png") -Force
Copy-Item -LiteralPath (Join-Path $Out "motion-k1.png") -Destination (Join-Path $BrandAssets "motion-k1.png") -Force
Copy-Item -LiteralPath (Join-Path $Out "motion-k2.png") -Destination (Join-Path $BrandAssets "motion-k2.png") -Force
Copy-Item -LiteralPath (Join-Path $Out "motion-k3.png") -Destination (Join-Path $BrandAssets "motion-k3.png") -Force

RenderOpening (Join-Path $Out "01-opening-square.png") 1080 1080
RenderIdentity (Join-Path $Out "02-brand-identity-square.png") 1080 1080
RenderWorld (Join-Path $Out "03-brand-world-square.png") 1080 1080
RenderCore (Join-Path $Out "04-core-illustration-square.png") 1080 1080
RenderMotion (Join-Path $Out "05-snap-motion-square.png") 1080 1080

Write-Host "First Crumb boards and assets generated."
