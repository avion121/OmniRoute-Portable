const fs = require('fs');
const path = require('path');

const chunksDir = path.join(__dirname, '..', 'bin', 'node_modules', 'omniroute', 'dist', '.build', 'next', 'server', 'chunks');

if (fs.existsSync(chunksDir)) {
  const files = fs.readdirSync(chunksDir);
  const oldCode = 'p=await Promise.all(s.map(e=>b(e,l,d)))';
  const newCode = 'p=await (async()=>{let res=[];if(!o.strategy||o.strategy==="priority"){let found=false;for(let i=0;i<s.length;i++){if(found){res.push(y(s[i],{status:"skipped"}))}else{let r=await b(s[i],l,d);res.push(r);if(r.status==="ok"){found=true}}}}else{res=new Array(s.length);let nextIdx=0;async function worker(){while(nextIdx<s.length){let idx=nextIdx++;res[idx]=await b(s[idx],l,d)}}await Promise.all(Array.from({length:Math.min(5,s.length)},()=>worker()))}return res})()';

  for (const file of files) {
    if (file.endsWith('.js')) {
      const filePath = path.join(chunksDir, file);
      try {
        const content = fs.readFileSync(filePath, 'utf8');
        if (content.includes(oldCode)) {
          const updated = content.replace(oldCode, newCode);
          fs.writeFileSync(filePath, updated, 'utf8');
          console.log(`[Combo Patch] Successfully applied concurrency and priority optimization to ${file}`);
        }
      } catch (err) {
        // Ignore read/write errors for non-matching chunks
      }
    }
  }
}
