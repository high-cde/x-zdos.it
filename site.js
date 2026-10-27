(() => {
  const meta = document.querySelector('meta[name="zdos-kira-api-base"]');
  const rawBase = (meta?.content || window.ZDOS_KIRA_API_BASE || "").trim();
  const statusNodes = [...document.querySelectorAll("[data-kira-status]")];
  const detailNodes = [...document.querySelectorAll("[data-kira-detail]")];
  const refreshButton = document.querySelector("[data-kira-refresh]");
  document.querySelectorAll("[data-year]").forEach((node) => {
    node.textContent = new Date().getFullYear();
  });

  function setState(state, label, detail) {
    for (const node of statusNodes) {
      node.dataset.state = state;
      node.textContent = label;
    }
    for (const node of detailNodes) node.textContent = detail;
  }

  function apiOrigin() {
    if (!rawBase) return { error: "API non configurata" };
    const value = rawBase === "same-origin" ? window.location.origin : rawBase;
    try {
      const url = new URL(value);
      const localHttp =
        url.protocol === "http:" &&
        ["localhost", "127.0.0.1", "[::1]"].includes(url.hostname);
      if (
        url.protocol !== "https:" &&
        !(
          localHttp &&
          ["localhost", "127.0.0.1", "[::1]"].includes(window.location.hostname)
        )
      ) {
        return {
          error:
            "Serve un endpoint HTTPS; HTTP è ammesso solo in sviluppo locale.",
        };
      }
      return { value: url.origin };
    } catch (_error) {
      return { error: "Origine API non valida." };
    }
  }

  async function checkGateway() {
    const api = apiOrigin();
    if (api.error) {
      setState(
        "limited",
        api.error,
        "Il portale è disponibile, ma l’assistente richiede un backend HTTPS configurato.",
      );
      return;
    }

    if (refreshButton) refreshButton.disabled = true;
    setState(
      "checking",
      "Verifica in corso…",
      "Controllo health e configurazione del gateway.",
    );
    const controller = new AbortController();
    const timeoutId = window.setTimeout(() => controller.abort(), 7000);
    try {
      const response = await fetch(new URL("/health", api.value), {
        headers: { Accept: "application/json" },
        credentials: "omit",
        signal: controller.signal,
      });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const data = await response.json();
      if (data.inferenceConfigured === true || data.llm?.configured === true) {
        setState(
          "ready",
          "Gateway online · AI configurata",
          "Il backend risponde e segnala una configurazione AI presente. Esegui comunque una richiesta di prova per confermare l’inferenza.",
        );
      } else {
        setState(
          "limited",
          "Gateway online · AI da configurare",
          "Il server risponde, ma non conferma una chiave/provider AI configurati.",
        );
      }
    } catch (error) {
      const detail =
        error.name === "AbortError"
          ? "Verifica scaduta: controlla rete, HTTPS e gateway."
          : "Gateway non raggiungibile da questa origine. Controlla HTTPS, CORS e reverse proxy.";
      setState("offline", "Gateway non raggiungibile", detail);
    } finally {
      window.clearTimeout(timeoutId);
      if (refreshButton) refreshButton.disabled = false;
    }
  }

  refreshButton?.addEventListener("click", checkGateway);
  checkGateway();
})();
