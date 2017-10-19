let { OutputChannel } = require('./output_channel/console'),
	{ Arguments } = require('./arguments'),
	{ getFileNames } = require('./files'),
	query = require('./query');

function main(args) {

	let app = new Arguments(args);

	if (app.isLaunchForTest()) return testMain();
	if (app.isLaunchForHelp()) return require('./help').print();	
	
	app.parse();

	//empty query. just print command files list
	if (app.isEmptyQuery())
		return console.log(`\nUseful Linux Command Files:\n  ${getFileNames().join('\n  ')}\n`);
	
	let isMini = app.getMiniOutput();
	let outputChannel = new OutputChannel();
	outputChannel.setMiniOutput(isMini);
	
	return query(
		app.getQueryString(),
		app.getFileNameLimit(),
		isMini ? 0 : app.getLinesBeforeCount(),
		isMini ? 1 : app.getLinesAfterCount(),
		outputChannel);
}

//@Test
function testMain() {
	console.log('Test success!');
}
module.exports = { main, testMain };