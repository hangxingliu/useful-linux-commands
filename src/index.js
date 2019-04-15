//@ts-check

let colors = require('colors/safe');

const { OutputChannel } = require('./output-channel/console');
const { Arguments } = require('./arguments');
const { getFileNames } = require('./files');
const query = require('./query');

function main(args) {
	let app = new Arguments(args);

	if (app.isLaunchForHelp())
		return require('./help').print();

	app.parse();

	//empty query. just print command files list
	if (app.isEmptyQuery())
		return console.log(`\nUseful Linux Command Files:\n  ${getFileNames().join('\n  ')}\n`);

	let isMini = app.getMiniOutput();
	let outputChannel = new OutputChannel();
	outputChannel.setMiniOutput(isMini);

	let qs = app.getQueryString();
	let fileName = app.getFileNameLimit();
	let linesBefore = app.getLinesBeforeCount();
	let linesAfter = app.getLinesAfterCount();

	if (isMini) {
		linesBefore = 0;
		linesAfter = 1;
	}

	return query(qs, fileName, linesBefore, linesAfter, outputChannel)
		.catch(exception => {
			let stack = String(exception.stack || exception);
			let msg = '\n  fatal: ' + stack.split('\n')
				.map((line, i) => (i > 0 ? `    ${line}` : line))
				.join('\n') + '\n';
			console.error(colors.red(msg));
			process.exit(1);
		});
}

module.exports = { main };
