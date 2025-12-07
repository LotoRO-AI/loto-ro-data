# 🚀 Ghid Complet: Setup GitHub Pages pentru Arhive Loto RO

## Prezentare

Acest sistem permite actualizarea automată a arhivelor CSV prin GitHub Pages, GRATUIT și fără nevoie de server propriu.

---

## 📋 Pas cu Pas: Prima Configurare

### Pas 1: Creează Repository pe GitHub

1. **Loghează-te** pe [github.com](https://github.com)
2. Click pe **"+"** (sus dreapta) → **"New repository"**
3. **Completează**:
   - Repository name: `loto-ro-data`
   - Description: "Archive CSV pentru aplicația Loto RO"
   - Visibility: **Public** ⚠️ IMPORTANT (pentru GitHub Pages gratuit)
   - **NU** bifa: "Add a README file"
   - **NU** bifa: "Add .gitignore"
   - **NU** bifa: "Choose a license"
4. Click **"Create repository"**
5. **Notează URL-ul**: `https://github.com/USERNAME/loto-ro-data`
   - Înlocuiește `USERNAME` cu username-ul tău real!

---

### Pas 2: Conectează Repository-ul Local

Deschide Terminal și rulează:

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data

# Commit inițial
git commit -m "Initial commit: archive data v1"

# Conectează la GitHub (ÎNLOCUIEȘTE USERNAME!)
git remote add origin https://github.com/USERNAME/loto-ro-data.git

# Push la GitHub
git branch -M main
git push -u origin main
```

**⚠️ Înlocuiește `USERNAME` cu username-ul tău de GitHub!**

Dacă te întreabă username/password:
- Username: username-ul tău GitHub
- Password: **Personal Access Token** (nu parola obișnuită)
  - Creează token: https://github.com/settings/tokens
  - Permissions: `repo` (toate)
  - Salvează token-ul undeva sigur!

---

### Pas 3: Activează GitHub Pages

1. Mergi în repository pe GitHub:
   ```
   https://github.com/USERNAME/loto-ro-data
   ```

2. Click **Settings** (tab-ul din dreapta)

3. Click **Pages** (în sidebar-ul din stânga)

4. Sub **"Source"**:
   - Branch: selectează **`main`**
   - Folder: selectează **`/ (root)`**

5. Click **"Save"**

6. **Așteaptă 2-3 minute** pentru deployment

7. **Verifică că funcționează**:
   - URL-ul va fi: `https://USERNAME.github.io/loto-ro-data/`
   - Testează manifestul: `https://USERNAME.github.io/loto-ro-data/archive-manifest.json`
   - Testează un CSV: `https://USERNAME.github.io/loto-ro-data/Arhiva_Joker.csv`

---

### Pas 4: Actualizează Manifestul cu USERNAME-ul Tău

**IMPORTANT**: Trebuie să înlocuiești `USERNAME` cu username-ul tău real în manifest!

**Opțiunea 1 - Manual**:
```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data

# Deschide în editor
nano archive-manifest.json
# sau
open -a TextEdit archive-manifest.json
```

Înlocuiește toate aparițiile:
- `https://USERNAME.github.io/` 
- cu `https://TAU_USERNAME.github.io/`

**Opțiunea 2 - Automat cu sed**:
```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data

# ÎNLOCUIEȘTE "tavumgithub" cu USERNAME-ul tău real!
sed -i '' 's/USERNAME/tavumgithub/g' archive-manifest.json

# Verifică
cat archive-manifest.json

# Commit modificarea
git add archive-manifest.json
git commit -m "Update: set real GitHub username in manifest"
git push origin main
```

---

### Pas 5: Actualizează Aplicația Flutter

Deschide:
```
/Users/liviu/Downloads/LotoRO/loto_ro/lib/utils/constants.dart
```

Găsește:
```dart
static const String _defaultManifestUrl =
    'https://lotor.ro/legal/data/archive-manifest.json';
```

Înlocuiește cu (PUNE USERNAME-UL TĂU!):
```dart
static const String _defaultManifestUrl =
    'https://TAU_USERNAME.github.io/loto-ro-data/archive-manifest.json';
```

**Salvează** și **rebuild** aplicația!

---

## 🔄 Actualizări Viitoare (Când Apar Extrageri Noi)

### Metoda Simplă cu Script

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data

# 1. Actualizează CSV-urile (adaugă extrageri noi)
# De exemplu, deschide Arhiva_Joker.csv și adaugă linia nouă

# 2. Rulează scriptul automat
./update-manifest.sh
# Introdu USERNAME-ul tău când te întreabă (sau Enter pentru placeholder)

# 3. Verifică manifestul
cat archive-manifest.json

# 4. Commit și push
git add .
git commit -m "Update: adăugat extrageri din 07.12.2025"
git push origin main

# 5. Așteaptă 2-3 minute pentru GitHub Pages
```

### Metoda Manuală

1. **Actualizează CSV-urile** cu noile extrageri

2. **Calculează hash-urile noi**:
   ```bash
   shasum -a 256 Arhiva_Joker.csv
   shasum -a 256 Arhiva_Loto_6_din_49.csv
   shasum -a 256 Arhiva_Loto_5_din_40.csv
   ```

3. **Editează `archive-manifest.json`**:
   - Incrementează `version` (ex: 1 → 2)
   - Actualizează `generatedAt` cu data curentă
   - Pentru fiecare joc:
     - Incrementează `version`
     - Actualizează `sha256`
     - Actualizează `size`
     - Actualizează `updatedAt`

4. **Push la GitHub**:
   ```bash
   git add .
   git commit -m "Update: adăugat extrageri din [DATA]"
   git push origin main
   ```

---

## ✅ Verificare Finală

După configurare, verifică că totul funcționează:

1. **Manifestul JSON este accesibil**:
   ```
   https://USERNAME.github.io/loto-ro-data/archive-manifest.json
   ```

2. **CSV-urile sunt accesibile**:
   ```
   https://USERNAME.github.io/loto-ro-data/Arhiva_Joker.csv
   ```

3. **În aplicație**:
   - Deschide aplicația
   - Mergi în **Settings** → **Actualizează Arhive**
   - Ar trebui să vadă "Actualizare disponibilă" sau "Arhivele sunt la zi"

---

## 🆘 Troubleshooting

### "403 Forbidden" când accesez URL-ul
- Repository-ul trebuie să fie **Public**
- GitHub Pages trebuie să fie **activat** (Settings → Pages)
- Așteaptă 2-3 minute după push

### "404 Not Found"
- Verifică că branch-ul este `main` (nu `master`)
- Verifică că folder-ul este `/ (root)`
- URL-ul corect este: `https://USERNAME.github.io/loto-ro-data/`

### Hash-urile nu se potrivesc
- Rulează scriptul `update-manifest.sh` pentru recalculare
- NU edita manual hash-urile (sunt generate automat)

### Aplicația nu vede actualizările
- Verifică că URL-ul din `constants.dart` este corect
- Verifică că manifestul JSON este valid (folosește jsonlint.com)
- Așteaptă 6 ore (interval minim între verificări) sau forțează din Settings

---

## 📱 Workflow Complet

**Ciclu normal de actualizare**:

1. **LUNI dimineață** - Extragere nouă apare pe site-ul oficial
2. **Tu**: Descarci CSV-ul actualizat sau adaugi manual linia nouă
3. **Tu**: Rulezi `./update-manifest.sh` → Commit → Push
4. **GitHub Pages**: Publică automat în 2-3 minute
5. **Utilizatorii**: La următoarea pornire a aplicației (sau manual din Settings), văd automat noile extrageri!

**Nicio intervenție manuală necesară de la utilizatori!** 🎉

---

## 🔒 Securitate

✅ **Ce este sigur**:
- Hash-uri SHA-256 verifică integritatea
- HTTPS obligatoriu pentru toate download-urile
- Rate limiting previne spam-ul
- GitHub Pages oferă CDN global gratuit

✅ **Best Practices**:
- Nu șterge niciodată extrageri vechi
- Păstrează backup-uri ale CSV-urilor
- Testează local înainte de push
- Folosește commit messages descriptive

---

## 💰 Costuri

**TOTAL: 0 RON / lună** 🎉

- GitHub Pages: GRATUIT (pentru repo-uri publice)
- Storage: GRATUIT (până la 1 GB)
- Bandwidth: GRATUIT (până la 100 GB/lună)
- CDN Global: GRATUIT (inclus)

---

## 📞 Ajutor

Dacă întâmpini probleme:
1. Verifică README.md din repository
2. Verifică că ai urmat toți pașii din acest ghid
3. Verifică logs în GitHub (Settings → Pages)

---

**Succes! 🚀**
