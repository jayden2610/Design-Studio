from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent / "etsy-featured-photos"
OUT.mkdir(parents=True, exist_ok=True)

W, H = 2000, 1125  # Etsy Featured Photos use a wide 16:9 display frame.
PAPER = "#FAF6F1"
INK = "#342E3F"
BLUSH = "#C17A7A"
GOLD = "#C4A46C"
SAGE = "#9CA274"
LINE = "#E8DDD0"
WHITE = "#FFFFFF"

PLAYFUL = ROOT / "02 Carousel Packs - Playful Scrapbook Social"
READING = ROOT / "02 Carousel Packs - Reading Nook Editorial"

FEATURES = [
    {
        "file": "02-playful-nightstand-edit.png",
        "series": "PLAYFUL SCRAPBOOK  /  01",
        "title": "Nightstand Edit",
        "description": "A warm, diary-style carousel for slow lifestyle moments.",
        "accent": BLUSH,
        "folder": PLAYFUL / "02 Nightstand Edit/output",
    },
    {
        "file": "03-playful-morning-pages.png",
        "series": "PLAYFUL SCRAPBOOK  /  02",
        "title": "Morning Pages",
        "description": "An airy, playful carousel for everyday creator stories.",
        "accent": GOLD,
        "folder": PLAYFUL / "03 Morning Pages/output",
    },
    {
        "file": "04-reading-nook-weekend-notes.png",
        "series": "READING NOOK EDITORIAL  /  01",
        "title": "Weekend Notes",
        "description": "A soft editorial carousel for reflective, personal posts.",
        "accent": SAGE,
        "folder": READING / "01 Weekend Notes/output",
    },
    {
        "file": "05-reading-nook-weekend-photo-diary.png",
        "series": "READING NOOK EDITORIAL  /  02",
        "title": "Weekend Photo Diary",
        "description": "A calm, photo-led layout made for gentle visual storytelling.",
        "accent": GOLD,
        "folder": READING / "02 Weekend Photo Diary/output",
    },
]


def font(size, bold=False):
    path = "C:/Windows/Fonts/georgiab.ttf" if bold else "C:/Windows/Fonts/georgia.ttf"
    return ImageFont.truetype(path, size)


def sans(size, bold=False):
    path = "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf"
    return ImageFont.truetype(path, size)


def tracked_width(draw, text, fnt, tracking):
    return sum(draw.textlength(ch, font=fnt) for ch in text) + max(0, len(text) - 1) * tracking


def draw_tracked(draw, xy, text, fnt, fill, tracking=0):
    x, y = xy
    for char in text:
        draw.text((x, y), char, font=fnt, fill=fill)
        x += draw.textlength(char, font=fnt) + tracking


def centered_tracked(draw, y, text, fnt, fill, tracking=0):
    x = (W - tracked_width(draw, text, fnt, tracking)) / 2
    draw_tracked(draw, (x, y), text, fnt, fill, tracking)


def cover(image_path, size):
    with Image.open(image_path) as source:
        return ImageOps.fit(source.convert("RGB"), size, method=Image.Resampling.LANCZOS)


def paste_card(base, card, x, y, radius=14, shadow_alpha=70):
    card = card.convert("RGBA")
    mask = Image.new("L", card.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, card.width - 1, card.height - 1), radius=radius, fill=255)
    card.putalpha(mask)
    shadow = Image.new("RGBA", (card.width + 40, card.height + 40), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle((20, 20, card.width + 18, card.height + 18), radius=radius + 4, fill=(48, 37, 51, shadow_alpha))
    shadow = shadow.filter(ImageFilter.GaussianBlur(13))
    base.alpha_composite(shadow, (x - 20, y - 7))
    base.alpha_composite(card, (x, y))


def slides(folder):
    return [folder / f"slide-{number}.png" for number in range(1, 5)]


def featured_photo(spec):
    image = Image.new("RGBA", (W, H), PAPER)
    draw = ImageDraw.Draw(image)
    draw.ellipse((1650, -260, 2220, 310), fill=spec["accent"] + "30")
    draw.ellipse((-220, 890, 235, 1345), fill=spec["accent"] + "1E")

    centered_tracked(draw, 55, spec["series"], sans(20, True), spec["accent"], 5)
    draw.text((W / 2, 95), spec["title"], font=font(75), fill=INK, anchor="ma")
    draw.text((W / 2, 188), spec["description"], font=sans(27), fill=INK, anchor="ma")
    draw.rounded_rectangle((860, 247, 1140, 253), radius=4, fill=spec["accent"])

    card_w, card_h = 310, 388
    xs = (280, 690, 1100, 1510)
    ys = (315, 365, 315, 365)
    for path, x, y in zip(slides(spec["folder"]), xs, ys):
        paste_card(image, cover(path, (card_w, card_h)), x, y)

    draw.rounded_rectangle((525, 835, 1475, 975), radius=26, fill=WHITE, outline=LINE, width=3)
    centered_tracked(draw, 870, "4 EDITABLE SLIDES", sans(22, True), INK, 5)
    centered_tracked(draw, 912, "CUSTOMISE IN CANVA  •  1080 × 1350 PX", sans(18, True), spec["accent"], 3)
    centered_tracked(draw, 1035, "SOFT STORY DESIGNS", sans(16, True), INK, 5)
    image.convert("RGB").save(OUT / spec["file"], "PNG", optimize=True)


def bundle_overview():
    image = Image.new("RGBA", (W, H), PAPER)
    draw = ImageDraw.Draw(image)
    draw.ellipse((-250, -250, 360, 360), fill=BLUSH + "28")
    draw.ellipse((1710, 860, 2220, 1370), fill=GOLD + "28")
    centered_tracked(draw, 52, "SOFT STORY DESIGNS", sans(19, True), BLUSH, 5)
    draw.text((W / 2, 95), "5 ready-to-edit\nCanva carousels", font=font(65), fill=INK, anchor="ma", align="center", spacing=1)
    draw.text((W / 2, 252), "For lifestyle creators who want their content to feel considered.", font=sans(27), fill=INK, anchor="ma")
    draw.rounded_rectangle((870, 310, 1130, 316), radius=4, fill=GOLD)

    sources = [
        READING / "01 Weekend Notes/output/slide-1.png",
        READING / "02 Weekend Photo Diary/output/slide-1.png",
        READING / "03 Camera Roll Dump/output/slide-1.png",
        PLAYFUL / "02 Nightstand Edit/output/slide-1.png",
        PLAYFUL / "03 Morning Pages/output/slide-1.png",
    ]
    positions = [(315, 365), (590, 405), (865, 365), (1140, 405), (1415, 365)]
    for path, (x, y) in zip(sources, positions):
        paste_card(image, cover(path, (250, 312)), x, y, radius=12, shadow_alpha=62)

    draw.rounded_rectangle((520, 790, 1480, 932), radius=26, fill=WHITE, outline=LINE, width=3)
    centered_tracked(draw, 827, "20 INSTAGRAM-READY 4:5 SLIDES", sans(22, True), INK, 5)
    centered_tracked(draw, 870, "EDIT TEXT, PHOTOS AND COLOURS IN CANVA", sans(18, True), BLUSH, 3)
    centered_tracked(draw, 1015, "INSTANT DIGITAL DOWNLOAD", sans(16, True), INK, 5)
    image.convert("RGB").save(OUT / "01-bundle-overview.png", "PNG", optimize=True)


if __name__ == "__main__":
    bundle_overview()
    for feature in FEATURES:
        featured_photo(feature)
    print(f"Created {len(list(OUT.glob('*.png')))} Etsy featured photos in {OUT}")
