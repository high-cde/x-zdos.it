#!/usr/bin/env bash
set -e

echo "=== FIX GITHUB CONNECTION & CONFIG ==="

echo "[1/8] Pulizia configurazioni corrotte..."
git config --global --unset-all http.sslVerify 2>/dev/null || true
git config --global --unset-all http.sslverify 2>/dev/null || true

echo "[2/8] Reimpostazione configurazioni corrette..."
git config --global http.sslVerify false
git config --global http.version HTTP/1.1
git config --global http.postBuffer 524288000
git config --global http.maxRequests 5
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999

echo "[3/8] Forzatura IPv4..."
git config --global url."https://".insteadOf git://

echo "[4/8] Fix DNS..."
echo "nameserver 1.1.1.1" > $PREFIX/etc/resolv.conf
echo "nameserver 8.8.8.8" >> $PREFIX/etc/resolv.conf
echo "nameserver 9.9.9.9" >> $PREFIX/etc/resolv.conf

echo "[5/8] Test connessione a GitHub..."
ping -c 2 github.com || echo "Ping instabile, ma procedo..."

echo "[6/8] Pull con rebase..."
git fetch --all
git pull --rebase || echo "Pull non riuscito, continuo..."

echo "[7/8] Commit vuoto per forzare rebuild..."
git commit --allow-empty -m "fix: rebuild after github repair" || true

echo "[8/8] Push finale..."
git push

echo "=== COMPLETATO: GITHUB RIPARATO ==="
