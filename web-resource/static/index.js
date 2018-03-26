//@ts-check
(function App() {
	let cache = createCacheManager();

	/** @type {HTMLInputElement} */
	let $input = $('#txtSearchBox');

	/** @type {HTMLFormElement} */
	let $form = $('#formSearchBox');

	let $help = $div('#rowHelp'),
		$menu = $div('#styleDropdown .dropdown-menu'),
		$blockResult = $div('#blockResult');

	let tmpl = $div('#result-template').innerHTML;

	let regexpA = /^-a(.*?)$/i,
		regexpB = /^-b(.*?)$/i,
		regexpFile = /^-f(.*?)$/i;

	/** @type {RegExp} */
	let resultKeywordHighlighter;

	//@ts-ignore
	let preQuery = window.PRE_QUERY;
	if (preQuery)
		handlerResult(null, 200, preQuery);

	$input.addEventListener('keydown', event => {
		let key = event.which || event.keyCode || 0;
		if (key == 10 || key == 13 || key == 32) {//enter || space
			if (key != 32)
				event.preventDefault();
			return setTimeout(sendQueryRequest, 15);
		}
	});
	$form.addEventListener('submit', event => { // for mobile device that could not catch keydown event
		event.preventDefault();
		return sendQueryRequest();
	});

	$('#styleDropdown .style-menu-toggle').addEventListener('click', event => {
		event.preventDefault();
		toggleDisplay($menu);
	});

	window.addEventListener('popstate', event => {
		// req-query after history go back or go forward
		console.log('popstate: ' + event.state);
		$input.value = String(event.state || '');
		sendQueryRequest();
	});

	function sendQueryRequest() {
		let rawInput = value($input);
		let parts =rawInput.split(/\s+/);

		let q = [], options = { file: '', a: '', b: '' };
		/** @type {{[x: string]: RegExp}} */
		let opt2regexpMap = { file: regexpFile, a: regexpA, b: regexpB };

		for (let i = 0; i < parts.length; i++) {
			let word = parts[i], match, isKeyword = true;
			if (!word) continue;
			for (let opt in opt2regexpMap) {
				let regexp = opt2regexpMap[opt];
				options[opt] = (match = word.match(regexp))
					? ((isKeyword = false) || match[1] || parts[++i] || '')
					: options[opt];
			}
			isKeyword && q.push(word);
		}

		resultKeywordHighlighter = getRegexp4ResultKeywordHightlight(q);

		let qs = `q=${encodeURIComponent(q.join('+'))}` +
			`&[a]&[b]&[file]`.replace(/\[(\w+)\]/g, (_, name) =>
				name + '=' + encodeURIComponent(options[name]));
		history.pushState(rawInput, null, `/?${qs}`);

		let hasCache = cache.get(qs);
		if (hasCache) {
			console.log(`matched cache for ${qs}`);
			return handlerResult(null, 200, hasCache);
		}

		let ajaxURI = `api?${qs}`;
		console.log(ajaxURI);
		httpGetJSON(ajaxURI, (err, status, result) => {
			if (err || status != 200) return;
			cache.set(qs, result);
			handlerResult(err, status, result);
		});
	}

	/**
	 *
	 * @param {Error} err
	 * @param {number} status
	 * @param {{files: any[]}} data
	 */
	function handlerResult(err, status, data) {
		let items = data.files, html = '';
		setHelpDisplay(items && items.length > 0);

		for (let index in items) {
			let item = items[index];
			item.content = item.contents.map(v =>
				v == '...' ? `<i>...(lines be omitted)</i><br />` : escapeHtml(v)).join('');
			html += appendResultItem(item);
		}
		$blockResult.innerHTML = html;
		$$('pre code', $blockResult).forEach(
			/** @param {HTMLPreElement} e */
			e => {
				if (resultKeywordHighlighter)
					e.innerHTML = e.innerHTML.replace(resultKeywordHighlighter, _ => `<b><u>${_}</u></b>`);
				//@ts-ignore highlight.js
				hljs.highlightBlock(e);
			});
	}

	/** @param {boolean} show */
	function setHelpDisplay(show) { (show ? removeClass : addClass).call(null, $help, 'd-flex'); }

	function appendResultItem(obj) {
		return tmpl.replace(/\{\{\s+(\w+)\s+\}\}/g, (_, name) =>
			name == 'content' ? (obj.content || '') : escapeHtml(obj[name] || '') );
	}

	function getRegexp4ResultKeywordHightlight(keywords) {
		let words = keywords.map(keywd => keywd.split('+')).reduce((a, b) => a.concat(b), []);
		return new RegExp('(' + words.map(keyword =>
			keyword.replace(/[\*\+\?\(\)\[\]\{\}\.\|]/g, _ => `\\${_}`)
		).join('|') + ')', 'ig');
	}

	// ==========================================
	//
	//      Vanilla js library functions
	//
	// ==========================================

	/** @param {string} str */
	function escapeHtml(str) {
		return str
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;")
			.replace(/'/g, "&#039;");
	}

	/** @return {any} */
	function $(selector) { return document.querySelector(selector); }
	/** @return {HTMLDivElement} */
	function $div(selector) { return $(selector); }
	/**
	 * @param {string} selector
	 * @param {HTMLElement} [parent]
	 * @returns {any[]}
	 */
	function $$(selector, parent) {
		return Array.prototype.slice.call(
			(parent || document).querySelectorAll(selector));
	}

	/** @param {HTMLElement} element */
	function toggleDisplay(element) {
		// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetParent
		element.style.display = element.offsetParent === null ? 'block' : 'none';
	}

	/** @param {HTMLInputElement} element */
	function value(element) { return String(element.value); }

	/**
	 * @param {HTMLElement} element
	 * @param {string} className
	 */
	function removeClass(element, className) {
		if (element.classList)
			element.classList.remove(className);
		else
			element.className = element.className
				.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
	}

	/**
	 * @param {HTMLElement} element
	 * @param {string} className
	 */
	function addClass(element, className) {
		if (element.classList)
			element.classList.add(className);
		else
			element.className += ' ' + className;
	}

	/**
	 * @param {string} uri
	 * @param {(err: Error, statusCode: number, object: any) => any} callback
	 */
	function httpGetJSON(uri, callback) {
		let request = new XMLHttpRequest();
		request.open('GET', uri, true);
		request.onload = function () {
			let data = null;
			try {
				data = JSON.parse(request.responseText);
			} catch (ex) {
				console.error(ex);
				return callback(new Error(`Parse response JSON Error`));
			}
			return callback(null, request.status, data);
		};
		request.onerror = () => callback(new Error('XMLHttpRequest Error'));
		request.send();
	}

	function createCacheManager() {
		let kv = {};
		return {get,set};
		function get(key) { return kv[key]; }
		function set(key, value) { kv[key] = value; }
	}
})();
