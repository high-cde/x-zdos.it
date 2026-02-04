const output = document.getElementById("output");
const input = document.getElementById("input");

function type(text) {
  let i = 0;
  const speed = 15;
  function typing() {
    if (i < text.length) {
      output.innerHTML += text.charAt(i);
      i++;
      output.scrollTop = output.scrollHeight;
      setTimeout(typing, speed);
    }
  }
  typing();
}

const aiResponses = {
  help: `
Comandi disponibili:
help        - Mostra questo menu
ciao        - Saluta RZAi‑pulciz
info        - Informazioni sull'agente
moduli      - Elenco moduli xCLOUD
nexus       - Info modulo Nexus
terminal    - Info modulo Terminal
portal      - Info modulo Portal Fusion
dsn         - Info DSN Layer
clear       - Pulisce il terminale
easter      - ???`,

  ciao: "Ciao High! Sono RZAi‑pulciz, la tua guida neon‑cartoon.",
  info: "Sono l’agente ufficiale dell’ecosistema xCLOUD. Sempre operativo.",
  moduli: "Moduli disponibili: Nexus, Terminal, Portal Fusion, DSN Layer.",
  nexus: "Nexus: modulo di orchestrazione e routing interno di xCLOUD.",
  terminal: "Terminal: interfaccia avanzata per comandi e automazioni.",
  portal: "Portal Fusion: layer di interazione tra utenti e servizi.",
  dsn: "DSN Layer: livello decentralizzato per configurazioni e chain.",
  easter: "🟣 *Easter‑egg attivato:* 'Pulciz‑Mode' online. 🐣✨",
};

function neonPulse() {
  output.style.boxShadow = "0 0 18px rgba(0,200,255,0.6)";
  setTimeout(() => {
    output.style.boxShadow = "0 0 12px rgba(0,200,255,0.3)";
  }, 300);
}

input.addEventListener("keydown", function (e) {
  if (e.key === "Enter") {
    const cmd = input.value.trim().toLowerCase();
    input.value = "";

    output.innerHTML += `\n> ${cmd}\n`;
    neonPulse();

    if (cmd === "clear") {
      output.innerHTML = "RZAi‑pulciz è online. Digita \"help\" per iniziare.\n";
      return;
    }

    if (aiResponses[cmd]) {
      type(aiResponses[cmd] + "\n");
    } else {
      type("Comando non riconosciuto. Digita 'help' per la lista.\n");
    }
  }
});
