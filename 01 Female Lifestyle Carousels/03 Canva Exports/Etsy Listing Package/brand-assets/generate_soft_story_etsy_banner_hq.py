from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps


SCALE = 4
W, H = 1200 * SCALE, 160 * SCALE
PAPER = "#FAF6F1"
INK = "#342E3F"
BLUSH = "#C17A7A"
GOLD = "#C4A46C"
LINE = "#E8DDD0"
PHOTO = Path(__file__).resolve().parent / "ugc-originals" / "morning-pages-kitchen-original.png"
OUT = Path(__file__).resolve().parent / "soft-story-designs-etsy-banner-4800x640-hq.png"


def font(size, bold=False):
    return ImageFont.truetype("C:/Windows/Fonts/georgiab.ttf" if bold else "C:/Windows/Fonts/georgia.ttf", size * SCALE)


def sans(size, bold=False):
    return ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf", size * SCALE)


def draw_tracked(draw, x, y, text, fnt, fill, tracking):
    x *= SCALE
    y *= SCALE
    tracking *= SCALE
    for char in text:
        draw.text((x, y), char, font=fnt, fill=fill)
        x += draw.textlength(char, font=fnt) + tracking


def tracked_width(draw, text, fnt, tracking):
    return sum(draw.textlength(character, font=fnt) for character in text) + tracking * SCALE * (len(text) - 1)


image = Image.new("RGB", (W, H), PAPER)
draw = ImageDraw.Draw(image)

with Image.open(PHOTO) as source:
    photo = ImageOps.fit(source.convert("RGB"), (260 * SCALE, H), method=Image.Resampling.LANCZOS, centering=(0.54, 0.50))
image.paste(photo, (940 * SCALE, 0))
overlay = Image.new("RGBA", photo.size, (250, 246, 241, 74))
image.paste(Image.alpha_composite(photo.convert("RGBA"), overlay).convert("RGB"), (940 * SCALE, 0))

draw.rectangle((937 * SCALE, 0, 940 * SCALE, H), fill=GOLD)
draw.ellipse((825 * SCALE, -28 * SCALE, 905 * SCALE, 52 * SCALE), fill="#C17A7A22")

brand_font = font(31)
soft, story = "SOFT", "STORY"
tracking = 31 * 0.05
soft_width = tracked_width(draw, soft, brand_font, tracking)
space = draw.textlength(" ", font=brand_font)
safe_x = 285
draw_tracked(draw, safe_x, 48, soft, brand_font, BLUSH, tracking)
draw_tracked(draw, safe_x + (soft_width + space) / SCALE, 48, story, brand_font, GOLD, tracking)

designs_font = font(11)
draw_tracked(draw, safe_x + 3, 85, "DESIGNS", designs_font, BLUSH, 11 * 0.34)
draw.rectangle((safe_x * SCALE, 108 * SCALE, 790 * SCALE, 110 * SCALE), fill=LINE)
draw_tracked(draw, safe_x, 121, "EDITABLE CANVA CAROUSELS FOR LIFESTYLE CREATORS", sans(9, True), INK, 1.6)

image.save(OUT, "PNG", optimize=False)
print(f"{OUT} — {W} x {H}")
