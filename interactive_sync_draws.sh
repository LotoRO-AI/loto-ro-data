#!/usr/bin/env bash
set -euo pipefail

# interactive_sync_draws.sh
# Variantă interactivă - te întreabă înainte de build dacă ai extrageri noi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLUTTER_APP_DIR="/Users/liviu/Downloads/LotoRO/loto_ro"
ASSETS_DATA_DIR="$FLUTTER_APP_DIR/assets/data"

# Culori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  🎯 PRE-BUILD CHECK: Extrageri Noi?                      ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Întreabă utilizatorul
echo -e "${YELLOW}📋 Au avut loc extrageri noi de la ultima compilare?${NC}"
echo ""
echo "  ${GREEN}1)${NC} Da - am adăugat extrageri noi în assets/data/"
echo "  ${RED}2)${NC} Nu - folosește arhivele existente"
echo ""
read -p "$(echo -e ${CYAN}Alege opțiunea [1/2]:${NC} )" -n 1 -r choice
echo ""
echo ""

if [[ ! $choice =~ ^[1]$ ]]; then
  echo -e "${GREEN}✅ OK! Continuăm cu arhivele existente.${NC}"
  echo ""
  exit 0
fi

# Utilizatorul a confirmat extrageri noi
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  📝 ADĂUGARE EXTRAGERI NOI                                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Sincronizează din assets/data către repo
echo -e "${YELLOW}🔄 Copiez extrageri din assets/data...${NC}"

for csv in "Arhiva_Joker.csv" "Arhiva_Loto_6_din_49.csv" "Arhiva_Loto_5_din_40.csv"; do
  if [[ -f "$ASSETS_DATA_DIR/$csv" ]]; then
    cp "$ASSETS_DATA_DIR/$csv" "$SCRIPT_DIR/$csv"
    echo -e "   ✅ $csv"
  fi
done

cd "$SCRIPT_DIR"

# Actualizează manifestul
echo ""
echo -e "${YELLOW}🔄 Actualizare manifest...${NC}"
if [[ -x ./update-manifest.sh ]]; then
  ./update-manifest.sh 2>/dev/null || true
else
  echo -e "${RED}❌ update-manifest.sh nu este executabil!${NC}"
  exit 1
fi

# Commit și push
echo ""
echo -e "${YELLOW}📤 Publicare pe GitHub...${NC}"
git add *.csv archive-manifest.json
git commit -m "Update: extrageri noi adăugate manual în assets/data" || {
  echo -e "${YELLOW}⚠️  Nicio modificare detectată${NC}"
  echo ""
  exit 0
}

git push origin main || {
  echo -e "${RED}❌ Git push eșuat!${NC}"
  exit 1
}

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ SUCCES! Extrageri publicate!                          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📱 Utilizatorii vor primi actualizarea automat!${NC}"
echo ""
