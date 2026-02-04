#!/usr/bin/env bash
set -e

echo "=== CloudX × ZDOS AUTO-UPDATER ==="

# 1) BACKUP
echo "[1/8] Backup file..."
mkdir -p backups
cp index.html backups/index_$(date +%s).bak || true
cp assets/css/style.css backups/style_$(date +%s).bak || true
cp assets/js/main.js backups/main_$(date +%s).bak || true

# 2) ASSICURA CHE CSS E JS SIANO LINKATI
echo "[2/8] Aggancio CSS/JS se mancanti..."

if ! grep -q "assets/css/style.css" index.html; then
  sed -i 's|</head>|<link rel="stylesheet" href="assets/css/style.css">\n</head>|' index.html
  echo "✔ CSS collegato"
fi

if ! grep -q "assets/js/main.js" index.html; then
  sed -i 's|</body>|<script src="assets/js/main.js"></script>\n</body>|' index.html
  echo "✔ JS collegato"
fi

# 3) AGGIUNTA MINI-RZAI ALLA HOMEPAGE
echo "[3/8] Inserimento mini-RZAi..."

if ! grep -q "mini-rzai" index.html; then
cat << 'EOF' >> index.html

<!-- MINI RZAI -->
<div id="mini-rzai">
  <div class="rzai-avatar"></div>
  <div class="rzai-bubble">Serve aiuto?</div>
</div>

EOF
echo "✔ Mini-RZAi aggiunto"
fi

# 4) HERO PREMIUM
echo "[4/8] Inserimento HERO premium..."

if ! grep -q "hero-main" index.html; then
sed -i 's|<body>|<body>\n<section class="hero-main">\n<h1 class="hero-title">xZDOS Enterprise Platform</h1>\n<p class="hero-sub">Ecosistema modulare per aziende, automazioni, AI e integrazioni.</p>\n<div class="hero-tags"><span class="tag">CloudX</span><span class="tag">Automazioni</span><span class="tag">AI</span><span class="tag">xCLOUD</span></div>\n<button class="btn btn-primary" onclick="window.location.href='\''/clienti.html'\''">Scopri le Soluzioni Aziendali</button>\n</section>|' index.html
echo "✔ HERO premium aggiunta"
fi

# 5) TERMINALE RZAI
echo "[5/8] Inserimento terminale RZAi..."

if ! grep -q "terminal-window" index.html; then
cat << 'EOF' >> index.html

<!-- TERMINALE RZAI -->
<section class="terminal-window">
  <div id="output">RZAi‑pulciz è online. Digita "help" per iniziare.</div>
  <input id="input" type="text" placeholder='Scrivi un comando...' />
</section>

<script src="assets/js/rzai.js"></script>

EOF
echo "✔ Terminale RZAi aggiunto"
fi

# 6) CSS POTENZIATO
echo "[6/8] Aggiornamento CSS neon + animazioni..."

cat << 'EOF' >> assets/css/style.css

/* === MAX POWER NEON + RZAI === */
@keyframes rzai-breath {
  0% { transform: scale(1); box-shadow: 0 0 14px rgba(34, 211, 238, 0.7); }
  50% { transform: scale(1.06); box-shadow: 0 0 22px rgba(34, 211, 238, 1); }
  100% { transform: scale(1); box-shadow: 0 0 14px rgba(34, 211, 238, 0.7); }
}

.rzai-avatar {
  animation: rzai-breath 3s ease-in-out infinite;
}

#mini-rzai:hover .rzai-bubble {
  opacity: 1;
  transform: translateY(-4px);
}

.rzai-bubble {
  opacity: 0;
  transition: 0.25s ease;
}

a:hover {
  text-shadow: 0 0 12px rgba(34, 211, 238, 0.8);
  color: #22d3ee;
}

body {
  background: radial-gradient(circle at top, #020617 0%, #000 100%);
}

EOF

echo "✔ CSS potenziato"

# 7) JS POTENZIATO
echo "[7/8] Aggiornamento JS mini-RZAi dinamico..."

cat << 'EOF' > assets/js/main.js
document.addEventListener("DOMContentLoaded", () => {
  const miniRzai = document.getElementById("mini-rzai");
  const bubble = document.querySelector(".rzai-bubble");

  if (!miniRzai || !bubble) return;

  const messages = [
    "Serve aiuto?",
    "Vuoi una soluzione su misura?",
    "Posso guidarti nei moduli.",
    "Hai già visto la pagina clienti?",
    "Vuoi automatizzare qualcosa?"
  ];

  let i = 0;
  bubble.textContent = messages[i];

  setInterval(() => {
    i = (i + 1) % messages.length;
    bubble.textContent = messages[i];
  }, 4000);

  miniRzai.addEventListener("click", () => {
    window.location.href = "/clienti.html#section-contatto";
  });
});
EOF

echo "✔ JS potenziato"

# 8) GIT COMMIT + PUSH
echo "[8/8] Commit & Push..."

git add .
git commit -m "auto-update: homepage restored + neon + mini-RZAI + terminal + premium UI"
git push

echo "=== COMPLETATO ==="
