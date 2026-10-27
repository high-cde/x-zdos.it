# Perimetro x-zdos.it / eNET / K.I.R.A.

## Definizione

`x-zdos.it` è il portale pubblico di orientamento dell’ecosistema ZDOS. `eNET` è la sua directory curata: collega ai servizi e ai repository, ma non è un protocollo di rete o un bus che li rende automaticamente interoperabili. `K.I.R.A.` è un’interfaccia chat per un gateway AI separato nel repository `Zdos-K.I.R.A`. Il backend inoltra le richieste a un provider OpenAI-compatible configurato esclusivamente lato server.

ZDOS OS, ZLang, ZComm, ZDOS Web App e ZDOS Organism sono progetti separati. Il portale non li esegue né attesta di averli integrati. La pagina pubblica usa i repository come fonte del codice e assegna uno stato descrittivo; l’uptime viene mostrato solo quando un endpoint live risponde.

## Confini funzionali

- **Portale:** pagine statiche responsive, catalogo, riferimenti ai repository e stato del gateway K.I.R.A. Non include login, account, database o sessioni utente.
- **eNET:** directory e navigazione tra moduli. Non effettua chiamate, transazioni, scansioni o comunicazioni P2P.
- **K.I.R.A.:** chat stateless nella pagina; `GET /health` segnala lo stato del server e `POST /api/v1/zllm/generate` inoltra un prompt al provider. Non esegue comandi sul dispositivo del visitatore.
- **DSN / wallet:** esclusi da questo perimetro; nessun token viene emesso, trasferito o custodito dal sito.

## Contratto di configurazione K.I.R.A.

Le pagine leggono l’origine API da `<meta name="zdos-kira-api-base">`. Un valore HTTPS come `https://api.example.it` indica l’origine del gateway; `same-origin` è disponibile quando reverse proxy e sito condividono l’host. Il campo vuoto disabilita la chat e non invia richieste a una rotta casuale.

Il server deve consentire l’origine esatta del portale via CORS. Il provider si configura con `ZLLM_API_KEY` sul server; la chiave non va distribuita nei file statici. Il backend espone `inferenceConfigured` nella health response, ma questo indica la presenza di configurazione e non sostituisce un test inferenza.

## Maturità e rilascio

Durante la preview il sito dichiara `noindex`. Prima di dichiararlo produzione devono essere definite l’origine pubblica e la destinazione DNS/HTTPS; configurati e verificati gateway, provider e CORS; completata l’informativa dati con titolare e retention effettivi; protetto il gateway con autenticazione o quote robuste; eseguiti test end-to-end e review del deploy; poi rimossi i meta robots di preview.

Una scheda eNET deve chiamarsi “operativa” solo se il relativo endpoint è verificato. In assenza di prova si usa “repository separato”, “in sviluppo” o “sperimentale”.
