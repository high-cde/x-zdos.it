# x-zdos.it — Portale ZDOS

Portale statico in italiano per orientarsi tra i repository ZDOS, la directory eNET e il backend AI K.I.R.A. Le pagine distinguono i servizi collegati dai progetti sperimentali. Non includono login, database, wallet o runtime ZLang.

## Pagine e file

- `index.html`: portale e stato del gateway.
- `enet.html`: directory dei servizi, con collegamenti e livelli di maturità.
- `ecosystem.html`, `ECOSYSTEM_SCOPE.md` e `ecosystem.json`: definizione leggibile e machine-readable dei confini del sistema.
- `privacy.html`: nota tecnica sui dati e sull’invio dei prompt; non è un’informativa legale completa.
- `site.css`, `site.js`, `kira-widget.js`: asset locali; nessun framework o font CDN richiesto.

## Avvio locale

```sh
python3 -m http.server 8080
```

Aprire `http://127.0.0.1:8080`. Senza API configurata, la UI mostra che il gateway non è collegato e disabilita l’invio; non produce risposte simulate.

## Collegamento K.I.R.A.

In entrambe le pagine impostare `<meta name="zdos-kira-api-base">` a un’origine HTTPS reale, ad esempio `https://api.example.it`. `same-origin` è ammesso quando reverse proxy e pagine condividono lo stesso host. Il valore vuoto lascia l’API disabilitata. Non configurare endpoint HTTP remoto: il browser bloccherebbe la chiamata da HTTPS.

Il server deve consentire l’origine esatta del portale via CORS e fornire `GET /health` e `POST /api/v1/zllm/generate`. Impostare `ZLLM_API_KEY` solo nel secret manager o nell’ambiente del backend, mai in questi file statici. `inferenceConfigured: true` prova la presenza della configurazione lato server, non sostituisce una richiesta d’inferenza di prova.

Prima dell’esposizione pubblica completare la protezione del gateway, le quote, la configurazione TLS e l’informativa legale con i dati effettivi del gestore e del provider. Le pagine restano `noindex` durante la preview.
