from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps


W, H = 1200, 160
PAPER = "#FAF6F1"
INK = "#342E3F"
BLUSH = "#C17A7A"
GOLD = "#C4A46C"
LINE = "#E8DDD0"
ROOT = Path(__file__).resolve().parents[3]
PHOTO = Path(__file__).resolve().parent / "ugc-originals" / "morning-pages-kitchen-original.png"
OUT = Path(__file__).resolve().parent / "soft-story-designs-etsy-banner-1200x160.png"


def font(size, bold=False):
    return ImageFont.truetype("C:/Windows/Fonts/georgiab.ttf" if bold else "C:/Windows/Fonts/georgia.ttf", size)


def sans(size, bold=False):
    return ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf", size)


def tracked_width(draw, text, fnt, tracking):
    return sum(draw.textlength(character, font=fnt) for character in text) + tracking * (len(text) - 1)


def draw_tracked(draw, x, y, text, fnt, fill, tracking):
    for character in text:
        draw.text((x, y), character, font=fnt, fill=fill)
        x += draw.textlength(character, font=fnt) + tracking


image = Image.new("RGB", (W, H), PAPER)
draw = ImageDraw.Draw(image)

# A calm lifestyle crop gives the narrow banner warmth without competing with the shop name.
with Image.open(PHOTO) as source:
    photo = ImageOps.fit(source.convert("RGB"), (260, H), method=Image.Resampling.LANCZOS, centering=(0.54, 0.50))
image.paste(photo, (940, 0))
overlay = Image.new("RGBA", (260, H), (250, 246, 241, 74))
image.paste(Image.alpha_composite(photo.convert("RGBA"), overlay).convert("RGB"), (940, 0))

draw.rectangle((937, 0, 940, H), fill=GOLD)
draw.ellipse((825, -28, 905, 52), fill="#C17A7A22")

brand_font = font(31)
soft = "SOFT"
story = "STORY"
tracking = 31 * 0.05
soft_width = tracked_width(draw, soft, brand_font, tracking)
space = draw.textlength(" ", font=brand_font)
safe_x = 285
draw_tracked(draw, safe_x, 48, soft, brand_font, BLUSH, tracking)
draw_tracked(draw, safe_x + soft_width + space, 48, story, brand_font, GOLD, tracking)

designs = "DESIGNS"
designs_font = font(11)
designs_tracking = 11 * 0.34
draw_tracked(draw, safe_x + 3, 85, designs, designs_font, BLUSH, designs_tracking)
draw.rectangle((safe_x, 108, 790, 110), fill=LINE)
draw_tracked(
    draw,
    safe_x,
    121,
    "EDITABLE CANVA CAROUSELS FOR LIFESTYLE CREATORS",
    sans(9, True),
    INK,
    1.6,
)

image.save(OUT, "PNG", optimize=True)
print(OUT)
