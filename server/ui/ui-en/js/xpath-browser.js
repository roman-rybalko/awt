$(error_handler(function($) {
	var storage = new Storage('xpath-browser-');
	function browser_url(url) {
		if (url) {
			$('.xpath-browser-url').val(url);
			storage.set('url', url);
		} else {
			url = storage.get('url');
			$('.xpath-browser-url').val(url);
		}
	}
	function url_history(pos) {
		var data = storage.get('history');
		if (!data)
			data = {pos: -1, urls: []};
		pos += data.pos;
		if (pos < 0 || pos >= data.urls.length)
			return null;
		var url = data.urls[pos];
		if (data.pos != pos) {
			data.pos = pos;
			storage.set('history', data);
		}
		return url;
	}
	function url_history_add(url) {
		var data = storage.get('history');
		if (!data)
			data = {pos: -1, urls: []};
		data.urls.splice(data.pos + 1, data.urls.length - (data.pos + 1), url);
		data.pos = data.urls.length - 1;
		storage.set('history', data);
	}
	browser_url();
	$('.xpath-browser-backward').click(error_handler(function() {
		var url = url_history(-1);
		browser_url(url);
	}));
	$('.xpath-browser-forward').click(error_handler(function() {
		var url = url_history(+1);
		browser_url(url);
	}));
	$('.xpath-browser-open').click(error_handler(function(ev) {
		var id = $(ev.target).attr('data-id');
		var url = $('#xpath-browser-url-' + id).val();
		if (!url)
			return;
		if (!url.match(/:\/\//))
			url = 'http://' + url;
		messaging.set_target(window.open(url));
		if (url_history(0) != url)
			url_history_add(url);
	}));
	messaging.recv(error_handler(function(data) {
		switch (data.type) {
			case 'xpath-browser-url':
				if (url_history(0) != data.url) {
					browser_url(data.url);
					url_history_add(data.url);
				}
				break;
		}
	}));
}));
