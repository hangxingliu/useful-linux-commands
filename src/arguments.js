
const SYSTEM_COLOR_ARGUMENTS = [
	'--no-color', '--color=false', '--color', '--color=true', '--color=always'];

let OPTION_BEFORE_AFTER_LINES_COUNT = /^-([aAbB])(\d*)$/;
let OPTION_FILE_NAME_LIMIT = /^-([fF])(.*)$/;
/**
 * @param {Array<string>} args
 */
function Arguments(args) {
	let linesBeforeCount = 1;
	let linesAfterCount = 5;
	let fileNameLimit = null;
	let miniOutput = false;
	let queryString = '';
	
	function parse() {
		let match = [], number = 0;
		for (let index = 0; index < args.length; index ++) {
			const it = args[index];

			//-a -A -b -B
			if (match = it.match(OPTION_BEFORE_AFTER_LINES_COUNT)) {
				//the number of option -a/-A/-b/-B in the next array element
				if (!match[2]) index++;
				
				number = parseInt(match[2] || args[index]);

				if (isNaN(number))
					throw new Error(`there are not a number following "-${match[1]}" param`);
				
				match[1].toLowerCase() == 'a' ?
					(linesAfterCount = number) :
					(linesBeforeCount = number);
				
				continue;
			}
			// -f -F
			if (match = it.match(OPTION_FILE_NAME_LIMIT)) {
				//the number of option -f/-F in the next array element
				if (!match[2]) index++;

				fileNameLimit = match[2] || args[index];
				if (!fileNameLimit)
					throw new Error(`there are not a string filename following "-${match[1]}" param`);	
				continue;
			}
			//--mini -m
			if (it == '--mini' || it == '-m') {
				miniOutput = true;
				continue;
			}
			//ignore color params
			if (SYSTEM_COLOR_ARGUMENTS.indexOf(it) >= 0)
				continue;
			
			//add to query string
			if (!queryString)
				queryString = it;
			else
				queryString += `+${it}`;	

			// End of "for"
		}
		return true;
	}
	
	this.isLaunchForHelp = () => args.indexOf('-h') >= 0 || args.indexOf('--help') >= 0;
	this.isLaunchForTest = () => args.indexOf('-t') >= 0 || args.indexOf('--test') >= 0;
	this.parse = parse;

	this.isEmptyQuery = () => !(queryString || fileNameLimit);
	this.getLinesBeforeCount = () => linesBeforeCount;
	this.getLinesAfterCount = () => linesAfterCount;
	this.getFileNameLimit = () => fileNameLimit;
	this.getMiniOutput = () => miniOutput;
	this.getQueryString = () => queryString;
	
}

module.exports = {
	Arguments
};