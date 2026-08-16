from PIL import Image
import pathlib, shutil

root = pathlib.Path(r"C:\Users\angdo\Desktop\Carousel Design Studio\Portfolio Concepts")
backup_dir = root / "_working" / "_backup-01"
backup_dir.mkdir(exist_ok=True)

concepts = ["First Crumb v2", "Noodle Signal v2", "Gimbap Roll v2"]
# Per-brand thresholds: First Crumb is sepia/beige — keep tight near pure white.
# Noodle/Gimbap are heavier black — 245 is safe.
thresholds = {
    "First Crumb v2": 248,
    "Noodle Signal v2": 245,
    "Gimbap Roll v2": 245,
}
feather_floor = 200  # below this, keep opaque

for concept in concepts:
    src = root / concept / "01-logo-illustration.png"
    backup = backup_dir / f"{concept}__01-logo-illustration.png"
    if not backup.exists():
        shutil.copy2(src, backup)
        print(f"backup {concept} -> {backup}")

    img = Image.open(src).convert("RGBA")
    px = img.load()
    w, h = img.size
    thr = thresholds[concept]
    ramp = thr - feather_floor  # feather range
    removed = 0
    feathered = 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            lum = (r + g + b) // 3
            # pure/near-white → transparent
            if r >= thr and g >= thr and b >= thr:
                # keep already-transparent
                if a != 0:
                    px[x, y] = (r, g, b, 0)
                    removed += 1
            elif lum >= feather_floor and r >= feather_floor-10 and g >= feather_floor-10 and b >= feather_floor-10:
                # near-white antialiased fringe — feather alpha
                # map lum feather_floor..thr-1  → alpha 255..1
                t = (lum - feather_floor) / max(1, ramp - 1)
                # scale alpha down for bright fringes
                new_a = int(a * (1 - t * 0.92))
                if new_a < a:
                    # desaturate fringe toward grey to avoid beige halo
                    px[x, y] = (r, g, b, new_a)
                    feathered += 1

    img.save(src, "PNG")
    print(f"{concept}: threshold {thr}, removed={removed}, feathered={feathered}, size={w}x{h}")

print("done")
