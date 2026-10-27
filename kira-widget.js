(() => {
  const apiBase = (
    document.querySelector('meta[name="zdos-kira-api-base"]')?.content ||
    window.ZDOS_KIRA_API_BASE ||
    ''
  ).trim().replace(/\/+$/, '');
  const endpoint = (path) => `${apiBase}${path}`;
  const icon = '<span aria-hidden="true">K</span>';

  const launcher = document.createElement('button');
  launcher.className = 'kira-launcher';
  launcher.type = 'button';
  launcher.setAttribute('aria-label', 'Apri assistente K.I.R.A.');
  launcher.setAttribute('aria-expanded', 'false');
  launcher.innerHTML = `${icon}<span>K.I.R.A.</span>`;

  const panel = document.createElement('section');
  panel.className = 'kira-panel';
  panel.hidden = true;
  panel.setAttribute('aria-label', 'Assistente K.I.R.A.');
  panel.innerHTML = `
    <header class="kira-header">
      <div><strong>K.I.R.A.</strong><small>ZDOS Intelligence Gateway</small></div>
      <button class="kira-close" type="button" aria-label="Chiudi assistente">×</button>
    </header>
    <div class="kira-status" role="status" aria-live="polite">Verifico il gateway…</div>
    <div class="kira-messages" aria-live="polite" aria-label="Conversazione">
      <p class="kira-note">Invia una richiesta: la risposta arriva dal provider AI configurato sul server. Questa conversazione non viene salvata in questa pagina.</p>
    </div>
    <form class="kira-form">
      <label class="kira-sr-only" for="kira-prompt">Messaggio per K.I.R.A.</label>
      <textarea id="kira-prompt" name="prompt" rows="2" maxlength="8000" required placeholder="Chiedi qualcosa a K.I.R.A.…"></textarea>
      <button class="kira-send" type="submit">Invia</button>
    </form>
    <footer class="kira-footer">Non inserire password, chiavi o dati sensibili.</footer>
  `;

  document.body.append(launcher, panel);

  const status = panel.querySelector('.kira-status');
  const messages = panel.querySelector('.kira-messages');
  const form = panel.querySelector('.kira-form');
  const promptField = panel.querySelector('#kira-prompt');
  const sendButton = panel.querySelector('.kira-send');

  function setOpen(open) {
    panel.hidden = !open;
    launcher.setAttribute('aria-expanded', String(open));
    if (open) promptField.focus();
    else launcher.focus();
  }

  launcher.addEventListener('click', () => setOpen(panel.hidden));
  panel.querySelector('.kira-close').addEventListener('click', () => setOpen(false));
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !panel.hidden) setOpen(false);
  });

  function addMessage(text, kind) {
    const item = document.createElement('p');
    item.className = `kira-message kira-message-${kind}`;
    item.textContent = text;
    messages.append(item);
    messages.scrollTop = messages.scrollHeight;
    return item;
  }

  async function checkGateway() {
    try {
      const response = await fetch(endpoint('/health'), { headers: { Accept: 'application/json' }, credentials: 'omit' });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const data = await response.json();
      if (data.inferenceConfigured === true || data.llm?.configured === true) {
        status.textContent = 'Gateway online · inferenza AI configurata';
        status.dataset.state = 'ready';
      } else {
        status.textContent = 'Gateway online · provider AI non configurato';
        status.dataset.state = 'limited';
      }
    } catch (_error) {
      status.textContent = 'Gateway non raggiungibile via HTTPS';
      status.dataset.state = 'offline';
    }
  }

  form.addEventListener('submit', async (event) => {
    event.preventDefault();
    const prompt = promptField.value.trim();
    if (!prompt || sendButton.disabled) return;

    addMessage(prompt, 'user');
    promptField.value = '';
    sendButton.disabled = true;
    status.textContent = 'K.I.R.A. sta elaborando…';
    status.dataset.state = 'busy';
    const pending = addMessage('In attesa della risposta del provider AI…', 'assistant');
    const controller = new AbortController();
    const timeout = window.setTimeout(() => controller.abort(), 45000);

    try {
      const response = await fetch(endpoint('/api/v1/zllm/generate'), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        credentials: 'omit',
        signal: controller.signal,
        body: JSON.stringify({ prompt, tier: 'primary' })
      });
      const data = await response.json().catch(() => ({}));
      if (!response.ok) {
        const message = data.message || data.error || `Il gateway ha risposto con HTTP ${response.status}.`;
        throw new Error(message);
      }
      const answer = data.result?.response || data.result?.output;
      if (typeof answer !== 'string' || !answer.trim()) {
        throw new Error('Il gateway non ha restituito una risposta AI valida.');
      }
      pending.textContent = answer;
      status.textContent = 'Risposta ricevuta dal gateway';
      status.dataset.state = 'ready';
    } catch (error) {
      pending.remove();
      const message = error.name === 'AbortError'
        ? 'Richiesta scaduta. Riprova tra poco.'
        : error.message === 'Failed to fetch'
          ? 'Connessione non disponibile. Serve un endpoint API HTTPS configurato.'
          : error.message;
      addMessage(`Richiesta non completata: ${message}`, 'error');
      status.textContent = 'Richiesta non completata';
      status.dataset.state = 'offline';
    } finally {
      window.clearTimeout(timeout);
      sendButton.disabled = false;
      promptField.focus();
    }
  });

  checkGateway();
})();
