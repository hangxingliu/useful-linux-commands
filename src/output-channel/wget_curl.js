//@ts-check
function OutputChannel(res, colorized) {
	let output = [];

	let miniOutput = false;

	function setMiniOutput(_miniOutput) { miniOutput = _miniOutput; }
	function getMiniOutput() { return miniOutput; }

	function printQueryInfo(keywordsArray, fileNameLimit) {
		if (miniOutput) return;

		let info = keywordsArray.length
			? keywordsArray.map(kw => colorized ? `\u001b[1m${kw}\u001b[22m` : kw)
				.join('+')
			: 'all content';

		if (fileNameLimit) {
			let fname = '*' + fileNameLimit + '*';
			info += ` in ${colorized ? `\u001b[1m${fname}\u001b[22m` : fname} files`
		}
		output.push(`\nquery: ${info}`);
	}

	function printFilenameDividingLine(fileName) {
		if (miniOutput) return;

		let str = colorized ? `\n\u001b[1m${fileName}\u001b[22m` : `\n${fileName}`;
		output.push(`${str} ---------------------------------\n`);
	}

	function printMoreEllipsis() {
		if (miniOutput) return;

		output.push(colorized ? '\u001b[37m...\u001b[39m' : '...');
	}

	const PREFIX = '> ';
	const PREFIX_COLOR = '\u001b[37m> \u001b[39m';
	function printCommentLine(content, highlightRegexp) {
		if (colorized) {
			content = content.replace(highlightRegexp, _ =>
				`\u001b[22m\u001b[36m${_}\u001b[39m\u001b[2m`); //.cyan
			content = '\u001b[2m' + content + '\u001b[22m'; //.dim
		}
		output.push(miniOutput ? content
			: ((colorized ? PREFIX_COLOR : PREFIX) + content));
	}

	function printLine(content, highlightRegexp) {
		if (colorized)
			content = content.replace(highlightRegexp, _ => `\u001b[36m${_}\u001b[39m`);
		output.push(miniOutput ? content
			: ((colorized ? PREFIX_COLOR : PREFIX) + content));
	}

	function finish() {
		res.write(output.join('\n') + '\n');
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
