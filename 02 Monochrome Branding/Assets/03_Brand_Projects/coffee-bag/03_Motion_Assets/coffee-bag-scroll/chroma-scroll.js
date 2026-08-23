(() => {
  const video = document.querySelector('.motion-source');
  const canvas = document.querySelector('.motion-canvas');
  const fallback = document.querySelector('.motion-fallback');
  const frames = 248;
  const fps = 24;
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;

  const vertex = `
    attribute vec2 position;
    varying vec2 uv;
    void main() {
      uv = (position + 1.0) * 0.5;
      gl_Position = vec4(position, 0.0, 1.0);
    }
  `;
  const fragment = `
    precision mediump float;
    varying vec2 uv;
    uniform sampler2D texture;
    uniform vec3 key;
    vec2 chroma(vec3 color) {
      float luma = dot(color, vec3(0.299, 0.587, 0.114));
      return vec2(color.b - luma, color.r - luma);
    }
    void main() {
      vec4 sample = texture2D(texture, vec2(uv.x, 1.0 - uv.y));
      float distanceFromKey = distance(chroma(sample.rgb), chroma(key));
      float alpha = smoothstep(0.10, 0.18, distanceFromKey);
      vec3 color = sample.rgb;
      float edge = 1.0 - alpha;
      color.g = mix(color.g, min(color.g, max(color.r, color.b)), edge);
      gl_FragColor = vec4(color * alpha, alpha);
    }
  `;

  const fallbackOnly = () => {
    canvas.hidden = true;
    fallback.hidden = false;
  };
  if (reduced) {
    fallbackOnly();
    return;
  }

  const gl = canvas.getContext('webgl', {
    alpha: true,
    antialias: false,
    premultipliedAlpha: true,
  });
  if (!gl) {
    fallbackOnly();
    return;
  }

  const shader = (type, source) => {
    const value = gl.createShader(type);
    gl.shaderSource(value, source);
    gl.compileShader(value);
    if (!gl.getShaderParameter(value, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(value));
    return value;
  };
  let program;
  try {
    program = gl.createProgram();
    gl.attachShader(program, shader(gl.VERTEX_SHADER, vertex));
    gl.attachShader(program, shader(gl.FRAGMENT_SHADER, fragment));
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) throw new Error(gl.getProgramInfoLog(program));
  } catch (_) {
    fallbackOnly();
    return;
  }

  const position = gl.getAttribLocation(program, 'position');
  const key = gl.getUniformLocation(program, 'key');
  const texture = gl.createTexture();
  const buffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1]), gl.STATIC_DRAW);
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

  const resize = () => {
    const rect = canvas.getBoundingClientRect();
    const dpr = Math.min(2, devicePixelRatio || 1);
    const width = Math.max(1, Math.round(rect.width * dpr));
    const height = Math.max(1, Math.round(rect.height * dpr));
    if (canvas.width !== width || canvas.height !== height) {
      canvas.width = width;
      canvas.height = height;
    }
    gl.viewport(0, 0, width, height);
  };
  const draw = () => {
    if (video.readyState < HTMLMediaElement.HAVE_CURRENT_DATA) return;
    resize();
    gl.useProgram(program);
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.enableVertexAttribArray(position);
    gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0);
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, video);
    gl.uniform3f(key, 0, 1, 0);
    gl.drawArrays(gl.TRIANGLES, 0, 6);
    fallback.hidden = true;
    canvas.hidden = false;
  };

  let seeking = false;
  let pending = 0;
  let requested = -1;
  const seek = () => {
    if (seeking || pending === requested || !Number.isFinite(video.duration)) return;
    requested = pending;
    seeking = true;
    video.currentTime = Math.min(requested / fps, video.duration - 1 / fps);
  };
  video.addEventListener('seeked', () => {
    seeking = false;
    draw();
    seek();
  });
  video.addEventListener('loadeddata', () => {
    video.pause();
    draw();
    seek();
  });
  video.addEventListener('error', fallbackOnly);

  let queued = false;
  const update = () => {
    queued = false;
    const limit = Math.max(1, document.documentElement.scrollHeight - innerHeight);
    const progress = Math.max(0, Math.min(1, scrollY / limit));
    pending = Math.round(progress * (frames - 1));
    seek();
  };
  const queue = () => {
    if (!queued) {
      queued = true;
      requestAnimationFrame(update);
    }
  };
  addEventListener('scroll', queue, { passive: true });
  addEventListener('resize', () => { draw(); queue(); }, { passive: true });
  new ResizeObserver(draw).observe(canvas);
  update();
})();
