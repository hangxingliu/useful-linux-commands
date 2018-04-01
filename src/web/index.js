//@ts-check

let Program = require('commander');
let express = require('express'),
	log = require("morgan"),
	favicon = require('serve-favicon'),
	queryString = require('querystring'),
	files = require('../files'),
	robotsSitemap = require('./robots-sitemap-generator'),
	forWgetCURL = require('./for-wget-or-curl'),
	forBrowser = require('./for-browser'),
	forDownloadInstallScript = require('./for-download-install-script');

let fs = require('fs'),
	os = require('os'),
	path = require('path'),
	http = require('http');

let config = require('./config');

Program
	//@ts-ignore
	.version(require('../../package.json').version)
	.usage('[options]')
	.description('Useful linux commands web query server')
	.option('-p, --port <port>', `Port server to use (defaults to ${config.port})`)
	.option('-a, --address <address>', `Address server to use (defaults to ${config.address})`)
	.option('-s, --seo-url <url>', `URL prefix for SEO (defaults to ${config.seourl})`)
	.parse(process.argv);

let seoURLRaw = String(process.env.SEO_URL || Program.seoUrl || config.seourl);

const env = process.env.NODE_ENV || 'development';
const port = parseInt(Program.port) || parseInt(process.env.PORT) || config.port;
const address = String(Program.address || config.address);
const seoURL = seoURLRaw.endsWith('/') ? seoURLRaw : (seoURLRaw + '/');

if (!seoURL.match(/^https?:\/\//)) {
	console.log(`fatal:  invalid SEO URL: "${seoURL}"`);
	process.exit(1);
}

let app = express();
app.set('port', port);
app.locals.ENV = env;
app.locals.ENV_DEVELOPMENT = env == 'development';
app.locals.seoURL = seoURL;

let user = os.userInfo();

console.log('Useful Linux Commands Web Query Server: ');
console.log(`  NODE_ENV:  ${env}`);
console.log(`  userInfo:  uid=${user.uid} gid=${user.gid} username=${user.username} shell=${user.shell}`);
console.log(`  host:port: ${address}:${port}`);
console.log(`  seoURL:    ${seoURL}`);
console.log('');

// limit query string length
app.set('query parser', qs => queryString.parse(qs, null, null, { maxKeys: 8 }));

// set up template engine and files
//@ts-ignore
app.engine('html', require('ejs').__express);
app.set('view engine', 'html');
app.set('views',  config.views);

// TODO: better log control by env environment or launch option
app.use(log('dev'));

app.use(favicon(`${config.favicon}`));
app.use('/static', express.static(config.static));

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
app.use('/', express.static(config.wwwroot));

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

initRobotsAndSiteMap()
	.then(startServer)
	.catch(error => console.error(`fatal: ${String(error.stack||error.message||error)}`));

function initRobotsAndSiteMap() {
	robotsSitemap.init(seoURL);

	let fileNames = files.getFileNames(), metas = [];
	return robotsSitemap.bindFile('/', path.join(config.views, 'index-min.html'))
		.then(() => files.iterateFiles(fileNames, (_, __, meta) => metas.push(meta)))
		.then(() => robotsSitemap.bindAllFiles(fileNames, metas))
		.then(() => robotsSitemap.generate(config.wwwroot))
		.then(() => console.log(`- Generated robots.txt and sitemap.xml into directory ` +
			`${path.relative(process.cwd(), config.wwwroot)}`));
}

function startServer() {
	let server = http.createServer(app);
	server.listen(port, address);
	server.on('listening', () => console.log(`- Server started, you can visit: ${seoURL}`));
}
