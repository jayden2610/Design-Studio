from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent / "etsy-featured-photos-v2"
OUT.mkdir(exist_ok=True)

# A high-resolution 16:9 master. The design keeps all critical elements large
# enough to survive Etsy's small Featured Photo preview.
W, H = 3000, 1688
PAPER = "#FAF6F1"
INK = "#342E3F"
BLUSH = "#C17A7A"
GOLD = "#C4A46C"
SAGE = "#9CA274"
WHITE = "#FFFFFF"
LINE = "#E8DDD0"

PLAYFUL = ROOT / "02 Carousel Packs - Playful Scrapbook Social"
READING = ROOT / "02 Carousel Packs - Reading Nook Editorial"

FEATURES = [
    ("02-playful-nightstand-edit.png", "Nightstand Edit", "PLAYFUL SCRAPBOOK", "A warm, diary-style carousel for slow lifestyle moments.", BLUSH, PLAYFUL / "02 Nightstand Edit/output"),
    ("03-playful-morning-pages.png", "Morning Pages", "PLAYFUL SCRAPBOOK", "An airy carousel for gentle everyday creator stories.", GOLD, PLAYFUL / "03 Morning Pages/output"),
    ("04-reading-nook-weekend-notes.png", "Weekend Notes", "READING NOOK EDITORIAL", "A soft editorial carousel for reflective personal posts.", SAGE, READING / "01 Weekend Notes/output"),
    ("05-reading-nook-weekend-photo-diary.png", "Weekend Photo Diary", "READING NOOK EDITORIAL", "A calm, photo-led layout for visual storytelling.", GOLD, READING / "02 Weekend Photo Diary/output"),
]


def serif(size):
    return ImageFont.truetype("C:/Windows/Fonts/georgia.ttf", size)


def sans(size, bold=False):
    return ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf", size)


def centered(draw, y, text, fnt, fill):
    draw.text((W / 2, y), text, font=fnt, fill=fill, anchor="ma", align="center")


def cover(path, size):
    with Image.open(path) as source:
        return ImageOps.fit(source.convert("RGB"), size, method=Image.Resampling.LANCZOS)


def paste_card(base, card, x, y, radius=20):
    card = card.convert("RGBA")
    mask = Image.new("L", card.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, card.width - 1, card.height - 1), radius=radius, fill=255)
    card.putalpha(mask)
    shadow = Image.new("RGBA", (card.width + 80, card.height + 80), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle((40, 40, card.width + 38, card.height + 38), radius=radius + 8, fill=(52, 42, 56, 74))
    base.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(24)), (x - 40, y - 20))
    base.alpha_composite(card, (x, y))


def feature_photo(file_name, title, collection, description, accent, folder):
    image = Image.new("RGBA", (W, H), PAPER)
    draw = ImageDraw.Draw(image)
    draw.ellipse((-260, -285, 500, 475), fill=accent + "24")
    draw.ellipse((2560, 1170, 3270, 1880), fill=accent + "1E")
    centered(draw, 92, collection, sans(28, True), accent)
    centered(draw, 145, title, serif(112), INK)
    centered(draw, 292, description, sans(39), INK)
    draw.rounded_rectangle((1325, 365, 1675, 375), radius=5, fill=accent)

    paths = [folder / f"slide-{number}.png" for number in range(1, 5)]
    paste_card(image, cover(paths[0], (640, 800)), 230, 480)
    for path, x in zip(paths[1:], (1040, 1610, 2180)):
        paste_card(image, cover(path, (470, 588)), x, 586)

    draw.rounded_rectangle((720, 1402, 2280, 1544), radius=30, fill=WHITE, outline=LINE, width=4)
    centered(draw, 1440, "4 EDITABLE CANVA SLIDES", sans(31, True), INK)
    centered(draw, 1498, "SWAP YOUR TEXT, PHOTOS AND COLOURS", sans(24, True), accent)
    image.convert("RGB").save(OUT / file_name, "PNG", optimize=False)


def bundle_photo():
    image = Image.new("RGBA", (W, H), PAPER)
    draw = ImageDraw.Draw(image)
    draw.ellipse((-270, -300, 540, 510), fill=BLUSH + "28")
    draw.ellipse((2520, 1180, 3270, 1930), fill=GOLD + "28")
    centered(draw, 92, "SOFT STORY DESIGNS", sans(27, True), BLUSH)
    centered(draw, 150, "5 editable Canva carousels", serif(108), INK)
    centered(draw, 308, "Content templates made for female lifestyle creators.", sans(39), INK)
    draw.rounded_rectangle((1325, 375, 1675, 385), radius=5, fill=GOLD)

    sources = [
        READING / "01 Weekend Notes/output/slide-1.png",
        PLAYFUL / "02 Nightstand Edit/output/slide-1.png",
        PLAYFUL / "03 Morning Pages/output/slide-1.png",
    ]
    for path, x, y in zip(sources, (370, 1225, 2080), (500, 555, 500)):
        paste_card(image, cover(path, (550, 688)), x, y)

    draw.rounded_rectangle((720, 1350, 2280, 1510), radius=30, fill=WHITE, outline=LINE, width=4)
    centered(draw, 1391, "20 INSTAGRAM-READY 4:5 SLIDES", sans(31, True), INK)
    centered(draw, 1452, "EDIT TEXT, PHOTOS AND COLOURS IN CANVA", sans(24, True), BLUSH)
    image.convert("RGB").save(OUT / "01-bundle-overview.png", "PNG", optimize=False)


if __name__ == "__main__":
    bundle_photo()
    for feature in FEATURES:
        feature_photo(*feature)
    print(f"Created {len(list(OUT.glob('*.png')))} redesigned Etsy Featured Photos in {OUT}")
