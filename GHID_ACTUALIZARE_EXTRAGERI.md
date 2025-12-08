# 🎯 Ghid Complet: Actualizare Extrageri Loto

## 📋 Prezentare

Acest ghid te învață cum să adaugi extrageri noi și să le publici automat către utilizatori prin GitHub Pages.

---

## 🚀 Metoda Simplă: Folosind Scriptul `publish_draw.sh`

### **Pas 1: Deschide Terminal**

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
```

### **Pas 2: Rulează Scriptul**

**Mod interactiv** (scriptul te întreabă pas cu pas):
```bash
./publish_draw.sh
```

**Mod rapid** (cu parametri):
```bash
# Pentru Joker (5 numere + 1 număr Joker)
./publish_draw.sh --game joker --date 2025-12-08 --nums 3,12,23,34,45,7

# Pentru 6/49 (6 numere)
./publish_draw.sh --game loto649 --date 2025-12-08 --nums 1,2,3,4,5,6

# Pentru 5/40 (5 numere)
./publish_draw.sh --game loto540 --date 2025-12-08 --nums 3,12,23,34,40
```

### **Pas 3: Așteaptă Confirmarea**

Scriptul va:
1. ✅ Adăuga linia în CSV
2. ✅ Recalcula hash-urile SHA-256
3. ✅ Incrementa versiunea în manifest (ex: 1 → 2)
4. ✅ Face commit în git
5. ✅ Face push la GitHub
6. ✅ GitHub Pages publică automat în 2-3 minute

### **Pas 4: Verifică**

După 2-3 minute, verifică că actualizarea e live:
```bash
curl https://LotoRO-AI.github.io/loto-ro-data/archive-manifest.json | grep version
```

---

## 📱 Ce se Întâmplă pentru Utilizatori?

1. **La următoarea pornire** a aplicației, aceasta:
   - Verifică manifestul de pe GitHub Pages
   - Vede că versiunea s-a schimbat (ex: 1 → 2)
   - Descarcă automat noul CSV
   - Validează integritatea cu SHA-256
   - Încarcă noile extrageri în aplicație

2. **Nu trebuie să facă nimic manual!** Totul este automat! 🎉

---

## 🔧 Metoda Manuală (Dacă Preferi)

### **Pas 1: Editează CSV-ul**

Deschide CSV-ul în editor:
```bash
open -a TextEdit Arhiva_Joker.csv
# sau
nano Arhiva_Joker.csv
```

Adaugă linia nouă **la final**, respectând formatul:

**Pentru Joker** (CSV: `data,numar_1,numar_2,numar_3,numar_4,numar_5,joker`):
```csv
2025-12-08,3,12,23,34,45,7
```

**Pentru 6/49** (CSV: `data,n1,n2,n3,n4,n5,n6`):
```csv
2025-12-08,1,2,3,4,5,6
```

**Pentru 5/40** (CSV: `data,n1,n2,n3,n4,n5`):
```csv
2025-12-08,3,12,23,34,40
```

**⚠️ IMPORTANT:**
- Data în format `YYYY-MM-DD` (ex: 2025-12-08)
- Fără spații între numere
- Numerele separate prin virgulă
- O singură linie la final (nu mai multe linii goale)

### **Pas 2: Actualizează Manifestul**

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
./update-manifest.sh
```

Scriptul va:
- Recalcula hash-urile SHA-256 pentru toate CSV-urile
- Incrementa versiunea pentru jocul modificat
- Actualiza manifestul JSON

### **Pas 3: Commit și Push**

```bash
git add Arhiva_Joker.csv archive-manifest.json
git commit -m "Update: extragere Joker din 08.12.2025"
git push origin main
```

### **Pas 4: Verifică Deployment-ul**

Mergi la:
```
https://github.com/LotoRO-AI/loto-ro-data/actions
```

Vei vedea un workflow care rulează. Când devine ✅ verde, actualizarea este live!

---

## 🔄 Workflow Complet (Vizualizare)

```
┌─────────────────────┐
│  Tu adaugi          │
│  extragerea nouă    │
│  (publish_draw.sh)  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Script calculează  │
│  hash SHA-256       │
│  și versiune        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Git commit + push  │
│  la GitHub          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  GitHub Pages       │
│  publică automat    │
│  (2-3 minute)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Aplicația Flutter  │
│  detectează update  │
│  la pornire         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Download automat   │
│  și validare hash   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Utilizatorii văd   │
│  noile extrageri!   │
└─────────────────────┘
```

---

## 📊 Format CSV Detaliat

### **Joker** (`Arhiva_Joker.csv`)

```csv
data,numar_1,numar_2,numar_3,numar_4,numar_5,joker
2000-09-14,4,30,32,39,27,7
2000-09-21,9,31,24,41,39,7
```

- 7 coloane: data + 5 numere + 1 joker
- Numere între 1-45
- Joker între 1-20

### **Loto 6/49** (`Arhiva_Loto_6_din_49.csv`)

```csv
data,n1,n2,n3,n4,n5,n6
1993-08-08,3,13,19,28,32,40
1993-08-15,1,18,23,31,32,49
```

- 7 coloane: data + 6 numere
- Numere între 1-49

### **Loto 5/40** (`Arhiva_Loto_5_din_40.csv`)

```csv
data,n1,n2,n3,n4,n5
1993-08-08,3,7,24,26,39
1993-08-15,9,14,17,27,40
```

- 6 coloane: data + 5 numere
- Numere între 1-40

---

## 🛠️ Troubleshooting

### **Problema: "Permission denied" când rulez scriptul**

**Soluție:**
```bash
chmod +x publish_draw.sh
chmod +x update-manifest.sh
```

### **Problema: "Push failed" sau "Authentication failed"**

**Soluție 1 - Verifică conexiunea:**
```bash
git remote -v
# Ar trebui să vezi: origin  https://github.com/LotoRO-AI/loto-ro-data.git
```

**Soluție 2 - Re-autentifică:**
GitHub poate să ceară Personal Access Token (PAT):
1. Mergi la: https://github.com/settings/tokens
2. Generează un token nou cu permisiuni `repo`
3. Când faci push, folosește token-ul ca parolă

### **Problema: Hash-ul nu se potrivește în aplicație**

**Cauză:** Probabil ai editat CSV-ul manual și ai introdus spații sau newlines în plus.

**Soluție:**
```bash
# Recalculează hash-ul
./update-manifest.sh

# Verifică hash-ul generat
shasum -a 256 Arhiva_Joker.csv

# Compară cu hash-ul din manifest
cat archive-manifest.json | grep sha256
```

### **Problema: GitHub Pages nu se actualizează**

**Verifică:**
1. Workflow-ul din Actions: https://github.com/LotoRO-AI/loto-ro-data/actions
2. Dacă e ✅ verde dar tot nu merge, așteaptă 5 minute (cache-ul GitHub)
3. Forțează refresh în browser: Ctrl+Shift+R (Windows/Linux) sau Cmd+Shift+R (Mac)

---

## 🔐 Securitate

✅ **Ce este securizat:**
- Hash-uri SHA-256 pentru integritate
- HTTPS obligatoriu pentru toate download-urile
- Rate limiting în aplicație (1 verificare la 6 ore)
- Validare automată a hash-urilor înainte de a încărca datele

✅ **Best Practices:**
- Nu edita niciodată manifestul manual (folosește scriptul!)
- Nu șterge extrageri vechi din CSV
- Păstrează backup-uri locale
- Testează local înainte de push

---

## 📅 Frecvența Actualizărilor

**Loto România:**
- **Joker**: Joi și Duminică (2x/săptămână)
- **6/49**: Joi și Duminică (2x/săptămână)
- **5/40**: Joi și Duminică (2x/săptămână)

**Procesul tău:**
1. Joi seară (după extragere) - adaugi numerele
2. Duminică seară (după extragere) - adaugi numerele

**Utilizatorii:**
- Vor vedea automat actualizările la următoarea pornire a aplicației
- Sau pot actualiza manual din Settings (când vei implementa butonul)

---

## 🎯 Exemplu Complet: Actualizare Joi

**Scenariul:** Este joi seară, 8 decembrie 2025. Tocmai s-au extras numerele la Joker, 6/49 și 5/40.

**Pașii:**

1. **Adaugă toate extragerile:**

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data

# Joker
./publish_draw.sh --game joker --date 2025-12-08 --nums 3,12,23,34,45,7

# 6/49
./publish_draw.sh --game loto649 --date 2025-12-08 --nums 1,2,3,4,5,6

# 5/40
./publish_draw.sh --game loto540 --date 2025-12-08 --nums 3,12,23,34,40
```

2. **Verifică că totul e OK:**

```bash
# Verifică ultimele commit-uri
git log --oneline -3

# Ar trebui să vezi 3 commit-uri noi:
# abc1234 Update: extragere loto540 din 2025-12-08 (3,12,23,34,40)
# def5678 Update: extragere loto649 din 2025-12-08 (1,2,3,4,5,6)
# ghi9012 Update: extragere joker din 2025-12-08 (3,12,23,34,45,7)
```

3. **Verifică GitHub Pages (după 2-3 minute):**

```bash
curl https://LotoRO-AI.github.io/loto-ro-data/archive-manifest.json | grep version

# Ar trebui să vezi:
#   "version": 2,  (sau 3, 4, etc. - incrementat față de ultima versiune)
#   "joker": { "version": 2, ... }
#   "loto649": { "version": 2, ... }
#   "loto540": { "version": 2, ... }
```

4. **Gata!** 🎉 Utilizatorii vor primi actualizările automat!

---

## 💡 Tips & Tricks

### **Actualizare rapidă pe o singură linie:**

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data && \
./publish_draw.sh --game joker --date 2025-12-08 --nums 3,12,23,34,45,7 && \
./publish_draw.sh --game loto649 --date 2025-12-08 --nums 1,2,3,4,5,6 && \
./publish_draw.sh --game loto540 --date 2025-12-08 --nums 3,12,23,34,40
```

### **Verificare rapidă a ultimei extrageri:**

```bash
# Joker
tail -1 Arhiva_Joker.csv

# 6/49
tail -1 Arhiva_Loto_6_din_49.csv

# 5/40
tail -1 Arhiva_Loto_5_din_40.csv
```

### **Rollback dacă ai greșit:**

```bash
# Anulează ultimul commit (dar păstrează modificările locale)
git reset --soft HEAD~1

# Sau anulează și modificările locale
git reset --hard HEAD~1

# Apoi re-push
git push origin main --force
```

**⚠️ ATENȚIE:** Folosește `--force` doar dacă ești sigur! Utilizatorii care au deja descărcat versiunea greșită vor avea probleme.

---

## 🔮 Viitor: Automatizare Totală

### **Idee 1: Scraping Automat**

Poți crea un script care:
1. Se conectează la site-ul oficial Loto România
2. Extrage automat numerele noi
3. Rulează `publish_draw.sh` automat
4. Se execută automat joi și duminică seară (cron job)

### **Idee 2: Integrare în Aplicație**

Poți adăuga în aplicația Flutter:
- Un ecran "Admin" protejat cu parolă
- Formular pentru introducerea numerelor
- Buton "Publică" care face commit direct la GitHub

### **Idee 3: GitHub Actions**

Poți configura GitHub Actions să:
- Ruleze scriptul automat la anumite intervale
- Verifice site-ul oficial și adauge automat extragerile
- Trimită notificări când actualizarea e completă

---

## 📞 Suport

Dacă întâmpini probleme:

1. **Verifică log-urile:**
   ```bash
   git log --oneline -5
   git status
   ```

2. **Verifică fișierele:**
   ```bash
   ls -lah *.csv
   cat archive-manifest.json
   ```

3. **Verifică GitHub:**
   - Actions: https://github.com/LotoRO-AI/loto-ro-data/actions
   - Commits: https://github.com/LotoRO-AI/loto-ro-data/commits/main

4. **Re-citește acest ghid** - probabil ai sarit un pas! 😊

---

**Mult succes cu actualizările! 🍀🎰**
