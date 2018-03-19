//@ts-check
/// <reference path="./output-channel/index.d.ts" />

let files = require('./files');

const COMMENT_LINE = /^\s*#/;

/**
 * @param {string} queryString
 * @param {string} fileNameLimit
 * @param {number} linesBeforeCount
 * @param {number} linesAfterCount
 * @param {OutputChannel} outputChannel
 */
function query(queryString, fileNameLimit, linesBeforeCount, linesAfterCount, outputChannel) {
	let originalQueryArray = queryString ? queryString.split('+') : [];
	outputChannel.printQueryInfo(originalQueryArray, fileNameLimit);

	let queryArray = originalQueryArray.map(q => q.toLowerCase());

	files.readEach(files.getFileNames(fileNameLimit), (content, file) => {
		let lines = content.split('\n');
		let fileContext = {
			fileName: file,
			fileLines: lines
		};
		let channel = new OutputChannelWrapper(outputChannel);

		for (var i = 0; i < lines.length; i++) {
			let line = lines[i].toLowerCase(), ok = true;
			queryArray.forEach(q => ok = (line.indexOf(q) >= 0 && ok));
			ok && channel.outputLines(i, originalQueryArray, linesBeforeCount, linesAfterCount, fileContext);
		}
	});

	outputChannel.finish();
};

/**
 * @constructor OutputChannelWrapper
 * @param {object} outputChannel
 */
function OutputChannelWrapper(outputChannel) {

	let lastFileName = '', lineRepeatMark = {}, lastOutputLine = -1;

	/**
	 *
	 * @param {number} targetLineNumber
	 * @param {Array<string>} keywords
	 * @param {number} linesBeforeCount
	 * @param {number} lineAfterCount
	 * @param {{fileName: string, fileLines: string[]}} fileInfo
	 */
	function outputLines(targetLineNumber, keywords, linesBeforeCount, lineAfterCount, fileInfo) {
		let { fileName, fileLines } = fileInfo;

		let from = Math.max(targetLineNumber - linesBeforeCount, 0);
		let to = Math.min(targetLineNumber + lineAfterCount, fileLines.length);

		let pointer = from;
		let highlightRegex = getHighLightRegexpFromKeywordsArray(keywords);

		if (fileName != lastFileName) {
			//new file
			outputChannel.printFilenameDividingLine(fileName);
			lastFileName = fileName;
			lineRepeatMark = {};
			lastOutputLine = from;
		}
		if (from > lastOutputLine)
			outputChannel.printMoreEllipsis();

		while (pointer < to) {
			if (!lineRepeatMark[pointer]) {

				let line = fileLines[pointer];
				if (line.match(COMMENT_LINE))
					outputChannel.printCommentLine(line, highlightRegex);
				else
					outputChannel.printLine(line, highlightRegex);

				lineRepeatMark[pointer] = true;
				lastOutputLine = pointer;
			}
			pointer++;
		}
	}

	this.outputLines = outputLines;
}

function getHighLightRegexpFromKeywordsArray(keywords) {
	return new RegExp('(' + keywords.map(keyword =>
		keyword.replace(/[\*\+\?\(\)\[\]\{\}\.\|]/g, _ => `\\${_}`)
	).join('|') + ')', 'ig');

}

module.exports = query;
