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
OUT = HERE / "outputs" / "bagel-controlled-motion"
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
    return 1 - (1 - t) ** 3


def ease_in_out(t: float) -> float:
    return t * t * (3 - 2 * t)


def build_wrapper() -> Image.Image:
    image = Image.open(WRAPPER_BACKGROUND).convert("RGB")
    image.paste(Image.open(WRAPPER_TOP).convert("RGB"), (0, 0))
    draw = ImageDraw.Draw(image)
    address_fill = image.getpixel((850, 120))
    draw.rectangle((450, 105, 760, 138), fill=address_fill)
    draw.text((453, 112), "bagel handoff demo", font=font(r"C:\Windows\Fonts\segoeui.ttf", 17), fill=(112, 112, 119))
    content_fill = image.getpixel((960, 250))
    draw.rectangle((760, 166, 1160, 222), fill=content_fill)
    title = "bagel handoff"
    title_font = font(r"C:\Windows\Fonts\georgia.ttf", 40)
    width = draw.textbbox((0, 0), title, font=title_font)[2]
    draw.text(((1920 - width) / 2, 176), title, font=title_font, fill=(22, 22, 22))
    return image.convert("RGBA")


def cut_layers():
    LAYERS.mkdir(parents=True, exist_ok=True)
    k0 = Image.open(SOURCE / "K0.png").convert("RGBA")
    k1 = Image.open(SOURCE / "K1.png").convert("RGBA")
    width, height = k0.size
    alpha = k0.getchannel("A")

    # K0 has a clean, unoccluded bag. Keep its bag and the shared ground line.
    bag_mask = Image.new("L", (width, height), 0)
    mask_draw = ImageDraw.Draw(bag_mask)
    mask_draw.rectangle((660, 0, width, height), fill=255)
    mask_draw.rectangle((0, 600, width, height), fill=255)
    bag_alpha = Image.composite(alpha, Image.new("L", (width, height), 0), bag_mask)
    bag = k0.copy()
    bag.putalpha(bag_alpha)

    # The open hand is isolated before it reaches the bag; no bag pixels travel
    # with it during the approach beat.
    hand_mask = Image.new("L", (width, height), 0)
    ImageDraw.Draw(hand_mask).rectangle((0, 0, 660, 600), fill=255)
    hand_alpha = Image.composite(alpha, Image.new("L", (width, height), 0), hand_mask)
    hand = k0.copy()
    hand.putalpha(hand_alpha)

    bag.save(LAYERS / "bag-static.png")
    hand.save(LAYERS / "hand-approach.png")
    k1.save(LAYERS / "hand-and-bag-grip.png")
    return bag, hand, k1


def place_layer(canvas: Image.Image, layer: Image.Image, scale: float, x: float, y: float):
    size = (round(layer.width * scale), round(layer.height * scale))
    resized = layer.resize(size, Image.Resampling.LANCZOS)
    canvas.alpha_composite(resized, (round(x), round(y)))


def render_frames():
    FRAMES.mkdir(parents=True, exist_ok=True)
    wrapper = build_wrapper()
    bag, hand, grip = cut_layers()
    anchor = (860, 455)  # bag centre used to keep the pull visually coherent.

    for frame_number in range(FPS * DURATION):
        time = frame_number / FPS
        canvas = wrapper.copy()
        if time < 1.40:
            # Beat 1: the bag stays locked while the hand approaches it.
            place_layer(canvas, bag, BASE_SCALE, *ART_ORIGIN)
            if time >= 0.55:
                p = ease_out((time - 0.55) / 0.85)
                hand_dx = 150 * p
            else:
                hand_dx = 0
            place_layer(canvas, hand, BASE_SCALE, ART_ORIGIN[0] + hand_dx, ART_ORIGIN[1])
        else:
            # Beat 2: after the grip, hand and bag become one locked assembly.
            p = min(1.0, (time - 1.40) / 2.05)
            pull = ease_in_out(p)
            scale = BASE_SCALE * (1 + 0.115 * pull)
            dest_x = ART_ORIGIN[0] + anchor[0] * BASE_SCALE - 145 * pull
            dest_y = ART_ORIGIN[1] + anchor[1] * BASE_SCALE + 10 * pull
            x = dest_x - anchor[0] * scale
            y = dest_y - anchor[1] * scale
            # A restrained settle makes the stop feel intentional, not elastic.
            if time > 3.45:
                settle = math.exp(-(time - 3.45) * 5.0) * math.sin((time - 3.45) * 14.0)
                x += settle * 5
                y -= settle * 2
            place_layer(canvas, grip, scale, x, y)
        canvas.convert("RGB").save(FRAMES / f"F{frame_number:03d}.png", optimize=True)


def run(command):
    subprocess.run(command, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def export():
    master = OUT / "Bagel Handoff - controlled motion master.mov"
    delivery = OUT / "Bagel Handoff - controlled motion.mp4"
    run([
        str(FFMPEG), "-y", "-framerate", str(FPS), "-i", str(FRAMES / "F%03d.png"),
        "-c:v", "prores_ks", "-profile:v", "3", "-pix_fmt", "yuv422p10le", "-an", str(master),
    ])
    run([
        str(FFMPEG), "-y", "-i", str(master), "-c:v", "libx264", "-preset", "slow", "-crf", "15",
        "-pix_fmt", "yuv420p", "-movflags", "+faststart", "-an", str(delivery),
    ])
    return delivery, master


def verify(video: Path):
    VERIFY.mkdir(parents=True, exist_ok=True)
    for label, timestamp in {"opening": "0", "approach": "1.1", "pull": "2.5", "ending": "4.9"}.items():
        run([str(FFMPEG), "-y", "-ss", timestamp, "-i", str(video), "-frames:v", "1", "-update", "1", str(VERIFY / f"{label}.png")])


def probe(video: Path):
    result = subprocess.run([
        str(FFPROBE), "-v", "error", "-show_entries",
        "format=duration:stream=codec_name,codec_type,width,height,pix_fmt,r_frame_rate",
        "-of", "json", str(video),
    ], check=True, capture_output=True, text=True)
    print(result.stdout)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    render_frames()
    delivery, master = export()
    verify(delivery)
    print(delivery)
    print(master)
    probe(delivery)


if __name__ == "__main__":
    main()
