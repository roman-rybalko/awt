$(error_handler(function($) {
	var input_value = null;
	$('body *').on('mouseup', error_handler(function(ev) {
		if (ev.eventPhase != Event.AT_TARGET)
			return;
		if (input_value) {
			messaging.send({type: 'xpath-composer-input', value: input_value});
			input_value = null;
		}
		var els = [];
		var el = ev.target;
		var selection = document.getSelection();
		while (el) {
			var descr = {
				name: el.nodeName,
				attrs: {},
				text: $(el).text().replace(/^\s+/, '').replace(/\s+$/, '').substr(0, 128),
				'nth-of-type': $(el.parentElement).children(el.nodeName).index(el) + 1
			};
			if (selection) {
				descr.selection = selection.toString();
				selection.removeAllRanges();
				selection = null;
			}
			for (var a = 0; a < el.attributes.length; ++a)
				descr.attrs[el.attributes[a].name] = el.attributes[a].value;
			els.push(descr);
			el = el.parentElement;
		}
		messaging.send({type: 'xpath-composer-elements', elements: els});
	}));
	$('body input[type="text"]').on('keyup', error_handler(function() {
		input_value = $(this).val();
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

		xpath = xpath  // strings pre-processing
			// escape strings, will not escape empty strings ("") or unquoted strings (string-without-quotes)
			.replace(/(=|,|\[|and)(\s*)("|')(.*?[^\\]\3)/g, function(s, m1, m2, m3, m4) {return m1 + m2 + escape(m3 + m4);})
			.replace(/\(:.+?:\)/g, '')  // remove XPATH 2.0 comments (after string escaping since a string containing a comment is a valid expression)
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

		if (xpath.match(/\]\[\d+\]|\)\[\d+\]/))
			throw new Error('xpath clauses "x[...][n]", "(...)[n]" (node-set index) are not supported, though "*[n]", "x[n]", "...[n][...]" (:nth-child, :nth-of-type) are ok');
		if (xpath.match(/.\/\/[^\/]+\[\d+\]/))
			throw new Error('xpath clause "//y//x[n]" is not supported, use "//y//z/x[n]" instead (specify a parent for an indexed tag), though "//x[n]" (:eq) is ok');
		if (xpath.match(/not\(/))
			throw new Error('xpath clause "not(...)" is unsupported');

		xpath = xpath  // converting
			.replace(/^\/\/([^\/]+)\[(\d+)\]/, function(s, m1, m2) {return m1 + ':eq(' + (m2 - 1) + ')'})  // index (before "//" converting)
			.replace(/^\/+/, '')  // remove root "/" since it's irrelevant in css
			.replace(/\/\./g, '')  // self (parent clause "/.." should be handled before here)
			.replace(/\/\//g, ' ')  // descendant
			.replace(/\//g, ' > ')  // child
			.replace(/position\(\)=/g, '')  // "position() = n" clause (preprocess, will be handled further in index)
			.replace(/\*\[(\d+)\]/g, '*:nth-child($1)')  // index
			.replace(/\[(\d+)\]/g, ':nth-of-type($1)')  // index
			.replace(/@/g, '')  // attribute
			.replace(/\[contains\(text\(\),(\S+?)\)\]/g, ':contains($1)')  // "contains(text(), ...)" clause (jQuery only)
			.replace(/\[contains\((\S+?),(\S+?)\)\]/g, '[$1*=$2]')  // "contains" clause
			.replace(/starts\-with\((\S+?),(\S+?)\)/g, '$1^=$2')  // "starts-with" clause
			.replace(/ends\-with\((\S+?),(\S+?)\)/g, '$1\$=$2')  // "ends-with" clause
			.replace(/\[__ESCAPE__\S+?\]/g, '')  // always-true-string as a comment
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
			if (result.length)
				$(document).triggerHandler('xpath-browser-selection', [result.get(0), 'scroll to target (bool)']);
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
}));
