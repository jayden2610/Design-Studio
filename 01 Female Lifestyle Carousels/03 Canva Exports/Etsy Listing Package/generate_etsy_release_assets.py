from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps
import json


ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent / "listing-images"
OUT.mkdir(parents=True, exist_ok=True)

PACKS = [
    ("01", "Weekend Notes", ROOT / "02 Carousel Packs - Reading Nook Editorial/01 Weekend Notes/output/slide-1.png"),
    ("02", "Weekend Photo Diary", ROOT / "02 Carousel Packs - Reading Nook Editorial/02 Weekend Photo Diary/output/slide-1.png"),
    ("03", "Camera Roll Dump", ROOT / "02 Carousel Packs - Reading Nook Editorial/03 Camera Roll Dump/output/slide-1.png"),
    ("04", "Nightstand Edit", ROOT / "02 Carousel Packs - Playful Scrapbook Social/02 Nightstand Edit/output/slide-1.png"),
    ("05", "Morning Pages", ROOT / "02 Carousel Packs - Playful Scrapbook Social/03 Morning Pages/output/slide-1.png"),
]

W, H = 2000, 2500
PAPER = "#FBF3E6"
INK = "#342E3F"
BERRY = "#7A3C57"
OLIVE = "#9CA274"


def font(size, bold=False):
    candidates = [
        "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf",
        "C:/Windows/Fonts/calibrib.ttf" if bold else "C:/Windows/Fonts/calibri.ttf",
    ]
    for candidate in candidates:
        if Path(candidate).exists():
            return ImageFont.truetype(candidate, size)
    return ImageFont.load_default()


def draw_centered(draw, box, text, fnt, fill=INK, spacing=8):
    left, top, right, bottom = box
    bbox = draw.multiline_textbbox((0, 0), text, font=fnt, spacing=spacing, align="center")
    x = (left + right - (bbox[2] - bbox[0])) / 2
    y = (top + bottom - (bbox[3] - bbox[1])) / 2
    draw.multiline_text((x, y), text, font=fnt, fill=fill, spacing=spacing, align="center")


def tile(path, size):
    im = Image.open(path).convert("RGB")
    return ImageOps.fit(im, size, method=Image.Resampling.LANCZOS)


def base():
    return Image.new("RGB", (W, H), PAPER)


def save(image, name):
    image.save(OUT / name, quality=95, optimize=True)


def make_main():
    image = base()
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((70, 75, W - 70, 180), radius=52, fill=BERRY)
    draw_centered(draw, (110, 87, W - 110, 168), "5 EDITABLE CANVA CAROUSELS", font(52, True), "#FFFFFF")
    draw_centered(draw, (100, 220, W - 100, 430), "Female Lifestyle\nCarousel Template Bundle", font(105, True), INK, 15)
    draw_centered(draw, (100, 455, W - 100, 535), "20 Instagram-ready 4:5 slides - edit text, photos and colours", font(43), INK)

    positions = [(120, 640), (760, 640), (1400, 640), (440, 1550), (1080, 1550)]
    for (number, name, path), (x, y) in zip(PACKS, positions):
        card = tile(path, (480, 700))
        image.paste(card, (x, y))
        draw.rounded_rectangle((x, y + 620, x + 480, y + 700), radius=18, fill="#FFFFFF")
        draw_centered(draw, (x + 15, y + 630, x + 465, y + 695), f"{number}  {name}", font(28, True), INK)
    draw_centered(draw, (100, 2310, W - 100, 2410), "Instant digital download - Canva access guide included", font(44, True), BERRY)
    save(image, "01-main-listing-image.png")


def make_included():
    image = base()
    draw = ImageDraw.Draw(image)
    draw_centered(draw, (100, 120, W - 100, 330), "What is included", font(112, True), INK)
    draw_centered(draw, (180, 355, W - 180, 465), "Five standalone, editable Canva carousel designs.", font(46), INK)
    y = 570
    for number, name, path in PACKS:
        draw.rounded_rectangle((145, y, W - 145, y + 245), radius=34, fill="#FFFFFF", outline="#E2D5C3", width=4)
        preview = tile(path, (128, 188))
        image.paste(preview, (175, y + 28))
        draw.text((345, y + 52), f"{number} - {name}", font=font(57, True), fill=INK)
        draw.text((345, y + 136), "4 editable slides - 1080 x 1350 px", font=font(37), fill=BERRY if int(number) >= 4 else OLIVE)
        y += 280
    draw_centered(draw, (180, 2050, W - 180, 2230), "You receive one Etsy-downloadable PDF.\nInside are five Canva template links - one complete carousel per link.", font(48, True), INK, 14)
    save(image, "02-whats-included.png")


def make_how_it_works():
    image = base()
    draw = ImageDraw.Draw(image)
    draw_centered(draw, (100, 120, W - 100, 320), "How it works", font(112, True), INK)
    steps = [
        ("1", "Purchase on Etsy", "Download the access PDF from Etsy Purchases."),
        ("2", "Open your Canva link", "Choose any of the five carousels in the guide."),
        ("3", "Make your own copy", "Canva creates an editable version in your account."),
        ("4", "Customise and post", "Replace photos and text, then download as PNG."),
    ]
    y = 490
    for no, title, body in steps:
        draw.ellipse((175, y, 345, y + 170), fill=BERRY)
        draw_centered(draw, (175, y + 10, 345, y + 160), no, font(76, True), "#FFFFFF")
        draw.text((410, y + 12), title, font=font(58, True), fill=INK)
        draw.multiline_text((410, y + 93), body, font=font(39), fill=INK, spacing=7)
        y += 330
    draw.rounded_rectangle((120, 1895, W - 120, 2310), radius=34, fill="#FFFFFF", outline="#E2D5C3", width=4)
    draw_centered(draw, (180, 1940, W - 180, 2250), "Canva account required.\nTemplates are for one buyer's own content.\nResale or redistribution is not included.", font(42, True), INK, 14)
    save(image, "03-how-it-works.png")


def make_previews():
    for number, name, path in PACKS:
        image = base()
        draw = ImageDraw.Draw(image)
        draw_centered(draw, (100, 115, W - 100, 310), f"{number} - {name}", font(98, True), INK)
        preview = tile(path, (1200, 1750))
        image.paste(preview, (400, 410))
        draw_centered(draw, (130, 2240, W - 130, 2400), "4 editable Canva slides - 1080 x 1350 px", font(49, True), BERRY if int(number) >= 4 else OLIVE)
        save(image, f"preview-{number}-{name.lower().replace(' ', '-')}.png")


if __name__ == "__main__":
    make_main()
    make_included()
    make_how_it_works()
    make_previews()
    print(f"Created {len(list(OUT.glob('*.png')))} Etsy listing images in {OUT}")
