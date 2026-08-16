from io import BytesIO
from pathlib import Path

from PIL import Image, ImageCms


PACKAGE = Path(__file__).resolve().parent
PHOTOS = PACKAGE / "etsy-featured-photos-v2"
BANNER = PACKAGE / "brand-assets" / "soft-story-designs-etsy-banner-4800x640-hq.png"
OUT = PACKAGE / "etsy-upload-ready-under-1mb"
OUT.mkdir(exist_ok=True)

# Leave headroom below Etsy's stated 1 MB threshold.
MAX_BYTES = 900_000
SRGB_PROFILE = ImageCms.ImageCmsProfile(ImageCms.createProfile("sRGB")).tobytes()


def save_under_limit(source: Path, destination: Path):
    with Image.open(source) as opened:
        image = opened.convert("RGB")

    for quality in range(94, 58, -2):
        buffer = BytesIO()
        image.save(
            buffer,
            "JPEG",
            quality=quality,
            optimize=True,
            progressive=True,
            subsampling=0,  # Keep text edges and fine gradients clean.
            icc_profile=SRGB_PROFILE,
        )
        if buffer.tell() <= MAX_BYTES:
            destination.write_bytes(buffer.getvalue())
            return quality, buffer.tell(), image.size

    # Only reduce dimensions if even a high-quality JPEG cannot meet Etsy's cap.
    reduced = image
    while True:
        reduced = reduced.resize((int(reduced.width * 0.9), int(reduced.height * 0.9)), Image.Resampling.LANCZOS)
        for quality in range(86, 58, -2):
            buffer = BytesIO()
            reduced.save(
                buffer,
                "JPEG",
                quality=quality,
                optimize=True,
                progressive=True,
                subsampling=0,
                icc_profile=SRGB_PROFILE,
            )
            if buffer.tell() <= MAX_BYTES:
                destination.write_bytes(buffer.getvalue())
                return quality, buffer.tell(), reduced.size


sources = [(source, OUT / f"{source.stem}.jpg") for source in sorted(PHOTOS.glob("*.png"))]
sources.append((BANNER, OUT / "soft-story-designs-etsy-banner.jpg"))

for source, destination in sources:
    quality, byte_count, dimensions = save_under_limit(source, destination)
    print(f"{destination.name}: {dimensions[0]} x {dimensions[1]}, quality {quality}, {byte_count:,} bytes")
