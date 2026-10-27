# x-zdos.it — Portale ZDOS

Portale statico in italiano per orientarsi tra i repository ZDOS, la directory eNET e il backend AI K.I.R.A. Le pagine distinguono i servizi collegati dai progetti sperimentali. Non includono login, database, wallet o runtime ZLang.

## Pagine e file

- `index.html`: portale e stato del gateway.
- `enet.html`: directory dei servizi, con collegamenti e livelli di maturità.
- `ecosystem.html`, `ECOSYSTEM_SCOPE.md` e `ecosystem.json`: definizione leggibile e machine-readable dei confini del sistema.
- `privacy.html`: nota tecnica; resta `noindex` finché il gestore non completa e verifica l’informativa.
- `site.css`, `site.js`, `kira-widget.js`: asset locali; nessun framework o font CDN richiesto.
- `robots.txt` e `sitemap.xml`: discovery delle pagine pubbliche; la home e le pagine informative principali sono indicizzabili, mentre il 404 e la nota tecnica restano esclusi.
- `deploy-vps.sh`: deploy controllato e versionato su Nginx; conserva il document root VelvetHub esistente e aggiunge i nomi host del portale e del sottodominio.

## Avvio locale

```sh
python3 -m http.server 8080
```

Aprire `http://127.0.0.1:8080`. Senza API configurata, la UI mostra che il gateway non è collegato e disabilita l’invio; non produce risposte simulate.

## Deploy sulla VPS

La destinazione è la VPS Nginx già in uso. Lo script controlla che `x-zdos.it` e `www.x-zdos.it` puntino alla macchina, scarica solo gli asset statici dal ramo `feat/kira-widget`, crea una nuova release sotto `/var/www/x-zdos-portal`, verifica Nginx e fa reload solo se il test passa. Non sovrascrive `/var/www/ourvelvet` né il vhost `velvethub.art`; crea un backup dei vhost e richiede una conferma interattiva `DEPLOY` prima di modificare il routing. Chiede anche un indirizzo per gli avvisi Certbot, che viene registrato localmente sulla VPS.

Da una shell SSH interattiva, esaminare lo script e poi avviarlo:

```sh
curl -fsSL https://raw.githubusercontent.com/high-cde/x-zdos.it/feat/kira-widget/deploy-vps.sh -o /tmp/xzdos-deploy.sh
less /tmp/xzdos-deploy.sh
sudo bash /tmp/xzdos-deploy.sh
```

Il deploy richiede HTTPS per `x-zdos.it` e `www.x-zdos.it`. Per instradare VelvetHub su `velvet.x-zdos.it`, aggiungere nel DNS un record `A` `velvet` verso l’IP della VPS; il vhost esistente mantiene lo stesso document root e le stesse regole. Dopo la propagazione, richiedere il certificato con `sudo certbot --nginx --redirect -d velvet.x-zdos.it`.

## Collegamento K.I.R.A.

Il sito distribuito lascia vuoto `<meta name="zdos-kira-api-base">`: il widget è disattivato e non invia prompt. Prima di collegare un’origine HTTPS reale, ad esempio `https://api.x-zdos.it`, verificare reverse proxy, TLS, CORS per `https://x-zdos.it`, limiti di frequenza, provider e gestione dei log. Impostare `ZLLM_API_KEY` esclusivamente nell’ambiente server, mai nei file statici. `inferenceConfigured: true` prova la presenza della configurazione lato server, non sostituisce un test d’inferenza.

La pagina privacy è deliberatamente una nota tecnica, non un’informativa legale definitiva: prima di abilitare raccolta/inoltro di prompt il gestore deve completare le informazioni effettive su titolare, finalità, base giuridica, provider, retention e diritti.
