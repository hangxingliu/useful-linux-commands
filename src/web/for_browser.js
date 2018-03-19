let { getFileNames } = require('../files');
let { OutputChannel } = require('../output-channel/ajax');
let query = require('../query');

let styles = ['github', 'gist', 'light', 'dark'];
let stylesMap = {
	github: 'github',
	gist: 'github-gist',
	light: 'solarized-light',
	dark: 'solarized-dark'
};

function handler(req, res) {
	let path = '/'; path = req.path;

	// response index page(homepage)
	if (path == '/') {
		let style = styles[0];
		for (const s of styles)
			if (s in req.query)
				style = s;
		return res.render('index', {
			style,
			styles: stylesMap,
			files: getFileNames()
		});
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
