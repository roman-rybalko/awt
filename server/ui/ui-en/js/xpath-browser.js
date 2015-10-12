$(function() {

	var debug = true;
	var storage_expire = 42;  // days

	if ($('.xpath-browser-wnd').length) {
		var storage = new Storage('xpath-browser-', storage_expire);
		$('.xpath-browser-wnd').resizable({
			handles: 's',
			disabled: true,
			stop: function(ev, ui) {
				storage.set('height', ui.size.height);
			}
		});
		function browser_url(url) {
			if (url) {
				$('.xpath-browser-url').val(url);
				storage.set('url', url);
			} else {
				url = storage.get('url');
				$('.xpath-browser-url').val(url);
			}
		}
		function browser_go(id, url) {
			if (url) {
				$('#xpath-browser-iframe-' + id).attr('src', 'php/proxy.php?' + url);
				$('#xpath-browser-wnd-' + id).resizable('option', 'disabled', false);
				$('#xpath-browser-wnd-' + id).height(storage.get('height') || 400);
			} else {
				$('#xpath-browser-iframe-' + id).attr('src', '');
				$('#xpath-browser-wnd-' + id).resizable('option', 'disabled', true);
				$('#xpath-browser-wnd-' + id).height(0);
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
		$('.xpath-browser-back').click(function() {
			var url = url_history(-1);
			browser_url(url);
		});
		$('.xpath-browser-forward').click(function() {
			var url = url_history(+1);
			browser_url(url);
		});
		$('[data-xpath-browser-form-id]').submit(function(ev) {
			ev.preventDefault();
			var id = $(this).attr('data-xpath-browser-form-id');
			var url = $('#xpath-browser-url-' + id).val();
			if (!url) return;
			browser_url(url);
			if (!url.match(/:\/\//))
				url = 'http://' + url;
			if (!url.match(/\/\/\S+\//))
				url += '/';
			browser_go(id, url);
		});
		$(window).on('message', function(ev) {
			var data = ev.originalEvent.data;
			if (data.key != 'gwLy0GfprNNM') {
				if (debug)
					console.log('Bad message key, message: ' + JSON.stringify(data));
				return;
			}
			switch (data.type) {
			case 'url':
				browser_url(data.url);
				url_history_add(data.url);
				break;
			default:
				if (debug)
					console.log('Unhandled message: ' + JSON.stringify(data));
				break;
			}
		});
	}
});
