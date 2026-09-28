# FERZZ STORE Key Backend

Backend untuk:
- Generate key 1 Day / 1 Month / Permanent
- Validasi key dari Roblox
- Expiry otomatis
- Revoke key
- Admin secret

## Upload ke GitHub

Upload isi folder ini ke root repo `Ferzz-Store`:
- server.js
- package.json
- keys.json
- .gitignore
- .env.example

JANGAN upload `.env` yang berisi Admin Secret.

## Deploy ke Render

Buat Web Service dari repo GitHub.

Build Command:
npm install

Start Command:
npm start

Environment Variable:
ADMIN_SECRET = buat secret rahasia sendiri

Contoh:
FERZZ-ADMIN-8K2P-X91M

Setelah deploy, Render akan memberi URL seperti:
https://nama-service.onrender.com

URL itulah yang dimasukkan ke API_URL pada generator HTML dan FERZZ_KEY_UI.lua.

## Endpoint

GET /health
GET /api/validate?key=FS-XXXXX-XXXXX-XXXXX

POST /api/admin/create
Header:
x-admin-secret: ADMIN_SECRET

Body:
{"plan":"1d","count":1}

Plan:
1d = 1 Day
1m = 1 Month
perm = Permanent

Catatan:
Versi ini memakai `keys.json` sebagai penyimpanan sederhana. Untuk produksi/jualan dengan banyak data, gunakan database/persistent disk agar data key tidak hilang ketika service diredeploy.
