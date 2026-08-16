from pathlib import Path
from PIL import Image, ImageDraw, ImageFont


OUT = Path(__file__).resolve().parent / "brand-assets"
OUT.mkdir(parents=True, exist_ok=True)
PAPER = "#FBF3E6"
INK = "#342E3F"
BERRY = "#7A3C57"
FONT = "C:/Windows/Fonts/georgia.ttf"
FONT_BOLD = "C:/Windows/Fonts/georgiab.ttf"


def tracked_text(draw, position, text, font, fill, tracking):
    x, y = position
    for character in text:
        draw.text((x, y), character, font=font, fill=fill)
        x += draw.textlength(character, font=font) + tracking


def tracked_width(draw, text, font, tracking):
    return sum(draw.textlength(character, font=font) for character in text) + tracking * (len(text) - 1)


def wordmark():
    image = Image.new("RGB", (1600, 500), PAPER)
    draw = ImageDraw.Draw(image)
    display = ImageFont.truetype(FONT, 132)
    support = ImageFont.truetype(FONT_BOLD, 29)
    name = "Soft Story"
    width = tracked_width(draw, name, display, -3)
    tracked_text(draw, ((1600 - width) / 2, 115), name, display, INK, -3)
    rule_y = 294
    draw.line((560, rule_y, 1040, rule_y), fill=BERRY, width=3)
    sub = "DESIGNS"
    sub_width = tracked_width(draw, sub, support, 9)
    tracked_text(draw, ((1600 - sub_width) / 2, 326), sub, support, BERRY, 9)
    image.save(OUT / "soft-story-designs-wordmark-1600x500.png", quality=97)


def etsy_logo():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    display = ImageFont.truetype(FONT, 71)
    support = ImageFont.truetype(FONT_BOLD, 20)
    for text, y in [("Soft", 138), ("Story", 223)]:
        width = tracked_width(draw, text, display, -1)
        tracked_text(draw, ((500 - width) / 2, y), text, display, INK, -1)
    draw.line((122, 326, 378, 326), fill=BERRY, width=3)
    sub = "DESIGNS"
    sub_width = tracked_width(draw, sub, support, 6)
    tracked_text(draw, ((500 - sub_width) / 2, 361), sub, support, BERRY, 6)
    image.save(OUT / "soft-story-designs-etsy-logo-500x500.png", quality=97)


if __name__ == "__main__":
    wordmark()
    etsy_logo()
    print(f"Created wordmarks in {OUT}")
