from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


SIZE = 500
BACKGROUND = "#faf6f1"
SOFT = "#c17a7a"
STORY = "#c4a46c"
FONT_PATH = r"C:\Windows\Fonts\georgia.ttf"


def width_with_tracking(draw, text, font, tracking):
    return sum(draw.textlength(character, font=font) for character in text) + tracking * (len(text) - 1)


def draw_tracked(draw, x, y, text, font, fill, tracking):
    for character in text:
        draw.text((x, y), character, font=font, fill=fill)
        x += draw.textlength(character, font=font) + tracking


image = Image.new("RGB", (SIZE, SIZE), BACKGROUND)
draw = ImageDraw.Draw(image)

# The font is the closest installed serif fallback to the supplied Playfair Display HTML.
brand_font = ImageFont.truetype(FONT_PATH, 42)
designs_font = ImageFont.truetype(FONT_PATH, 15)
brand_tracking = 42 * 0.08
designs_tracking = 15 * 0.4

soft_text = "SOFT"
story_text = "STORY"
soft_width = width_with_tracking(draw, soft_text, brand_font, brand_tracking)
story_width = width_with_tracking(draw, story_text, brand_font, brand_tracking)
space_width = draw.textlength(" ", font=brand_font)
brand_width = soft_width + space_width + story_width
brand_x = (SIZE - brand_width) / 2
brand_y = 215

draw_tracked(draw, brand_x, brand_y, soft_text, brand_font, SOFT, brand_tracking)
draw_tracked(
    draw,
    brand_x + soft_width + space_width,
    brand_y,
    story_text,
    brand_font,
    STORY,
    brand_tracking,
)

designs_text = "DESIGNS"
designs_width = width_with_tracking(draw, designs_text, designs_font, designs_tracking)
draw_tracked(
    draw,
    (SIZE - designs_width) / 2,
    277,
    designs_text,
    designs_font,
    SOFT,
    designs_tracking,
)

output = Path(__file__).with_name("soft-story-designs-option-d-etsy-logo-500x500.png")
image.save(output, "PNG")
print(output)
