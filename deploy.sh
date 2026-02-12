#!/bin/bash
echo "🔄 Avvio deploy completo di x-zdos.it..."

# Verifica che la cartella agents esista
mkdir -p agents

# Aggiungi tutti i file
git add .

# Commit con timestamp
git commit -m "🚀 Deploy completo $(date +'%Y-%m-%d %H:%M:%S')"

# Push al repository GitHub
git push origin main

echo "✅ Deploy completato su https://high-cde.github.io/x-zdos.it/"
