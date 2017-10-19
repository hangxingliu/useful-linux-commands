/*
									WARNING!!!
	THIS COMMENT BLOCK WILL BE PRINT WHEN LAUNCHING CLI SCRIPT FOLLOW OPTION `--help`
				SO DO NOT DELETE IT OR REMOVE THIS WARNING TEXT
START>>>

#Useful Linux Commands Help Manual

#Example:

`  useful-commands DNS
>    query commands around DNS

`  useful-commands DNS+Ubuntu
`  useful-commands DNS Ubuntu
>    query commands around DNS and Ubuntu(Match line included 'DNS' and 'Ubuntu')

`  useful-commands DNS -F network    
`  useful-commands DNS -f network
`  useful-commands DNS -fnetwork
>    query commands around DNS in files `*network*`

` useful-commands -fnetwork
>	query all commands(content) in files `*network*`

`  useful-commands DNS -A 10 -B 2
`  useful-commands DNS -a 10 -b 2
`  useful-commands DNS -a10 -b2
>    query commands around DNS, and print content with 2 lines before keyword("DNS") and 10 lines after keyword

`  useful-commands DNS --mini
`  useful-commands DNS -m
>    query commands around DNS, and minify output

`  useful-commands
>    list all commands files

`  useful-commands --help
>    read this document

<<<END
*/

require('colors');

let contentAutoColor = [];

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
	contentAutoColor = contentAutoColor.join('\n');

	function addTitleLine(text) {
		contentAutoColor.push(text.bold);
	}
	function addCodeLine(text) {
		contentAutoColor.push(text.white);
	}
	function addNormalLine(text) {
		contentAutoColor.push(text);
	}
})();

module.exports = {
	print: () => console.log(contentAutoColor),
	getContentAutoColor: () => contentAutoColor,
};