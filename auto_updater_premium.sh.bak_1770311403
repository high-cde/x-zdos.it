#!/usr/bin/env bash
set -e

echo "=== CloudX × ZDOS PREMIUM AUTO-UPDATER ==="

# 1) BACKUP
echo "[1/6] Backup file..."
mkdir -p backups
cp index.html backups/index_premium_$(date +%s).bak || true
cp assets/css/style.css backups/style_premium_$(date +%s).bak || true
cp assets/js/main.js backups/main_premium_$(date +%s).bak || true

# 2) HTML: NAV + HERO + ORACLE CONTAINER (mantiene il <head> esistente)
echo "[2/6] Aggiornamento layout HTML pulito..."

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>xZDOS Enterprise Platform</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>

<body>

  <!-- NAVBAR -->
  <header class="navbar">
    <nav class="nav-inner">
      <a href="/">Home</a>
      <a href="/zdos/">ZDOS</a>
      <a href="/xCLOUD/">xCLOUD</a>
      <a href="/agents/rzai-pulciz/">RZAi‑pulciz</a>
      <a href="/clienti.html" class="new-badge">Soluzioni Aziendali</a>
      <a href="https://wallet.x-zdos.it/">Wallet</a>
    </nav>
  </header>

  <!-- HERO -->
  <section class="hero-main">
    <h1 class="hero-title">xZDOS Enterprise Platform</h1>
    <p class="hero-sub">Ecosistema modulare per aziende, automazioni, AI e integrazioni.</p>
  </section>

  <!-- ORACLE PANEL -->
  <section id="oracle-root"></section>

  <!-- FOOTER -->
  <footer class="site-footer">
    © CloudX × ZDOS — All Rights Reserved
  </footer>

  <script src="assets/js/main.js"></script>
</body>
</html>
EOF

echo "✔ index.html aggiornato"

# 3) CSS: NAV + HERO + ORACLE PANEL + BASE NEON
echo "[3/6] Aggiornamento CSS premium..."

cat > assets/css/style.css << 'EOF'
/* BASE */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
  color: #e5e7eb;
  background: radial-gradient(circle at top, #020617 0%, #000 100%);
}

/* NAVBAR */
.navbar {
  position: sticky;
  top: 0;
  z-index: 50;
  background: rgba(15, 23, 42, 0.9);
  border-bottom: 1px solid rgba(34, 211, 238, 0.3);
  backdrop-filter: blur(10px);
}

.nav-inner {
  max-width: 1000px;
  margin: 0 auto;
  padding: 12px 20px;
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: flex-start;
}

.nav-inner a {
  font-size: 14px;
  text-decoration: none;
  color: #cbd5f5;
  padding: 6px 10px;
  border-radius: 999px;
  transition: 0.2s ease;
}

.nav-inner a:hover {
  color: #0f172a;
  background: #22d3ee;
  box-shadow: 0 0 14px rgba(34, 211, 238, 0.8);
}

/* BADGE NEW */
.new-badge::after {
  content: "NEW";
  font-size: 9px;
  margin-left: 6px;
  padding: 2px 6px;
  border-radius: 999px;
  background: #22d3ee;
  color: #000;
  font-weight: 600;
  box-shadow: 0 0 8px rgba(34, 211, 238, 0.7);
}

/* HERO */
.hero-main {
  max-width: 900px;
  margin: 60px auto 30px;
  padding: 20px;
  text-align: left;
}

.hero-title {
  font-size: 34px;
  color: #e5e7eb;
  margin-bottom: 10px;
}

.hero-sub {
  font-size: 16px;
  opacity: 0.8;
}

/* ORACLE PANEL */
.oracle-panel {
  max-width: 900px;
  margin: 20px auto 40px;
  padding: 30px;
  border-radius: 20px;
  background: rgba(2, 6, 23, 0.7);
  border: 1px solid rgba(34, 211, 238, 0.3);
  backdrop-filter: blur(12px);
  box-shadow: 0 0 40px rgba(34, 211, 238, 0.15);
}

.oracle-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 25px;
}

.oracle-avatar {
  width: 60px;
  height: 60px;
  border-radius: 999px;
  background: radial-gradient(circle at 30% 20%, #22d3ee, #0f172a);
  box-shadow: 0 0 20px rgba(34, 211, 238, 0.8);
  animation: oracle-pulse 3s infinite ease-in-out;
}

@keyframes oracle-pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.08); }
  100% { transform: scale(1); }
}

.oracle-title {
  font-size: 26px;
  color: #22d3ee;
  margin: 0;
}

.oracle-sub {
  margin: 0;
  opacity: 0.7;
  font-size: 14px;
}

.oracle-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.oracle-card {
  padding: 20px;
  border-radius: 14px;
  background: rgba(15, 23, 42, 0.8);
  border: 1px solid rgba(34, 211, 238, 0.25);
  box-shadow: 0 0 20px rgba(34, 211, 238, 0.1);
}

.oracle-card h3 {
  margin: 0 0 10px;
  color: #22d3ee;
}

.oracle-card .value {
  font-size: 18px;
  color: #e2e8f0;
}

.oracle-wide {
  grid-column: span 2;
}

/* FOOTER */
.site-footer {
  max-width: 900px;
  margin: 0 auto 30px;
  padding: 10px 20px;
  font-size: 12px;
  opacity: 0.6;
}
EOF

echo "✔ style.css aggiornato"

# 4) JS: monta pannello ORACLE e logica
echo "[4/6] Aggiornamento main.js con RZAi-Oracle..."

cat > assets/js/main.js << 'EOF'
document.addEventListener("DOMContentLoaded", async () => {
  const root = document.getElementById("oracle-root");
  if (!root) return;

  root.innerHTML = `
    <section class="oracle-panel">
      <div class="oracle-header">
        <div class="oracle-avatar"></div>
        <div>
          <h2 class="oracle-title">RZAi‑Oracle</h2>
          <p class="oracle-sub">Analisi AI + Blockchain Polygon</p>
        </div>
      </div>

      <div class="oracle-grid">
        <div class="oracle-card" id="matic-price">
          <h3>Prezzo MATIC</h3>
          <p class="value">Caricamento...</p>
        </div>

        <div class="oracle-card" id="gas-price">
          <h3>Gas Price</h3>
          <p class="value">Caricamento...</p>
        </div>

        <div class="oracle-card" id="network-status">
          <h3>Stato Rete</h3>
          <p class="value">Caricamento...</p>
        </div>

        <div class="oracle-card oracle-wide" id="oracle-ai">
          <h3>Messaggio dell’Oracolo</h3>
          <p class="value">In attesa dei dati...</p>
        </div>
      </div>
    </section>
  `;

  const priceBox = document.querySelector("#matic-price .value");
  const gasBox = document.querySelector("#gas-price .value");
  const statusBox = document.querySelector("#network-status .value");
  const oracleBox = document.querySelector("#oracle-ai .value");

  async function fetchMatic() {
    const res = await fetch("https://api.coingecko.com/api/v3/simple/price?ids=matic-network&vs_currencies=eur");
    const data = await res.json();
    return data["matic-network"].eur;
  }

  async function fetchGas() {
    const res = await fetch("https://gasstation.polygon.technology/v2");
    const data = await res.json();
    return data.fast.maxFee;
  }

  async function fetchOracleMessage(context) {
    try {
      const res = await fetch("https://api-inference.huggingface.co/models/bigscience/bloom-560m", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          inputs: `Analizza questi dati blockchain e genera un messaggio breve in stile oracolo cyberpunk, in italiano:\n${context}`
        })
      });

      const data = await res.json();
      const text = Array.isArray(data) && data[0]?.generated_text
        ? data[0].generated_text
        : "Oracolo non disponibile al momento.";
      return text;
    } catch (e) {
      return "Oracolo non raggiungibile. RZAi in modalità offline.";
    }
  }

  try {
    const [matic, gas] = await Promise.all([fetchMatic(), fetchGas()]);

    priceBox.textContent = `${matic} €`;
    gasBox.textContent = `${gas.toFixed(2)} gwei`;
    statusBox.textContent = gas < 50 ? "Rete fluida" : "Rete congestionata";

    const oracleText = await fetchOracleMessage(`Prezzo MATIC: ${matic} EUR, Gas: ${gas} gwei`);
    oracleBox.textContent = oracleText;
  } catch (e) {
    priceBox.textContent = "Errore";
    gasBox.textContent = "Errore";
    statusBox.textContent = "Errore";
    oracleBox.textContent = "Impossibile recuperare i dati. Riprova più tardi.";
  }
});
EOF

echo "✔ main.js aggiornato"

# 5) MINI CHECK
echo "[5/6] Mini check file..."
ls index.html assets/css/style.css assets/js/main.js

# 6) GIT COMMIT + PUSH
echo "[6/6] Git add + commit + push..."
git add index.html assets/css/style.css assets/js/main.js auto_updater_premium.sh
git commit -m "feat: premium layout + RZAi-Oracle panel + neon theme"
git push

echo "=== COMPLETATO: PREMIUM THEME + ORACLE PANEL ATTIVI ==="
EOF

---

### 2️⃣ Rendi eseguibile ed esegui

```bash
chmod +x auto_updater_premium.sh
./auto_updater_premium.sh
