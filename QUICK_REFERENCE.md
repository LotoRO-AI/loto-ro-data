# ⚡ Quick Reference: Actualizare Extrageri

## 🎯 Comanda Rapidă (Copy-Paste)

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data
./publish_draw.sh
```

Apoi urmează prompturile interactive!

---

## 📝 Comenzi cu Parametri (Mai Rapid)

### Joi sau Duminică - Toate Jocurile

```bash
cd /Users/liviu/Downloads/LotoRO/loto-ro-data

# Înlocuiește DATA și NUMERELE cu cele reale!
./publish_draw.sh --game joker --date 2025-12-08 --nums 3,12,23,34,45,7
./publish_draw.sh --game loto649 --date 2025-12-08 --nums 1,2,3,4,5,6
./publish_draw.sh --game loto540 --date 2025-12-08 --nums 3,12,23,34,40
```

---

## ✅ Verificare Rapidă

```bash
# Verifică că push-ul a reușit
git log --oneline -1

# Verifică manifestul (după 2-3 min)
curl -s https://LotoRO-AI.github.io/loto-ro-data/archive-manifest.json | grep version
```

---

## 🔧 Format Numere

| Joc    | Format Exemplu           | Numere Totale |
|--------|--------------------------|---------------|
| Joker  | `3,12,23,34,45,7`        | 5 + 1 Joker   |
| 6/49   | `1,2,3,4,5,6`            | 6 numere      |
| 5/40   | `3,12,23,34,40`          | 5 numere      |

**⚠️ Fără spații între numere!**

---

## 🆘 Probleme Comune

### Script nu se execută
```bash
chmod +x publish_draw.sh
```

### Git push eșuează
```bash
git remote -v
# Verifică că arată: origin  https://github.com/LotoRO-AI/loto-ro-data.git
```

### Rollback la ultima versiune
```bash
git reset --hard HEAD~1
git push origin main --force
```

---

## 📱 Ce Văd Utilizatorii?

- **Automat la pornirea aplicației**: Noile extrageri apar!
- **Fără acțiuni manuale necesare** pentru ei!
- **2-3 minute delay** după ce tu faci push

---

## 📖 Documentație Completă

Pentru detalii: `GHID_ACTUALIZARE_EXTRAGERI.md`

---

**🍀 Baftă la actualizări!**
