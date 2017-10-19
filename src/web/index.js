let Program = require('commander');
let Express = require('express'),
	Log = require("morgan"),
	favicon = require('serve-favicon'),
	QueryString = require('querystring'),
	forWgetCURL = require('./for_wget_or_curl'),
	forBrowser = require('./for_browser'),
	forDownloadInstallScript = require('./for_download_install_script');

let Config = require('./config');

Program
	.version(require('../../package.json'))
	.usage('[options]')
	.description('Useful linux commands web query server')
	.option('-p, --port <port>', `Specifying the port is server listening on(default: ${Config.port})`)
	.option('-h, --host <host>', `Specifying the host is server listening on(default: ${Config.host})`)
	.parse(process.argv);

Config.port = parseInt(Program.port) || Config.port;
Config.host = Program.host || Config.host;
 

let app = Express();

// limit query string length
app.set('query parser', qs => QueryString.parse(qs, null, null, { maxKeys: 8 }));

// set up template engine and files
app.engine('html', require('ejs').__express);
app.set('view engine', 'html');
app.set('views',  Config.views);


app.use(Log('dev'));

app.use(favicon(`${Config.favicon}`));
app.use('/static', Express.static(Config.static));

app.use(forDownloadInstallScript);

app.use((req, res) => {
	let ua = req.header('user-agent');
	isFromCURLorWGET(ua) ?
		forWgetCURL.handler(req, res) :
		forBrowser.handler(req, res);
});

app.use((err, req, res, next) => {
	console.error(err && (err.stack ? err.stack : err));
	
	res.status(500);
	res.write(`500: One day you'll leave this world behind. So live a life you will remember.`);
	res.end();
});


let server = require('http').createServer(app);
server.listen(Config.port, Config.host);
server.on('listening', () => console.log(`Server is listening on ${Config.host}:${Config.port}`));


// Functions
const WGET_CURL_UA_MATCHER = /^(?:Wget|curl)/i;
function isFromCURLorWGET(ua = '') { return ua.match(WGET_CURL_UA_MATCHER); }