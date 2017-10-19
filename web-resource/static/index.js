var App = function() {
	var $input = $('#txtSearchBox'),
		$help = $('#rowHelp'),
		tmpl = $('#result-template').clone().html(),
		$blockResult = $('#blockResult');
	
	var regexpA = /^-a(.*?)$/i,
		regexpB = /^-b(.*?)$/i,
		regexpFile = /^-f(.*?)$/i;
	
	var resultKeywordHighlighter = '';
	var OriginalQueryText = '';

	$input.keydown(function(e){
		var key = e.which || e.keyCode || 0;
		if (key == 13 || key == 32)//enter || space
			return sendQueryRequest();
	});
	
	function sendQueryRequest() {
		OriginalQueryText = $input.val();
		var parts = OriginalQueryText.split(/\s+/);

		var q = [], options = { file: '', a: '', b: '' };
		var opt2regexpMap = {
			file: regexpFile, a: regexpA, b: regexpB
		};

		for (var i = 0; i < parts.length; i++) {
			var word = parts[i], match, isKeyword = true;
			if (!word) continue;
			Object.keys(opt2regexpMap).map(opt =>
				options[opt] = (match = word.match(opt2regexpMap[opt]))
					? ((isKeyword = false) || match[1] || parts[++i] || '')
					: options[opt]);
			isKeyword && q.push(word);
		}
		
		resultKeywordHighlighter = getRegexp4ResultKeywordHightlight(q);

		var url = `api?q=${encodeURIComponent(q.join('+'))}` +
			`&[a]&[b]&[file]`.replace(/\[(\w+)\]/g, (_, name) =>
				name + '=' + encodeURIComponent(options[name]));
		console.log(url);
		$.get(url, handlerResult);
	}

	function handlerResult(data) {
		var items = data.files, html = '';
		items && items.length ? $help.removeClass('d-flex') : $help.addClass('d-flex');

		for (var index in items) {
			var item = items[index];
			item.content = item.contents.map(v => 
				v == '...' ? `<i>...(lines be omitted)</i><br />` : escapeHtml(v)).join('');
			html += appendResultItem(item);
		}
		$blockResult.html(html).find('pre code').each(function (i, e) {
			if (resultKeywordHighlighter)
				e.innerHTML = e.innerHTML.replace(resultKeywordHighlighter, _ => `<b><u>${_}</u></b>`);
			hljs.highlightBlock(e);
		});
	}

	function appendResultItem(obj) {
		return tmpl.replace(/\{\{\s+(\w+)\s+\}\}/g, (_, name) =>
			name == 'content' ? (obj.content || '') : escapeHtml(obj[name] || '') );
	}	
	function escapeHtml(str) {
		return str
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;")
			.replace(/'/g, "&#039;");
	}

	function getRegexp4ResultKeywordHightlight(keywords) {
		var words = keywords.map(keywd => keywd.split('+')).reduce((a, b) => a.concat(b), []);
		return new RegExp('(' + words.map(keyword =>
			keyword.replace(/[\*\+\?\(\)\[\]\{\}\.\|]/g, _ => `\\${_}`)
		).join('|') + ')', 'ig');
	}
};
app = new App();