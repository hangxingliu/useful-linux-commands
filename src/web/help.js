/*
START>>>

# Useful Linux Commands Help Manual(for web query)

# Query Syntax

`   /word
`   /word1+word2
`   /filename/word
`   /filename/word1+word2

# More Query Option

`   b=${linesBeforeCount: number}
`   a=${linesAfterCount: number}
`   mini
`   color

# Examples

`   /ssh/rsync?mini
       query all "rsync" in file "*ssh*". and minified output
`   /yum?b=0&a=5
       query all "yum". and output 0 lines before keyword and 5 lines after keyword

# Useful Installers (download and "bash ${name}")

`   /init
		Init software and environment in a new Linux OS
`   /nodejs
		Install Nodejs , NODE_PATH and pm2 in one step

<<<END
*/

let contentWithColor = [];
let contentWithoutColor = [];

(function init() {
	let lines = require('fs').readFileSync(__filename, 'utf8').split('\n');
	let enable = false;
	for (const line of lines) {
		if (!enable) {
			if (line.trim() == 'START>>>')
				enable = true;
			continue;
		}
		if (enable && line.trim() == '<<<END') {
			enable = false;
			break;
		}
		switch (line[0]) {
			case '#': addTitleLine(line.slice(1)); break;
			case '`': addCodeLine(line.slice(1)); break;
			case '>': addNormalLine(line.slice(1)); break;
			default: addNormalLine(line);
		}
	}
	contentWithColor = contentWithColor.join('\n');
	contentWithoutColor = contentWithoutColor.join('\n');

	function addTitleLine(text) {
		contentWithColor.push(`\u001b[1m${text}\u001b[22m`);
		contentWithoutColor.push(text);
	}
	function addCodeLine(text) {
		contentWithColor.push(`\u001b[37m${text}\u001b[39m`);
		contentWithoutColor.push(text);
	}
	function addNormalLine(text) {
		contentWithColor.push(text);
		contentWithoutColor.push(text);
	}
})();


module.exports = {
	print: (res, colorized) => res.write(colorized ? contentWithColor : contentWithoutColor)
};
