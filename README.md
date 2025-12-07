# Loto RO - Archive Data Repository

Acest repository conține arhivele CSV cu extragerile istorice pentru aplicația **Loto RO**.

## 📦 Conținut

- `Arhiva_Joker.csv` - Extrageri Joker
- `Arhiva_Loto_6_din_49.csv` - Extrageri 6/49
- `Arhiva_Loto_5_din_40.csv` - Extrageri 5/40
- `archive-manifest.json` - Manifest cu versiuni și hash-uri SHA-256

## 🔄 Actualizare Date

### Când adaugi extrageri noi:

1. **Actualizează fișierele CSV** cu noile extrageri
2. **Regenerează hash-urile SHA-256**:
   ```bash
   shasum -a 256 Arhiva_Joker.csv
   shasum -a 256 Arhiva_Loto_6_din_49.csv
   shasum -a 256 Arhiva_Loto_5_din_40.csv
   ```

3. **Actualizează `archive-manifest.json`**:
   - Incrementează `version` (ex: 1 → 2)
   - Actualizează `generatedAt` cu data curentă
   - Pentru fiecare joc modificat:
     - Incrementează `version` specific
     - Actualizează `sha256` cu hash-ul nou
     - Actualizează `size` cu dimensiunea noului fișier
     - Actualizează `updatedAt`

4. **Commit și push**:
   ```bash
   git add .
   git commit -m "Update: adăugat extragerile din [DATA]"
   git push origin main
   ```

5. **Așteaptă 2-3 minute** pentru ca GitHub Pages să publice modificările

## 🚀 Setup Inițial

### Pasul 1: Creează Repository pe GitHub

1. Mergi pe [github.com/new](https://github.com/new)
2. Nume repository: `loto-ro-data`
3. Visibility: **Public** (IMPORTANT pentru GitHub Pages gratuit)
4. Nu adăuga README, .gitignore sau license (le avem deja)
5. Click **Create repository**

### Pasul 2: Conectează Repository-ul Local

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
git init
git add .
git commit -m "Initial commit: archive data and manifest"
git branch -M main
git remote add origin https://github.com/USERNAME/loto-ro-data.git
git push -u origin main
```

**⚠️ Înlocuiește `USERNAME` cu username-ul tău de GitHub!**

### Pasul 3: Activează GitHub Pages

1. Mergi în repository pe GitHub: `https://github.com/USERNAME/loto-ro-data`
2. Click **Settings**
3. Click **Pages** (în stânga)
4. Sub **Source**:
   - Branch: `main`
   - Folder: `/ (root)`
5. Click **Save**
6. Așteaptă 2-3 minute
7. Verifică că site-ul este live: `https://USERNAME.github.io/loto-ro-data/archive-manifest.json`

### Pasul 4: Actualizează URL-urile în Aplicație

În aplicația Flutter, modifică fișierul:
`lib/utils/constants.dart`

Înlocuiește:
```dart
static const String _defaultManifestUrl =
    'https://lotor.ro/legal/data/archive-manifest.json';
```

Cu:
```dart
static const String _defaultManifestUrl =
    'https://USERNAME.github.io/loto-ro-data/archive-manifest.json';
```

**⚠️ Înlocuiește `USERNAME` cu username-ul tău de GitHub!**

Apoi în fișierul `archive-manifest.json`, înlocuiește toate aparițiile lui `USERNAME` cu username-ul tău real.

## 📱 Cum Funcționează

1. La pornirea aplicației, se verifică automat dacă există versiuni noi
2. Dacă manifestul indică o versiune nouă, se descarcă automat CSV-urile actualizate
3. Hash-ul SHA-256 verifică integritatea fișierelor
4. Utilizatorii pot forța și manual actualizarea din Settings

## 🔒 Securitate

- Toate URL-urile folosesc HTTPS
- Hash-urile SHA-256 previn fișiere corupte sau modificate
- Rate limiting previne spam-ul de request-uri
- Manifestul permite rollback la versiuni anterioare dacă e necesar

## 📊 Format CSV

Fișierele CSV trebuie să respecte formatul:
```
Data,Numar 1,Numar 2,Numar 3,Numar 4,Numar 5[,Extra]
DD.MM.YYYY,N1,N2,N3,N4,N5[,NExtra]
```

## 🛠️ Script Automat de Actualizare

Pentru viitor, poți crea un script `update-archives.sh`:

```bash
#!/bin/bash
# Update archives and manifest

echo "Calculating SHA-256 hashes..."
JOKER_HASH=$(shasum -a 256 Arhiva_Joker.csv | awk '{print $1}')
L649_HASH=$(shasum -a 256 Arhiva_Loto_6_din_49.csv | awk '{print $1}')
L540_HASH=$(shasum -a 256 Arhiva_Loto_5_din_40.csv | awk '{print $1}')

echo "Joker: $JOKER_HASH"
echo "6/49: $L649_HASH"
echo "5/40: $L540_HASH"

# TODO: Update manifest JSON with new hashes and versions
# TODO: git commit and push
```

## 📞 Contact

Pentru probleme sau întrebări despre acest repository, contactează dezvoltatorul aplicației.

---

**Nota**: Acest repository este parte din ecosistemul aplicației Loto RO și conține doar date publice (extrageri istorice oficiale).
