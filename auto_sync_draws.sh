#!/usr/bin/env bash
set -eo pipefail

# auto_sync_draws.sh
# Detectează automat extrageri noi în assets/data și le publică pe GitHub
# Rulează automat la fiecare flutter build/run

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLUTTER_APP_DIR="/Users/liviu/Downloads/LotoRO/loto_ro"
ASSETS_DATA_DIR="$FLUTTER_APP_DIR/assets/data"

# Culori pentru output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  🔍 VERIFICARE AUTOMATĂ EXTRAGERI NOI                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verifică dacă există folder-ul assets
if [[ ! -d "$ASSETS_DATA_DIR" ]]; then
  echo -e "${RED}❌ Folder assets/data nu există: $ASSETS_DATA_DIR${NC}"
  exit 0
fi

# Funcție pentru a compara două CSV-uri și a extrage linii noi
compare_and_extract_new_lines() {
  local github_csv="$1"
  local assets_csv="$2"
  local game_name="$3"
  
  if [[ ! -f "$github_csv" ]] || [[ ! -f "$assets_csv" ]]; then
    return 1
  fi
  
  # Exclude header și compară
  local github_lines=$(tail -n +2 "$github_csv" | sort)
  local assets_lines=$(tail -n +2 "$assets_csv" | sort)
  
  # Găsește linii noi (în assets dar nu în github)
  local new_lines=$(comm -13 <(echo "$github_lines") <(echo "$assets_lines"))
  
  if [[ -n "$new_lines" ]]; then
    echo "$new_lines"
    return 0
  fi
  
  return 1
}

# Verifică fiecare joc (folosind arrays simple pentru compatibilitate bash 3.2)
NEW_DRAWS_FOUND=false
UPDATES_LOG=""

# Joker
game="joker"
csv_file="Arhiva_Joker.csv"
github_csv="$SCRIPT_DIR/$csv_file"
assets_csv="$ASSETS_DATA_DIR/$csv_file"

echo -e "${YELLOW}🔍 Verificare $game...${NC}"
if new_lines=$(compare_and_extract_new_lines "$github_csv" "$assets_csv" "$game" 2>/dev/null); then
  num_new=$(echo "$new_lines" | wc -l | xargs)
  echo -e "${GREEN}   ✅ Găsite $num_new extrageri noi!${NC}"
  NEW_DRAWS_FOUND=true
  echo "$new_lines" >> "$github_csv"
  UPDATES_LOG="$UPDATES_LOG\n  - $game: $num_new extrageri noi"
else
  echo -e "   ℹ️  Nicio extragere nouă"
fi

# Loto 6/49
game="loto649"
csv_file="Arhiva_Loto_6_din_49.csv"
github_csv="$SCRIPT_DIR/$csv_file"
assets_csv="$ASSETS_DATA_DIR/$csv_file"

echo -e "${YELLOW}🔍 Verificare $game...${NC}"
if new_lines=$(compare_and_extract_new_lines "$github_csv" "$assets_csv" "$game" 2>/dev/null); then
  num_new=$(echo "$new_lines" | wc -l | xargs)
  echo -e "${GREEN}   ✅ Găsite $num_new extrageri noi!${NC}"
  NEW_DRAWS_FOUND=true
  echo "$new_lines" >> "$github_csv"
  UPDATES_LOG="$UPDATES_LOG\n  - $game: $num_new extrageri noi"
else
  echo -e "   ℹ️  Nicio extragere nouă"
fi

# Loto 5/40
game="loto540"
csv_file="Arhiva_Loto_5_din_40.csv"
github_csv="$SCRIPT_DIR/$csv_file"
assets_csv="$ASSETS_DATA_DIR/$csv_file"

echo -e "${YELLOW}🔍 Verificare $game...${NC}"
if new_lines=$(compare_and_extract_new_lines "$github_csv" "$assets_csv" "$game" 2>/dev/null); then
  num_new=$(echo "$new_lines" | wc -l | xargs)
  echo -e "${GREEN}   ✅ Găsite $num_new extrageri noi!${NC}"
  NEW_DRAWS_FOUND=true
  echo "$new_lines" >> "$github_csv"
  UPDATES_LOG="$UPDATES_LOG\n  - $game: $num_new extrageri noi"
else
  echo -e "   ℹ️  Nicio extragere nouă"
fi

echo ""

if [[ "$NEW_DRAWS_FOUND" == false ]]; then
  echo -e "${GREEN}✅ Toate arhivele sunt la zi! Nicio actualizare necesară.${NC}"
  echo ""
  exit 0
fi

# Au fost găsite extrageri noi - actualizează manifestul și publică
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  📦 PUBLICARE AUTOMATĂ PE GITHUB                          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

cd "$SCRIPT_DIR"

# Actualizează manifestul
echo -e "${YELLOW}🔄 Actualizare manifest (recalculare hash-uri)...${NC}"
if [[ -x ./update-manifest.sh ]]; then
  ./update-manifest.sh 2>/dev/null || true
else
  echo -e "${RED}❌ update-manifest.sh nu este executabil!${NC}"
  exit 1
fi

# Commit și push
echo -e "${YELLOW}📤 Commit și push la GitHub...${NC}"
git add *.csv archive-manifest.json
COMMIT_MSG="Auto-sync: extrageri noi detectate în assets/data$(echo -e "$UPDATES_LOG")"
git commit -m "$COMMIT_MSG" || {
  echo -e "${YELLOW}⚠️  Nicio modificare de commit-uit${NC}"
  exit 0
}

git push origin main || {
  echo -e "${RED}❌ Git push eșuat!${NC}"
  exit 1
}

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ SUCCES! Extrageri publicate pe GitHub!                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📱 Utilizatorii vor primi actualizarea automat!${NC}"
echo -e "${BLUE}⏱️  Așteaptă 2-3 minute pentru GitHub Pages deployment${NC}"
echo ""
