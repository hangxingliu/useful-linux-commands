//@ts-check

let { getFileNames } = require('../files');
let { OutputChannel } = require('../output-channel/ajax');
let query = require('../query');

let tmplVariables = require('./config-templates');

function handler(req, res) {
	let path = '/'; path = req.path;

	// response index page(homepage)
	if (path == '/') {
		let style = tmplVariables.styles[0];
		for (const s of tmplVariables.styles)
			if (s in req.query)
				style = s;
		return res.render('index-min',
			Object.assign({ style, files: getFileNames() }, tmplVariables));
	}

	if (path == '/api') {
		let linesBeforeCount = parseInt(req.query.b),
			linesAfterCount = parseInt(req.query.a),
			keywords = req.query.q || '',
			fileNameFilter = req.query.file || '';

		if (isNaN(linesBeforeCount)) linesBeforeCount = 1;
		if (isNaN(linesAfterCount)) linesAfterCount = 5;

		if (!keywords && !fileNameFilter)
			return res.json({ error: 'empty query' }) + res.end();

		console.log('web ajax api query: ', fileNameFilter, keywords);

		let outputChannel = new OutputChannel(res);
		query(keywords, fileNameFilter, linesBeforeCount, linesAfterCount, outputChannel);

		return;
	}

	res.status(404);
	res.write('All this time I was finding myself. And I didn\'t know I was lost');
	return res.end();
}


module.exports = {
	handler
};
