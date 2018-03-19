//@ts-check

const DIR = `${__dirname}/../useful-commands`;

let fs = require('fs');

let fileContentCache = {},
	fileNames = [];

reload();
module.exports = { reload, getFileNames, readEach };

function clearFileContentCache() {
	fileContentCache = {};
}

function reload() {
	clearFileContentCache();
	try {
		fileNames = fs.readdirSync(DIR).filter(fileName => fileName.endsWith('.sh'));
	} catch (e) {
		console.error(e.stack);
		return false;
	}
	return true;
}

/**
 * @param {string} [keyword]
 * @returns {Array<string>}
 */
function getFileNames(keyword) {
	return keyword ? fileNames.filter(fileName => fileName.indexOf(keyword) >= 0) : fileNames;
}

/**
 * @param {Array<string>} fileNames
 * @param {(content: string, fileName: string) => any} callback
 */
function readEach(fileNames, callback) {
	fileNames.forEach( fileName => {
		if (fileContentCache[fileName])
			return callback(fileContentCache[fileName], fileName);
		let content = '';
		try {
			content = fs.readFileSync(`${DIR}/${fileName}`, 'utf8');
			fileContentCache[fileName] = content;
		} catch (e) {
			console.error(e);
		}
		return callback(content, fileName);
	});
}
