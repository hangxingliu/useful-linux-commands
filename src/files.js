const DIR = `${__dirname}/../useful-commands`;

let fs = require('fs');

let fileContentCache = {},
	fileNames = [];

reload();
function reload() {
	clearFileContentCache();
	try {
		fileNames = fs.readdirSync(DIR).filter(shellScriptFilter);
	} catch (e) {
		console.error(e.stack);
		return false;
	}
	return true;
}
function clearFileContentCache() { for (let key in fileContentCache) delete fileContentCache[key] }
function shellScriptFilter(fileName) { return fileName.endsWith('.sh'); }

/**
 * @param {string} [keyword] 
 * @returns {Array<string>}
 */
function getFileNames(keyword) {
	return keyword ? fileNames.filter(fileName => fileName.indexOf(keyword) >= 0)
		: fileNames;
}
/**
 * @param {Array<string>} fileNames 
 * @param {Function} callback (content, fileName)
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

module.exports = {
	reload,
	getFileNames,
	readEach
};