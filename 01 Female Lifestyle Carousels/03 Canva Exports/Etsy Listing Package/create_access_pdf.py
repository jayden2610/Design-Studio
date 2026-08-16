"""Create the Etsy-deliverable PDF after real Canva template links are available."""

from pathlib import Path
import json
from reportlab.lib.colors import HexColor
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas


HERE = Path(__file__).resolve().parent
LINKS_FILE = HERE / "template-links.json"
OUT_FILE = HERE / "Female-Lifestyle-Carousel-Templates-Access.pdf"
REQUIRED = [
    ("weekend_notes", "01 - Weekend Notes"),
    ("weekend_photo_diary", "02 - Weekend Photo Diary"),
    ("camera_roll_dump", "03 - Camera Roll Dump"),
    ("nightstand_edit", "04 - Nightstand Edit"),
    ("morning_pages", "05 - Morning Pages"),
]
PAPER = HexColor("#FBF3E6")
INK = HexColor("#342E3F")
BERRY = HexColor("#7A3C57")
OLIVE = HexColor("#687044")


def require_links():
    if not LINKS_FILE.exists():
        raise SystemExit("Create template-links.json from template-links.example.json first.")
    links = json.loads(LINKS_FILE.read_text(encoding="utf-8"))
    invalid = [
        key for key, _ in REQUIRED
        if not isinstance(links.get(key), str)
        or not links[key].startswith("https://")
        or "PASTE_" in links[key]
    ]
    if invalid:
        raise SystemExit(f"Add all five real Canva template links before generating the PDF: {invalid}")
    return links


def centred(c, text, y, size, bold=False, color=INK):
    c.setFont("Helvetica-Bold" if bold else "Helvetica", size)
    c.setFillColor(color)
    c.drawCentredString(A4[0] / 2, y, text)


def paragraph(c, lines, x, y, size=11, leading=16):
    c.setFont("Helvetica", size)
    c.setFillColor(INK)
    for line in lines:
        c.drawString(x, y, line)
        y -= leading


def link_button(c, label, url, y, accent):
    x, width, height = 54, A4[0] - 108, 46
    c.setFillColor(accent)
    c.roundRect(x, y - height, width, height, 12, fill=1, stroke=0)
    centred(c, label + " - Open Canva template", y - 29, 13, True, HexColor("#FFFFFF"))
    c.linkURL(url, (x, y - height, x + width, y), relative=0, thickness=0)


def main():
    links = require_links()
    c = canvas.Canvas(str(OUT_FILE), pagesize=A4)
    width, height = A4

    c.setFillColor(PAPER)
    c.rect(0, 0, width, height, fill=1, stroke=0)
    c.setFillColor(BERRY)
    c.roundRect(44, height - 105, width - 88, 42, 21, fill=1, stroke=0)
    centred(c, "EDITABLE CANVA CAROUSEL BUNDLE", height - 91, 15, True, HexColor("#FFFFFF"))
    centred(c, "Your template access", height - 165, 31, True)
    centred(c, "Five editable carousels - 20 social-media slides", height - 195, 13)
    paragraph(c, [
        "Thank you for your purchase. Each button opens one complete four-page carousel.",
        "Sign in to Canva, select Use template, and Canva will make an editable copy for you.",
        "Please do not edit the original link or share, resell, or redistribute these templates.",
    ], 54, height - 255)

    y = height - 350
    for index, (key, label) in enumerate(REQUIRED):
        link_button(c, label, links[key], y, OLIVE if index < 3 else BERRY)
        y -= 66

    c.setFillColor(HexColor("#FFFFFF"))
    c.roundRect(54, 95, width - 108, 115, 12, fill=1, stroke=0)
    paragraph(c, [
        "Quick start: replace the photos and text, then download each page as a PNG for posting.",
        "You need a Canva account. If a link does not open, paste it into a desktop browser",
        "and contact the Etsy shop with your order number if you still need help.",
    ], 70, 178, size=10.5, leading=15)
    c.showPage()

    c.setFillColor(PAPER)
    c.rect(0, 0, width, height, fill=1, stroke=0)
    centred(c, "How to edit and export", height - 105, 28, True)
    steps = [
        ("1", "Open a template link and select Use template."),
        ("2", "Click text to replace the words; select photos to replace the imagery."),
        ("3", "Keep the existing text-box size or add pages if you need more room."),
        ("4", "Download as PNG, select all four pages, then upload in order to Instagram."),
    ]
    y = height - 185
    for no, line in steps:
        c.setFillColor(BERRY)
        c.circle(82, y + 4, 17, fill=1, stroke=0)
        centred(c, no, y - 2, 13, True, HexColor("#FFFFFF"))
        c.setFillColor(INK)
        c.setFont("Helvetica", 12)
        c.drawString(118, y, line)
        y -= 70

    c.setFillColor(HexColor("#FFFFFF"))
    c.roundRect(54, 210, width - 108, 155, 12, fill=1, stroke=0)
    centred(c, "Licence", 333, 18, True)
    paragraph(c, [
        "One purchase grants one buyer a non-transferable licence to use these templates for their own",
        "personal or business social content. You may not resell, share, redistribute, sublicense, or",
        "claim the templates themselves as your own product. Digital purchases are final, but support",
        "is available through Etsy Messages if you need access help.",
    ], 75, 300, size=11, leading=17)
    c.save()
    print(f"Created {OUT_FILE}")


if __name__ == "__main__":
    main()
