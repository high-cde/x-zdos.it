#!/usr/bin/env bash
# Deploy x-zdos.it from the public feature branch to the existing Nginx VPS.
# Keeps the current VelvetHub document root and routing rules intact.
set -Eeuo pipefail

DOMAIN="x-zdos.it"
WWW_DOMAIN="www.x-zdos.it"
VELVET_DOMAIN="velvet.x-zdos.it"
REPO="https://github.com/high-cde/x-zdos.it.git"
BRANCH="feat/kira-widget"
SITE="/var/www/x-zdos-portal"
CONF="/etc/nginx/sites-available/x-zdos-portal"
ENABLED="/etc/nginx/sites-enabled/x-zdos-portal"
VELVET_ENABLED="/etc/nginx/sites-enabled/ourvelvet"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)-$$"
RELEASE="$SITE/releases/$STAMP"
BACKUP="/root/xzdos-portal-backup-$STAMP"
TMP="$(mktemp -d /tmp/xzdos-portal.XXXXXX)"
CURRENT_OLD=""
VELVET_CONF=""
CONFIG_INSTALLED=0
VELVET_MODIFIED=0
DEPLOY_COMMITTED=0

cleanup() { rm -rf "$TMP"; }
rollback() {
  if [[ "$DEPLOY_COMMITTED" -eq 0 && "$CONFIG_INSTALLED" -eq 1 ]]; then
    echo "Ripristino delle configurazioni Nginx modificate da questo script..." >&2
    rm -f "$ENABLED" "$CONF"
    if [[ "$CURRENT_OLD" == /* ]]; then
      ln -sfn "$CURRENT_OLD" "$SITE/current"
    else
      rm -f "$SITE/current"
    fi
    if [[ "$VELVET_MODIFIED" -eq 1 && -n "$VELVET_CONF" && -s "$BACKUP/ourvelvet.conf" ]]; then
      cp -a "$BACKUP/ourvelvet.conf" "$VELVET_CONF"
    fi
    nginx -t && systemctl reload nginx || true
  fi
}
trap cleanup EXIT
trap rollback ERR

if [[ "$EUID" -ne 0 ]]; then
  echo "Esegui questo script da una shell root oppure con sudo bash." >&2
  exit 1
fi
for cmd in git tar nginx systemctl getent curl python3; do
  command -v "$cmd" >/dev/null || { echo "Comando richiesto non trovato: $cmd" >&2; exit 1; }
done
systemctl is-active --quiet nginx || { echo "Nginx non è attivo; non modifico il server." >&2; exit 1; }
nginx -t

if [[ -e "$CONF" || -L "$ENABLED" ]]; then
  echo "Esiste già una configurazione x-zdos-portal; mi fermo senza sovrascriverla: $CONF" >&2
  exit 1
fi
if nginx -T 2>/dev/null | grep -Eq '^[[:space:]]*server_name[^;]*x-zdos\.it'; then
  echo "Nginx ha già un server_name x-zdos.it; mi fermo per non sostituire una configurazione esistente." >&2
  exit 1
fi
if [[ -e "$SITE/current" && ! -L "$SITE/current" ]]; then
  echo "$SITE/current esiste ma non è un link simbolico; mi fermo senza modificarlo." >&2
  exit 1
fi
[[ -e "$VELVET_ENABLED" || -L "$VELVET_ENABLED" ]] || {
  echo "Non trovo il vhost attivo /etc/nginx/sites-enabled/ourvelvet; mi fermo." >&2
  exit 1
}
VELVET_CONF="$(readlink -f "$VELVET_ENABLED")"
[[ -f "$VELVET_CONF" ]] || { echo "Il vhost VelvetHub non punta a un file leggibile." >&2; exit 1; }
python3 - "$VELVET_CONF" <<'PY'
from pathlib import Path
import sys
text = Path(sys.argv[1]).read_text()
if text.count("server_name _;") != 1:
    raise SystemExit("Nel vhost VelvetHub non trovo una singola riga server_name _; attesa; nessuna modifica applicata.")
if "velvet.x-zdos.it" in text:
    raise SystemExit("Il vhost ha già un riferimento a velvet.x-zdos.it; nessuna modifica applicata.")
PY

VPS_IP="$(curl -4fsS --max-time 8 https://api.ipify.org | tr -d '[:space:]')"
for host in "$DOMAIN" "$WWW_DOMAIN"; do
  DNS_IPS="$(getent ahostsv4 "$host" 2>/dev/null | awk '{print $1}' | sort -u || true)"
  if ! grep -Fxq "$VPS_IP" <<<"$DNS_IPS"; then
    echo "Il DNS A di $host non punta a questo server ($VPS_IP); non applico il deploy." >&2
    echo "Record A rilevati: ${DNS_IPS:-nessuno}" >&2
    exit 1
  fi
done

echo "x-zdos.it e www.x-zdos.it serviranno il nuovo portale."
echo "VelvetHub manterrà il suo document root e le regole esistenti; aggiungo solo il nome velvet.x-zdos.it al vhost attuale."
echo "Il record DNS per velvet.x-zdos.it non esiste ancora: andrà creato come A -> $VPS_IP dopo il deploy."
if [[ ! -r /dev/tty ]]; then
  echo "Serve una sessione SSH interattiva per confermare il rilascio." >&2
  exit 1
fi
read -r -p "Digita DEPLOY per continuare: " ANSWER </dev/tty
[[ "$ANSWER" == "DEPLOY" ]] || { echo "Operazione annullata."; exit 0; }
read -r -p "Email per gli avvisi di rinnovo HTTPS (Certbot la registrerà sulla VPS): " CERT_EMAIL </dev/tty
[[ "$CERT_EMAIL" =~ ^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$ ]] || {
  echo "Inserisci un indirizzo email valido; nessuna modifica applicata." >&2
  exit 1
}

if ! command -v certbot >/dev/null; then
  echo "Installo Certbot e il plugin Nginx (senza aggiornare i pacchetti esistenti)..."
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y certbot python3-certbot-nginx
fi

mkdir -p "$BACKUP" "$SITE/releases" "$RELEASE"
chmod 700 "$BACKUP"
cp -a "$VELVET_CONF" "$BACKUP/ourvelvet.conf"
for f in /etc/nginx/sites-enabled/ourvelvet /etc/nginx/sites-enabled/velvethub.art; do
  [[ ! -e "$f" && ! -L "$f" ]] || cp -a "$f" "$BACKUP/"
done
printf 'Release: %s\nBackup config: %s\n' "$RELEASE" "$BACKUP"

git clone --depth 1 --branch "$BRANCH" "$REPO" "$TMP/repo"
git -C "$TMP/repo" archive --format=tar HEAD \
  index.html enet.html ecosystem.html privacy.html 404.html \
  site.css site.js kira-widget.js ecosystem.json robots.txt sitemap.xml \
  | tar -xf - -C "$RELEASE"
for f in index.html enet.html ecosystem.html 404.html site.css site.js kira-widget.js robots.txt sitemap.xml; do
  [[ -s "$RELEASE/$f" ]] || { echo "File di rilascio mancante: $f" >&2; exit 1; }
done
if grep -q 'noindex,nofollow' "$RELEASE/index.html" "$RELEASE/enet.html" "$RELEASE/ecosystem.html"; then
  echo "Le pagine pubbliche risultano noindex: mi fermo per evitare un rilascio non indicizzabile." >&2
  exit 1
fi
chown -R root:www-data "$RELEASE"
find "$RELEASE" -type d -exec chmod 755 {} +
find "$RELEASE" -type f -exec chmod 644 {} +
CURRENT_OLD="$(readlink -f "$SITE/current" 2>/dev/null || true)"
ln -s "$RELEASE" "$SITE/current.$STAMP"
mv -Tf "$SITE/current.$STAMP" "$SITE/current"

CONFIG_INSTALLED=1
VELVET_MODIFIED=1
python3 - "$VELVET_CONF" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
old = "server_name _;"
if s.count(old) != 1:
    raise SystemExit("Il vhost VelvetHub è cambiato dopo il controllo iniziale; deploy annullato.")
p.write_text(s.replace(old, "server_name _ velvet.x-zdos.it;", 1))
PY
cat > "$CONF" <<'NGINX'
server {
    listen 80;
    server_name x-zdos.it www.x-zdos.it;
    root /var/www/x-zdos-portal/current;
    index index.html;
    server_tokens off;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        try_files $uri $uri/ =404;
    }

    error_page 404 /404.html;
    location = /404.html {
        internal;
    }
}
NGINX
ln -s "$CONF" "$ENABLED"
nginx -t
systemctl reload nginx
curl -fsS --max-time 8 -H "Host: $DOMAIN" http://127.0.0.1/ -o /dev/null
curl -fsS --max-time 8 -H "Host: $VELVET_DOMAIN" http://127.0.0.1/ -o /dev/null
DEPLOY_COMMITTED=1

echo "Portale servito da Nginx; rilascio: $RELEASE"
echo "Richiedo il certificato TLS per $DOMAIN e $WWW_DOMAIN..."
if certbot --nginx --non-interactive --agree-tos --redirect \
  --email "$CERT_EMAIL" -d "$DOMAIN" -d "$WWW_DOMAIN"; then
  echo "HTTPS attivo per https://$DOMAIN/ e https://$WWW_DOMAIN/."
else
  echo "Il portale è installato ma Certbot non ha completato HTTPS." >&2
  echo "Il sito resta servito via HTTP; controlla DNS, firewall 80/443 e riprova:" >&2
  echo "sudo certbot --nginx --redirect -d $DOMAIN -d $WWW_DOMAIN" >&2
  exit 2
fi

echo "VelvetHub non è stato spostato né sovrascritto; aggiunto solo il nome host $VELVET_DOMAIN al vhost esistente."
echo "Crea il record DNS A velvet -> $VPS_IP. Dopo propagazione, richiedi HTTPS con: sudo certbot --nginx --redirect -d $VELVET_DOMAIN"
echo "K.I.R.A. resta disattivata nel portale finché api.x-zdos.it, TLS, CORS e provider non sono verificati."
