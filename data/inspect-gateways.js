const http = require('http');

const GATEWAY_TESTS = [
  { port: 4000, name: 'LiteLLM Proxy Gateway' },
  { port: 3000, name: 'One API Gateway' },
  { port: 3001, name: 'New API Gateway' },
  { port: 8080, name: 'Bifrost & LLM Gateway' },
  { port: 8787, name: 'Portkey AI Gateway' },
  { port: 8002, name: 'BricksLLM Gateway' },
  { port: 1337, name: 'GPT4Free (G4F) Server' },
  { port: 8585, name: 'Helicone AI Gateway' },
  { port: 3005, name: 'Langfuse AI Gateway' },
  { port: 5000, name: 'MLflow AI Gateway' },
  { port: 8001, name: 'Kong AI Gateway' },
  { port: 5001, name: 'Pezzo AI Gateway' },
  { port: 11434, name: 'Ollama Local Engine' },
  { port: 8000, name: 'vLLM / Pangolin Gateway' },
  { port: 8088, name: 'ProxyGateLLM Gateway' }
];

async function testGateway(port, name) {
  return new Promise((resolve) => {
    const start = Date.now();
    const data = JSON.stringify({
      model: 'free-stack',
      messages: [{ role: 'user', content: 'test probe' }],
      stream: false
    });

    const path = port === 11434 ? '/api/chat' : (port === 5000 ? '/gateway/invocations' : '/v1/chat/completions');

    const req = http.request(`http://127.0.0.1:${port}${path}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data),
        'Authorization': 'Bearer test-token'
      },
      timeout: 5000
    }, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        const elapsed = Date.now() - start;
        resolve({ port, name, status: res.statusCode, elapsed: `${elapsed}ms`, ok: res.statusCode === 200 });
      });
    });

    req.on('error', (err) => {
      resolve({ port, name, error: err.message, ok: false });
    });

    req.write(data);
    req.end();
  });
}

async function testOmniRouteModel(modelName) {
  return new Promise((resolve) => {
    const start = Date.now();
    const data = JSON.stringify({
      model: modelName,
      messages: [{ role: 'user', content: 'Ping' }],
      stream: false
    });

    const req = http.request('http://127.0.0.1:20128/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data),
        'Authorization': 'Bearer omniroute-default'
      },
      timeout: 15000
    }, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        const elapsed = Date.now() - start;
        resolve({ model: modelName, status: res.statusCode, elapsed: `${elapsed}ms`, ok: res.statusCode === 200 });
      });
    });

    req.on('error', (err) => {
      resolve({ model: modelName, error: err.message, ok: false });
    });

    req.write(data);
    req.end();
  });
}

(async () => {
  console.log('======================================================================');
  console.log('   VERIFYING ALL 15 LOCAL AI GATEWAY LISTENERS & ROUTING');
  console.log('======================================================================');
  for (const gw of GATEWAY_TESTS) {
    const res = await testGateway(gw.port, gw.name);
    console.log(`[${res.ok ? 'OK' : 'FAIL'}] Port ${res.port.toString().padEnd(5)} | ${res.name.padEnd(28)} | Status: ${res.status || res.error} (${res.elapsed || 'N/A'})`);
  }

  console.log('\n======================================================================');
  console.log('   VERIFYING OMNIROUTE CORE PROXY MODEL PATTERN RESOLUTION');
  console.log('======================================================================');
  const testModels = [
    'free-stack',
    'gpt-4o',
    'gpt-4o-mini',
    'claude-3-5-sonnet',
    'claude-3-5-haiku',
    'gemini-2.0-flash',
    'deepseek-chat',
    'deepseek-r1',
    'llama-3.3-70b',
    'qwen-2.5-coder-32b',
    'mistral-small'
  ];

  for (const m of testModels) {
    const res = await testOmniRouteModel(m);
    console.log(`[${res.ok ? 'OK' : 'FAIL'}] Model: ${m.padEnd(22)} | Status: ${res.status || res.error} (${res.elapsed || 'N/A'})`);
  }
})();
