require('colors');

function OutputChannel() {

	let miniOutput = false;
	
	function setMiniOutput(_miniOutput) { miniOutput = _miniOutput; }
	function getMiniOutput() { return miniOutput; }
	
	function printQueryInfo(keywordsArray, fileNameLimit) {
		if (miniOutput) return;

		let info = keywordsArray.length 
			? keywordsArray.map(kw => kw.bold).join('+')
			: 'all content';

		if (fileNameLimit)
			info += ` in ${('*'+fileNameLimit+'*').bold} files`	
		console.log(`\nquery: ${info}`);
	}
	
	function printFilenameDividingLine(fileName){
		if (miniOutput) return;

		console.log(`\n${fileName.bold} ---------------------------------\n`);
	}

	function printMoreEllipsis(){
		if (miniOutput) return;

		console.log('...'.white);	
	}

	const PREFIX = '> '.white;
	const COLORABLE = 'test'.white != 'test';
	function printCommentLine(content, highlightRegexp){
		if (COLORABLE) {
			content = content.replace(highlightRegexp, _ => '\u001b[22m' + _.cyan + '\u001b[2m');
			content = '\u001b[2m' + content + '\u001b[22m'; //.dim
		}
		console.log(miniOutput ? content : (PREFIX + content));
	}

	function printLine(content, highlightRegexp) {
		content = content.replace(highlightRegexp, _ => _.cyan);
		console.log(miniOutput ? content : (PREFIX + content));
	}

	function finish(){ }

	//export public methods
	this.getMiniOutput = getMiniOutput;
	this.isMiniOutput = getMiniOutput;
	this.setMiniOutput = setMiniOutput
	this.printQueryInfo = printQueryInfo
	this.printFilenameDividingLine = printFilenameDividingLine
	this.printMoreEllipsis = printMoreEllipsis
	this.printCommentLine = printCommentLine
	this.printLine = printLine
	this.finish = finish
}

module.exports = { OutputChannel };