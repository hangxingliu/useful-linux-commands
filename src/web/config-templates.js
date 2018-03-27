module.exports = {
	CSP: [ // Content-Security-Policy
		"default-src",
		"'self' 'unsafe-inline' 'unsafe-eval'",
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
		github: '3os04U6CRSZxAX9SO97BPnd90GVfzlfbJvpeTAGpHSDjGNIftACTITCXIhWdeaMm',
		gist: '4dJlnp9ZK7fF+a6IldWe0MwL1NG+HWAhI9k9jJa0ly0iwnyX+qQ7nxlXpcDx4mE/',
		light: 'Tnnq6pbLZp9PjpOt+RfOeRPGGKlGVI4o4dUEk6aPfkMf0sFzLLuPwWe217uipl4b',
		dark: 'r6qmB9/fPnKwgAlSFlqwLDc5mWgL5SSxvLHPJbmFPL36fTg/BQaII9kKq0CxffSU'
	}
};
