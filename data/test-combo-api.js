const http = require('http');

async function callComboTest() {
  return new Promise((resolve) => {
    const data = JSON.stringify({ comboName: 'free-stack' });
    const req = http.request('http://127.0.0.1:20128/api/combos/test', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data),
        'Authorization': 'Bearer omniroute-default'
      },
      timeout: 60000
    }, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        resolve({
          status: res.statusCode,
          body: body
        });
      });
    });

    req.on('error', (err) => {
      resolve({ error: err.message });
    });

    req.write(data);
    req.end();
  });
}

(async () => {
  console.log("Calling /api/combos/test with comboName: 'free-stack'...");
  const start = Date.now();
  const res = await callComboTest();
  console.log("Combo test finished in", Date.now() - start, "ms. Status:", res.status);
  console.log("Response snippet:", res.body.substring(0, 500));
})();
