#!/usr/bin/env bash
set -e

echo "=== xZ-TEMPLATES-MASTER ==="

###############################################
# 1) CREAZIONE STRUTTURA
###############################################
echo "[1/7] Creo cartelle templates/ e pages/..."

mkdir -p templates
mkdir -p pages
mkdir -p backups

###############################################
# 2) BACKUP FILE ATTUALI
###############################################
echo "[2/7] Backup file esistenti..."

cp -f index.html backups/index_$(date +%s).bak || true

###############################################
# 3) GENERAZIONE TEMPLATE MODULARI
###############################################
echo "[3/7] Genero template modulari..."

cat > templates/header.html << 'EOF'
<header class="navbar">
  <nav class="nav-inner">
    <div class="nav-logo">xZDOS</div>
    <div class="nav-links">
      <a href="/">Home</a>
      <a href="/zdos/">ZDOS</a>
      <a href="/xCLOUD/">xCLOUD</a>
      <a href="/agents/rzai-pulciz/">RZAi‑pulciz</a>
      <a href="/clienti.html" class="new-badge">Soluzioni Aziendali</a>
      <a href="https://wallet.x-zdos.it/">Wallet</a>
    </div>
  </nav>
</header>
EOF

cat > templates/footer.html << 'EOF'
<footer class="site-footer">
  © CloudX × ZDOS — All Rights Reserved
</footer>
EOF

cat > templates/oracle.html << 'EOF'
<section id="oracle-root"></section>
EOF

cat > templates/terminal.html << 'EOF'
<section class="rzai-terminal">
  <div class="terminal-header">RZAi Terminal</div>
  <div id="terminal-output" class="terminal-output"></div>
  <input id="terminal-input" class="terminal-input" placeholder="rzai> digita un comando...">
</section>
EOF

cat > templates/admin.html << 'EOF'
<section id="admin-panel" class="admin-panel" style="display:none;">
  <h2>Admin Panel</h2>
  <p>Stato GitHub Pages: <span id="gh-status">Caricamento...</span></p>
  <p>Ultimo deploy: <span id="deploy-time">Caricamento...</span></p>
  <button id="deploy-btn" class="cta-button">Esegui Deploy</button>
</section>
EOF

###############################################
# 4) TEMPLATE BASE
###############################################
echo "[4/7] Genero base template..."

cat > templates/base.html << 'EOF'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{ page.title }}</title>
  <link rel="stylesheet" href="/assets/css/style.css">
</head>

<body>

  {% include header.html %}

  <main>
    {{ content }}
  </main>

  {% include footer.html %}

  <script src="/assets/js/main.js"></script>
</body>
</html>
EOF

###############################################
# 5) GENERAZIONE PAGINE
###############################################
echo "[5/7] Genero pagine modulari..."

cat > pages/index.html << 'EOF'
---
layout: base
title: xZDOS Enterprise Platform
---

{% include oracle.html %}
{% include terminal.html %}
EOF

cat > pages/admin.html << 'EOF'
---
layout: base
title: Admin Panel
---

{% include admin.html %}
EOF

###############################################
# 6) SOSTITUZIONE INDEX PRINCIPALE
###############################################
echo "[6/7] Aggiorno index.html principale..."

cat > index.html << 'EOF'
---
layout: base
title: xZDOS Enterprise Platform
---

{% include oracle.html %}
{% include terminal.html %}
EOF

###############################################
# 7) COMMIT + PUSH + REBUILD
###############################################
echo "[7/7] Commit, push e rebuild..."

git add .
git commit -m "deploy: template modulari + struttura pages + base template" || true
git push || echo "Push instabile, riprova dopo"
git commit --allow-empty -m "force rebuild"
git push

echo "=== COMPLETATO: xZ-TEMPLATES-MASTER ==="
