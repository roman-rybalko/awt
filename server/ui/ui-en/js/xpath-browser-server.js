(function($) {

	var debug = true;
	var send_msg_key = 'gwLy0GfprNNM';

	$(function() {
	try {
		var proxy_url = _proxy_url;
		var target_url = _target_url;
		function send_msg(data) {
			data.key = send_msg_key;
			try {
				parent.postMessage(data, '*');
			} catch (e) {
				if (debug)
					console.log('postMessage: ' + e);
			}
		}
		setTimeout(function() {
			var cur_selection = {top: -1, left: -1, width: -1, height: -1};
			$('body *').on('mouseover', function(ev) {
				if (ev.eventPhase != Event.AT_TARGET) return;
				var pos = $(this).offset();
				var dim = {width: $(this).width(), height: $(this).height()};
				if (cur_selection.top == pos.top && cur_selection.left == pos.left
						&& cur_selection.width == dim.width && cur_selection.height == dim.height)
					return;
				cur_selection = {top: pos.top, left: top.left, width: dim.width, height: dim.height};
				pos.top -= 5;
				pos.left -= 5;
				dim.width += 10;
				dim.height += 10;
				if (pos.top < 0) pos.top = 0;
				if (pos.left < 0) pos.left = 0;
				$('.selection').remove();
				$('body').append(
					'<div class="selection top" style="position: absolute; border-top: 1px dotted red; z-index: 7777777;'
						+ ' top: ' + pos.top + 'px;'
						+ ' left: ' + pos.left + 'px;'
						+ ' width: ' + dim.width + 'px;'
						+ ' height: 1px;'
					+ '"></div>'
					+ '<div class="selection right" style="position: absolute; border-left: 1px dotted red; z-index: 7777777;'
						+ ' top: ' + pos.top + 'px;'
						+ ' left: ' + (pos.left + dim.width) + 'px;'
						+ ' width: 1px;'
						+ ' height: ' + dim.height + 'px;'
					+ '"></div>'
					+ '<div class="selection bottom" style="position: absolute; border-top: 1px dotted red; z-index: 7777777;'
						+ ' top: ' + (pos.top + dim.height) + 'px;'
						+ ' left: ' + pos.left + 'px;'
						+ ' width: ' + dim.width + 'px;'
						+ ' height: 1px;'
					+ '"></div>'
					+ '<div class="selection left" style="position: absolute; border-left: 1px dotted red; z-index: 7777777;'
						+ ' top: ' + pos.top + 'px;'
						+ ' left: ' + pos.left + 'px;'
						+ ' width: 1px;'
						+ ' height: ' + dim.height + 'px;'
					+ '"></div>');
			});
			function mangle_url(url) {
				if (url) {
					url = url.replace(/^\s+/, '');
					if (url.match(/^\w+:\/\//)) {
						// ok
					} else if (url.match(/^\//))
						if (url.match(/^\/\//))
							url = 'http:' + url;
						else {
							var base = $('base').attr('href');
							var srv = base.match(/^.+:\/\/[^\/]+/)[0];
							url = srv + url;
						}
					else {
						var base = $('base').attr('href');
						base = base.replace(/\/[^\/]+$/, '/');
						url = base + url;
					}
				} else
					url = target_url;
				return url;
			}
			function mangle_root_url(url) {
				if (url == '/' || url.match(/^\s*\/[^\/]/))
					url = mangle_url(url);
				return url;
			}
			$('[href]').each(function() {
				var url = $(this).attr('href');
				var url2 = mangle_root_url(url);
				if (url2 != url)
					$(this).attr('href', url2);
			});
			$('[src]').each(function() {
				var url = $(this).attr('src');
				var url2 = mangle_root_url(url);
				if (url2 != url)
					$(this).attr('src', url2);
			});
			$('body *').mousedown(function(ev) {
				if (ev.eventPhase != Event.AT_TARGET) return;
				var els = [];
				var el = this;
				while (el) {
					var descr = {name: el.nodeName, attrs: {}};
					for (var a = 0; a < el.attributes.length; ++a)
						descr.attrs[el.attributes[a].name] = el.attributes[a].value;
					els.push(descr);
					el = el.parentElement;
				}
				send_msg({type: 'elements', elements: els});
			});
			$('a').click(function() {
				var href = mangle_url($(this).attr('href'));
				href = proxy_url + '?' + href;
				$(this).attr('href', href);
			});
			$('form').submit(function() {
				var href = mangle_url($(this).attr('action'));
				var method = $(this).attr('method');
				if (method && method.match(/post/i)) {
					href = proxy_url + '?' + href;
				} else {
					$.cookie('proxy_target', href);
					href = proxy_url;
				}
				$(this).attr('action', href);
			});
			send_msg({type: 'url', url: window.location.href.match(/\?(.+)/)[1]});
		}, 100);
	} catch (e) {
		// TODO
	}
	});
})(jQuery);
