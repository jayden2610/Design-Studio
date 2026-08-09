from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from html import escape

ROOT = Path(r"C:\Users\angdo\Desktop\Carousel Design Studio\01 Female Lifestyle Carousels")
OUT = ROOT / "05 Soft iOS Photo Diary Carousel Kit"
ASSETS = OUT / "40 New Stickers"
BUNDLE = OUT / "Canva Import Bundle"
LISTING = OUT / "Etsy Listing Gallery"

P = {"ink":"#342E3F", "plum":"#6D526D", "rose":"#E8BBC8", "cream":"#FFF9F5", "paper":"#F5E8E6", "lilac":"#DCD3F0", "sage":"#B9CDBB", "line":"#FFFFFF"}

def svg(name, body, w=1000, h=1000):
    ASSETS.mkdir(parents=True, exist_ok=True)
    (ASSETS / f"{name}.svg").write_text(f'''<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}"><g stroke="{P['ink']}" stroke-width="18" stroke-linecap="round" stroke-linejoin="round">{body}</g></svg>''', encoding="utf-8")

def rounded(x,y,w,h,fill=P['cream'],r=60): return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}"/>'
def text(x,y,s,size=52,fill=P['ink'],weight=600,anchor='start'): return f'<text x="{x}" y="{y}" fill="{fill}" stroke="none" font-family="Arial, sans-serif" font-size="{size}" font-weight="{weight}" text-anchor="{anchor}">{escape(s)}</text>'

def make_assets():
    # Generic soft mobile UI assets, intentionally not copied from any product UI.
    svg('01-soft-phone-frame', rounded(210,90,580,820,P['cream'],95)+rounded(420,125,160,25,P['ink'],18)+rounded(245,170,510,665,'none',55))
    svg('02-photo-window', rounded(95,155,810,655,P['cream'],55)+rounded(95,155,810,95,P['rose'],55)+f'<circle cx="165" cy="202" r="17" fill="{P["ink"]}"/><circle cx="220" cy="202" r="17" fill="{P["ink"]}"/><circle cx="275" cy="202" r="17" fill="{P["ink"]}"/>'+f'<path d="M175 700l170-175 115 105 120-150 220 220" fill="{P["lilac"]}"/>')
    svg('03-camera-roll-card', rounded(100,170,800,620,P['cream'],50)+rounded(135,205,730,410,P['lilac'],34)+f'<circle cx="300" cy="395" r="90" fill="{P["rose"]}"/><path d="M140 580l180-160 135 110 120-180 290 230" fill="{P["sage"]}"/>'+text(145,700,'camera roll',48))
    svg('04-now-playing-card', rounded(80,190,840,560,P['cream'],55)+rounded(125,235,240,240,P['rose'],36)+f'<circle cx="245" cy="355" r="70" fill="{P["plum"]}"/>'+text(410,310,'little things',54)+text(410,375,'soft sunday playlist',34,P['plum'],400)+f'<path d="M410 470h375"/><circle cx="520" cy="470" r="20" fill="{P["ink"]}"/>'+f'<circle cx="460" cy="585" r="45" fill="{P["lilac"]}"/><path d="M445 565l38 20-38 20z" fill="{P["ink"]}"/>')
    svg('05-calendar-widget', rounded(130,170,740,610,P['cream'],55)+rounded(130,170,740,135,P['rose'],55)+text(500,260,'SUNDAY',42,P['ink'],700,'middle')+text(500,485,'25',230,P['plum'],700,'middle')+text(500,655,'slow morning',45,P['plum'],500,'middle'))
    svg('06-weather-widget', rounded(140,225,720,470,P['cream'],55)+text(500,340,'SINGAPORE',34,P['plum'],700,'middle')+text(500,535,'29°',180,P['ink'],700,'middle')+f'<circle cx="700" cy="385" r="65" fill="{P["rose"]}"/>'+text(500,620,'warm + cloudy',38,P['plum'],500,'middle'))
    svg('07-notes-card', rounded(120,120,760,760,P['paper'],45)+rounded(120,120,760,105,P['rose'],45)+text(180,320,'little reminders',60)+text(180,415,'• drink water',43,P['plum'],400)+text(180,500,'• text your friend',43,P['plum'],400)+text(180,585,'• take it slowly',43,P['plum'],400)+text(180,720,'today is enough',43,P['ink'],500))
    svg('08-message-bubble-left', rounded(80,300,630,230,P['cream'],80)+f'<path d="M180 505l-65 95 150-65" fill="{P["cream"]}"/>'+text(150,415,'thinking of you ♡',52))
    svg('09-message-bubble-right', rounded(290,300,630,230,P['rose'],80)+f'<path d="M820 505l65 95-150-65" fill="{P["rose"]}"/>'+text(365,415,'same time next week?',45,P['ink'],600))
    svg('10-search-bar', rounded(80,350,840,190,P['cream'],95)+f'<circle cx="190" cy="445" r="42" fill="none"/><path d="M220 475l45 45"/>'+text(315,465,'search your little joys',45,P['plum'],400))
    svg('11-browser-tab', rounded(80,210,840,520,P['cream'],55)+rounded(80,210,840,105,P['lilac'],55)+f'<circle cx="155" cy="262" r="15" fill="{P["rose"]}"/><circle cx="205" cy="262" r="15" fill="{P["sage"]}"/>'+rounded(270,235,420,54,P['cream'],25)+text(480,274,'softdays.co',29,P['plum'],500,'middle')+text(150,425,'a little corner of the internet',45)+text(150,500,'for collecting good moments.',45))
    svg('12-email-card', rounded(90,220,820,520,P['cream'],45)+text(155,335,'from: future me',38,P['plum'],500)+text(155,430,'you are doing better',55)+text(155,500,'than you think.',55)+text(155,640,'sent with love',35,P['plum'],400))
    svg('13-heart-reaction', f'<path d="M500 800C250 640 150 500 150 355c0-120 95-205 210-205 72 0 117 34 140 77 23-43 68-77 140-77 115 0 210 85 210 205 0 145-100 285-350 445z" fill="{P["rose"]}"/>')
    svg('14-star-reaction', f'<path d="M500 105l95 280 295 5-235 180 82 290-237-170-237 170 82-290L110 390l295-5z" fill="{P["lilac"]}"/>')
    svg('15-sparkle', f'<path d="M500 90l55 355 355 55-355 55-55 355-55-355-355-55 355-55z" fill="{P["rose"]}"/>')
    svg('16-smiley', f'<circle cx="500" cy="500" r="310" fill="{P["cream"]}"/><circle cx="390" cy="430" r="30" fill="{P["ink"]}"/><circle cx="610" cy="430" r="30" fill="{P["ink"]}"/><path d="M345 580q155 160 310 0" fill="none"/>')
    svg('17-doodle-heart', f'<path d="M500 820C230 625 170 485 210 355c40-128 195-145 290-25 95-120 250-103 290 25 40 130-20 270-290 465z" fill="none" stroke="{P["rose"]}" stroke-width="35"/>')
    svg('18-doodle-arrow', f'<path d="M145 700c200-30 195-335 510-260" fill="none" stroke="{P["plum"]}" stroke-width="32"/><path d="M560 275l115 170-200 25" fill="none" stroke="{P["plum"]}" stroke-width="32"/>')
    svg('19-doodle-underline', f'<path d="M160 560q160-55 330 0t350-15" fill="none" stroke="{P["rose"]}" stroke-width="35"/>')
    svg('20-doodle-circle', f'<ellipse cx="500" cy="500" rx="355" ry="255" fill="none" stroke="{P["plum"]}" stroke-width="32"/>')
    svg('21-polaroid-portrait', f'<path d="M195 125h610v710H195z" fill="{P["cream"]}"/><rect x="240" y="170" width="520" height="505" fill="{P["lilac"]}"/><path d="M240 650l160-150 110 75 90-190 160 265" fill="{P["sage"]}"/>')
    svg('22-polaroid-landscape', f'<path d="M105 220h790v560H105z" fill="{P["cream"]}"/><rect x="150" y="265" width="700" height="370" fill="{P["lilac"]}"/><path d="M150 610l175-150 145 90 105-175 275 235" fill="{P["sage"]}"/>')
    svg('23-torn-paper-cream', f'<path d="M95 210q60-35 125 0t125 0 125 0 125 0 125 0 125 0 125 0v585q-55 35-120 0t-120 0-120 0-120 0-120 0-120 0-120 0z" fill="{P["cream"]}"/>')
    svg('24-torn-paper-pink', f'<path d="M95 210q60-35 125 0t125 0 125 0 125 0 125 0 125 0 125 0v585q-55 35-120 0t-120 0-120 0-120 0-120 0-120 0-120 0z" fill="{P["rose"]}"/>')
    svg('25-location-pin', f'<path d="M500 875C330 650 255 535 255 390a245 245 0 01490 0c0 145-75 260-245 485z" fill="{P["rose"]}"/><circle cx="500" cy="390" r="85" fill="{P["cream"]}"/>')
    svg('26-date-stamp', rounded(125,330,750,260,P['cream'],40)+text(500,455,'AUG 2026',72,P['plum'],700,'middle')+text(500,540,'little life update',34,P['plum'],500,'middle'))
    svg('27-film-strip', f'<path d="M120 235h760v530H120z" fill="{P["ink"]}"/>'+''.join(f'<rect x="{150+i*150}" y="275" width="110" height="450" fill="{P["lilac"]}"/>' for i in range(5)))
    svg('28-postcard', rounded(110,220,780,560,P['cream'],25)+f'<path d="M500 250v500"/><path d="M555 320h240v150H555z" fill="{P["rose"]}"/>'+text(185,415,'wish you were here',40,P['plum'],500)+text(185,505,'from a soft little day',34,P['plum'],400))
    svg('29-mini-checklist', rounded(150,200,700,600,P['cream'],40)+text(230,335,'today’s tiny wins',48)+''.join(f'<rect x="{230}" y="{395+i*92}" width="38" height="38" rx="10" fill="none"/>'+f'<path d="M238 {414+i*92}l12 12 22-26" fill="none" stroke="{P["sage"]}"/>'+f'<path d="M305 {415+i*92}h300" fill="none" stroke="{P["plum"]}" stroke-width="14"/>' for i in range(3)))
    svg('30-quote-card', rounded(120,240,760,520,P['plum'],48)+text(500,420,'“collect more',64,P['cream'],600,'middle')+text(500,505,'ordinary magic.”',64,P['cream'],600,'middle')+text(500,650,'— your soft life',32,P['rose'],500,'middle'))
    svg('31-coffee-bean', f'<path d="M500 155c190 0 290 175 190 395S470 845 310 760 210 520 310 325 390 155 500 155z" fill="{P["plum"]}"/><path d="M625 225C470 380 435 560 390 745" fill="none" stroke="{P["cream"]}" stroke-width="28"/>')
    svg('32-flower-daisy', ''.join(f'<ellipse cx="500" cy="290" rx="80" ry="190" fill="{P["cream"]}" transform="rotate({i*45} 500 500)"/>' for i in range(8))+f'<circle cx="500" cy="500" r="105" fill="{P["rose"]}"/>')
    svg('33-ribbon-bow', f'<path d="M500 480C310 195 85 235 145 475c45 180 250 130 355 15 105 115 310 165 355-15 60-240-165-280-355 5z" fill="{P["rose"]}"/><circle cx="500" cy="500" r="85" fill="{P["cream"]}"/><path d="M445 565l-85 275 145-125 135 125-80-275" fill="{P["lilac"]}"/>')
    svg('34-paperclip', f'<path d="M645 220L350 515a125 125 0 00177 177l270-270a205 205 0 00-290-290L220 420a285 285 0 00403 403l205-205" fill="none" stroke="{P["plum"]}" stroke-width="48"/>')
    svg('35-tape-strip', f'<path d="M155 355l660-130 70 410-660 130z" fill="{P["lilac"]}"/>')
    svg('36-pencil-scribble', f'<path d="M150 610c130-310 230 245 345-50s205 245 355-150" fill="none" stroke="{P["rose"]}" stroke-width="35"/>')
    svg('37-bookmark', f'<path d="M295 120h410v755L500 725 295 875z" fill="{P["rose"]}"/>')
    svg('38-moon', f'<path d="M650 160C405 255 385 625 660 770 350 855 130 570 240 325 330 125 525 95 650 160z" fill="{P["lilac"]}"/>')
    svg('39-sun', f'<circle cx="500" cy="500" r="170" fill="{P["rose"]}"/>'+''.join(f'<path d="M500 {120+i%2*0}V35"/>' if False else '' for i in range(1))+''.join(f'<path d="M500 100V25" transform="rotate({i*45} 500 500)"/>' for i in range(8)))
    svg('40-three-hearts', ''.join(f'<path d="M{x} {y+130}c-90-65-115-120-80-165 35-45 100-15 80 28-20-43 45-73 80-28 35 45 10 100-80 165z" fill="{col}"/>' for x,y,col in [(260,280,P['rose']),(480,390,P['lilac']),(650,260,P['cream'])]))

SETS = [
('Currently Loving','five little things I’m loving lately','little joys / 01','my current comfort:','the softest things stay','save this for later'),
('Sunday Reset','a soft reset for the week ahead','slow sunday / 02','my reset looks like:','nothing rushed, nothing forced','share with your sunday person'),
('Little Life Update','a few small things from lately','life lately / 03','tiny moments, big feelings','I want to remember this','tell me yours ↓'),
('Weekend Photo Diary','the kind of weekend that felt like a deep breath','weekend diary / 04','a soft collection of moments','more of this, please','save the feeling'),
('Things That Made Me Happy','ordinary things with extraordinary magic','happy list / 05','today’s tiny wins:','it was enough','what made you smile?'),
('Monthly Favourites','my soft little favourites this month','august notes / 06','on repeat, on my mind','keeping these close','which one are you stealing?'),
('A Day In My Life','a very ordinary, very lovely day','day in my life / 07','morning to moonlight','the small parts were my favourite','come back tomorrow'),
('Soft Routine','my low-pressure self-care rhythm','gentle routine / 08','the things that bring me back','slow is still forward','save for your next reset')]

def page(title, kicker, headline, line, n, kind):
    sticker = f'../40 New Stickers/{(n%40)+1:02d}-'+['soft-phone-frame','photo-window','camera-roll-card','now-playing-card','calendar-widget'][n%5]+'.svg'
    # Assets are decorative in HTML preview; the real sticker library contains the exact individual source files.
    return f'''<div data-document-role="page" data-label="{escape(title)} - {kind}" class="page page-{kind}"><div class="grain"></div><div class="meta">{escape(kicker)}</div><div class="page-number">0{n}</div><div class="photo photo-{n%4}"></div><div class="ios-card"><span>● ● ●</span><b>{escape(line)}</b></div><h1>{escape(headline)}</h1><p>replace this text with your own little story, favourite thing, or meaningful moment.</p><div class="doodle">♡</div></div>'''

def build_html():
    pages=[]; n=1
    for title, cover, kicker, prompt, closing, cta in SETS:
        pages += [page(title,kicker,cover,prompt,n,'cover'), page(title,kicker,prompt,'photo / replace me',n+1,'story'), page(title,kicker,'a few little details','notes / list / feeling',n+2,'notes'), page(title,kicker,closing,'photo collage / replace images',n+3,'collage'), page(title,kicker,cta,'save / share / comment',n+4,'cta')]
        n+=5
    css='''*{box-sizing:border-box}body{margin:0;background:#ddd;font-family:Arial,sans-serif}.page{width:1080px;height:1350px;position:relative;overflow:hidden;background:#f7edf0;color:#342e3f;page-break-after:always;padding:92px}.grain{position:absolute;inset:0;opacity:.2;background-image:radial-gradient(#6d526d 1px,transparent 1px);background-size:9px 9px}.meta,.page-number{position:absolute;font-size:22px;font-weight:700;letter-spacing:3px;text-transform:uppercase}.meta{top:72px;left:92px}.page-number{top:72px;right:92px}.photo{position:absolute;border:13px solid #fff9f5;box-shadow:0 18px 45px #6d526d55}.photo-0{width:660px;height:820px;right:-50px;bottom:70px;background:linear-gradient(140deg,#e8bbc8,#dcd3f0 55%,#b9cdbb)}.photo-1{width:720px;height:640px;left:80px;bottom:120px;background:linear-gradient(35deg,#b9cdbb,#fff9f5 42%,#e8bbc8)}.photo-2{width:560px;height:760px;right:65px;bottom:90px;background:linear-gradient(160deg,#dcd3f0,#fff9f5,#e8bbc8)}.photo-3{width:800px;height:510px;left:145px;bottom:150px;background:linear-gradient(150deg,#6d526d,#e8bbc8 54%,#fff9f5)}h1{position:relative;margin:195px 0 20px;max-width:720px;font-family:Georgia,serif;font-size:105px;line-height:.94;letter-spacing:-5px;z-index:2}p{position:relative;max-width:420px;font-size:27px;line-height:1.4;z-index:2}.ios-card{position:absolute;left:92px;bottom:112px;width:440px;padding:28px 30px;border:4px solid #342e3f;border-radius:32px;background:#fff9f5cc;z-index:3;font-size:22px}.ios-card span{display:block;color:#e8bbc8;margin-bottom:12px}.doodle{position:absolute;top:440px;left:580px;font-family:Georgia,serif;font-size:160px;color:#e8bbc8;z-index:4;transform:rotate(-18deg)}.page-story h1,.page-notes h1{font-size:82px}.page-collage .photo{box-shadow:260px -50px 0 -30px #fff9f5,260px -50px 0 -16px #dcd3f0}.page-cta{background:#6d526d;color:#fff9f5}.page-cta .ios-card{background:#e8bbc8;color:#342e3f}.page-cta .doodle{color:#dcd3f0}'''
    BUNDLE.mkdir(parents=True,exist_ok=True)
    (BUNDLE/'soft-ios-photo-diary-carousel-kit.html').write_text(f'<!doctype html><html><head><meta charset="utf-8"><style>{css}</style></head><body>{"".join(pages)}</body></html>',encoding='utf-8')
    # Library page is the buyer's browsable asset map.
    new_cards=''.join(f'<div class="card"><img src="../40 New Stickers/{p.name}"/><span>{p.stem[3:].replace("-"," ")}</span></div>' for p in sorted(ASSETS.glob('*.svg')))
    original_dir = ROOT / '03 Sticker Pack'
    original_cards=''.join(f'<div class="card"><img src="../../03 Sticker Pack/{p.name}"/><span>{p.stem.replace("-outlined", "").replace("-", " ")}</span></div>' for p in sorted(original_dir.glob('*.png')))
    cards = new_cards + original_cards
    (BUNDLE/'sticker-library.html').write_text(f'''<!doctype html><html><head><style>body{{margin:0;background:#f7edf0;color:#342e3f;font-family:Arial;padding:70px}}h1{{font:80px Georgia;margin:0 0 10px}}p{{font-size:26px}}.grid{{display:grid;grid-template-columns:repeat(5,1fr);gap:24px}}.card{{height:265px;border:3px solid #342e3f;border-radius:24px;padding:14px;background:#fff9f5;display:flex;flex-direction:column;justify-content:space-between}}img{{width:190px;height:190px;object-fit:contain;align-self:center}}span{{font-size:17px;font-weight:bold;text-transform:capitalize}}</style></head><body><div data-document-role="page" data-label="Sticker Library"><h1>Soft iOS sticker library</h1><p>70 draggable stickers - lifestyle, iOS-inspired UI, frames and doodles</p><div class="grid">{cards}</div></div></body></html>''',encoding='utf-8')

def gallery_html():
    labels=['before → after','8 ready-to-edit carousel sets','70 sticker library','photo diary + iOS details','edit in 3 steps','instant download • no resale rights']
    cards=''.join(f'<div data-document-role="page" data-label="Etsy Gallery {i+1}" class="page"><div class="k">SOFT IOS PHOTO-DIARY CAROUSEL KIT</div><h1>{escape(label)}</h1><div class="phone"><div class="screen">{i+1:02d}<br/><small>your little story<br/>goes here</small></div></div><p>8 editable Canva carousel sets · 70 lifestyle stickers · made for your softest little updates</p></div>' for i,label in enumerate(labels))
    css='''.page{width:2000px;height:1600px;background:#f7edf0;color:#342e3f;padding:125px;position:relative;page-break-after:always;font-family:Arial}.k{letter-spacing:4px;font-size:25px;font-weight:700}.page h1{font:140px Georgia;line-height:.95;max-width:1000px;letter-spacing:-7px;margin:150px 0 60px}.phone{position:absolute;right:220px;top:220px;width:570px;height:1040px;border:25px solid #342e3f;border-radius:85px;background:#fff9f5;padding:45px}.screen{height:100%;border-radius:48px;background:linear-gradient(145deg,#e8bbc8,#dcd3f0 52%,#b9cdbb);padding:320px 35px;font:110px Georgia;text-align:center}.screen small{font:35px Arial}.page p{font-size:38px;max-width:900px;line-height:1.35}'''
    (LISTING/'etsy-listing-gallery.html').parent.mkdir(parents=True,exist_ok=True)
    (LISTING/'etsy-listing-gallery.html').write_text(f'<!doctype html><html><head><style>{css}</style></head><body>{cards}</body></html>',encoding='utf-8')

def readme():
    (OUT/'PRODUCT README.md').write_text('''# Soft iOS Photo-Diary Carousel Kit

## Deliverables
- 40 editable-style SVG stickers in `40 New Stickers`.
- 30 original lifestyle PNG stickers are retained in `../03 Sticker Pack`.
- 40-page 4:5 carousel HTML import in `Canva Import Bundle`.
- Etsy gallery HTML in `Etsy Listing Gallery`.

## Customer licence
Commercial use is allowed for the purchaser's finished social media content. The template, stickers, and editable files may not be resold, redistributed, sublicensed, shared, or used to create competing template or asset packs.

## Etsy title
iOS Photo Diary Instagram Carousel Templates | 8 Editable Canva Carousels + 70 Lifestyle Stickers | Personal Brand Content Kit
''',encoding='utf-8')

def package():
    z=OUT/'soft-ios-photo-diary-canva-import.zip'
    with ZipFile(z,'w',ZIP_DEFLATED) as zip:
        for p in BUNDLE.rglob('*'):
            if p.is_file(): zip.write(p,p.relative_to(OUT))
        for p in ASSETS.glob('*.svg'): zip.write(p,p.relative_to(OUT))
        for p in (ROOT / '03 Sticker Pack').glob('*.png'):
            zip.write(p,Path('Original Lifestyle Stickers') / p.name)
    return z

if __name__=='__main__':
    make_assets(); build_html(); gallery_html(); readme(); print(package())
