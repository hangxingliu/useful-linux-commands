//@ts-check
/// <reference path="./index.d.ts" />

let { getFileNames, iterateFiles } = require('../files');
let { OutputChannel } = require('../output-channel/ajax');
let query = require('../query');

let tmplVariables = require('./config-templates');

const TEMPLATE_NAME = "index-min";

module.exports = { handler };

/**
 * @param {{[key: string]: string}} qsMap
 * @returns {string}
 */
function getIndexStyleFromQueryString(qsMap) {
	let style = qsMap.style;
	if (style && (style in tmplVariables.stylesMap))
		return style;
	return tmplVariables.styles[0];
}

function getPositiveIntQuery(qsMap, name, defaultNum) {
	if (name in qsMap) {
		let num = parseInt(qsMap[name]);
		if (!isNaN(num) && num >= 0)
			return num;
	}
	return defaultNum;
}

/**
 * @returns {QueryParameters}
 */
function getQueryParamsFromQueryString(qsMap) {
	let q = {
		keywords: qsMap.q || '',
		file: qsMap.file || '',
		linesBefore: getPositiveIntQuery(qsMap, 'b', 1),
		linesAfter: getPositiveIntQuery(qsMap, 'a', 5),
		queryString: ''
	};

	let queryString = qsMap.q ? `${qsMap.q} ` : '';
	if (qsMap.file) queryString += `-f${qsMap.file} `;
	if (qsMap.a) queryString += `-a${q.linesAfter} `;
	if (qsMap.b) queryString += `-b${q.linesBefore} `;
	q.queryString = queryString;

	return q;
}

function getRenderBaseData(style, preQueryString = '', preQueryResult = null) {
	return { style, files: getFileNames(), preQueryString, preQuery: preQueryResult };
}

function renderIndex(req, res) {
	let style = getIndexStyleFromQueryString(req.query);
	return res.render(TEMPLATE_NAME, Object.assign(getRenderBaseData(style), tmplVariables));
}

/** @param {QueryParameters} q */
function renderIndexWithPreQueryData(q, req, res) {
	let style = getIndexStyleFromQueryString(req.query);
	let queryResult = null;

	let outputChannel = new OutputChannel({
		json: data => queryResult = data,
		write: data => void data,
		end
	});
	query(q.keywords, q.file, q.linesBefore, q.linesAfter, outputChannel);

	function end() {
		let base = getRenderBaseData(style, q.queryString,
			`<script>PRE_QUERY=${JSON.stringify(queryResult)}</script>`);

		if (!q.keywords && q.file) {
			// SEO for all content of file page
			let fileNames = getFileNames().filter(name => name == q.file);
			if (fileNames.length == 1) {
				return iterateFiles(fileNames, (ctx, fileName, meta) => {
					let title = meta.title + ' - ' + tmplVariables.title;
					let description = meta.description;

					res.render(TEMPLATE_NAME,
						Object.assign(base, tmplVariables, { title, description }));
				});
			}
		}

		res.render(TEMPLATE_NAME, Object.assign(base, tmplVariables));
	}
}

function handler(req, res, next) {
	let path = '/'; path = req.path;

	res.setHeader('Content-Security-Policy', tmplVariables.CSP);
	res.setHeader('X-Frame-Options', 'deny'); // Disallow put page into iframe
	res.setHeader('X-XSS-Protection', '1; mode=block'); // XSS Protection

	if (path == '/') {
		if (('keywords' in req.query) || ('file' in req.query) ) {
			// index page with pre query data
			let q = getQueryParamsFromQueryString(req.query);
			if (q.keywords || q.file)
				return renderIndexWithPreQueryData(q, req, res);
		}
		// index page
		return renderIndex(req, res);
	}

	if (path == '/api') {
		let q = getQueryParamsFromQueryString(req.query);
		if (!q.keywords && !q.file)
			return res.json({ error: 'empty query' }) + res.end();

		if (req.app.locals.ENV_DEVELOPMENT)
			console.log('web ajax api query: ', q.file, q.keywords);

		let outputChannel = new OutputChannel(res);
		query(q.keywords, q.file, q.linesBefore, q.linesAfter, outputChannel);
		return;
	}

	// if (path == '/meta') {
	// 	let file = req.query.file;
	// 	if (file) {
	// 		let fileNames = getFileNames().filter(name => name == file);
	// 		if (fileNames.length > 0) {
	// 			let object = {};
	// 			return iterateFiles(fileNames, (ctx, name, meta) => object[name] = meta)
	// 				.then(() => { res.json(object); res.end() });
	// 		}
	// 	}
	// 	res.json({});
	// 	res.end();
	// 	return;
	// }

	next();
}
