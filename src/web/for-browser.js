//@ts-check
/// <reference path="./index.d.ts" />

let { getFileNames } = require('../files');
let { OutputChannel } = require('../output-channel/ajax');
let query = require('../query');

let tmplVariables = require('./config-templates');

module.exports = { handler };

/**
 * @param {{[key: string]: string}} query
 * @returns {string}
 */
function getIndexStyleFromQueryString(query) {
	for (const s of tmplVariables.styles)
		if (s in query)
			return s;
	return tmplVariables.styles[0];
}

function getPositiveIntQuery(query, name, defaultNum) {
	if (name in query) {
		let num = parseInt(query[name]);
		if (!isNaN(num) && num >= 0)
			return num;
	}
	return defaultNum;
}

/**
 * @returns {QueryParameters}
 */
function getQueryParamsFromQueryString(query) {
	let q = {
		keywords: query.q || '',
		file: query.file || '',
		linesBefore: getPositiveIntQuery(query, 'b', 1),
		linesAfter: getPositiveIntQuery(query, 'a', 5),
		queryString: ''
	};

	let queryString = 'q' in query ? `${query.q} ` : '';
	if ('file' in query) queryString += `-f${query.file} `;
	if ('a' in query) queryString += `-a${q.linesAfter} `;
	if ('b' in query) queryString += `-b${q.linesBefore} `;
	q.queryString = queryString;

	return q;
}

function getRenderBaseData(style, preQueryString = '', preQueryResult = null) {
	return { style, files: getFileNames(), preQueryString, preQuery: preQueryResult };
}

function renderIndex(req, res) {
	let style = getIndexStyleFromQueryString(req.query);
	return res.render('index-min', Object.assign(getRenderBaseData(style), tmplVariables));
}

/** @param {QueryParameters} q */
function renderIndexWithPreQueryData(q, req, res) {
	let style = getIndexStyleFromQueryString(req.query);
	let queryResult = null;

	let outputChannel = new OutputChannel({
		json: data => queryResult = data,
		write: data => void data,
		end: () => {
			let renderBase = getRenderBaseData(style, q.queryString,
				`<script>PRE_QUERY=${JSON.stringify(queryResult)}</script>`);

			res.render('index-min', Object.assign(renderBase, tmplVariables))
		}
	});
	query(q.keywords, q.file, q.linesBefore, q.linesAfter, outputChannel);
}

function handler(req, res) {
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

	res.status(404);
	res.write('All this time I was finding myself. And I didn\'t know I was lost');
	return res.end();
}
