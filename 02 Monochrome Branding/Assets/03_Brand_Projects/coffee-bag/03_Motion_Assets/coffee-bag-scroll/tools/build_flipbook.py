"""Build a deterministic scroll flipbook from the Coffee Bag source layers."""

from __future__ import annotations

from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
KEYFRAMES = ROOT / "final" / "keyframes-alpha"
COMPONENTS = ROOT / "final" / "components"
OUTPUT = ROOT / "final" / "flipbook-alpha"
FRAME_COUNT = 24


def clamp(value: float) -> float:
    return max(0.0, min(1.0, value))


def ease(value: float) -> float:
    value = clamp(value)
    return value * value * (3 - 2 * value)


def top_reveal(source: Image.Image, amount: float) -> Image.Image:
    height = round(source.height * 0.48 * amount)
    layer = Image.new("RGBA", source.size)
    if height > 0:
        layer.alpha_composite(source.crop((0, 0, source.width, height)), (0, 0))
    return layer


def composite_scaled(canvas: Image.Image, layer: Image.Image, scale: float) -> None:
    width = round(layer.width * scale)
    height = round(layer.height * scale)
    resized = layer.resize((width, height), Image.Resampling.LANCZOS)
    x = (canvas.width - width) // 2
    y = canvas.height - height
    canvas.alpha_composite(resized, (x, y))


def main() -> None:
    base = Image.open(KEYFRAMES / "K0.png").convert("RGBA")
    open_top = Image.open(KEYFRAMES / "K1.png").convert("RGBA")
    bean_reveal = Image.open(KEYFRAMES / "K2.png").convert("RGBA")
    beans = [Image.open(COMPONENTS / f"bean-{index}.png").convert("RGBA") for index in range(1, 4)]
    bean_positions = ((378, 200), (500, 125), (635, 210))
    bean_offsets = (18, 34, 22)
    bean_drifts = (-10, 3, 12)
    bean_angles = (-16, 9, 18)

    OUTPUT.mkdir(parents=True, exist_ok=True)
    for stale in OUTPUT.glob("F*.png"):
        stale.unlink()

    for index in range(FRAME_COUNT):
        progress = index / (FRAME_COUNT - 1)
        opening = ease((progress - 0.22) / 0.18)
        reveal = ease((progress - 0.43) / 0.22)
        aroma = ease((progress - 0.68) / 0.24)
        scale = 1 + progress * 0.045
        frame = Image.new("RGBA", base.size)

        composite_scaled(frame, base, scale)
        composite_scaled(frame, top_reveal(open_top, opening), scale)
        composite_scaled(frame, top_reveal(bean_reveal, reveal), scale)

        for bean, position, offset, drift, angle in zip(beans, bean_positions, bean_offsets, bean_drifts, bean_angles):
            alpha = bean.getchannel("A").point(lambda value: round(value * aroma))
            moving = bean.copy()
            moving.putalpha(alpha)
            moving = moving.rotate(angle * aroma, resample=Image.Resampling.BICUBIC, expand=True)
            x = round(position[0] + drift * aroma - (moving.width - bean.width) / 2)
            y = round(position[1] - offset * aroma - (moving.height - bean.height) / 2)
            frame.alpha_composite(moving, (x, y))

        frame.save(OUTPUT / f"F{index:02d}.png")


if __name__ == "__main__":
    main()
