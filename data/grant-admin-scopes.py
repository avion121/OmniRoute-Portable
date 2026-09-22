import sqlite3
import json

conn = sqlite3.connect('G:/DOWNLOADS/OmniRoute-Portable-With-VS-CODE-TUI_CLAUDE-CODE/data/storage.sqlite')
cur = conn.cursor()

admin_scopes = json.dumps(["admin", "manage", "combo/*", "self:usage"])

cur.execute("UPDATE api_keys SET scopes = ?", (admin_scopes,))
conn.commit()
print("Updated all api_keys with admin & manage scopes.")

for row in cur.execute("SELECT id, name, key, scopes FROM api_keys").fetchall():
    print("Row:", row)
