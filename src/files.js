//@ts-check
/// <reference path="./index.d.ts" />

const DIR = `${__dirname}/../useful-commands`;

let fs = require('fs');

/** @type {StringKVMap} */
let fileContentCache = {};

/** @type {FileMetaInfoMap} */
let fileMetaInfoCache = {};

/** @type {string[]} */
let fileNames = [];

reload();
module.exports = { reload, getFileNames, iterateFiles };

function reload() {
	fileContentCache = {};
	fileMetaInfoCache = {};
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
 * @param {string[]} fileNames
 * @param {(content: string, fileName: string, meta: FileMetaInfo) => any} eachCallback
 * @returns {Promise<boolean>}
 */
function iterateFiles(fileNames, eachCallback) {
	return Promise.all(fileNames.map(readFile)).then(contents =>
		Promise.all(fileNames.map(readFileMetaInfo)).then(metaInfoArray => {
			for (let i = 0; i < fileNames.length; i++)
				eachCallback(contents[i], fileNames[i], metaInfoArray[i]);
			return Promise.resolve(true);
		}));
}

/**
 * @param {string} fileName
 * @returns {Promise<FileMetaInfo>}
 */
function readFileMetaInfo(fileName) {
	if (fileName in fileMetaInfoCache)
		return Promise.resolve(fileMetaInfoCache[fileName]);
	return readFile(fileName).then(content => {
		let meta = { title: '', description: '', fullPath: `${DIR}/${fileName}` };
		let mtx = content.match(/^#(.+)/);
		if (!mtx)
			return Promise.reject(new Error(`Could not read meta info(title) for "${fileName}"`));
		meta.title = mtx[1].trim();

		let split = content.match(/[\r\n]{2}/);
		if (!split)
			return Promise.reject(new Error(`Could not read meta info(description) for "${fileName}"`));

		let from = mtx.index + mtx[0].length;
		let to = split.index;
		meta.description = content.slice(from, to)
			.replace(/^#\s*/mg, '')
			.replace(/\s/g, ' ')
			.replace(/["'`<>]/g, '')
			.trim();

		fileMetaInfoCache[fileName] = meta
		return Promise.resolve(meta);
	});
}

/**
 * @param {string} fileName
 * @returns {Promise<string>}
 */
function readFile(fileName) {
	if (fileName in fileContentCache)
		return Promise.resolve(fileContentCache[fileName]);
	return new Promise((resolve, reject) =>
		fs.readFile(`${DIR}/${fileName}`, { encoding: 'utf8' }, (err, data) => {
			if (err) return reject(err);
			fileContentCache[fileName] = data;
			return resolve(data);
		}));
}
