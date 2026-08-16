from PIL import Image
import pathlib
root = pathlib.Path(r"C:\Users\angdo\Desktop\Carousel Design Studio\Portfolio Concepts")
for concept in ['First Crumb v2','Noodle Signal v2','Gimbap Roll v2']:
    src = root / concept / '01-logo-illustration.png'
    dst = root / concept / '02-logo-small.png'
    im = Image.open(src).convert('RGBA')
    thumb = im.copy()
    thumb.thumbnail((300,300), Image.LANCZOS)
    canvas = Image.new('RGBA', (640,640), (0,0,0,0))
    x = (640 - thumb.width)//2
    y = (640 - thumb.height)//2
    canvas.paste(thumb, (x,y), thumb)
    canvas.save(dst, 'PNG')
    v = Image.open(dst)
    print(f"{concept}: thumb {thumb.size} -> 640 alpha={v.mode} has_transparency={v.getchannel('A').getextrema()}")
