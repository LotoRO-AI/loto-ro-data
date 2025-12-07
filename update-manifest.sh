#!/bin/bash
set -e

# Script pentru actualizarea automată a manifestului după modificarea CSV-urilor
# Rulează din directorul loto-ro-data/

echo "🔄 Actualizare manifest arhive..."
echo ""

# Calculează hash-uri
echo "📊 Calculez hash-urile SHA-256..."
JOKER_HASH=$(shasum -a 256 Arhiva_Joker.csv | awk '{print $1}')
L649_HASH=$(shasum -a 256 Arhiva_Loto_6_din_49.csv | awk '{print $1}')
L540_HASH=$(shasum -a 256 Arhiva_Loto_5_din_40.csv | awk '{print $1}')

# Calculează dimensiuni
JOKER_SIZE=$(wc -c < Arhiva_Joker.csv | tr -d ' ')
L649_SIZE=$(wc -c < Arhiva_Loto_6_din_49.csv | tr -d ' ')
L540_SIZE=$(wc -c < Arhiva_Loto_5_din_40.csv | tr -d ' ')

echo "✅ Hash-uri calculate:"
echo "  Joker:  $JOKER_HASH ($JOKER_SIZE bytes)"
echo "  6/49:   $L649_HASH ($L649_SIZE bytes)"
echo "  5/40:   $L540_HASH ($L540_SIZE bytes)"
echo ""

# Citește versiunea curentă din manifest
CURRENT_VERSION=$(grep -o '"version": [0-9]*' archive-manifest.json | head -1 | grep -o '[0-9]*')
NEW_VERSION=$((CURRENT_VERSION + 1))

# Data curentă în format ISO 8601
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "📝 Versiune nouă: $CURRENT_VERSION → $NEW_VERSION"
echo "📅 Data: $CURRENT_DATE"
echo ""

# Opțional: poți să ceri USERNAME dacă nu e setat
read -p "GitHub USERNAME (sau Enter pentru USERNAME placeholder): " GITHUB_USER
GITHUB_USER=${GITHUB_USER:-USERNAME}

# Creează manifestul nou
cat > archive-manifest.json << EOF
{
  "version": $NEW_VERSION,
  "generatedAt": "$CURRENT_DATE",
  "archives": {
    "joker": {
      "version": $NEW_VERSION,
      "csvUrl": "https://$GITHUB_USER.github.io/loto-ro-data/Arhiva_Joker.csv",
      "sha256": "$JOKER_HASH",
      "size": $JOKER_SIZE,
      "updatedAt": "$CURRENT_DATE"
    },
    "loto649": {
      "version": $NEW_VERSION,
      "csvUrl": "https://$GITHUB_USER.github.io/loto-ro-data/Arhiva_Loto_6_din_49.csv",
      "sha256": "$L649_HASH",
      "size": $L649_SIZE,
      "updatedAt": "$CURRENT_DATE"
    },
    "loto540": {
      "version": $NEW_VERSION,
      "csvUrl": "https://$GITHUB_USER.github.io/loto-ro-data/Arhiva_Loto_5_din_40.csv",
      "sha256": "$L540_HASH",
      "size": $L540_SIZE,
      "updatedAt": "$CURRENT_DATE"
    }
  }
}
EOF

echo "✅ Manifestul a fost actualizat!"
echo ""
echo "📋 Următorii pași:"
echo "  1. Verifică manifestul: cat archive-manifest.json"
echo "  2. Commit și push:"
echo "     git add ."
echo "     git commit -m \"Update: adăugat extrageri din $(date +%d.%m.%Y)\""
echo "     git push origin main"
echo "  3. Așteaptă 2-3 minute pentru GitHub Pages"
echo ""
