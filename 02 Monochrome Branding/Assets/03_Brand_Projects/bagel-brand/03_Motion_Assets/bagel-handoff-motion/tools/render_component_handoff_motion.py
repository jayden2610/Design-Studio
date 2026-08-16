from pathlib import Path
import math
import subprocess

from PIL import Image, ImageDraw, ImageFont


WORKSPACE = Path(__file__).resolve().parents[6]
HERE = Path(__file__).resolve().parents[1]
GIMBAP_MOTION = WORKSPACE / "Assets" / "03_Brand_Projects" / "gimbap-roll" / "03_Motion_Assets" / "gimbap-roll-motion"
FFMPEG = GIMBAP_MOTION / "tools" / "ffmpeg" / "bin" / "ffmpeg.exe"
FFPROBE = GIMBAP_MOTION / "tools" / "ffmpeg" / "bin" / "ffprobe.exe"
WRAPPER_BACKGROUND = GIMBAP_MOTION / "outputs" / "gimbap-wrapper-render" / "wrapper-base.png"
WRAPPER_TOP = GIMBAP_MOTION / "outputs" / "gimbap-wrapper-render" / "base-top.png"
SOURCE = HERE / "final" / "keyframes-alpha"
COMPONENTS = HERE / "final" / "keyframes-components"
OUT = HERE / "outputs" / "bagel-component-handoff-motion"
FRAMES = OUT / "frames"
LAYERS = OUT / "layers"
VERIFY = OUT / "verification"

FPS = 30
DURATION = 5
SOURCE_SIZE = (1717, 916)
ART_WIDTH = 1450
BASE_SCALE = ART_WIDTH / SOURCE_SIZE[0]
ART_ORIGIN = (235, 230)


def font(path: str, size: int):
    try:
        return ImageFont.truetype(path, size)
    except OSError:
        return ImageFont.load_default()


def ease_out(t: float) -> float:
    return 1 - (1 - max(0, min(1, t))) ** 3


def ease_in_out(t: float) -> float:
    t = max(0, min(1, t))
    return t * t * (3 - 2 * t)


def build_wrapper() -> Image.Image:
    image = Image.open(WRAPPER_BACKGROUND).convert("RGB")
    image.paste(Image.open(WRAPPER_TOP).convert("RGB"), (0, 0))
    draw = ImageDraw.Draw(image)
    address_fill = image.getpixel((850, 120))
    draw.rectangle((450, 105, 760, 138), fill=address_fill)
    draw.text((453, 112), "bagel handoff demo", font=font(r"C:\\Windows\\Fonts\\segoeui.ttf", 17), fill=(112, 112, 119))
    content_fill = image.getpixel((960, 250))
    draw.rectangle((760, 166, 1160, 222), fill=content_fill)
    title_font = font(r"C:\\Windows\\Fonts\\georgia.ttf", 40)
    title = "bagel handoff"
    width = draw.textbbox((0, 0), title, font=title_font)[2]
    draw.text(((1920 - width) / 2, 176), title, font=title_font, fill=(22, 22, 22))
    return image.convert("RGBA")


def cut_layers():
    LAYERS.mkdir(parents=True, exist_ok=True)
    k0 = Image.open(SOURCE / "K0.png").convert("RGBA")
    k1 = Image.open(SOURCE / "K1.png").convert("RGBA")
    width, height = k0.size
    alpha = k0.getchannel("A")

    # Keep the illustration's bag, bagel, receipt and baseline identical until grip.
    bag_mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(bag_mask)
    draw.rectangle((660, 0, width, height), fill=255)
    draw.rectangle((0, 600, width, height), fill=255)
    bag = k0.copy()
    bag.putalpha(Image.composite(alpha, Image.new("L", (width, height), 0), bag_mask))

    hand_mask = Image.new("L", (width, height), 0)
    ImageDraw.Draw(hand_mask).rectangle((0, 0, 660, 600), fill=255)
    open_hand = k0.copy()
    open_hand.putalpha(Image.composite(alpha, Image.new("L", (width, height), 0), hand_mask))

    isolated = [
        Image.open(COMPONENTS / "H01-touch.png").convert("RGBA"),
        Image.open(COMPONENTS / "H02-curl.png").convert("RGBA"),
        Image.open(COMPONENTS / "H03-pinch.png").convert("RGBA"),
    ]
    bag.save(LAYERS / "bag-static.png")
    open_hand.save(LAYERS / "hand-open.png")
    k1.save(LAYERS / "hand-and-bag-grip.png")
    return bag, open_hand, isolated, k1


def place(canvas: Image.Image, layer: Image.Image, scale: float, x: float, y: float):
    size = (round(layer.width * scale), round(layer.height * scale))
    canvas.alpha_composite(layer.resize(size, Image.Resampling.LANCZOS), (round(x), round(y)))


def place_component(canvas: Image.Image, hand: Image.Image, local_scale: float, source_x: float, source_y: float):
    place(
        canvas,
        hand,
        BASE_SCALE * local_scale,
        ART_ORIGIN[0] + source_x * BASE_SCALE,
        ART_ORIGIN[1] + source_y * BASE_SCALE,
    )


def render_frames():
    FRAMES.mkdir(parents=True, exist_ok=True)
    wrapper = build_wrapper()
    bag, open_hand, contacts, grip = cut_layers()
    touch, curl, pinch = contacts
    anchor = (860, 455)

    for frame_number in range(FPS * DURATION):
        time = frame_number / FPS
        canvas = wrapper.copy()
        if time < 1.80:
            # The bag world remains stable while the hand completes a readable reach → touch → curl.
            place(canvas, bag, BASE_SCALE, *ART_ORIGIN)
            if time < 0.80:
                # First 0.8 seconds: a smooth approach, ending at the exact contact zone.
                dx = 105 * ease_out((time - 0.15) / 0.65) if time >= 0.15 else 0
                place(canvas, open_hand, BASE_SCALE, ART_ORIGIN[0] + dx, ART_ORIGIN[1])
            elif time < 1.12:
                place_component(canvas, touch, 0.68, -90, 105)
            elif time < 1.45:
                place_component(canvas, curl, 0.67, -100, 100)
            else:
                place_component(canvas, pinch, 0.65, -35, 103)
        else:
            # Once held, the original grip drawing and bag travel as a single assembly.
            p = ease_in_out((time - 1.80) / 2.05)
            scale = BASE_SCALE * (1 + 0.18 * p)
            dest_x = ART_ORIGIN[0] + anchor[0] * BASE_SCALE - 190 * p
            dest_y = ART_ORIGIN[1] + anchor[1] * BASE_SCALE + 12 * p
            x = dest_x - anchor[0] * scale
            y = dest_y - anchor[1] * scale
            if time > 3.85:
                settle = math.exp(-(time - 3.85) * 6.0) * math.sin((time - 3.85) * 15.0)
                x += settle * 4
                y -= settle * 1.5
            place(canvas, grip, scale, x, y)
        canvas.convert("RGB").save(FRAMES / f"F{frame_number:03d}.png", optimize=True)


def run(command):
    subprocess.run(command, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def export():
    master = OUT / "Bagel Handoff - component handoff master.mov"
    delivery = OUT / "Bagel Handoff - component handoff.mp4"
    run([str(FFMPEG), "-y", "-framerate", str(FPS), "-i", str(FRAMES / "F%03d.png"), "-c:v", "prores_ks", "-profile:v", "3", "-pix_fmt", "yuv422p10le", "-an", str(master)])
    run([str(FFMPEG), "-y", "-i", str(master), "-c:v", "libx264", "-preset", "slow", "-crf", "15", "-pix_fmt", "yuv420p", "-movflags", "+faststart", "-an", str(delivery)])
    return delivery, master


def verify(video: Path):
    VERIFY.mkdir(parents=True, exist_ok=True)
    captures = {"opening": "0", "touch": "0.95", "curl": "1.25", "grip": "1.85", "pull": "2.8", "ending": "4.9"}
    for label, timestamp in captures.items():
        run([str(FFMPEG), "-y", "-ss", timestamp, "-i", str(video), "-frames:v", "1", "-update", "1", str(VERIFY / f"{label}.png")])


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    render_frames()
    delivery, master = export()
    verify(delivery)
    result = subprocess.run([str(FFPROBE), "-v", "error", "-show_entries", "format=duration:stream=codec_name,codec_type,width,height,pix_fmt,r_frame_rate", "-of", "json", str(delivery)], check=True, capture_output=True, text=True)
    print(delivery)
    print(master)
    print(result.stdout)


if __name__ == "__main__":
    main()
