_awt_error_handler(function($) {
	var messaging = _awt_messaging;
	var error_handler = _awt_error_handler;
	$('body *').mousedown(error_handler(function(ev) {
		if (ev.eventPhase != Event.AT_TARGET)
			return;
		var els = [];
		var el = ev.target;
		while (el) {
			var descr = {name: el.nodeName, attrs: {}, text: $(el).text().substr(0, 128)};
			for (var a = 0; a < el.attributes.length; ++a)
				descr.attrs[el.attributes[a].name] = el.attributes[a].value;
			els.push(descr);
			el = el.parentElement;
		}
		messaging.send({type: 'xpath-composer-elements', elements: els});
	}));

	function xpath2css(xpath) {
		if (xpath.match(/__ESCAPE__/))
			throw new Error('"__ESCAPE__" clause is reserved');

		function escape(str) {
			var codes = [];
			for (var i in str)
				codes.push(str.charCodeAt(i));
			return '__ESCAPE__' + codes.join('_');
		}
		function unescape(str) {
			return str.replace(/__ESCAPE__([\d_]+)/g, function(s, m1) {
				var codes = m1.split('_');
				var decoded = '';
				for (var i in codes)
					decoded += String.fromCharCode(codes[i]);
				return decoded;
			});
		}

		xpath = xpath  // escape strings, will not escape empty strings ("") or unquoted strings (string-without-quotes)
			.replace(/(=|,)(\s*)("|')(.*?[^\\]\3)/g, function(s, m1, m2, m3, m4) {return m1 + m2 + escape(m3 + m4);})
		;

		if (xpath.match(/\s+or\s+/))
			throw new Error('xpath "or" clause is not supported');  // ambiguous
		if (xpath.match(/::/))
			throw new Error('xpath axes (/axis::) are not supported');
		if (xpath.match(/\/\.\./))
			throw new Error('xpath parent (/..) clause is not supported');  // unsupported by css, see https://css-tricks.com/parent-selectors-in-css/
		if (xpath.match(/\/\/\./))
			throw new Error('xpath clause "//." is not supported');  // dunno what to do with it

		xpath = xpath  // convert "and" clause before normalization
			.replace(/\s+and\s+/g, '][')  // "and" clause
		;

		xpath = xpath  // normalization (extra space, fixes)
			.replace(/^\s+/, '')  // extra space
			.replace(/\s+$/, '')  // extra space
			.replace(/\s*\[\s*/g, '[')  // extra space
			.replace(/\s*\]\s*/g, ']')  // extra space
			.replace(/\s*\(\s*/g, '(')  // extra space
			.replace(/\s*\)\s*/g, ')')  // extra space
			.replace(/\s*(\/+)\s*/g, '$1')  // extra space
			.replace(/\s*,\s*/g, ',')  // extra space
			.replace(/\s*=\s*/g, '=')  // extra space
			.replace(/\/\/+/g, '//')  // fix "////" "///" clauses
		;

		xpath = xpath  // converting
			.replace(/^\/+/, '')  // remove root "/" since it's irrelevant in css
			.replace(/\[(\d+)\]/g, function(s, m1) {return ':eq('+(m1-1)+')';})  // index
			.replace(/\/\./g, '')  // self (parent clause "/.." should be handled before here)
			.replace(/\/\//g, ' ')  // descendant
			.replace(/\//g, ' > ')  // child
			.replace(/@/g, '')  // attribute
			.replace(/\[contains\(text\(\),(\S+?)\)\]/g, ':contains($1)')  // "contains(text(), ...)" clause (jQuery only)
			.replace(/\[contains\((\S+?),(\S+?)\)\]/g, '[$1*=$2]')  // "contains" clause
			.replace(/starts\-with\((\S+?),(\S+?)\)/g, '$1^=$2')  // "starts-with" clause
			.replace(/ends\-with\((\S+?),(\S+?)\)/g, '$1\$=$2')  // "ends-with" clause
		;

		xpath = unescape(xpath);  // unescape strings

		return xpath;
	}

	function validate(xpath) {
		try {
			var result = $(document);
			var selector = xpath2css(xpath);
			if (console)
				console.log('css:', selector);
			result = result.find(selector);
			messaging.send({type: 'xpath-composer-validate-result', result: result.length});
		} catch (e) {
			messaging.send({type: 'xpath-composer-validate-result', result: e.message});
		}
	}
	messaging.recv(error_handler(function(data) {
		switch (data.type) {
			case 'xpath-composer-validate':
				validate(data.xpath);
				break;
		}
	}));
})($);
