# K.I.R.A nel template x-zdos.it

Il widget riutilizzabile è composto da `kira-widget.js` e `kira-widget.css` ed è incluso in `index.html` e `enet.html`. Il browser invia i prompt a `POST /api/v1/zllm/generate` e legge `GET /health`; il widget mostra distintamente gateway offline e provider AI non configurato. La chat resta in memoria della pagina e non salva la conversazione.

## Configurazione dell'origine API

Il backend deve essere esposto da un'origine HTTPS raggiungibile dal browser, preferibilmente tramite un reverse proxy TLS sul dominio del sito. Impostare il meta tag in entrambe le pagine, per esempio:

```html
<meta name="zdos-kira-api-base" content="https://api.example.it">
```

Sostituire `https://api.example.it` con l'origine HTTPS effettivamente configurata; non inserire percorsi `/health` o `/api` nel valore. Lasciarlo vuoto usa l'origine corrente della pagina, utile quando il backend è servito sullo stesso host. Un endpoint HTTP remoto non è accettato dai browser su pagine HTTPS per il blocco mixed-content.

Il server deve consentire via CORS l'origine esatta del sito e fornire `GET /health` e `POST /api/v1/zllm/generate`. Il campo `inferenceConfigured` nella health response deve essere `true` solo quando il provider è configurato lato server.

## Importante

Questa integrazione non contiene né incorpora chiavi AI nel client. Il provider è invocato dal backend; finché l'origine HTTPS o la configurazione del provider manca, il widget segnala il problema e non inventa risposte. Proteggere il gateway con limiti e controlli adeguati prima dell'esposizione pubblica.
