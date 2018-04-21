#!/usr/bin/env node

//@ts-check

let fs = require('fs');
let path = require('path');
let child_process = require('child_process');

let Async = require('async'),
	babel = require('babel-core'),
	sass = require('node-sass'),
	postcss = require('postcss'),
	autoprefixer = require('autoprefixer'),
	htmlminifier = require('html-minifier');

const DIR = path.join(__dirname, '..', 'web-resource', 'static');
const HTML_DIR = path.join(__dirname, '..', 'web-resource', 'views');
const SASSOPTS = {
	outputStyle: 'compressed'
};
const AUTOPREFIXER = autoprefixer({
	browsers: ['cover 95%'],
});

let jsIntegrity = '', cssIntegrity = '';

let isWatch = process.argv.slice(2).findIndex(arg => arg == '--watch' || arg == '-w') >= 0;

taskMain(isWatch ? taskWatch : undefined);

// Main building flow:
function taskMain(then) {
	Async.series([
		then => Async.parallel([taskJavascript, taskStylesheet], then),
		getIntegrity,
		taskHTML
	], then);
}

function taskWatch() {
	let { watchTree, unwatchTree } = require('watch');
	let watch = dir => { unwatchTree(dir); watchTree(dir, { interval: 0.3 }, notify); };
	watch(DIR);
	watch(HTML_DIR);
	console.log('>> Watching ... >>>>>>');

	function notify(f) {
		if (typeof f != 'string') return; // first scan all files after watch

		let tasks = [];
		if (f.endsWith('index.js')) tasks = [taskJavascript, getIntegrity];
		else if (f.endsWith('.scss')) tasks = [taskStylesheet, getIntegrity];
		else if (f.endsWith('index.html')) tasks = [];
		else return;

		console.log(`changed: ${f}`);
		tasks.push(taskHTML);
		Async.series(tasks);
	}
}

function taskJavascript(then) {
	let task = startTask('javascript');
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
		if (err) return task.fatal(err);
		task.done();

		task = startTask('write index.min.js');
		fs.writeFile(path.join(DIR, 'index.min.js'), result.code,
			function (err) {
				if (err) return task.fatal(err);
				task.done();
				then();
			});
	});
}

function taskStylesheet(then) {
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

					task = startTask('write index.min.css');
					fs.writeFile(path.join(DIR, 'index.min.css'), result.css,
						function (err) {
							if (err) return task.fatal(err);
							task.done();
							then();
						});
				});
		});
}

function taskHTML(then) {
	let task = startTask('html');
	fs.readFile(path.join(HTML_DIR, 'index.html'), { encoding: 'utf8' }, (err, html) => {
		if (err) return task.fatal(err);
		task.done();

		task = startTask(`minify html`);
		try {
			html = htmlminifier.minify(html, {
				removeComments: true,
				collapseWhitespace: true
			});
		} catch (ex) {
			return task.fatal(ex);
		}
		task.done();

		task = startTask('write index.min.html');
		// console.log(jsIntegrity);
		// console.log(cssIntegrity);
		html = html.replace('__insert_css_integrity_here__', `integrity="sha384-${cssIntegrity}"`)
			.replace('__insert_js_integrity_here__', `integrity="sha384-${jsIntegrity}"`);
		fs.writeFile(path.join(HTML_DIR, 'index-min.html'), html,
			function (err) {
				if (err) return task.fatal(err);
				task.done();
				then();
			});
	});
}

function getIntegrity(then) {
	let task = startTask('get files integrity');
	Async.parallel([
		then => getFileIntegrity(path.join(DIR, 'index.min.js'), then),
		then => getFileIntegrity(path.join(DIR, 'index.min.css'), then)
	], (err, results) => {
		if (err) return task.fatal(err);
		jsIntegrity = results[0];
		cssIntegrity = results[1];

		task.done();
		then();
	})
}

/**
 * @param {string} file
 * @param {function} then
 */
function getFileIntegrity(file, then) {
	file = "'" + file.replace(/'/g, "'\\''") + "'";
	child_process.exec(`shasum -b -a 384 ${file} | xxd -r -p | base64`, (err, stdout, stderr) => {
		void stderr; // unused variable
		if (err) return then(err, null);
		return then(null, stdout.trim());
	});
}

function startTask(what = '') {
	console.log(`[.] start task: "${what}" ...`);
	return { done, fatal };

	function done() {
		console.log(`[~]   task "${what}" done!`);
	}

	function fatal(err) {
		console.error(`[-] fatal: task "${what}" failed!`);
		console.error(err);
		if(!isWatch)
			process.exit(1);
	}
}
