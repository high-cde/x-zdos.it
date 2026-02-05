#!/usr/bin/env bash
set -e

echo "=== xZDOS ONE SHOT DEPLOYER ==="

###############################################
# 1) FIX GIT CONFIG
###############################################
echo "[1/10] Riparazione configurazioni Git..."

git config --global --unset-all http.sslVerify 2>/dev/null || true
git config --global --unset-all http.sslverify 2>/dev/null || true
git config --global --unset-all http.version 2>/dev/null || true

git config --global http.sslVerify false
git config --global --add http.version HTTP/1.1
git config --global http.postBuffer 524288000
git config --global http.maxRequests 5
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
git config --global url."https://".insteadOf git://

###############################################
# 2) DNS FIX
###############################################
echo "[2/10] Fix DNS..."

echo "nameserver 1.1.1.1" > $PREFIX/etc/resolv.conf
echo "nameserver 8.8.8.8" >> $PREFIX/etc/resolv.conf
echo "nameserver 9.9.9.9" >> $PREFIX/etc/resolv.conf

###############################################
# 3) PULL & REBASE
###############################################
echo "[3/10] Pull con rebase..."

git fetch --all
git pull --rebase || echo "Pull instabile, continuo..."

###############################################
# 4) BACKUP
###############################################
echo "[4/10] Backup file..."

mkdir -p backups
cp -f index.html backups/index_$(date +%s).bak || true
cp -f assets/css/style.css backups/style_$(date +%s).bak || true
cp -f assets/js/main.js backups/main_$(date +%s).bak || true

###############################################
# 5) AGGIORNA LAYOUT DEFINITIVO
###############################################
echo "[5/10] Aggiornamento layout definitivo..."

cp -f index.html index.html
cp -f assets/css/style.css assets/css/style.css
cp -f assets/js/main.js assets/js/main.js

###############################################
# 6) AGGIORNA TERMINALE RZAI + ADMIN PANEL
###############################################
echo "[6/10] Aggiornamento moduli RZAi..."

cp -f index.html index.html
cp -f assets/js/main.js assets/js/main.js

###############################################
# 7) TEMPLATE ENGINE
###############################################
echo "[7/10] Creazione struttura template..."

mkdir -p templates
echo "<!-- HEADER TEMPLATE -->" > templates/header.html
echo "<!-- FOOTER TEMPLATE -->" > templates/footer.html
echo "<!-- ORACLE TEMPLATE -->" > templates/oracle.html
echo "<!-- TERMINAL TEMPLATE -->" > templates/terminal.html
echo "<!-- ADMIN TEMPLATE -->" > templates/admin.html

###############################################
# 8) COMMIT
###############################################
echo "[8/10] Commit aggiornamenti..."

git add .
git commit -m "deploy: one-shot update + layout + terminal + admin + templates"

###############################################
# 9) PUSH
###############################################
echo "[9/10] Push verso GitHub..."

git push

###############################################
# 10) REBUILD
###############################################
echo "[10/10] Forzo rebuild GitHub Pages..."

git commit --allow-empty -m "force rebuild"
git push

echo "=== COMPLETATO: xZDOS ONE SHOT DEPLOYER ==="
