from pathlib import Path
from reportlab.lib.pagesizes import A4
from reportlab.lib.colors import HexColor
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.utils import simpleSplit

OUT = Path(r"C:\Users\angdo\Desktop\Carousel Design Studio\01 Female Lifestyle Carousels\05 Soft iOS Photo Diary Carousel Kit")
PDF = OUT / "Soft iOS Photo-Diary Carousel Kit - Quick Start.pdf"

INK=HexColor('#342E3F'); PLUM=HexColor('#6D526D'); ROSE=HexColor('#E8BBC8'); CREAM=HexColor('#FFF9F5'); PAPER=HexColor('#F5E8E6')
MASTER='https://www.canva.com/d/9E0Zzlrlag4J71E'
LIBRARY='https://www.canva.com/d/PoPQDoUGYw3rU_p'

def block(c, title, body, y):
    c.setFillColor(ROSE); c.roundRect(48,y-26,499,28,12,fill=1,stroke=0)
    c.setFillColor(INK); c.setFont('Helvetica-Bold',11); c.drawString(62,y-16,title.upper())
    y-=48; c.setFillColor(PLUM); c.setFont('Helvetica',10.8)
    for line in simpleSplit(body,'Helvetica',10.8,475): c.drawString(58,y,line); y-=16
    return y-18

c=Canvas(str(PDF),pagesize=A4); w,h=A4
c.setFillColor(PAPER);c.rect(0,0,w,h,fill=1,stroke=0)
c.setFillColor(INK);c.setFont('Times-Bold',34);c.drawString(48,h-88,'Soft iOS Photo-Diary')
c.setFont('Times-Italic',25);c.drawString(48,h-121,'Carousel Kit')
c.setFillColor(PLUM);c.setFont('Helvetica',12);c.drawString(50,h-155,'8 editable Instagram carousel sets  •  70 lifestyle stickers  •  Canva')
c.setFillColor(ROSE);c.circle(475,h-104,58,fill=1,stroke=0);c.setFillColor(CREAM);c.setFont('Times-Bold',26);c.drawCentredString(475,h-112,'♡')
y=h-220
y=block(c,'Before you begin','This is a digital Canva product. You need a free Canva account and a desktop browser for the smoothest editing experience.',y)
y=block(c,'1. Duplicate the carousel kit',f'Open the creator master design: {MASTER}. Before selling, replace this master-design URL with your Canva Template Link (Share → Template link) so every buyer receives an independent copy.',y)
y=block(c,'2. Make it yours','Replace the sample photos, headline, body copy and small labels. Every kit page is 1080 × 1350 px (Instagram 4:5). Keep key text inside the safe margin.',y)
y=block(c,'3. Use the sticker library',f'Open the sticker library: {LIBRARY}. Copy any sticker or grouped UI card into your carousel. The kit includes your 30 lifestyle PNG stickers plus 40 soft iOS-style UI, frame and doodle assets.',y)
y=block(c,'4. Export for Instagram','Download pages as PNG at 1×. Upload the five pages from a set in their shown order. Use the cover as page 1.',y)
c.setFillColor(INK);c.setFont('Helvetica-Bold',10);c.drawString(48,64,'LICENCE')
c.setFont('Helvetica',9.2);c.setFillColor(PLUM)
for i,line in enumerate(simpleSplit('Commercial use is allowed for the purchaser’s finished social media content. You may not resell, redistribute, sublicense, share, or turn the editable templates or stickers into a competing product.', 'Helvetica',9.2,495)): c.drawString(48,47-i*12,line)
c.save(); print(PDF)
