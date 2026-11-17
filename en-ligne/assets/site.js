/* Zoé Mossino — Portfolio */
(() => {
  const $$ = (s, r = document) => [...r.querySelectorAll(s)];
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---- apparition des visuels au scroll */
  const items = $$('.tile');
  if ('IntersectionObserver' in window && !reduce) {
    const io = new IntersectionObserver((entries) => {
      let n = 0;
      entries.forEach((e) => {
        if (!e.isIntersecting) return;
        e.target.style.transitionDelay = `${Math.min(n++ * 70, 280)}ms`;
        e.target.classList.add('in');
        io.unobserve(e.target);
      });
    }, { rootMargin: '0px 0px -6% 0px', threshold: 0.05 });
    items.forEach((el) => io.observe(el));
  } else {
    items.forEach((el) => el.classList.add('in'));
  }

  /* ---- projet actif dans la barre latérale */
  const spies = $$('[data-spy]');
  if (spies.length) {
    const byId = Object.fromEntries(spies.map((a) => [a.dataset.spy, a]));
    const setOn = (id) => spies.forEach((a) => a.classList.toggle('on', a.dataset.spy === id));
    setOn(spies[0].dataset.spy);
    const so = new IntersectionObserver((entries) => {
      entries.forEach((e) => { if (e.isIntersecting && byId[e.target.id]) setOn(e.target.id); });
    }, { rootMargin: '-35% 0px -60% 0px' });
    $$('.project').forEach((s) => so.observe(s));
  }

  /* ---- vidéos : lecture automatique quand le fichier existe dans assets/video/ */
  const vids = $$('video[data-src]');
  if (vids.length && 'IntersectionObserver' in window) {
    const vo = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        const v = e.target;
        if (e.isIntersecting) {
          if (!v.src && !v.dataset.failed) {
            v.addEventListener('error', () => {
              if (!v.dataset.retried) { // une seconde tentative avant d'abandonner
                v.dataset.retried = '1';
                setTimeout(() => { v.src = v.dataset.src; v.play().catch(() => {}); }, 1500);
              } else {
                v.dataset.failed = '1'; v.removeAttribute('src'); v.load();
              }
            });
            v.src = v.dataset.src;
          }
          if (!v.dataset.failed && !reduce) v.play().catch(() => {});
        } else if (v.src) {
          v.pause();
        }
      });
    }, { rootMargin: '200px 0px' });
    vids.forEach((v) => vo.observe(v));
  }

  /* ---- YouTube : chargé seulement au clic */
  $$('[data-yt]').forEach((b) => b.addEventListener('click', () => {
    // Fichier ouvert directement depuis le disque (file://) : YouTube refuse l'intégration, on ouvre la vidéo dans un onglet
    if (location.protocol === 'file:') {
      window.open(`https://www.youtube.com/watch?v=${b.dataset.yt}`, '_blank', 'noopener');
      return;
    }
    if (b.querySelector('iframe')) return;
    const f = document.createElement('iframe');
    f.referrerPolicy = 'strict-origin-when-cross-origin';
    f.src = `https://www.youtube-nocookie.com/embed/${b.dataset.yt}?autoplay=1&rel=0`;
    f.allow = 'autoplay; encrypted-media; picture-in-picture; fullscreen';
    f.allowFullscreen = true;
    f.title = b.getAttribute('aria-label') || 'Video';
    b.style.position = getComputedStyle(b).position === 'static' ? 'relative' : '';
    b.append(f);
    b.querySelector('.play')?.remove();
  }));

  /* ---- visionneuse d'images */
  const dlg = document.querySelector('.zoom');
  if (dlg && dlg.showModal) {
    const big = dlg.querySelector('img');
    let set = [], at = 0;
    const show = (i) => {
      at = (i + set.length) % set.length;
      big.src = set[at].href;
      big.alt = set[at].querySelector('img')?.alt || '';
    };
    $$('[data-zoom]').forEach((a) => a.addEventListener('click', (e) => {
      if (e.metaKey || e.ctrlKey || e.shiftKey) return;
      e.preventDefault();
      set = $$('[data-zoom]', a.closest('.project') || document);
      show(set.indexOf(a));
      dlg.showModal();
    }));
    dlg.querySelector('.zoom-prev').addEventListener('click', (e) => { e.stopPropagation(); show(at - 1); });
    dlg.querySelector('.zoom-next').addEventListener('click', (e) => { e.stopPropagation(); show(at + 1); });
    dlg.addEventListener('click', () => dlg.close());
    dlg.addEventListener('keydown', (e) => {
      if (e.key === 'ArrowLeft') show(at - 1);
      if (e.key === 'ArrowRight') show(at + 1);
    });
  }

  /* ---- accueil : aperçu qui suit le curseur */
  const pv = document.querySelector('.preview');
  const rows = $$('.index a[data-cover]');
  if (pv && rows.length && matchMedia('(hover: hover) and (pointer: fine)').matches) {
    const imgs = rows.map((r) => {
      const i = new Image();
      i.decoding = 'async';
      i.alt = '';
      i.dataset.src = r.dataset.cover;
      pv.append(i);
      return i;
    });
    let x = innerWidth / 2, y = innerHeight / 2, tx = x, ty = y, raf = 0;
    const tick = () => {
      x += (tx - x) * 0.16; y += (ty - y) * 0.16;
      pv.style.translate = `${x}px ${y}px`;
      raf = Math.abs(tx - x) + Math.abs(ty - y) > 0.3 ? requestAnimationFrame(tick) : 0;
    };
    const aim = (e) => {
      const w = pv.offsetWidth, h = pv.offsetHeight;
      tx = Math.min(e.clientX + 28, innerWidth - w - 16);
      ty = Math.max(16, Math.min(e.clientY - h / 2, innerHeight - h - 16));
      if (reduce) { x = tx; y = ty; pv.style.translate = `${x}px ${y}px`; } else if (!raf) raf = requestAnimationFrame(tick);
    };
    rows.forEach((r, n) => {
      r.addEventListener('pointerenter', (e) => {
        imgs.forEach((i, k) => {
          if (k === n && !i.src) i.src = i.dataset.src;
          i.classList.toggle('on', k === n);
        });
        pv.style.setProperty('--ar', r.dataset.ar || 1.5);
        pv.classList.toggle('tall', +r.dataset.ar < 1);
        if (!pv.classList.contains('on')) { aim(e); x = tx; y = ty; pv.style.translate = `${x}px ${y}px`; }
        pv.classList.add('on');
      });
      r.addEventListener('pointermove', aim);
      r.addEventListener('pointerleave', () => pv.classList.remove('on'));
    });
  }
})();
