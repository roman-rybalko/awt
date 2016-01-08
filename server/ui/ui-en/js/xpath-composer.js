$(error_handler(function($) {
	if ($('#modal-xpath-composer').length) {
		var old_title = null;
		function highlight(title_prefix) {
			if (old_title)
				return;
			old_title = document.title;
			function upd_title() {
				if (!old_title)
					return;
				if (document.title == old_title)
					document.title = title_prefix + ' ' + old_title;
				else
					document.title = old_title;
				setTimeout(upd_title, 500);
			}
			upd_title();
			$(window).one('focus', function() {
				if (!old_title)
					return;
				document.title = old_title;
				old_title = null;
			});
		}
		function validate() {
			$('.xpath-composer-validation').hide();
			$('.xpath-composer-validation[data-status="process"]').show();
			messaging.send({type: 'xpath-composer-validate', xpath: $('#xpath-composer-result').val()});
		}
		function xpath_composer(elements) {
			var xpath_composer_tags = [];
			function upd_title(tag_id) {
				var tag = xpath_composer_tags[tag_id];
				var title = '//' + tag.name;
				var attrs = [];
				for (var a in tag.attrs)
					if (tag.attrs[a].enabled)
						attrs.push(tag.attrs[a].expr);
				if (attrs.length)
					title += '[' + attrs.join(' and ') + ']';
				$('#xpath-composer-tags .xpath-composer-tag-title[data-tag-id=' + tag_id +']').html(title);
			}
			function upd_xpath() {
				var xpath = '';
				var tags = xpath_composer_tags;
				for (var t in tags)
					if (tags[t].enabled) {
						if (t-1 >= 0)
							if (tags[t-1].enabled)
								xpath += '/';
							else
								xpath += '//';
						else
							xpath += '//';
						xpath += tags[t].name;
						var attrs = [];
						for (var a in tags[t].attrs)
							if (tags[t].attrs[a].enabled)
								attrs.push(tags[t].attrs[a].expr);
						if (attrs.length)
							xpath += '[' + attrs.join(' and ') + ']';
					}
				$('#xpath-composer-result').val(xpath);
			}
			function guess_selection() {
				var tag_cnt = 1;
				var tags = xpath_composer_tags;
				for (var t in tags) {
					var upd_fl = false;
					for (var a in tags[t].attrs) {
						var attr = tags[t].attrs[a];
						if (attr.expr.match(/@id|@name|@type|@value|contains.+@src|contains.+@href|contains.+@action|@role/i)) {
							upd_fl = true;
							attr.enabled = true;
							$('#xpath-composer-tags .xpath-composer-attr-control[data-tag-id=' + t + '][data-attr-id=' + a + ']').prop('checked', true);
						}
					}
					if (upd_fl)
						upd_title(t);
				}
				for (var t = tags.length-1, tag_cnt = 1; t >= 0 && tag_cnt > 0; --t)
					for (var a in tags[t].attrs)
						if (tags[t].attrs[a].enabled) {
							tags[t].enabled = true;
							$('#xpath-composer-tags .xpath-composer-tag-control[data-tag-id=' + t + ']').prop('checked', true);
							--tag_cnt;
							break;
						}
				for (var t in tags)
					if (tags[t].name.match(/form|input|button/i)) {
						tags[t].enabled = true;
						$('#xpath-composer-tags .xpath-composer-tag-control[data-tag-id=' + t + ']').prop('checked', true);
						--tag_cnt;
					}
				if (tag_cnt > 0) {
					var t = tags.length - 1;
					tags[t].enabled = true;
					$('#xpath-composer-tags .xpath-composer-tag-control[data-tag-id=' + t + ']').prop('checked', true);
				}
				upd_xpath();
				validate();
			}
			$('#xpath-composer-tags').empty();
			for (var e in elements) {
				var attrs = [];
				for (var name in elements[e].attrs) {
					switch (name.toLowerCase()) {
					case 'href':
					case 'src':
					case 'action':
						var path = elements[e].attrs[name].match(/\/([^\/]+)$/);
						if (path)
							attrs.push({expr: 'contains(@' + name + ', "' + path[1] + '")', name: name, substring: path[1], enabled: false});
						attrs.push({expr: '@' + name + ' = "' + elements[e].attrs[name] + '"', name: name, value: elements[e].attrs[name], enabled: false});
						break;
					case 'class':
						var classes = elements[e].attrs[name].split(/\s+/);
						for (var c in classes)
							attrs.push({expr: 'contains(@' + name + ', "' + classes[c] + '")', name: name, substring: classes[c], enabled: false});
						attrs.push({expr: '@' + name + ' = "' + elements[e].attrs[name] + '"', name: name, value: elements[e].attrs[name], enabled: false});
						break;
					default:
						attrs.push({expr: '@' + name + ' = "' + elements[e].attrs[name] + '"', name: name, value: elements[e].attrs[name], enabled: false});
						break;
					}
				}
				xpath_composer_tags[e] = {name: elements[e].name, attrs: attrs, enabled: false};
				$('#xpath-composer-tag-template .xpath-composer-tag-title').html('//' + elements[e].name);
				$('#xpath-composer-tag-template .xpath-composer-tag-title').attr('data-tag-id', e);
				$('#xpath-composer-tag-template .xpath-composer-tag-text').empty();
				for (var a in attrs) {
					var css = '[' + attrs[a].name;
					if (attrs[a].value)
						css += ' = "' + attrs[a].value + '"';
					if (attrs[a].substring)
						css += ' *= "' + attrs[a].substring + '"';
					css += ']';
					$('#xpath-composer-attr-template .xpath-composer-attr-text').html(attrs[a].expr);
					$('#xpath-composer-attr-template .xpath-composer-attr-text').attr('title', css);
					$('#xpath-composer-attr-template .xpath-composer-attr-control').attr('data-tag-id', e);
					$('#xpath-composer-attr-template .xpath-composer-attr-control').attr('data-attr-id', a);
					$('#xpath-composer-tag-template .xpath-composer-tag-text').append($('#xpath-composer-attr-template').html());
				}
				$('#xpath-composer-tag-template .xpath-composer-tag-link').attr('data-tag-id', e);
				$('#xpath-composer-tag-template .xpath-composer-tag-hidden').attr('data-tag-id', e);
				$('#xpath-composer-tag-template .xpath-composer-tag-control').attr('data-tag-id', e);
				$('#xpath-composer-tags').append($('#xpath-composer-tag-template').html());
			}
			$('#xpath-composer-tags .xpath-composer-tag-hidden').collapse({
				parent: '#xpath-composer-tags',
				toggle: false
			});
			$('#xpath-composer-tags .xpath-composer-tag-link').click(error_handler(function(ev) {
				var tag_id = $(ev.target).attr('data-tag-id');
				$('#xpath-composer-tags .xpath-composer-tag-hidden[data-tag-id=' + tag_id +']').collapse('toggle');
			}));
			//$('#xpath-composer-tags .xpath-composer-tag-hidden').last().collapse('show');
			$('#xpath-composer-tags .xpath-composer-tag-control').change(error_handler(function(ev) {
				var tag_id = $(ev.target).attr('data-tag-id');
				xpath_composer_tags[tag_id].enabled = $(ev.target).prop('checked');
				upd_title(tag_id);
				upd_xpath();
				validate();
			}));
			$('#xpath-composer-tags .xpath-composer-attr-control').change(error_handler(function(ev) {
				var tag_id = $(ev.target).attr('data-tag-id');
				var attr_id = $(ev.target).attr('data-attr-id');
				xpath_composer_tags[tag_id].attrs[attr_id].enabled = $(ev.target).prop('checked');
				upd_title(tag_id);
				upd_xpath();
				validate();
			}));
			guess_selection();
			$('#modal-xpath-composer').modal('show');
			highlight('[XPATH Composer]');
		}
		$('#xpath-composer-result').on('keyup', error_handler(function() {
			validate();
		}));
		function validate_result(result) {
			if (typeof(result) == 'string') {
				$('.xpath-composer-validation').hide();
				$('.xpath-composer-validation[data-status="fail-other"]').find('.xpath-composer-validation-error').html(result);
				$('.xpath-composer-validation[data-status="fail-other"]').show();
			} else switch (result) {
				case -1:
					$('.xpath-composer-validation').hide();
					$('.xpath-composer-validation[data-status="fail-other"]').find('.xpath-composer-validation-error').html(result);
					$('.xpath-composer-validation[data-status="fail-other"]').show();
					break;
				case 0:
					$('.xpath-composer-validation').hide();
					$('.xpath-composer-validation[data-status="fail-none"]').show();
					break;
				case 1:
					$('.xpath-composer-validation').hide();
					$('.xpath-composer-validation[data-status="ok"]').show();
					break;
				default:
					$('.xpath-composer-validation').hide();
					$('.xpath-composer-validation[data-status="fail-more"]').show();
					break;
			}
		}
		messaging.recv(error_handler(function(data) {
			switch (data.type) {
				case 'xpath-composer-elements':
					xpath_composer(data.elements.reverse());
					break;
				case 'xpath-composer-validate-result':
					validate_result(data.result);
					break;
			}
		}));
	}
}));
