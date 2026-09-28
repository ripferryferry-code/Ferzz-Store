const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const PORT = process.env.PORT || 3000;
const ADMIN_SECRET = process.env.ADMIN_SECRET || "CHANGE_ME";

const DB_FILE = path.join(__dirname, "keys.json");

function loadKeys() {
  try {
    return JSON.parse(fs.readFileSync(DB_FILE, "utf8"));
  } catch {
    return {};
  }
}

function saveKeys(keys) {
  fs.writeFileSync(DB_FILE, JSON.stringify(keys, null, 2));
}

function makeKey() {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const part = (n) => {
    let s = "";
    for (let i = 0; i < n; i++) {
      s += chars[Math.floor(Math.random() * chars.length)];
    }
    return s;
  };
  return `FS-${part(5)}-${part(5)}-${part(5)}`;
}

function expiryFor(plan) {
  const now = Date.now();
  if (plan === "1d") return now + 24 * 60 * 60 * 1000;
  if (plan === "1m") return now + 30 * 24 * 60 * 60 * 1000;
  if (plan === "perm") return null;
  return undefined;
}

function admin(req, res, next) {
  if (req.headers["x-admin-secret"] !== ADMIN_SECRET) {
    return res.status(401).json({ ok: false, error: "Unauthorized" });
  }
  next();
}

// Check key from Roblox
app.get("/api/validate", (req, res) => {
  const key = String(req.query.key || "").trim().toUpperCase();
  const keys = loadKeys();
  const item = keys[key];

  if (!item) {
    return res.json({ ok: false, error: "invalid" });
  }

  if (item.expiresAt !== null && Date.now() >= item.expiresAt) {
    return res.json({
      ok: false,
      error: "expired",
      expiresAt: item.expiresAt
    });
  }

  res.json({
    ok: true,
    key,
    plan: item.plan,
    expiresAt: item.expiresAt
  });
});

// Create keys from admin panel
app.post("/api/admin/create", admin, (req, res) => {
  const plan = req.body.plan;
  const count = Math.max(1, Math.min(50, Number(req.body.count) || 1));

  if (!["1d", "1m", "perm"].includes(plan)) {
    return res.status(400).json({ ok: false, error: "Invalid plan" });
  }

  const keys = loadKeys();
  const created = [];

  for (let i = 0; i < count; i++) {
    let key;
    do {
      key = makeKey();
    } while (keys[key]);

    keys[key] = {
      plan,
      createdAt: Date.now(),
      expiresAt: expiryFor(plan),
      revoked: false
    };

    created.push({
      key,
      plan,
      expiresAt: keys[key].expiresAt
    });
  }

  saveKeys(keys);
  res.json({ ok: true, keys: created });
});

// Revoke a key
app.post("/api/admin/revoke", admin, (req, res) => {
  const key = String(req.body.key || "").trim().toUpperCase();
  const keys = loadKeys();

  if (!keys[key]) {
    return res.status(404).json({ ok: false, error: "Key not found" });
  }

  keys[key].revoked = true;
  saveKeys(keys);
  res.json({ ok: true });
});

// List keys
app.get("/api/admin/list", admin, (req, res) => {
  res.json({ ok: true, keys: loadKeys() });
});

app.get("/health", (req, res) => {
  res.json({ ok: true, service: "FERZZ STORE API" });
});

app.listen(PORT, () => {
  console.log(`FERZZ STORE API running on port ${PORT}`);
});
