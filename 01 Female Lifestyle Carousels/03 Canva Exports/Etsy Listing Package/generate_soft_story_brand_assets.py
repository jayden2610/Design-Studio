from pathlib import Path
from PIL import Image, ImageDraw, ImageFont


OUT = Path(__file__).resolve().parent / "brand-assets"
OUT.mkdir(parents=True, exist_ok=True)
PAPER = "#FBF3E6"
INK = "#342E3F"
BERRY = "#7A3C57"
OLIVE = "#9CA274"


def font(size, bold=False):
    path = "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf"
    return ImageFont.truetype(path, size)


def centred(draw, box, text, fnt, fill, spacing=6):
    left, top, right, bottom = box
    bbox = draw.multiline_textbbox((0, 0), text, font=fnt, spacing=spacing, align="center")
    draw.multiline_text(
        ((left + right - (bbox[2] - bbox[0])) / 2, (top + bottom - (bbox[3] - bbox[1])) / 2),
        text, font=fnt, fill=fill, spacing=spacing, align="center",
    )


def logo():
    image = Image.new("RGB", (500, 500), PAPER)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((36, 36, 464, 464), radius=72, outline=INK, width=7)
    centred(draw, (55, 88, 445, 340), "SS", font(190, True), INK)
    draw.ellipse((350, 342, 388, 380), fill=BERRY)
    draw.line((125, 389, 335, 389), fill=OLIVE, width=8)
    centred(draw, (70, 410, 430, 455), "SOFT STORY", font(25, True), INK)
    image.save(OUT / "soft-story-studio-etsy-logo-500x500.png", quality=96)


def banner():
    image = Image.new("RGB", (1600, 400), PAPER)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((56, 50, 1544, 350), radius=55, fill="#FFF9F2", outline="#E6D8C8", width=4)
    draw.ellipse((117, 150, 150, 183), fill=BERRY)
    draw.ellipse((1450, 220, 1483, 253), fill=OLIVE)
    draw.line((1220, 255, 1420, 255), fill=BERRY, width=7)
    draw.text((190, 117), "SOFT STORY STUDIO", font=font(67, True), fill=INK)
    draw.text((195, 208), "Editable Canva templates for the little moments worth sharing.", font=font(33), fill=BERRY)
    draw.text((195, 267), "Warm, story-led social content - made easy.", font=font(27), fill=INK)
    image.save(OUT / "soft-story-studio-etsy-big-banner-1600x400.png", quality=96)


if __name__ == "__main__":
    logo()
    banner()
    print(f"Created brand assets in {OUT}")
