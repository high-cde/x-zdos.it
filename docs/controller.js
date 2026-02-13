document.getElementById("generate").addEventListener("click", () => {
    const vision = document.getElementById("visionMode").value;
    const tone = document.getElementById("tone").value;
    const density = document.getElementById("density").value;
    const prudence = document.getElementById("prudence").value;
    const type = document.getElementById("contentType").value;
    const subject = document.getElementById("subject").value || "l’ecosistema xZDOS";
    const details = document.getElementById("details").value;

    let base = "";

    if (type === "announce") {
        base = `Annunciamo una nuova espansione: ${subject}.
Non è un semplice aggiornamento, ma un nodo evolutivo dell’architettura.`;
    }

    if (type === "vision") {
        base = `${subject} non è un punto di arrivo, ma un vettore narrativo.
Ogni componente dialoga con gli altri, generando un ecosistema coerente e sorprendente.`;
    }

    if (type === "behind") {
        base = `Dietro ${subject} c’è una logica precisa: ridurre attrito, aumentare coerenza.
Ogni script, ogni pannello, ogni log è parte di una storia tecnica.`;
    }

    if (type === "manifesto") {
        base = `Manifesto per ${subject}:
Costruiamo sistemi che non si limitano a funzionare, ma che raccontano una visione.`;
    }

    if (density === "3") {
        base += `\n\nIn xZDOS_AOA ogni scelta è un atto architetturale:
strati, moduli, ponti cognitivi, tutto converge verso un’unica direzione: eleganza operativa.`;
    }

    if (prudence !== "medio") {
        base += `\n\nNota: contenuto generato con livello di prudenza ${prudence}.`;
    }

    if (details.trim() !== "") {
        base += `\n\n${details}`;
    }

    document.getElementById("outputBox").textContent = base;
});
