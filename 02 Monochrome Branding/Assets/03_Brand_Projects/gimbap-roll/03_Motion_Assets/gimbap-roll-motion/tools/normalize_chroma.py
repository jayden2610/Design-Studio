from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("output")
    parser.add_argument("--key", default="#00FF00")
    parser.add_argument("--green-dominance", type=int, default=48)
    args = parser.parse_args()

    key = tuple(int(args.key[i : i + 2], 16) for i in (1, 3, 5))
    image = Image.open(args.input).convert("RGBA")
    pixels = image.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            if g - r >= args.green_dominance and g - b >= args.green_dominance:
                pixels[x, y] = (*key, a)
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    image.save(output)


if __name__ == "__main__":
    main()
