module.exports = {
	CSP: [ // Content-Security-Policy
		"default-src",
		"'self' 'unsafe-inline' 'unsafe-eval'",
		"data:", // for google-analytics inject data:application/javascript
		"https://www.google-analytics.com;",
	].join(' '),

	siteName: 'Useful Linux Commands',
	title: 'Useful Linux Commands',
	description: 'A collection of useful linux commands that can be queried from the command line and within the browser.',

	styles: ['github', 'gist', 'light', 'dark'],
	stylesMap: {
		github: 'github',
		gist: 'github-gist',
		light: 'solarized-light',
		dark: 'solarized-dark'
	},
	styleSRIsMap: {
		github: 'yaOEEinoAKxVHv1ZCY3vqJeRItlRVwZ9pyTCCJLHlyHNndGZIF+S30C1+8oRQ2sz',
		gist: 'FwjVcgPHUmKBs7MindDuCw8B29LdAnaKjkXsIP9FYRefyGCpxpUVtfRgSgiN3FLe',
		light: 'a1dj0x8qD781iEPEXGKT7QjGhbXLBofaVP6wCF2N/xWaij9y8ZXSt9IZpqDRjggj',
		dark: 'ubTNJRmlJBCExgXpPeGaPgNT3x13wbjM/FVT/BmJwalqsq2nQbJ5iE/HUptFmaH+'
	}
};
