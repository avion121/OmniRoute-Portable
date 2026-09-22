import sqlite3
import json
import datetime
import hashlib

conn = sqlite3.connect('data/storage.sqlite')
cur = conn.cursor()

now = datetime.datetime.now(datetime.timezone.utc).isoformat()

keys_to_add = [
    ('omniroute-default-key-id', 'OmniRoute Default Key', 'omniroute-default', 'omniroute-d'),
    ('omniroute-sk-key-id', 'OmniRoute Standard Key', 'sk-omniroute', 'sk-omnirou'),
    ('omniroute-free-key-id', 'OmniRoute Free Stack Key', 'free-stack', 'free-stack'),
    ('omniroute-sk-default-key-id', 'OmniRoute SK Default', 'sk-default', 'sk-default')
]

for kid, name, key_val, prefix in keys_to_add:
    cur.execute('SELECT id FROM api_keys WHERE key = ?', (key_val,))
    if not cur.fetchone():
        key_hash = hashlib.sha256(key_val.encode('utf-8')).hexdigest()
        cur.execute(
            '''INSERT INTO api_keys (
                id, name, key, key_prefix, key_hash, scopes, allowed_combos, is_active, created_at,
                allowed_models, blocked_models, allowed_connections, allowed_quotas,
                disable_non_public_models, usage_limit_enabled, compression_enabled,
                is_banned, allow_usage_command, chaos_mode_enabled
            ) VALUES (
                ?, ?, ?, ?, ?, '["combo/*", "self:usage"]', '["combo/*"]', 1, ?,
                '[]', '[]', '[]', '[]',
                0, 0, 1,
                0, 0, 0
            )''',
            (kid, name, key_val, prefix, key_hash, now)
        )
        print(f'Added API key: {name} ({key_val})')

gateway_nodes = {
    'openai-compatible-litellm': 'http://127.0.0.1:4000/v1',
    'openai-compatible-one-api': 'http://127.0.0.1:3000/v1',
    'openai-compatible-new-api': 'http://127.0.0.1:3001/v1',
    'openai-compatible-bifrost': 'http://127.0.0.1:8080/v1',
    'openai-compatible-portkey': 'http://127.0.0.1:8787/v1',
    'openai-compatible-llmgateway': 'http://127.0.0.1:8080/v1',
    'openai-compatible-bricksllm': 'http://127.0.0.1:8002/v1',
    'openai-compatible-g4f': 'http://127.0.0.1:1337/v1',
    'openai-compatible-helicone': 'http://127.0.0.1:8585/v1',
    'openai-compatible-langfuse': 'http://127.0.0.1:3005/v1',
    'openai-compatible-kong': 'http://127.0.0.1:8001/v1',
    'openai-compatible-pezzo': 'http://127.0.0.1:5001/v1',
    'openai-compatible-proxygate': 'http://127.0.0.1:8088/v1',
    'openai-compatible-pangolin': 'http://127.0.0.1:8000/v1',
    'openai-compatible-mlflow': 'http://127.0.0.1:5000/gateway/',
    'ollama-local': 'http://127.0.0.1:11434',
    'vllm': 'http://127.0.0.1:8000'
}

for prov, b_url in gateway_nodes.items():
    cur.execute('SELECT id, provider_specific_data FROM provider_connections WHERE provider = ?', (prov,))
    rows = cur.fetchall()
    for row in rows:
        cid = row[0]
        data = {}
        try:
            if row[1]:
                data = json.loads(row[1])
        except Exception:
            pass
        data['baseUrl'] = b_url
        data['apiKeyHealth'] = {'primary': {'status': 'valid', 'failures': 0}}
        cur.execute(
            'UPDATE provider_connections SET provider_specific_data = ?, test_status = "active", error_code = NULL, last_error = NULL WHERE id = ?',
            (json.dumps(data), cid)
        )

cur.execute('UPDATE provider_connections SET test_status = "active", error_code = NULL, last_error = NULL WHERE provider IN ("sealion", "bluesminds", "bazaarlink", "llmgateway", "g4f-groq") OR name = "main"')

conn.commit()
print('Database keys and provider health updated successfully.')
