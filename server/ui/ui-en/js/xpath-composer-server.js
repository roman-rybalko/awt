_awt_error_handler(function($) {
	var messaging = _awt_messaging;
	var error_handler = _awt_error_handler;
	$('body *').mousedown(error_handler(function(ev) {
		if (ev.eventPhase != Event.AT_TARGET)
			return;
		var els = [];
		var el = ev.target;
		while (el) {
			var descr = {name: el.nodeName, attrs: {}};
			for (var a = 0; a < el.attributes.length; ++a)
				descr.attrs[el.attributes[a].name] = el.attributes[a].value;
			els.push(descr);
			el = el.parentElement;
		}
		messaging.send({type: 'xpath-composer-elements', elements: els});
	}));
	function validate_tags(tags) {
		if (!tags.length) {
			messaging.send({type: 'xpath-composer-validate-result', result: -1});
			return;
		}
		try {
			var result = $(document);
			for (var t in tags) {
				var selector = tags[t].name;
				var attrs = [];
				for (var a in tags[t].attrs) {
					var attr = '[' + tags[t].attrs[a].name;
					if (tags[t].attrs[a].value)
						attr += '="' + tags[t].attrs[a].value.replace(/"/g, '\\"') + '"';
					if (tags[t].attrs[a].substring)
						attr += '*="' + tags[t].attrs[a].substring.replace(/"/g, '\\"') + '"';
					attr += ']';
					attrs.push(attr);
				}
				selector += attrs.join('');
				result = result.find(selector);
			}
			messaging.send({type: 'xpath-composer-validate-result', result: result.length});
		} catch (e) {
			messaging.send({type: 'xpath-composer-validate-result', result: -1});
			throw e;
		}
	}
	messaging.recv(error_handler(function(data) {
		switch (data.type) {
			case 'xpath-composer-validate':
				validate_tags(data.tags);
				break;
		}
	}));
})(jQuery);
