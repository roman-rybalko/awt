(function($) {

	var debug = true;
	var send_msg_key = 'gwLy0GfprNNM';
	var recv_msg_key = 'sRiLTYpar7EU';

	function send_msg(data) {
		data.key = send_msg_key;
		try {
			parent.postMessage(data, '*');
		} catch (e) {
			if (debug)
				console.log('postMessage: ' + e);
		}
	}
	function validate_tags(tags) {
		if (!tags.length) {
			send_msg({type: 'validate_result', result: -1});
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
			send_msg({type: 'validate_result', result: result.length});
		} catch (e) {
			if (debug)
				console.log('validate error:', e);
			send_msg({type: 'validate_result', result: -1});
		}
	}
	$(window).on('message', function(ev) {
		var data = ev.originalEvent.data;
		if (data.key != recv_msg_key) {
			if (debug)
				console.log('Bad message key, message: ' + JSON.stringify(data));
			return;
		}
		switch (data.type) {
		case 'validate':
			validate_tags(data.tags);
			break;
		default:
			if (debug)
				console.log('Unhandled message: ' + JSON.stringify(data));
		}
	});
})(jQuery);
