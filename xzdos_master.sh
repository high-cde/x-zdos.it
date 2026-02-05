#!/usr/bin/env bash
set -e

echo "=== xZDOS MASTER DEPLOYER ==="

# 1) FIX GIT CONFIG
echo "[1/8] Riparazione configurazioni Git..."
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

# 2) DNS FIX
echo "[2/8] Fix DNS..."
echo "nameserver 1.1.1.1" > $PREFIX/etc/resolv.conf
echo "nameserver 8.8.8.8" >> $PREFIX/etc/resolv.conf
echo "nameserver 9.9.9.9" >> $PREFIX/etc/resolv.conf

# 3) PULL & REBASE
echo "[3/8] Pull con rebase..."
git fetch --all
git pull --rebase || echo "Pull instabile, continuo..."

# 4) AGGIORNA LAYOUT DEFINITIVO
echo "[4/8] Aggiornamento layout definitivo..."
cp -f index.html index.html.bak_$(date +%s)
cp -f assets/css/style.css assets/css/style.css.bak_$(date +%s)
cp -f assets/js/main.js assets/js/main.js.bak_$(date +%s)

# 5) AUTO‑UPDATER PREMIUM
echo "[5/8] Aggiornamento auto-updater premium..."
cp -f auto_updater_premium.sh auto_updater_premium.sh.bak_$(date +%s)

# 6) COMMIT
echo "[6/8] Commit aggiornamenti..."
git add .
git commit -m "deploy: full layout update + oracle + fixes + master deployer"

# 7) PUSH
echo "[7/8] Push verso GitHub..."
git push

# 8) REBUILD
echo "[8/8] Forzo rebuild GitHub Pages..."
git commit --allow-empty -m "force rebuild"
git push

echo "=== COMPLETATO: xZDOS MASTER DEPLOYER ==="
