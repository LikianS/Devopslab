const http = require('http');
const server = http.createServer((req, res) => {
res.end('DevOps Base!\n');
});
server.listen(8080, () => {
console.log('Listening on port 8080');
});
