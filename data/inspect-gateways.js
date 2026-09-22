const http = require('http');

const ALL_PROVIDERS = [
  // 18 Gateways & Engine Nodes
  { name: 'LiteLLM Proxy Gateway', model: 'openai-compatible-litellm/gpt-4o' },
  { name: 'One API Gateway', model: 'openai-compatible-one-api/gpt-4o' },
  { name: 'New API Gateway', model: 'openai-compatible-new-api/gpt-4o' },
  { name: 'Bifrost AI Gateway', model: 'openai-compatible-bifrost/gpt-4o' },
  { name: 'Portkey AI Gateway', model: 'openai-compatible-portkey/gpt-4o' },
  { name: 'LLM Gateway Local', model: 'openai-compatible-llmgateway/gpt-4o' },
  { name: 'BricksLLM Gateway', model: 'openai-compatible-bricksllm/gpt-4o' },
  { name: 'GPT4Free (G4F) Local', model: 'openai-compatible-g4f/gpt-4o' },
  { name: 'GPT4Free Groq', model: 'g4f-groq/llama-3.3-70b-versatile' },
  { name: 'GPT4Free Gemini', model: 'g4f-gemini/gemini-2.0-flash' },
  { name: 'GPT4Free Pollinations', model: 'g4f-pollinations/openai' },
  { name: 'GPT4Free Ollama', model: 'g4f-ollama/llama3.3:latest' },
  { name: 'GPT4Free NVIDIA', model: 'g4f-nvidia/meta/llama-3.3-70b-instruct' },
  { name: 'UnoRouter', model: 'unorouter/meta-llama/llama-3.3-70b-instruct:free' },
  { name: 'ProxyGateLLM Gateway', model: 'openai-compatible-proxygate/gpt-4o' },
  { name: 'Helicone AI Gateway', model: 'openai-compatible-helicone/gpt-4o' },
  { name: 'Langfuse AI Gateway', model: 'openai-compatible-langfuse/gpt-4o' },
  { name: 'MLflow AI Gateway', model: 'openai-compatible-mlflow/gpt-4o' },
  { name: 'Kong AI Gateway', model: 'openai-compatible-kong/gpt-4o' },
  { name: 'Pezzo AI Gateway', model: 'openai-compatible-pezzo/gpt-4o' },
  { name: 'Ollama Local Engine', model: 'ollama-local/llama3.3:latest' },
  { name: 'vLLM Local Server', model: 'vllm/Llama-3.3-70B-Instruct' },
  { name: 'Pangolin AI Gateway', model: 'openai-compatible-pangolin/gpt-4o' },

  // Antigravity & Zero-Config Free Stack Models
  { name: 'Antigravity Gemini 3.7 Flash', model: 'agy/gemini-3.7-flash-high' },
  { name: 'Antigravity Claude Opus', model: 'agy/claude-opus-4-6-thinking' },
  { name: 'Antigravity Claude Sonnet', model: 'agy/claude-sonnet-4-6' },
  { name: 'Antigravity GPT-OSS', model: 'agy/gpt-oss-120b-medium' },
  { name: 'OpenCode Zen', model: 'opencode-zen/gemini-2.0-flash' },
  { name: 'OpenRouter Free Auto', model: 'openrouter/auto' },
  { name: 'Api.Airforce Free', model: 'af/chatgpt-4o-latest' },
  { name: 'LLM7.io Free', model: 'llm7/gpt-4o-mini' },
  { name: 'Dahl Free', model: 'dahl/gpt-4o-mini' },
  { name: 'FreeModel.dev', model: 'fmd/gpt-4o-mini' },
  { name: 'OpenAdapter', model: 'oad/gpt-4o-mini' },
  { name: 'ZenMux', model: 'zm/gpt-4o-mini' },
  { name: 'Pollinations AI', model: 'pol/openai' },
  { name: 'NaraRouter', model: 'nara/gemini-2.0-flash' },
  { name: 'RouteWay', model: 'routeway/gpt-4o-mini' },
  { name: 'DGrid', model: 'dgrid/gpt-4o-mini' },
  { name: 'AgentRouter', model: 'agentrouter/gpt-4o-mini' },
  { name: 'DeepSeek Direct', model: 'deepseek/deepseek-chat' },

  // Standard Universal Models (Resolved via OmniRoute Model Combo Mappings to free-stack)
  { name: 'OmniRoute free-stack combo', model: 'free-stack' },
  { name: 'Universal GPT-4o', model: 'gpt-4o' },
  { name: 'Universal GPT-4o-mini', model: 'gpt-4o-mini' },
  { name: 'Universal Claude 3.5 Sonnet', model: 'claude-3-5-sonnet' },
  { name: 'Universal Claude 3.5 Haiku', model: 'claude-3-5-haiku' },
  { name: 'Universal Gemini 2.0 Flash', model: 'gemini-2.0-flash' },
  { name: 'Universal DeepSeek R1', model: 'deepseek-r1' },
  { name: 'Universal LLaMA 3.3 70B', model: 'llama-3.3-70b' },
  { name: 'Universal Qwen 2.5 Coder 32B', model: 'qwen-2.5-coder-32b' },
  { name: 'Universal Mistral Small', model: 'mistral-small' }
];

async function testModelDirectlyViaOmniRoute(item) {
  return new Promise((resolve) => {
    const start = Date.now();
    const data = JSON.stringify({
      model: item.model,
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
        resolve({
          name: item.name,
          model: item.model,
          status: res.statusCode,
          elapsed: elapsed + 'ms',
          ok: res.statusCode === 200,
          body: body.substring(0, 150)
        });
      });
    });

    req.on('error', (err) => {
      resolve({ name: item.name, model: item.model, error: err.message, ok: false });
    });

    req.write(data);
    req.end();
  });
}

(async () => {
  console.log('======================================================================');
  console.log('   DEEP 1-BY-1 VERIFICATION OF ALL MODELS THROUGH OMNIROUTE (20128)');
  console.log('======================================================================\n');
  let passed = 0;
  let failed = 0;

  for (const item of ALL_PROVIDERS) {
    const res = await testModelDirectlyViaOmniRoute(item);
    if (res.ok) {
      passed++;
      console.log(`[PASS] ${item.name.padEnd(28)} | Model: ${item.model.padEnd(46)} | Status: 200 (${res.elapsed})`);
    } else {
      failed++;
      console.log(`[FAIL] ${item.name.padEnd(28)} | Model: ${item.model.padEnd(46)} | Status: ${res.status || res.error} (${res.elapsed || 'N/A'})`);
      console.log('       Error Details:', res.body);
    }
  }

  console.log('\n======================================================================');
  console.log(`   FINAL VERIFICATION SUMMARY: ${passed} PASSED / ${failed} FAILED`);
  console.log('======================================================================');
})();
