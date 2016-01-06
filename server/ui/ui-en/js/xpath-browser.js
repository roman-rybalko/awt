$(error_handler(function() {
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
		data.pos = pos;
		var url = data.urls[pos];
		storage.set('history', data);
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
	$('.xpath-browser-backward').click(function() {
		var url = url_history(-1);
		browser_url(url);
	});
	$('.xpath-browser-forward').click(function() {
		var url = url_history(+1);
		browser_url(url);
	});
	$('.xpath-browser-open').click(function() {
		var id = $(this).attr('data-id');
		var url = $('#xpath-browser-url-' + id).val();
		if (!url) return;
		if (messaging.target)
			messaging.target.close();
		messaging.target = window.open(url);
	});
	messaging.onrecv(error_handler(function(data) {
		switch (data.type) {
			case 'xpath-browser-url':
				browser_url(data.url);
				url_history_add(data.url);
				break;
		}
	}));
}));
