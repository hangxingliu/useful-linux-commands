//@ts-check

let Program = require('commander');
let Express = require('express'),
	Log = require("morgan"),
	favicon = require('serve-favicon'),
	QueryString = require('querystring'),
	forWgetCURL = require('./for-wget-or-curl'),
	forBrowser = require('./for-browser'),
	forDownloadInstallScript = require('./for-download-install-script');

let fs = require('fs');

let config = require('./config');

Program
	//@ts-ignore
	.version(require('../../package.json').version)
	.usage('[options]')
	.description('Useful linux commands web query server')
	.option('-p, --port <port>', `Specifying the port is server listening on(default: ${config.port})`)
	.option('    --host <host>', `Specifying the host is server listening on(default: ${config.host})`)
	.parse(process.argv);

const env = process.env.NODE_ENV || 'development';
const port = parseInt(Program.port) || parseInt(process.env.PORT) || config.port;
const host = Program.host || config.host;


let app = Express();
app.set('port', port);
app.locals.ENV = env;
app.locals.ENV_DEVELOPMENT = env == 'development';

console.log('Useful Linux Commands Web Query Server: ');
console.log(`  NODE_ENV: ${env}`);
console.log(`  host:port: ${host}:${port}`);
console.log('');

// limit query string length
app.set('query parser', qs => QueryString.parse(qs, null, null, { maxKeys: 8 }));

// set up template engine and files
//@ts-ignore
app.engine('html', require('ejs').__express);
app.set('view engine', 'html');
app.set('views',  config.views);

// TODO: better log control by env environment or launch option
app.use(Log('dev'));

app.use(favicon(`${config.favicon}`));
app.use('/static', Express.static(config.static));

app.use(forDownloadInstallScript);

app.use((req, res, next) => {
	let ua = req.header('user-agent') || '';
	ua.match(/^(?:Wget|curl)/i) ?
		forWgetCURL.handler(req, res) :
		forBrowser.handler(req, res, next);
});

// ==============
//   wwwroot
if (!fs.existsSync(config.wwwroot))
	fs.mkdirSync(config.wwwroot);
app.use('/', Express.static(config.wwwroot));

// 404
app.use((req, res) => {
	res.status(404);
	res.write('All this time I was finding myself. And I didn\'t know I was lost');
	return res.end();
})

// 500
app.use((err, req, res, next) => {
	void next; // ignore unused next function

	console.error(err && (err.stack ? err.stack : err));

	res.status(500);
	res.write(`500: One day you'll leave this world behind. So live a life you will remember.`);
	res.end();
});


let server = require('http').createServer(app);
host ? server.listen(port, host) : server.listen(port);

server.on('listening', () => {
	console.log(`Server is listening on ${host||''}:${port}`);
	if (host)
		console.log(`  Visit: http://${host}:${port}`);
});
