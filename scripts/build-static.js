#!/usr/bin/env node

//@ts-check

let fs = require('fs');
let path = require('path');
let sass = require('node-sass');
let postcss = require('postcss');
let autoprefixer = require('autoprefixer');

const DIR = path.join(__dirname, '..', 'web-resource', 'static');
const SASSOPTS = {
	outputStyle: 'compressed'
};
const AUTOPREFIXER = autoprefixer({
	browsers: ['cover 95%'],
});

let task = startTask('sass');
sass.render(Object.assign({ file: path.join(DIR, 'index.scss'), }, SASSOPTS),
	function (err, result) {
		if (err) return task.fatal(err);
		task.done();

		task = startTask('autoprefixer');
		//@ts-ignore
		postcss([AUTOPREFIXER])
			.process(result.css, { from: undefined })
			.then(function (result) {
				if (result.warnings()) {
					for (let warning of result.warnings())
						console.error(`postcss warning: `, warning.toString());
					// return task.fatal(new Error(`there have warnings in postcss process`));
				}
				task.done();

				task = startTask('write');
				fs.writeFile(path.join(DIR, 'index.css'), result.css,
					function (err) {
						if (err) return task.fatal(err);
						task.done();
					});
			});
	});


function startTask(what = '') {
	console.log(`[.] start task: "${what}" ...`);
	return { done, fatal };

	function done() {
		console.log(`[~] task "${what}" done!`);
	}

	function fatal(err) {
		console.error(`[-] fatal: task "${what}" failed!`);
		console.error(err);
		process.exit(0);
	}
}
