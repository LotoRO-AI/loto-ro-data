#!/usr/bin/env bash
set -euo pipefail

# publish_draw.sh
# Adaugă o extragere nouă în CSV, actualizează manifestul și publică pe GitHub
# 
# Utilizare:
#   ./publish_draw.sh --game joker --date 2025-12-08 --nums 3,12,23,34,45,7
#   ./publish_draw.sh --game loto649 --date 2025-12-08 --nums 1,2,3,4,5,6
#   ./publish_draw.sh    # Mod interactiv (va cere toate detaliile)

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

function usage(){
  cat <<EOF
Utilizare: $0 --game {joker|loto649|loto540} --date YYYY-MM-DD --nums num1,num2,...

Exemple:
  $0 --game joker --date 2025-12-08 --nums 3,12,23,34,45,7
  $0 --game loto649 --date 2025-12-08 --nums 1,2,3,4,5,6
  $0 --game loto540 --date 2025-12-08 --nums 3,12,23,34,40

Note:
  - Pentru Joker: 5 numere + 1 număr Joker (ex: 3,12,23,34,45,7)
  - Pentru 6/49: 6 numere (ex: 1,2,3,4,5,6)
  - Pentru 5/40: 5 numere (ex: 3,12,23,34,40)
  - Data în format YYYY-MM-DD (ex: 2025-12-08)
EOF
}

GAME=""
DATE=""
NUMS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --game) GAME="$2"; shift 2;;
    --date) DATE="$2"; shift 2;;
    --nums) NUMS="$2"; shift 2;;
    --help|-h) usage; exit 0;;
    *) echo "❌ Parametru necunoscut: $1"; usage; exit 1;;
  esac
done

if [[ -z "$GAME" ]]; then
  echo "🎲 Alege jocul:"
  echo "  1) joker"
  echo "  2) loto649"
  echo "  3) loto540"
  read -rp "Introdu numărul (1-3): " game_choice
  case "$game_choice" in
    1) GAME="joker";;
    2) GAME="loto649";;
    3) GAME="loto540";;
    *) echo "❌ Alegere invalidă"; exit 1;;
  esac
fi

if [[ -z "$DATE" ]]; then
  read -rp "📅 Data extragerii (YYYY-MM-DD, ex: 2025-12-08): " DATE
fi

if [[ -z "$NUMS" ]]; then
  case "$GAME" in
    joker)
      echo "🎯 Introdu numerele pentru JOKER (5 numere + 1 Joker)"
      read -rp "   Ex: 3,12,23,34,45,7: " NUMS;;
    loto649)
      echo "🎯 Introdu numerele pentru LOTO 6/49 (6 numere)"
      read -rp "   Ex: 1,2,3,4,5,6: " NUMS;;
    loto540)
      echo "🎯 Introdu numerele pentru LOTO 5/40 (5 numere)"
      read -rp "   Ex: 3,12,23,34,40: " NUMS;;
  esac
fi

case "$GAME" in
  joker)
    CSV="Arhiva_Joker.csv" ;;
  loto649)
    CSV="Arhiva_Loto_6_din_49.csv" ;;
  loto540)
    CSV="Arhiva_Loto_5_din_40.csv" ;;
  *) echo "❌ Joc invalid: $GAME"; exit 1;;
esac

if [[ ! -f "$REPO_DIR/$CSV" ]]; then
  echo "❌ CSV nu există: $REPO_DIR/$CSV"; exit 1
fi

# Verifică formatul datei
if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "❌ Format dată invalid. Folosește YYYY-MM-DD (ex: 2025-12-08)"; exit 1
fi

# Curăță numerele (elimină spații)
NUMS_CLEAN=$(echo "$NUMS" | tr -d ' ')

# CSV-urile folosesc format YYYY-MM-DD direct
LINE="$DATE,$NUMS_CLEAN"

echo ""
echo "📝 Adaug extragerea:"
echo "   Joc: $GAME"
echo "   Data: $DATE"
echo "   Numere: $NUMS_CLEAN"
echo "   CSV: $CSV"
echo ""

# Adaugă linia în CSV
printf "%s\n" "$LINE" >> "$REPO_DIR/$CSV"
echo "✅ Linie adăugată în $CSV"

cd "$REPO_DIR"

# Actualizează manifestul (recalculează hash-uri și incrementează versiunea)
if [[ -x ./update-manifest.sh ]]; then
  echo "🔄 Actualizez manifestul..."
  ./update-manifest.sh
else
  echo "⚠️  update-manifest.sh nu este executabil. Rulează manual: ./update-manifest.sh"
  exit 1
fi

echo ""
echo "📦 Comit și public pe GitHub..."
git add "$CSV" archive-manifest.json
git commit -m "Update: extragere $GAME din $DATE ($NUMS_CLEAN)" || {
  echo "⚠️  Nicio modificare de commit-uit (poate extragerea există deja?)";
  exit 0
}

git push origin main || {
  echo "❌ Push eșuat. Verifică conexiunea și încearcă din nou.";
  exit 1
}

echo ""
echo "✅ SUCCES! Extragerea a fost publicată pe GitHub!"
echo "⏱️  Așteaptă 2-3 minute pentru deployment pe GitHub Pages"
echo "🌐 Verifică: https://LotoRO-AI.github.io/loto-ro-data/archive-manifest.json"
echo ""
echo "📱 Utilizatorii vor primi actualizarea automat la următoarea pornire a aplicației!"
