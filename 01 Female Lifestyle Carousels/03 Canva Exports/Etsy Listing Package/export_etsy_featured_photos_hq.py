from pathlib import Path

from PIL import Image


PACKAGE = Path(__file__).resolve().parent
SOURCE = PACKAGE / "etsy-featured-photos"
OUT = PACKAGE / "etsy-featured-photos-hq-4000px"
OUT.mkdir(exist_ok=True)

# Etsy receives a 4K, 16:9 master for each feature photo. PNG remains lossless.
TARGET = (4000, 2250)

for source_path in sorted(SOURCE.glob("*.png")):
    with Image.open(source_path) as image:
        master = image.convert("RGB").resize(TARGET, Image.Resampling.LANCZOS)
        destination = OUT / source_path.name
        master.save(destination, "PNG", optimize=False)
        print(f"{destination.name}: {master.width} x {master.height}")
