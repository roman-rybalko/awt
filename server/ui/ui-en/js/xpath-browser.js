$(error_handler(function($) {
	if (!$('.xpath-browser-open').length)
		return;

	var hist_urls_max_cnt = 42;  // a const

	var storage = new Storage('xpath-browser-');

	function url_history(pos) {
		var data = storage.get('history');
		if (!data)
			data = {pos: -1, urls: []};
		pos += data.pos;
		if (pos < 0)
			pos = 0;
		if (pos >= data.urls.length - 1)
			pos = data.urls.length - 1;
		if (pos < 0)
			return '';
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
		if (data.urls.length == 0 || data.urls[data.urls.length - 1] != url) {
			data.urls.push(url);
		}
		data.pos = data.urls.length - 1;
		if (data.urls.length > hist_urls_max_cnt) {
			data.pos -= data.urls.length - hist_urls_max_cnt;
			data.urls.splice(0, data.urls.length - hist_urls_max_cnt);
		}
		storage.set('history', data);
	}

	function browser_url(id, url) {
		if (url) {
			$('#xpath-browser-url-' + id).val(url);
			storage.set('url', url);
		} else {
			url = storage.get('url');
			$('#xpath-browser-url-' + id).val(url);
		}
	}

	var id;
	var state = {};

	$('.xpath-browser-backward').click(error_handler(function() {
		var id = $(this).attr('data-id');
		var url = $('#xpath-browser-url-' + id).val();
		url = url_history(-1);
		browser_url(id, url);
		state.url = url;
	}));
	$('.xpath-browser-forward').click(error_handler(function() {
		var id = $(this).attr('data-id');
		var url = $('#xpath-browser-url-' + id).val();
		url = url_history(+1);
		browser_url(id, url);
		state.url = url;
	}));

	$('.xpath-browser-open').click(error_handler(function() {
		var id = $(this).attr('data-id');
		var url = $('#xpath-browser-url-' + id).val();
		if (!url)
			return;
		if (!url.match(/:\/\//))
			url = 'http://' + url;
		url_history_add(url);
		if (state.tags)
			$(document).triggerHandler('xpath-composer', [state.tags]);
		messaging.set_target(window.open(url));
	}));

	$(document).on('xpath-composer-state', error_handler(function() {
		state.url = $('#xpath-browser-url-' + id).val();  // re-read new url
	}));
	$(document).on('xpath-composer-done', error_handler(function(ev, xpath, data, tags) {
		state.tags = tags;
		$(document).triggerHandler('xpath-browser-done', [id, xpath, data, JSON.stringify(state)]);
	}));

	$(document).on('xpath-browser', error_handler(function(ev, new_id, state_data) {
		id = new_id;
		try {
			state = JSON.parse(state_data);
		} catch (e) {
			state = {};
		}
		if (state.url)
			$('#xpath-browser-url-' + id).val(state.url);
		else
			$('#xpath-browser-url-' + id).val(url_history(0));
	}));

	messaging.recv(error_handler(function(data) {
		switch (data.type) {
			case 'xpath-browser-url':
				if (url_history(0) != data.url) {
					browser_url(id, data.url);
					url_history_add(data.url);
				}
				$(document).triggerHandler('xpath-browser-url', [data.url]);
				break;
		}
	}));
}));
