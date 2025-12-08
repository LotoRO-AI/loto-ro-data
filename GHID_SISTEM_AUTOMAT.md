# 🚀 SISTEM AUTOMAT DE SINCRONIZARE - Ghid Complet

## 📋 Prezentare

Sistemul detectează automat extrageri noi în `assets/data/` și le publică pe GitHub **fără intervenție manuală**!

---

## 🎯 Două Variante Disponibile

### **Varianta 1: AUTOMATĂ (Recomandată)** ⭐

Detectează automat diferențele între `assets/data/` și `loto-ro-data/` și publică automat.

**Când rulează:**
- Automat la fiecare `flutter run` (prin tasks.json)
- Sau manual când dorești

**Cum funcționează:**
1. Comparează CSV-urile din `assets/data/` cu cele din `loto-ro-data/`
2. Identifică linii noi (extrageri care există în assets dar nu în GitHub)
3. Le adaugă automat în `loto-ro-data/`
4. Actualizează manifestul (hash-uri, versiune)
5. Face commit + push la GitHub
6. GATA! Utilizatorii primesc update-ul!

### **Varianta 2: INTERACTIVĂ**

Te întreabă înainte de build dacă ai extrageri noi.

**Când rulează:**
- La fiecare `flutter run` (varianta interactivă din tasks.json)

**Cum funcționează:**
1. Te întreabă: "Au avut loc extrageri noi?"
2. Dacă DA → copiază din `assets/data/` și publică
3. Dacă NU → continuă cu arhivele existente

---

## 🛠️ Instalare și Configurare

### **Pas 1: Scripturile sunt deja create!**

- ✅ `/Users/liviu/Downloads/LotoRO/loto-ro-data/auto_sync_draws.sh`
- ✅ `/Users/liviu/Downloads/LotoRO/loto-ro-data/interactive_sync_draws.sh`
- ✅ Tasks.json actualizat în `/Users/liviu/Downloads/LotoRO/loto_ro/.vscode/tasks.json`

### **Pas 2: Alege varianta dorită**

În VS Code, când faci build/run, ai acum 3 opțiuni în task selector:

1. **"Run on Samsung S21 FE (with auto-sync)"** ⭐ AUTOMAT
2. **"Run on Samsung S21 FE (interactive sync)"** - INTERACTIV
3. **"Run on Samsung S21 FE"** - FĂRĂ SYNC (comportament vechi)

---

## 📱 Workflow Complet

### **Scenariul 1: AUTOMAT (Zero Efort!)** 🤖

```
Joi seară: Apar noi extrageri pe site-ul oficial Loto

Tu:
1. Descarci CSV-urile actualizate în assets/data/
   (sau editezi manual și adaugi liniile noi)

2. Salvezi fișierele

3. Rulezi aplicația:
   - CMD+Shift+P → "Tasks: Run Task"
   - Alegi "Run on Samsung S21 FE (with auto-sync)"
   
   SAU direct din VS Code: F5 (dacă ai setat ca default task)

4. Scriptul rulează AUTOMAT în background:
   ✅ Detectează diferențele
   ✅ Publică pe GitHub
   ✅ Mesaj de confirmare

5. Aplicația se compilează și rulează normal

6. GATA! 🎉
```

**Timp total pentru tine:** ~1 minut (doar download + save + run)  
**Tot restul:** AUTOMAT! 🚀

### **Scenariul 2: INTERACTIV** 💬

```
Tu:
1. Adaugi extragerile în assets/data/

2. Rulezi aplicația:
   - Alegi "Run on Samsung S21 FE (interactive sync)"

3. Scriptul te întreabă:
   "Au avut loc extrageri noi? [1=Da / 2=Nu]"

4. Tastezi "1" dacă ai adăugat extrageri
   SAU "2" dacă vrei să folosești arhivele existente

5. Dacă ai ales "1":
   ✅ Copiază și publică automat
   ✅ Mesaj de confirmare

6. Aplicația se compilează

7. GATA! 🎉
```

---

## 🔧 Utilizare Manuală (Dacă Vrei)

### **Test Automat (Fără Build)**

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
./auto_sync_draws.sh
```

Va verifica diferențele și publica dacă găsește extrageri noi.

### **Test Interactiv**

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
./interactive_sync_draws.sh
```

Te va întreba și va aștepta input-ul tău.

---

## 📊 Comparație Sisteme

| Caracteristică | Varianta VECHE (publish_draw.sh) | Varianta AUTOMATĂ | Varianta INTERACTIVĂ |
|----------------|-----------------------------------|-------------------|----------------------|
| **Detectare automată** | ❌ Manual | ✅ Automat | ⚠️ Cu confirmare |
| **Introducere numere** | ⌨️ Manual, număr cu număr | ✅ Detectează automat din CSV | ✅ Citește din CSV |
| **Integrare în build** | ❌ Separat | ✅ Automat la build | ✅ Automat la build |
| **Timp necesar** | ~5 minute | ~10 secunde | ~30 secunde |
| **Pași manuali** | 3-4 comenzi | 0 | 1 (confirmare) |
| **Risc de eroare** | Mediu | Minim | Foarte mic |

---

## 🎯 Exemplu Complet: Joi Seară

### **Cu Sistemul AUTOMAT**

```bash
# 1. Descarci CSV-urile actualizate
# Salvezi în: /Users/liviu/Downloads/LotoRO/loto_ro/assets/data/

# 2. Rulezi aplicația (F5 sau CMD+Shift+P → Run Task)
# Vei vedea în terminal:

╔════════════════════════════════════════════════════════════╗
║  🔍 VERIFICARE AUTOMATĂ EXTRAGERI NOI                     ║
╚════════════════════════════════════════════════════════════╝

🔍 Verificare joker...
   ✅ Găsite 1 extrageri noi!
🔍 Verificare loto649...
   ✅ Găsite 1 extrageri noi!
🔍 Verificare loto540...
   ✅ Găsite 1 extrageri noi!

╔════════════════════════════════════════════════════════════╗
║  📦 PUBLICARE AUTOMATĂ PE GITHUB                          ║
╚════════════════════════════════════════════════════════════╝

🔄 Actualizare manifest (recalculare hash-uri)...
📤 Commit și push la GitHub...

╔════════════════════════════════════════════════════════════╗
║  ✅ SUCCES! Extrageri publicate pe GitHub!                ║
╚════════════════════════════════════════════════════════════╝

📱 Utilizatorii vor primi actualizarea automat!
⏱️  Așteaptă 2-3 minute pentru GitHub Pages deployment

# 3. Aplicația continuă să se compileze normal
# 4. GATA! Zero comenzi manuale! 🎉
```

---

## 🔄 Cum Funcționează Detectarea Automată

### **Algoritmul:**

1. **Compară CSV-urile** linie cu linie
2. **Exclude header-ul** (prima linie)
3. **Sortează** ambele fișiere pentru comparație precisă
4. **Identifică diferențe**:
   - Linii în `assets/data/` dar NU în `loto-ro-data/` = extrageri NOI
5. **Adaugă liniile noi** la sfârșitul CSV-ului GitHub
6. **Recalculează hash-uri** pentru integritate
7. **Incrementează versiunea** în manifest
8. **Publică** automat

### **De ce este sigur?**

✅ **Nu șterge niciodată** date existente  
✅ **Adaugă doar** linii noi  
✅ **Validează hash-uri** pentru integritate  
✅ **Git history** păstrează toate modificările  
✅ **Rollback ușor** dacă e necesar  

---

## 🆘 Troubleshooting

### **Problema: "Nicio extragere nouă" dar eu am adăugat**

**Cauze posibile:**
1. CSV-urile din `assets/data/` sunt identice cu cele din `loto-ro-data/`
2. Ai uitat să salvezi fișierele după editare
3. Format incorect (spații în plus, newlines)

**Soluție:**
```bash
# Verifică diferențele manual
diff /Users/liviu/Downloads/LotoRO/loto_ro/assets/data/Arhiva_Joker.csv \
     /Users/liviu/Downloads/LotoRO/loto-ro-data/Arhiva_Joker.csv
```

### **Problema: Script nu se execută**

**Soluție:**
```bash
chmod +x /Users/liviu/Downloads/LotoRO/loto-ro-data/auto_sync_draws.sh
chmod +x /Users/liviu/Downloads/LotoRO/loto-ro-data/interactive_sync_draws.sh
```

### **Problema: Git push eșuează**

**Soluție:**
```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
git status
git pull origin main  # Sincronizează mai întâi
git push origin main
```

### **Problema: Vreau să revin la sistemul vechi**

**Soluție:**  
Folosește task-ul "Run on Samsung S21 FE" (fără sync)  
SAU șterge `dependsOn` din tasks.json

---

## 🎓 Tips & Tricks

### **Setează AUTOMAT ca default**

În `tasks.json`, task-ul cu `"isDefault": true` va rula când apeși F5:

```json
{
  "label": "Run on Samsung S21 FE (with auto-sync)",
  "group": {
    "kind": "build",
    "isDefault": true  // ← Acest task rulează la F5
  }
}
```

### **Verificare rapidă înainte de build**

```bash
# Rulează manual scriptul pentru a vedea ce va face
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
./auto_sync_draws.sh
```

### **Sincronizare forțată (ignoră cache)**

Dacă vrei să forțezi re-upload chiar dacă nu detectează diferențe:

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
cp /Users/liviu/Downloads/LotoRO/loto_ro/assets/data/*.csv .
./update-manifest.sh
git add *.csv archive-manifest.json
git commit -m "Force update: manual sync"
git push origin main
```

---

## 🌟 Avantaje Față de Sistemul Vechi

| Aspecte | Sistemul Vechi | Sistemul NOU |
|---------|----------------|--------------|
| **Timp** | ~5 minute | ~10 secunde |
| **Pași manuali** | 3-4 comenzi | 0 (automat) |
| **Risc de eroare** | Mare (introducere manuală) | Minim (citește din CSV) |
| **Integrare** | Separat de build | Integrat în workflow |
| **Experiență** | Trebuie să îți amintești comenzile | Automat la F5 |
| **Flexibilitate** | O singură extragere | Detectează toate diferențele |

---

## 💡 Viitor: Next Level

### **Nivel 1: Web Scraping Automat**
Script care descarcă automat CSV-urile de pe site-ul oficial:
```bash
# Rulează automat joi/duminică la 22:00
0 22 * * 4,0 /path/to/scrape_and_sync.sh
```

### **Nivel 2: GitHub Actions**
Automatizare completă în cloud - zero dependență de laptop-ul tău!

### **Nivel 3: Real-time Sync**
File watcher care detectează modificări și publică instant:
```bash
fswatch assets/data/*.csv | xargs -n1 ./auto_sync_draws.sh
```

---

## 📞 Suport

**Verifică statusul:**
```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
git status
git log --oneline -5
```

**Rollback dacă e necesar:**
```bash
git reset --hard HEAD~1
git push origin main --force
```

---

## ✅ Checklist Final

- [x] Scripturile create și executabile
- [x] Tasks.json configurat
- [x] Sistemul testat și funcțional
- [x] Documentație completă
- [x] Git push-uit pe GitHub

**TOTUL ESTE GATA! Poți începe să folosești sistemul automat! 🎉**

---

**🎯 REMEMBER: Doar adaugi extrageri în `assets/data/` și apeși F5. Restul este AUTOMAT! ✨**
