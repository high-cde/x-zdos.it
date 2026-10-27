# Perimetro x-zdos.it / eNET / K.I.R.A.

## Definizione

`x-zdos.it` è il portale pubblico di orientamento dell’ecosistema ZDOS. `eNET` è la sua directory curata: collega ai servizi e ai repository, ma non è un protocollo di rete o un bus che li rende automaticamente interoperabili. `K.I.R.A.` è un’interfaccia chat per un gateway AI separato nel repository `Zdos-K.I.R.A`. Il backend inoltra le richieste a un provider OpenAI-compatible configurato esclusivamente lato server.

ZDOS OS, ZLang, ZComm, ZDOS Web App e ZDOS Organism sono progetti separati. Il portale non li esegue né attesta di averli integrati. La pagina pubblica usa i repository come fonte del codice e assegna uno stato descrittivo; l’uptime viene mostrato solo quando un endpoint live risponde.

## Confini funzionali

- **Portale:** pagine statiche responsive, catalogo, riferimenti ai repository e stato del gateway K.I.R.A. Non include login, account, database o sessioni utente.
- **eNET:** directory e navigazione tra moduli. Non effettua chiamate, transazioni, scansioni o comunicazioni P2P.
- **K.I.R.A.:** la chat del portale resta disabilitata finché non è configurata un’origine HTTPS verificata. Quando attivata, `GET /health` segnala lo stato del server e `POST /api/v1/zllm/generate` inoltra un prompt al provider. Non esegue comandi sul dispositivo del visitatore.
- **DSN / wallet:** esclusi da questo perimetro; nessun token viene emesso, trasferito o custodito dal sito.

## Contratto di configurazione K.I.R.A.

Le pagine leggono l’origine API da `<meta name="zdos-kira-api-base">`. Un valore HTTPS come `https://api.x-zdos.it` indica l’origine del gateway; `same-origin` è disponibile quando reverse proxy e sito condividono l’host. Il campo vuoto disabilita la chat e non invia richieste a una rotta casuale.

Il server deve consentire l’origine esatta del portale via CORS. Il provider si configura con `ZLLM_API_KEY` sul server; la chiave non va distribuita nei file statici. Il campo `inferenceConfigured` indica presenza di configurazione e non sostituisce un test d’inferenza.

## Pubblicazione e maturità

La homepage, eNET e la definizione dell’ecosistema sono pagine pubbliche indicizzabili. Il 404 e la nota tecnica dati/AI restano esclusi dall’indice; la nota chiarisce esplicitamente che non sostituisce l’informativa legale del gestore. Il deploy VPS usa Nginx, conserva il vhost VelvetHub esistente e aggiunge il portale per il nome host esatto `x-zdos.it`.

K.I.R.A. non è attivata nel portale. Prima di collegarla devono essere verificati DNS e TLS per `api.x-zdos.it`, reverse proxy verso il backend esistente, CORS, autenticazione o limiti di frequenza, provider, logging e retention; il gestore deve completare le informazioni legali e poi superare un test end-to-end.

Una scheda eNET deve chiamarsi “operativa” solo se il relativo endpoint è verificato. In assenza di prova si usa “repository separato”, “in sviluppo” o “sperimentale”.
