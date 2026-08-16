from pathlib import Path
import subprocess

from PIL import Image, ImageDraw, ImageFont


WORKSPACE = Path(__file__).resolve().parents[6]
HERE = Path(__file__).resolve().parents[1]
GIMBAP_MOTION = WORKSPACE / "Assets" / "03_Brand_Projects" / "gimbap-roll" / "03_Motion_Assets" / "gimbap-roll-motion"
FFMPEG = GIMBAP_MOTION / "tools" / "ffmpeg" / "bin" / "ffmpeg.exe"
FFPROBE = GIMBAP_MOTION / "tools" / "ffmpeg" / "bin" / "ffprobe.exe"
WRAPPER_BACKGROUND = (
    GIMBAP_MOTION
    / "outputs"
    / "gimbap-wrapper-render"
    / "wrapper-base.png"
)
WRAPPER_TOP = (
    GIMBAP_MOTION
    / "outputs"
    / "gimbap-wrapper-render"
    / "base-top.png"
)
KEYFRAMES = HERE / "final" / "keyframes-alpha"
OUT = HERE / "outputs" / "bagel-wrapper-render"
FRAMES = OUT / "composites"
VERIFY = OUT / "verification"


def font(path: str, size: int):
    try:
        return ImageFont.truetype(path, size)
    except OSError:
        return ImageFont.load_default()


def make_base() -> Image.Image:
    image = Image.open(WRAPPER_BACKGROUND).convert("RGB")
    top = Image.open(WRAPPER_TOP).convert("RGB")
    image.paste(top, (0, 0))
    draw = ImageDraw.Draw(image)

    # Replace the inherited Gimbap address text while keeping the original bar,
    # icon, chrome, spacing, and neutral gradient intact.
    address_bg = image.getpixel((850, 120))
    draw.rectangle((450, 105, 720, 138), fill=address_bg)
    address_font = font(r"C:\Windows\Fonts\segoeui.ttf", 17)
    draw.text((453, 112), "bagel handoff demo", font=address_font, fill=(112, 112, 119))

    # Replace the inherited page title with the title for this storyboard.
    content_bg = image.getpixel((960, 250))
    draw.rectangle((790, 166, 1135, 222), fill=content_bg)
    title_font = font(r"C:\Windows\Fonts\georgia.ttf", 40)
    title = "bagel handoff"
    bounds = draw.textbbox((0, 0), title, font=title_font)
    title_width = bounds[2] - bounds[0]
    draw.text(((1920 - title_width) / 2, 176), title, font=title_font, fill=(22, 22, 22))
    return image


def make_composites(base: Image.Image):
    FRAMES.mkdir(parents=True, exist_ok=True)
    # Fit the full transparent source into the browser viewport with modest
    # margins, preserving the source aspect ratio and all six states.
    target_width = 1450
    for index in range(6):
        source = Image.open(KEYFRAMES / f"K{index}.png").convert("RGBA")
        scale = target_width / source.width
        target_height = round(source.height * scale)
        source = source.resize((target_width, target_height), Image.Resampling.LANCZOS)
        frame = base.copy().convert("RGBA")
        x = (1920 - target_width) // 2
        y = 230
        frame.alpha_composite(source, (x, y))
        frame.convert("RGB").save(FRAMES / f"K{index}.png", optimize=True)


def render_video():
    output = OUT / "Bagel Handoff - Oil Motion macOS wrapper.mp4"
    # Six one-second storyboard holds, 30 fps, with a direct cut between states.
    command = [
        str(FFMPEG),
        "-y",
        "-framerate",
        "1",
        "-i",
        str(FRAMES / "K%d.png"),
        "-c:v",
        "libx264",
        "-pix_fmt",
        "yuv420p",
        "-r",
        "30",
        "-movflags",
        "+faststart",
        str(output),
    ]
    subprocess.run(command, check=True)
    return output


def verify(output: Path):
    VERIFY.mkdir(parents=True, exist_ok=True)
    captures = {"opening": 0, "middle": 2.5, "ending": 5.9}
    for name, timestamp in captures.items():
        subprocess.run(
            [
                str(FFMPEG),
                "-y",
                "-ss",
                str(timestamp),
                "-i",
                str(output),
                "-frames:v",
                "1",
                str(VERIFY / f"{name}.png"),
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def main():
    if not FFMPEG.exists():
        raise FileNotFoundError(FFMPEG)
    if not WRAPPER_BACKGROUND.exists():
        raise FileNotFoundError(WRAPPER_BACKGROUND)
    if not WRAPPER_TOP.exists():
        raise FileNotFoundError(WRAPPER_TOP)
    OUT.mkdir(parents=True, exist_ok=True)
    base = make_base()
    base.save(OUT / "wrapper-base-bagel-handoff.png", optimize=True)
    make_composites(base)
    output = render_video()
    verify(output)
    probe = subprocess.run(
        [
            str(FFPROBE),
            "-v",
            "error",
            "-show_entries",
            "format=duration:stream=codec_name,width,height,r_frame_rate,codec_type",
            "-of",
            "json",
            str(output),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    print(output)
    print(probe.stdout)


if __name__ == "__main__":
    main()
