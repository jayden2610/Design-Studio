from pathlib import Path
from PIL import Image, ImageDraw, ImageFont


OUT = Path(__file__).resolve().parent / "brand-assets" / "logo-variants"
OUT.mkdir(parents=True, exist_ok=True)
PAPER = "#FBF3E6"
INK = "#342E3F"
BERRY = "#7A3C57"
BLUSH = "#F4D8D5"
OLIVE = "#9CA274"
GEORGIA = "C:/Windows/Fonts/georgia.ttf"
GEORGIA_BOLD = "C:/Windows/Fonts/georgiab.ttf"
GEORGIA_ITALIC = "C:/Windows/Fonts/georgiai.ttf"


def f(path, size):
    return ImageFont.truetype(path, size)


def tracked(draw, xy, text, font, fill, tracking=0):
    x, y = xy
    for letter in text:
        draw.text((x, y), letter, font=font, fill=fill)
        x += draw.textlength(letter, font=font) + tracking


def width(draw, text, font, tracking=0):
    return sum(draw.textlength(letter, font=font) for letter in text) + tracking * (len(text) - 1)


def centered_tracked(draw, y, text, font, fill, tracking=0):
    tracked(draw, ((500 - width(draw, text, font, tracking)) / 2, y), text, font, fill, tracking)


def save(image, name):
    image.save(OUT / name, quality=97)


def variant_01():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    centered_tracked(draw, 112, "Soft", f(GEORGIA, 74), INK, -2)
    centered_tracked(draw, 198, "Story", f(GEORGIA, 74), INK, -2)
    draw.line((140, 310, 360, 310), fill=BERRY, width=2)
    centered_tracked(draw, 345, "DESIGNS", f(GEORGIA_BOLD, 18), BERRY, 7)
    save(image, "01-classic-editorial.png")


def variant_02():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    draw.ellipse((88, 74, 412, 398), outline=INK, width=3)
    centered_tracked(draw, 113, "SS", f(GEORGIA, 150), INK, -14)
    draw.ellipse((343, 285, 357, 299), fill=BERRY)
    centered_tracked(draw, 421, "SOFT STORY DESIGNS", f(GEORGIA_BOLD, 15), BERRY, 3)
    save(image, "02-monogram-circle.png")


def variant_03():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((57, 57, 443, 443), radius=42, outline="#DCCDBB", width=3)
    centered_tracked(draw, 116, "Soft", f(GEORGIA_ITALIC, 76), INK, -2)
    centered_tracked(draw, 202, "Story", f(GEORGIA, 76), INK, -2)
    centered_tracked(draw, 318, "DESIGNS", f(GEORGIA_BOLD, 19), BERRY, 8)
    draw.line((147, 300, 353, 300), fill=OLIVE, width=3)
    save(image, "03-soft-framed.png")


def variant_04():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    draw.arc((135, 95, 365, 325), start=205, end=335, fill=BLUSH, width=18)
    centered_tracked(draw, 148, "Soft", f(GEORGIA, 69), INK, -1)
    centered_tracked(draw, 225, "Story", f(GEORGIA, 69), INK, -1)
    centered_tracked(draw, 347, "DESIGNS", f(GEORGIA_BOLD, 18), BERRY, 7)
    save(image, "04-blush-arc.png")


def variant_05():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    centered_tracked(draw, 128, "Soft Story", f(GEORGIA, 58), INK, -2)
    draw.line((102, 247, 398, 247), fill=BERRY, width=3)
    centered_tracked(draw, 281, "D E S I G N S", f(GEORGIA_BOLD, 19), BERRY, 2)
    draw.ellipse((240, 352, 260, 372), fill=OLIVE)
    save(image, "05-minimal-wide.png")


if __name__ == "__main__":
    variant_01()
    variant_02()
    variant_03()
    variant_04()
    variant_05()
    print(f"Created 5 logo variants in {OUT}")
