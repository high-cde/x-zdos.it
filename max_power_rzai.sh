#!/usr/bin/env bash
set -e

echo "[1/4] Backup file esistenti..."
mkdir -p backups
cp assets/css/style.css backups/style.css.bak_$(date +%s) || true
cp assets/js/main.js backups/main.js.bak_$(date +%s) || true

echo "[2/4] Potenziamento CSS (respiro neon + hover bubble)..."

cat >> assets/css/style.css << 'EOF'

/* === RZAI MAX POWER: RESPIRO NEON + HOVER BUBBLE === */
@keyframes rzai-breath {
  0% { transform: scale(1); box-shadow: 0 0 14px rgba(34, 211, 238, 0.7); }
  50% { transform: scale(1.06); box-shadow: 0 0 22px rgba(34, 211, 238, 1); }
  100% { transform: scale(1); box-shadow: 0 0 14px rgba(34, 211, 238, 0.7); }
}

.rzai-avatar {
  animation: rzai-breath 3s ease-in-out infinite;
}

/* Hover bubble più viva */
#mini-rzai:hover .rzai-bubble {
  opacity: 1;
  transform: translateY(-4px);
}

.rzai-bubble {
  opacity: 0;
  transition: 0.25s ease;
}

/* Neon generale link + background premium */
a:hover {
  text-shadow: 0 0 12px rgba(34, 211, 238, 0.8);
  color: #22d3ee;
}

body {
  background: radial-gradient(circle at top, #020617 0%, #000 100%);
}
EOF

echo "[3/4] Potenziamento JS (mini-RZAI dinamico)..."

cat > assets/js/main.js << 'EOF'
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

echo "[4/4] Fatto. Controlla con: git diff assets/css/style.css assets/js/main.js"
