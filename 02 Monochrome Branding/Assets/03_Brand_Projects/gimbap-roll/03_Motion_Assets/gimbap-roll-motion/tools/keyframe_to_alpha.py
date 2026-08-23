from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("output")
    parser.add_argument("--key", default="#00FF00")
    parser.add_argument("--threshold", type=float, default=55)
    parser.add_argument("--softness", type=float, default=35)
    args = parser.parse_args()

    key = tuple(int(args.key[i : i + 2], 16) for i in (1, 3, 5))
    image = Image.open(args.input).convert("RGBA")
    pixels = image.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            distance = ((r - key[0]) ** 2 + (g - key[1]) ** 2 + (b - key[2]) ** 2) ** 0.5
            if distance <= args.threshold:
                alpha = 0
            elif distance <= args.threshold + args.softness:
                alpha = round(255 * (distance - args.threshold) / args.softness)
            else:
                alpha = 255
            pixels[x, y] = (r, g, b, min(a, alpha))
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    image.save(output)


if __name__ == "__main__":
    main()
