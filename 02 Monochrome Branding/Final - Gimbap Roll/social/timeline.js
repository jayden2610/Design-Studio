(() => {
  const BEATS = Object.freeze([
    { id: "logo", label: "01 / Mark", file: "01_logo_hierarchy", ms: 1700 },
    { id: "colour", label: "02 / Colour", file: "02_color_palette", ms: 1600 },
    { id: "type", label: "03 / Type", file: "03_typography_tagline", ms: 1700 },
    { id: "pattern", label: "04 / Pattern", file: "04_brand_pattern", ms: 1700 },
    { id: "packaging", label: "05 / Packaging", file: "05_packaging_action", ms: 2300 },
    { id: "grid", label: "06 / Grid", file: "06_outro_3x3_grid", ms: 3000 },
  ]);

  const params = new URLSearchParams(location.search);
  const contactMode = params.has("contact") || document.body.dataset.mode === "contact";
  const captureMode = params.has("capture");
  const holdMode = params.has("hold") || contactMode;
  const startBeat = clampBeat(Number.parseInt(params.get("beat") ?? "", 10));
  const reduced = matchMedia("(prefers-reduced-motion: reduce)").matches;

  const stage = document.getElementById("stage");
  const shell = document.querySelector(".stage-shell");
  const beatNodes = Array.from(document.querySelectorAll(".beat"));
  const labelEl = document.getElementById("beat-label");
  const playBtn = document.getElementById("play-btn");
  const contactWall = document.getElementById("contact-wall");
  const contactRow = document.getElementById("contact-row");

  let index = Number.isInteger(startBeat) ? startBeat : 0;
  let playing = !holdMode && !contactMode && !reduced && !captureMode;
  let timer = 0;
  let startedAt = 0;

  function clampBeat(value) {
    if (!Number.isInteger(value) || value < 0 || value >= BEATS.length) return null;
    return value;
  }

  function setTicks(beatIndex, fraction) {
    document.querySelectorAll(".tick i").forEach((el, i) => {
      const slot = i % BEATS.length;
      let fill = 0;
      if (slot < beatIndex) fill = 1;
      else if (slot === beatIndex) fill = fraction;
      el.style.transform = `scaleX(${fill})`;
    });
  }

  function show(nextIndex, options) {
    const animate = Boolean(options && options.animate) && !reduced && !holdMode;
    index = ((nextIndex % BEATS.length) + BEATS.length) % BEATS.length;
    beatNodes.forEach((node, i) => {
      const on = i === index;
      node.classList.toggle("is-active", on);
      node.classList.toggle("is-hold", on && !animate);
      node.classList.toggle("is-settled", on && !animate);
      if (on && animate) {
        node.classList.remove("is-settled");
        window.setTimeout(() => {
          if (i === index) node.classList.add("is-settled");
        }, 480);
      }
    });
    if (labelEl) labelEl.textContent = BEATS[index].label;
    if (playBtn) playBtn.setAttribute("aria-pressed", playing ? "true" : "false");
    if (playBtn) playBtn.textContent = playing ? "Pause" : "Play";
    setTicks(index, playing ? 0 : 1);
    startedAt = performance.now();
  }

  function schedule() {
    window.clearTimeout(timer);
    if (!playing) return;
    const current = BEATS[index];
    timer = window.setTimeout(() => {
      if (index >= BEATS.length - 1) {
        playing = false;
        show(index, { animate: false });
        return;
      }
      show(index + 1, { animate: true });
      schedule();
    }, current.ms);
  }

  function togglePlay() {
    playing = !playing;
    if (playing && index >= BEATS.length - 1) {
      show(0, { animate: !reduced });
    } else {
      show(index, { animate: playing && !reduced });
    }
    if (playing) schedule();
    else window.clearTimeout(timer);
  }

  function step(delta) {
    playing = false;
    window.clearTimeout(timer);
    show(index + delta, { animate: !reduced });
  }

  function fitStage() {
    if (!stage || captureMode || contactMode) return;
    if (!shell) return;
    const scale = Math.min(shell.clientWidth / 1080, shell.clientHeight / 1920);
    stage.style.transform = `scale(${Math.max(scale, 0.12)})`;
  }

  function paintProgress() {
    if (!playing) return;
    const elapsed = performance.now() - startedAt;
    const fraction = Math.max(0, Math.min(1, elapsed / BEATS[index].ms));
    setTicks(index, fraction);
    requestAnimationFrame(paintProgress);
  }

  function uniquifySvgIds(root, suffix) {
    const renamed = new Map();
    root.querySelectorAll("[id]").forEach((el) => {
      renamed.set(el.id, `${el.id}-${suffix}`);
      el.id = `${el.id}-${suffix}`;
    });
    root.querySelectorAll("[fill], [stroke]").forEach((el) => {
      for (const attr of ["fill", "stroke"]) {
        const value = el.getAttribute(attr);
        if (!value) continue;
        renamed.forEach((next, prev) => {
          if (value === `url(#${prev})`) el.setAttribute(attr, `url(#${next})`);
        });
      }
    });
  }

  function renderContact() {
    if (!contactWall || !contactRow || !stage) return;
    document.body.classList.add("is-contact");
    contactWall.hidden = false;
    const scale = Math.min(0.22, Math.max(0.14, (window.innerWidth - 80) / 6 / 1080));
    document.documentElement.style.setProperty("--contact-scale", String(scale));
    BEATS.forEach((beat, beatIndex) => {
      const figure = document.createElement("figure");
      const cell = document.createElement("div");
      cell.className = "contact-cell";
      cell.style.width = `${1080 * scale}px`;
      cell.style.height = `${1920 * scale}px`;
      const frame = document.createElement("div");
      frame.className = "contact-frame";
      frame.style.transform = `scale(${scale})`;
      const clone = stage.cloneNode(true);
      clone.removeAttribute("id");
      clone.style.transform = "none";
      uniquifySvgIds(clone, String(beatIndex));
      clone.querySelectorAll(".beat").forEach((node, nodeIndex) => {
        const on = nodeIndex === beatIndex;
        node.classList.toggle("is-active", on);
        node.classList.toggle("is-hold", on);
        node.classList.toggle("is-settled", on);
      });
      frame.appendChild(clone);
      cell.appendChild(frame);
      figure.appendChild(cell);
      const cap = document.createElement("figcaption");
      cap.innerHTML = `<span>${beat.file}</span><span>${beat.label}</span>`;
      figure.appendChild(cap);
      contactRow.appendChild(figure);
    });
    stage.remove();
  }

  document.body.classList.toggle("is-capture", captureMode);

  if (contactMode) {
    renderContact();
  } else {
    show(index, { animate: playing });
    if (playing) {
      schedule();
      requestAnimationFrame(paintProgress);
    }
    fitStage();
    addEventListener("resize", fitStage, { passive: true });
  }

  if (playBtn) playBtn.addEventListener("click", togglePlay);
  const prevBtn = document.getElementById("prev-btn");
  const nextBtn = document.getElementById("next-btn");
  if (prevBtn) prevBtn.addEventListener("click", () => step(-1));
  if (nextBtn) nextBtn.addEventListener("click", () => step(1));

  if (stage && !contactMode) {
    stage.addEventListener("click", () => step(1));
  }

  addEventListener("keydown", (event) => {
    if (contactMode) return;
    if (event.key === " " || event.code === "Space") {
      event.preventDefault();
      togglePlay();
      return;
    }
    if (event.key === "ArrowRight") step(1);
    if (event.key === "ArrowLeft") step(-1);
    const numeric = Number.parseInt(event.key, 10);
    if (numeric >= 1 && numeric <= 6) {
      playing = false;
      window.clearTimeout(timer);
      show(numeric - 1, { animate: !reduced });
    }
  });
})();
