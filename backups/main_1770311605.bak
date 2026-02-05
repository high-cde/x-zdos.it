document.addEventListener("DOMContentLoaded", () => {
  const miniRzai = document.getElementById("mini-rzai");
  const bubble = document.querySelector(".rzai-bubble");

  if (!miniRzai || !bubble) return;

  const messages = [
    "Serve aiuto?",
    "Vuoi una soluzione su misura?",
    "Posso guidarti nei moduli.",
    "Hai già visto la pagina clienti?",
    "Vuoi automatizzare qualcosa?"
  ];

  let i = 0;
  bubble.textContent = messages[i];

  setInterval(() => {
    i = (i + 1) % messages.length;
    bubble.textContent = messages[i];
  }, 4000);

  miniRzai.addEventListener("click", () => {
    window.location.href = "/clienti.html#section-contatto";
  });
});
