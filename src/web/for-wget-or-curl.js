let help = require('./help');
let { getFileNames } = require('../files');
let { OutputChannel } = require('../output-channel/wget_curl');
let query = require('../query');

let fileNameMatcher = /^\/(\w+)\//;
let keywordMatcher = /\/([\w\s\.\+]*)$/

function handler(req, res) {
	let path = '/'; path = req.path;
	let colorized = 'color' in req.query;
	let mini = 'mini' in req.query;
	let linesBeforeCount = parseInt(req.query.b);
	let linesAfterCount = parseInt(req.query.a);

	if (isNaN(linesBeforeCount)) linesBeforeCount = 1;
	if (isNaN(linesAfterCount)) linesAfterCount = 5;

	// response help content
	if (path == '/help') {
		help.print(res, colorized);
		return res.end();
	}

	// response file index content
	if (path == '/')
		return printFilesInfo(res);

	//match path
	let fileNameFilter = ''; let keywords = '';
	let match = path.match(fileNameMatcher);
	fileNameFilter = match ? match[1] : null;

	match = path.match(keywordMatcher);
	keywords = match ? match[1] : null;

	if (!keywords && !fileNameFilter)
		return printFilesInfo(res);

	keywords = keywords.replace(/\W/g, '+');
	if (req.app.locals.ENV_DEVELOPMENT)
		console.log(`wget/curl query: "${keywords}" in "${fileNameFilter || '*'}"`)

	let outputChannel = new OutputChannel(res, colorized);
	outputChannel.setMiniOutput(mini);
	query(keywords, fileNameFilter, linesBeforeCount, linesAfterCount, outputChannel);
}

function printFilesInfo(res) {
	res.write(`\nUseful Linux Command Files:\n` +
		`  ${getFileNames().join('\n  ')}\n\n` +
		`More help info:\n  visit "/help"\n\n`);
	return res.end();
}

module.exports = {
	handler
};
