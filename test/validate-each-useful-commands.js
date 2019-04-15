//@ts-check
/// <reference path="../src/index.d.ts" />

let colors = require('colors/safe');

let { Assert } = require('@hangxingliu/assert');
let files = require('../src/files');

describe('Validate each useful commands', () => {
	/** @type {string[]} */
	let allFileNames = files.getFileNames();

	it('# iterate each files (ensure meta info correct)', () => {
		/** @type {FileMetaInfo[]} */
		let metaArray = [];
		let lastMeta = null;

		return files.iterateFiles(allFileNames, (content, fileName, meta) => metaArray.push(meta))
			.then(() => metaArray.map(meta => {
				lastMeta = meta;
				Assert(meta.title).isString().lengthIn(1, 32);
				Assert(meta.description).isString().lengthIn(16, 256);
			})).catch(error => {
				process.nextTick(() =>
					console.error(colors.red(`    Related meta info: \n      ${JSON.stringify(lastMeta)}`)));
				throw error;
			});
	});
});
