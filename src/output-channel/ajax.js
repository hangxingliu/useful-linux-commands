//@ts-check
/// <reference path="./index.d.ts" />

/**
 * @param {MinimizedExpressResponse} res
 */
function OutputChannel(res) {
	let output = {
		query: {
			keyword: [],
			filename: ''
		},
		files: [

		]
	};
	let initFile = (name = '') => ({
		name,
		contents: [''],
	});
	let currentFile = initFile();

	function setMiniOutput(_miniOutput) { return _miniOutput; }
	function getMiniOutput() { return false; }

	function printQueryInfo(keywordsArray, fileNameLimit) {
		output.query.keyword = keywordsArray.length ? keywordsArray : ['all content'];
		if (fileNameLimit)
			output.query.filename = '*' + fileNameLimit + '*';
	}

	function printFilenameDividingLine(fileName) {
		if (currentFile.name)
			output.files.push(currentFile);

		currentFile = initFile(fileName);
	}

	function printMoreEllipsis() {
		currentFile.contents.push('...', '');
	}

	function printCommentLine(content /*, highlightRegexp*/) {
		let { contents } = currentFile;
		contents[contents.length - 1] += content + '\n';
	}

	function printLine(content/*, highlightRegexp*/) {
		let { contents } = currentFile;
		contents[contents.length - 1] += content + '\n';
	}

	function finish() {
		if (currentFile.name)
			output.files.push(currentFile);

		res.json(output);
		res.end();
	}

	//export public methods
	this.getMiniOutput = getMiniOutput;
	this.setMiniOutput = setMiniOutput
	this.printQueryInfo = printQueryInfo
	this.printFilenameDividingLine = printFilenameDividingLine
	this.printMoreEllipsis = printMoreEllipsis
	this.printCommentLine = printCommentLine
	this.printLine = printLine
	this.finish = finish
}

module.exports = { OutputChannel };
