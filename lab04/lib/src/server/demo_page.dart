/// HTML-сторінка для демонстрації HTTP-сервісу (не частина API).
String demoPageHtml() {
  return '''
<!DOCTYPE html>
<html lang="uk">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Каталог фільмів — піксельна бібліотека</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&family=VT323&display=swap" rel="stylesheet" />
  <style>
    :root {
      --bg0: #030712;
      --bg1: #071428;
      --wood: #0a1a33;
      --wood2: #0d2244;
      --neon: #22d3ee;
      --neon2: #3b82f6;
      --text: #e2f3ff;
      --muted: #7dd3fc;
      --danger: #fb7185;
      --ok: #34d399;
      --pixel: 4px;
    }
    * { box-sizing: border-box; image-rendering: pixelated; }
    html { font-size: 18px; }
    body {
      margin: 0;
      min-height: 100vh;
      color: var(--text);
      font-family: VT323, monospace;
      font-size: 1.35rem;
      letter-spacing: .02em;
      background-color: var(--bg0);
      background-image:
        linear-gradient(rgba(3,7,18,.55), rgba(3,7,18,.75)),
        repeating-linear-gradient(
          90deg,
          #061229 0 14px,
          #0a1f3d 14px 18px,
          #071833 18px 28px,
          #0c274f 28px 32px,
          #081a36 32px 48px
        );
      background-size: auto, 48px 100%;
    }
    /* пил / віньєтка бібліотеки */
    body::before {
      content: "";
      position: fixed;
      inset: 0;
      pointer-events: none;
      background:
        radial-gradient(ellipse at 50% 20%, rgba(34,211,238,.12), transparent 55%),
        radial-gradient(ellipse at center, transparent 40%, rgba(0,0,0,.65) 100%);
      z-index: 0;
    }
    /* scanlines як у ретро-грі */
    body::after {
      content: "";
      position: fixed;
      inset: 0;
      pointer-events: none;
      background: repeating-linear-gradient(
        to bottom,
        rgba(0,0,0,.12) 0 1px,
        transparent 1px 3px
      );
      z-index: 5;
      mix-blend-mode: multiply;
      opacity: .45;
    }
    .wrap {
      position: relative;
      z-index: 1;
      width: min(980px, calc(100% - 1.5rem));
      margin: 0 auto;
      padding: 1.75rem 0 3rem;
    }
    .sign {
      text-align: center;
      margin-bottom: 1.5rem;
    }
    .brand {
      font-family: "Press Start 2P", monospace;
      font-size: clamp(.7rem, 2.2vw, 1.05rem);
      line-height: 1.7;
      color: var(--neon);
      text-transform: uppercase;
      text-shadow:
        3px 0 0 #0b3a5c,
        -3px 0 0 #0b3a5c,
        0 3px 0 #0b3a5c,
        0 -3px 0 #0b3a5c,
        0 0 12px rgba(34,211,238,.9),
        0 0 28px rgba(59,130,246,.55);
      margin: 0;
    }
    .lamp {
      display: block;
      width: 72px;
      height: 20px;
      margin: 0 auto 1rem;
      background:
        linear-gradient(var(--neon), var(--neon2));
      box-shadow:
        0 0 16px var(--neon),
        0 18px 40px rgba(34,211,238,.25);
      clip-path: polygon(20% 0, 80% 0, 100% 100%, 0 100%);
      opacity: .9;
    }
    .panel {
      position: relative;
      background: linear-gradient(180deg, var(--wood2), var(--wood));
      border: var(--pixel) solid var(--neon2);
      box-shadow:
        0 0 0 var(--pixel) #03101f,
        inset 0 0 0 2px rgba(34,211,238,.25),
        0 0 24px rgba(34,211,238,.15);
      padding: 1rem 1rem 1.1rem;
      margin-bottom: 1.15rem;
    }
    .panel::before {
      content: "";
      position: absolute;
      left: 8px; right: 8px; top: 8px;
      height: 6px;
      background: repeating-linear-gradient(
        90deg,
        rgba(34,211,238,.35) 0 8px,
        transparent 8px 14px
      );
      pointer-events: none;
    }
    .panel h2 {
      font-family: "Press Start 2P", monospace;
      font-size: .62rem;
      line-height: 1.6;
      letter-spacing: .04em;
      color: var(--neon);
      margin: .4rem 0 1rem;
      text-shadow: 0 0 8px rgba(34,211,238,.7);
    }
    .row { display: flex; flex-wrap: wrap; gap: .55rem; align-items: flex-end; }
    label {
      display: flex;
      flex-direction: column;
      gap: .25rem;
      color: var(--muted);
      font-size: 1.05rem;
    }
    input, select, button {
      font-family: VT323, monospace;
      font-size: 1.25rem;
      color: var(--text);
      background: #04101f;
      border: 3px solid var(--neon);
      padding: .35rem .55rem;
      outline: none;
      border-radius: 0;
      image-rendering: pixelated;
    }
    input:focus, select:focus {
      box-shadow: 0 0 0 2px #031018, 0 0 12px rgba(34,211,238,.45);
    }
    button {
      cursor: pointer;
      background: var(--neon2);
      border-color: var(--neon);
      color: #021018;
      font-family: "Press Start 2P", monospace;
      font-size: .52rem;
      line-height: 1.5;
      padding: .55rem .7rem;
      text-transform: uppercase;
      box-shadow: 3px 3px 0 #021018;
    }
    button:active { transform: translate(2px, 2px); box-shadow: 1px 1px 0 #021018; }
    button.ghost {
      background: #04101f;
      color: var(--neon);
    }
    button.danger {
      background: #04101f;
      color: var(--danger);
      border-color: var(--danger);
      box-shadow: 3px 3px 0 #2a0a12;
      text-shadow: 0 0 8px rgba(251,113,133,.45);
    }
    button.danger:hover {
      filter: brightness(1.12);
    }
    .shelf {
      margin-top: 1rem;
      padding-top: .75rem;
      border-top: 4px solid rgba(34,211,238,.35);
      background:
        linear-gradient(180deg, transparent 0 70%, rgba(10,30,60,.85) 70% 100%);
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      grid-auto-rows: 188px;
      gap: .75rem;
      align-items: stretch;
    }
    @media (max-width: 900px) {
      .grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
    }
    @media (max-width: 640px) {
      .grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    }
    .card {
      position: relative;
      height: 100%;
      display: flex;
      flex-direction: column;
      padding: .7rem .55rem .85rem .85rem;
      background:
        linear-gradient(90deg, rgba(34,211,238,.35) 0 6px, transparent 6px),
        linear-gradient(180deg, #0c2a52, #071a36);
      border: 3px solid var(--neon2);
      box-shadow: 4px 4px 0 #020617, inset -6px 0 0 rgba(34,211,238,.15);
      overflow: hidden;
    }
    .card .spine {
      position: absolute;
      left: 0; top: 0; bottom: 0;
      width: 6px;
      background: var(--neon);
      box-shadow: 0 0 10px rgba(34,211,238,.6);
    }
    .card .code {
      color: var(--neon);
      font-family: "Press Start 2P", monospace;
      font-size: .48rem;
      line-height: 1.5;
      flex: 0 0 auto;
    }
    .card .title {
      font-family: "Press Start 2P", monospace;
      font-size: .52rem;
      line-height: 1.5;
      margin: .5rem 0 .45rem;
      color: var(--text);
      text-shadow: 0 0 6px rgba(59,130,246,.4);
      flex: 1 1 auto;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 3;
      overflow: hidden;
      min-height: 0;
    }
    .meta {
      color: var(--muted);
      font-size: 1.05rem;
      line-height: 1.15;
      flex: 0 0 auto;
      margin-top: auto;
    }
    .card.broken {
      border-color: var(--danger);
      background:
        linear-gradient(90deg, rgba(251,113,133,.55) 0 6px, transparent 6px),
        linear-gradient(180deg, #3a1020, #1a0810);
      box-shadow: 4px 4px 0 #2a0a12, inset -6px 0 0 rgba(251,113,133,.2),
        0 0 16px rgba(251,113,133,.2);
    }
    .card.broken .spine {
      background: var(--danger);
      box-shadow: 0 0 10px rgba(251,113,133,.7);
    }
    .card.broken .code,
    .card.broken .title {
      color: var(--danger);
      text-shadow: 0 0 8px rgba(251,113,133,.45);
    }
    .card.broken .meta { color: #fda4af; }
    .card.broken .badge {
      font-family: "Press Start 2P", monospace;
      font-size: .42rem;
      line-height: 1.5;
      color: #fff;
      background: var(--danger);
      display: inline-block;
      padding: .25rem .35rem;
      margin-top: .35rem;
      box-shadow: 2px 2px 0 #2a0a12;
    }
    .status {
      margin-top: .7rem;
      min-height: 1.2rem;
      font-size: 1.2rem;
    }
    .status.ok { color: var(--ok); text-shadow: 0 0 8px rgba(52,211,153,.4); }
    .status.err { color: var(--danger); text-shadow: 0 0 8px rgba(251,113,133,.4); }
    .form-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: .55rem;
    }
    @media (max-width: 720px) {
      .form-grid { grid-template-columns: 1fr; }
      button { width: 100%; }
    }
    #oneBody {
      margin: .7rem 0 0;
      padding: .6rem;
      border: 3px dashed rgba(34,211,238,.4);
      background: #04101f;
      white-space: pre-wrap;
      font-size: 1.15rem;
      color: var(--muted);
    }
    .footer-plaque {
      text-align: center;
      margin-top: 1.5rem;
      font-family: "Press Start 2P", monospace;
      font-size: .45rem;
      color: rgba(125,211,252,.7);
      line-height: 1.8;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="sign">
      <div class="lamp" aria-hidden="true"></div>
      <h1 class="brand">Архів фільмів</h1>
    </div>

    <section class="panel">
      <h2>// полиця каталогу</h2>
      <div class="row">
        <label>жанр
          <select id="genre">
            <option value="">усі томи</option>
            <option value="драма">драма</option>
            <option value="комедія">комедія</option>
            <option value="трилер">трилер</option>
            <option value="фантастика">фантастика</option>
            <option value="анімація">анімація</option>
          </select>
        </label>
        <label>minRating
          <input id="minRating" type="number" step="0.1" min="0" max="10" placeholder="8.0" style="width:6rem" />
        </label>
        <button type="button" id="btnLoad">GET /items</button>
      </div>
      <div class="status" id="listStatus"></div>
      <div class="shelf">
        <div class="grid" id="list"></div>
      </div>
    </section>

    <section class="panel">
      <h2>// картка з шухляди</h2>
      <div class="row">
        <input id="filmId" value="FM-001" style="width:9rem" />
        <button type="button" id="btnGet">GET id</button>
        <button type="button" class="ghost" id="btnMissing">FM-999 → 404</button>
      </div>
      <div class="status" id="oneStatus"></div>
      <pre id="oneBody"></pre>
    </section>

    <section class="panel">
      <h2>// новий том на полицю</h2>
      <div class="form-grid">
        <label>code <input id="fCode" placeholder="FM-010" /></label>
        <label>title <input id="fTitle" placeholder="назва" /></label>
        <label>director <input id="fDirector" placeholder="режисер" /></label>
        <label>year <input id="fYear" type="number" placeholder="2020" /></label>
        <label>durationMinutes <input id="fDur" type="number" placeholder="90" /></label>
        <label>genre
          <select id="fGenre">
            <option>драма</option>
            <option>комедія</option>
            <option>трилер</option>
            <option>фантастика</option>
            <option>анімація</option>
          </select>
        </label>
        <label>rating <input id="fRating" type="number" step="0.1" placeholder="8.0" /></label>
        <label>watchedOn <input id="fWatched" placeholder="2024-01-15T00:00:00.000" /></label>
      </div>
      <div class="row" style="margin-top:.85rem">
        <button type="button" id="btnPost">POST → 201</button>
        <button type="button" class="danger" id="btnBad">зламаний JSON → 400</button>
      </div>
      <div class="status" id="postStatus"></div>
    </section>

    <p class="footer-plaque">PRESS START · lab04 shelf archive</p>
  </div>
  <script>
    const listEl = document.getElementById('list');
    const listStatus = document.getElementById('listStatus');
    const oneStatus = document.getElementById('oneStatus');
    const oneBody = document.getElementById('oneBody');
    const postStatus = document.getElementById('postStatus');
    let showBrokenJson = false;
    const brokenPayload = '{"code":1}';

    function setStatus(el, ok, text) {
      el.className = 'status ' + (ok ? 'ok' : 'err');
      el.textContent = text;
    }

    function card(film) {
      const div = document.createElement('article');
      div.className = 'card';
      div.innerHTML =
        '<div class="spine"></div>' +
        '<div class="code">' + film.code + '</div>' +
        '<div class="title">' + film.title + '</div>' +
        '<div class="meta">' + film.director + '<br>' +
        film.year + ' · ' + film.durationMinutes + ' хв<br>' +
        film.genre + ' · ★ ' + film.rating + '</div>';
      return div;
    }

    function brokenCard() {
      const div = document.createElement('article');
      div.className = 'card broken';
      div.innerHTML =
        '<div class="spine"></div>' +
        '<div class="code">BAD-JSON</div>' +
        '<div class="title">зламаний JSON</div>' +
        '<div class="meta">' + brokenPayload + '<br>не потрапив у каталог</div>' +
        '<div class="badge">зламано</div>';
      return div;
    }

    function appendBrokenIfNeeded() {
      if (showBrokenJson) {
        listEl.appendChild(brokenCard());
      }
    }

    async function loadList() {
      const genre = document.getElementById('genre').value;
      const minRating = document.getElementById('minRating').value;
      const q = new URLSearchParams();
      if (genre) q.set('genre', genre);
      if (minRating) q.set('minRating', minRating);
      const url = '/items' + (q.toString() ? '?' + q.toString() : '');
      const res = await fetch(url);
      const data = await res.json();
      listEl.innerHTML = '';
      if (!res.ok) {
        setStatus(listStatus, false, res.status + ' ' + JSON.stringify(data));
        return;
      }
      data.forEach((f) => listEl.appendChild(card(f)));
      appendBrokenIfNeeded();
      const extra = showBrokenJson ? ' + 1 зламаний' : '';
      setStatus(listStatus, true, 'HTTP ' + res.status + ' · томів: ' + data.length + extra + ' · ' + url);
    }

    async function loadOne(id) {
      const res = await fetch('/items/' + encodeURIComponent(id));
      const text = await res.text();
      let pretty = text;
      try { pretty = JSON.stringify(JSON.parse(text), null, 2); } catch (_) {}
      oneBody.textContent = pretty;
      setStatus(oneStatus, res.ok, 'HTTP ' + res.status + ' · GET /items/' + id);
    }

    async function postFilm(payload, expect) {
      const res = await fetch('/items', {
        method: 'POST',
        headers: { 'content-type': 'application/json; charset=utf-8' },
        body: typeof payload === 'string' ? payload : JSON.stringify(payload),
      });
      const text = await res.text();
      setStatus(
        postStatus,
        res.status === expect,
        'HTTP ' + res.status + ' (чекали ' + expect + ') · ' + text.slice(0, 160)
      );
      if (res.status === 201) {
        loadList();
      }
      if (res.status === 400 && expect === 400) {
        showBrokenJson = true;
        loadList();
      }
    }

    document.getElementById('btnLoad').onclick = loadList;
    document.getElementById('btnGet').onclick = () =>
      loadOne(document.getElementById('filmId').value.trim() || 'FM-001');
    document.getElementById('btnMissing').onclick = () => loadOne('FM-999');
    document.getElementById('btnPost').onclick = () => postFilm({
      code: document.getElementById('fCode').value,
      title: document.getElementById('fTitle').value,
      director: document.getElementById('fDirector').value,
      year: Number(document.getElementById('fYear').value),
      durationMinutes: Number(document.getElementById('fDur').value),
      genre: document.getElementById('fGenre').value,
      rating: Number(document.getElementById('fRating').value),
      watchedOn: document.getElementById('fWatched').value,
    }, 201);
    document.getElementById('btnBad').onclick = () => postFilm(brokenPayload, 400);

    loadList();
  </script>
</body>
</html>
''';
}
