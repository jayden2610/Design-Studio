from pathlib import Path
import subprocess

from PIL import Image, ImageDraw, ImageFont


WORKSPACE = Path(__file__).resolve().parents[6]
HERE = Path(__file__).resolve().parents[1]
GIMBAP_MOTION = WORKSPACE / "Assets" / "03_Brand_Projects" / "gimbap-roll" / "03_Motion_Assets" / "gimbap-roll-motion"
FFMPEG = GIMBAP_MOTION / "tools" / "ffmpeg" / "bin" / "ffmpeg.exe"
FFPROBE = GIMBAP_MOTION / "tools" / "ffmpeg" / "bin" / "ffprobe.exe"
WRAPPER_BACKGROUND = GIMBAP_MOTION / "outputs" / "gimbap-wrapper-render" / "wrapper-base.png"
WRAPPER_TOP = GIMBAP_MOTION / "outputs" / "gimbap-wrapper-render" / "base-top.png"
OUT = HERE / "outputs" / "bagel-wrapper-smooth-hq"
COMPOSITES = OUT / "composites"
VERIFY = OUT / "verification"

# Original poses are retained in their authored order. Each generated B pose is
# a hand-drawn-style bridge inserted only between its two adjacent originals.
SEQUENCE = [
    ("keyframes-alpha", "K0"), ("keyframes-alpha", "K0"),
    ("keyframes-bridges", "B01"),
    ("keyframes-alpha", "K1"), ("keyframes-bridges", "B12"),
    ("keyframes-alpha", "K2"), ("keyframes-bridges", "B23"),
    ("keyframes-alpha", "K3"), ("keyframes-bridges", "B34"),
    ("keyframes-alpha", "K4"), ("keyframes-bridges", "B45"),
    ("keyframes-alpha", "K5"), ("keyframes-alpha", "K5"),
    ("keyframes-alpha", "K5"), ("keyframes-alpha", "K5"),
]


def get_font(path: str, size: int):
    try:
        return ImageFont.truetype(path, size)
    except OSError:
        return ImageFont.load_default()


def make_wrapper_base() -> Image.Image:
    image = Image.open(WRAPPER_BACKGROUND).convert("RGB")
    image.paste(Image.open(WRAPPER_TOP).convert("RGB"), (0, 0))
    draw = ImageDraw.Draw(image)
    address_fill = image.getpixel((850, 120))
    draw.rectangle((450, 105, 760, 138), fill=address_fill)
    draw.text((453, 112), "bagel handoff demo", font=get_font(r"C:\Windows\Fonts\segoeui.ttf", 17), fill=(112, 112, 119))
    content_fill = image.getpixel((960, 250))
    draw.rectangle((760, 166, 1160, 222), fill=content_fill)
    title = "bagel handoff"
    title_font = get_font(r"C:\Windows\Fonts\georgia.ttf", 40)
    title_width = draw.textbbox((0, 0), title, font=title_font)[2]
    draw.text(((1920 - title_width) / 2, 176), title, font=title_font, fill=(22, 22, 22))
    return image


def make_composites():
    COMPOSITES.mkdir(parents=True, exist_ok=True)
    base = make_wrapper_base()
    base.save(OUT / "wrapper-base-bagel-handoff.png", optimize=True)
    target_width = 1450
    for index, (folder, name) in enumerate(SEQUENCE):
        source = Image.open(HERE / "final" / folder / f"{name}.png").convert("RGBA")
        target_height = round(source.height * target_width / source.width)
        source = source.resize((target_width, target_height), Image.Resampling.LANCZOS)
        canvas = base.copy().convert("RGBA")
        canvas.alpha_composite(source, ((1920 - target_width) // 2, 230))
        canvas.convert("RGB").save(COMPOSITES / f"F{index:02d}.png", optimize=True)


def run(command):
    subprocess.run(command, check=True)


def render():
    mp4 = OUT / "Bagel Handoff - Oil Motion smooth HQ.mp4"
    master = OUT / "Bagel Handoff - Oil Motion smooth HQ master.mov"
    # Each pose remains a crisp authored drawing. The earlier motion-compensated
    # approach distorted fingers, so this final uses a paced 3 fps pencil-test
    # cadence in a 30 fps delivery file: smooth enough to travel, no ghost lines.
    run([
        str(FFMPEG), "-y", "-framerate", "3", "-i", str(COMPOSITES / "F%02d.png"),
        "-r", "30", "-c:v", "prores_ks", "-profile:v", "3", "-pix_fmt", "yuv422p10le",
        "-an", str(master),
    ])
    run([
        str(FFMPEG), "-y", "-i", str(master), "-c:v", "libx264", "-preset", "slow", "-crf", "15",
        "-pix_fmt", "yuv420p", "-movflags", "+faststart", "-an", str(mp4),
    ])
    return mp4, master


def verify(video: Path):
    VERIFY.mkdir(parents=True, exist_ok=True)
    for label, timestamp in {"opening": "0", "middle": "2.5", "ending": "4.95"}.items():
        run([
            str(FFMPEG), "-y", "-ss", timestamp, "-i", str(video), "-frames:v", "1",
            str(VERIFY / f"{label}.png"),
        ])


def probe(video: Path):
    result = subprocess.run([
        str(FFPROBE), "-v", "error", "-show_entries",
        "format=duration:stream=codec_name,codec_type,width,height,pix_fmt,r_frame_rate",
        "-of", "json", str(video),
    ], check=True, capture_output=True, text=True)
    print(result.stdout)


def main():
    for path in (FFMPEG, FFPROBE, WRAPPER_BACKGROUND, WRAPPER_TOP):
        if not path.exists():
            raise FileNotFoundError(path)
    OUT.mkdir(parents=True, exist_ok=True)
    make_composites()
    mp4, master = render()
    verify(mp4)
    print(mp4)
    print(master)
    probe(mp4)


if __name__ == "__main__":
    main()
