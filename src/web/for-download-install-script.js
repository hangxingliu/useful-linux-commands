const INSTALLER_SCRIPTS_PATH = `${__dirname}/../../useful-installers`;
let path2FileMap = {
	'/node': 'nodejs.sh',
	'/nodejs': 'nodejs.sh',
	'/init': 'init.sh',
	'/linux': 'init.sh'
}

function middleware(req, res, next) {
	if (req.method == 'GET') {
		let file = path2FileMap[req.path];
		if (file)
			return res.download(`${INSTALLER_SCRIPTS_PATH}/${file}`, file);
	}
	next();
}

module.exports = middleware;
