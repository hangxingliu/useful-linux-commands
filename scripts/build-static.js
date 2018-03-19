#!/usr/bin/env node

//@ts-check

let fs = require('fs');
let path = require('path');

let babel = require('babel-core');
let sass = require('node-sass');
let postcss = require('postcss');
let autoprefixer = require('autoprefixer');
let htmlminifier = require('html-minifier');

const DIR = path.join(__dirname, '..', 'web-resource', 'static');
const HTML_DIR = path.join(__dirname, '..', 'web-resource', 'views');
const SASSOPTS = {
	outputStyle: 'compressed'
};
const AUTOPREFIXER = autoprefixer({
	browsers: ['cover 95%'],
});

let taskHTML = startTask('html');
fs.readFile(path.join(HTML_DIR, 'index.html'), { encoding: 'utf8' }, (err, html) => {
	if (err) return taskHTML.fatal(err);
	taskHTML.done();

	taskHTML = startTask(`minify html`);
	try {
		html = htmlminifier.minify(html, {
			removeComments: true,
			collapseWhitespace: true
		});
	} catch (ex) {
		return taskHTML.fatal(ex);
	}

	taskHTML = startTask('write index.min.html');
	fs.writeFile(path.join(HTML_DIR, 'index-min.html'), html,
		function (err) {
			if (err) return taskHTML.fatal(err);
			taskHTML.done();
		});
});

let taskJavascript = startTask('javascript');
babel.transformFile(path.join(DIR, 'index.js'), {
	plugins: [
		["transform-es2015-block-scoping", { throwIfClosureRequired: true }], // for `let`, `const`
		"transform-es2015-arrow-functions", // for `() => {}`
		"transform-es2015-template-literals",
		"transform-merge-sibling-variables",
		"minify-mangle-names",
	],
	comments: false,
	compact: true
}, (err, result) => {
	if (err) return taskJavascript.fatal(err);
	taskJavascript.done();

	taskJavascript = startTask('write index.min.js');
	fs.writeFile(path.join(DIR, 'index.min.js'), result.code,
		function (err) {
			if (err) return taskJavascript.fatal(err);
			taskJavascript.done();
		});
});

let taskStylesheet = startTask('sass');
sass.render(Object.assign({ file: path.join(DIR, 'index.scss'), }, SASSOPTS),
	function (err, result) {
		if (err) return taskStylesheet.fatal(err);
		taskStylesheet.done();

		taskStylesheet = startTask('autoprefixer');
		//@ts-ignore
		postcss([AUTOPREFIXER])
			.process(result.css, { from: undefined })
			.then(function (result) {
				if (result.warnings()) {
					for (let warning of result.warnings())
						console.error(`postcss warning: `, warning.toString());
					// return task.fatal(new Error(`there have warnings in postcss process`));
				}
				taskStylesheet.done();

				taskStylesheet = startTask('write index.min.css');
				fs.writeFile(path.join(DIR, 'index.min.css'), result.css,
					function (err) {
						if (err) return taskStylesheet.fatal(err);
						taskStylesheet.done();
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
