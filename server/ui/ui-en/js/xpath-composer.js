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
				var preds = [];
				for (var p in tag.preds)
					if (tag.preds[p].enabled)
						preds.push(tag.preds[p].expr);
				if (preds.length)
					title += '[' + preds.join(' and ') + ']';
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
						var preds = [];
						for (var p in tags[t].preds)
							if (tags[t].preds[p].enabled)
								preds.push(tags[t].preds[p].expr);
						if (preds.length)
							xpath += '[' + preds.join(' and ') + ']';
					}
				$('#xpath-composer-result').val(xpath);
			}
			function guess_selection() {
				var tag_cnt = 1;
				var tags = xpath_composer_tags;
				for (var t in tags) {
					var upd_fl = false;
					for (var p in tags[t].preds) {
						var pred = tags[t].preds[p];
						if (
							pred.expr.match(/@id|@name|@type|@value|contains.+@src|contains.+@href|contains.+@action|@role/i)
							|| (!pred.name && pred.substring && pred.substring.length < 42 /* magic length */)
						) {
							upd_fl = true;
							pred.enabled = true;
							$('#xpath-composer-tags .xpath-composer-pred-control[data-tag-id=' + t + '][data-pred-id=' + p + ']').prop('checked', true);
						}
					}
					if (upd_fl)
						upd_title(t);
				}
				for (var t = tags.length-1, tag_cnt = 1; t >= 0 && tag_cnt > 0; --t)
					for (var p in tags[t].preds)
						if (tags[t].preds[p].enabled) {
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
				var preds = [];
				for (var a in elements[e].attrs) {
					switch (a.toLowerCase()) {
						case 'href':
						case 'src':
						case 'action':
							var path = elements[e].attrs[a].match(/\/([^\/]+)$/);
							if (path)
								preds.push({expr: 'contains(@' + a + ', "' + path[1] + '")', name: a, substring: path[1], enabled: false});
							preds.push({expr: '@' + a + ' = "' + elements[e].attrs[a] + '"', name: a, value: elements[e].attrs[a], enabled: false});
							break;
						case 'class':
							var classes = elements[e].attrs[a].split(/\s+/);
							for (var c in classes)
								preds.push({expr: 'contains(@' + a + ', "' + classes[c] + '")', name: a, substring: classes[c], enabled: false});
							preds.push({expr: '@' + a + ' = "' + elements[e].attrs[a] + '"', name: a, value: elements[e].attrs[a], enabled: false});
							break;
						default:
							preds.push({expr: '@' + a + ' = "' + elements[e].attrs[a] + '"', name: a, value: elements[e].attrs[a], enabled: false});
							break;
					}
				}
				preds.push({expr: 'contains(text(), "' + elements[e].text + '")', substring: elements[e].text, enabled: false});
				xpath_composer_tags[e] = {name: elements[e].name, preds: preds, enabled: false};
				$('#xpath-composer-tag-template .xpath-composer-tag-title').html('//' + elements[e].name);
				$('#xpath-composer-tag-template .xpath-composer-tag-title').attr('data-tag-id', e);
				$('#xpath-composer-tag-template .xpath-composer-tag-text').empty();
				for (var p in preds) {
					var css = '';
					if (preds[p].name) {
						css += '[' + preds[p].name;
						if (preds[p].value)
							css += ' = "' + preds[p].value + '"';
						if (preds[p].substring)
							css += ' *= "' + preds[p].substring + '"';
						if (preds[p].name)
							css += ']';
					} else {
						if (preds[p].substring)
							css += ':contains("' + preds[p].substring + '")';
					}
					$('#xpath-composer-pred-template .xpath-composer-pred-text').html(preds[p].expr);
					$('#xpath-composer-pred-template .xpath-composer-pred-text').attr('title', css);
					$('#xpath-composer-pred-template .xpath-composer-pred-control').attr('data-tag-id', e);
					$('#xpath-composer-pred-template .xpath-composer-pred-control').attr('data-pred-id', p);
					$('#xpath-composer-tag-template .xpath-composer-tag-text').append($('#xpath-composer-pred-template').html());
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
			$('#xpath-composer-tags .xpath-composer-pred-control').change(error_handler(function(ev) {
				var tag_id = $(ev.target).attr('data-tag-id');
				var pred_id = $(ev.target).attr('data-pred-id');
				xpath_composer_tags[tag_id].preds[pred_id].enabled = $(ev.target).prop('checked');
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
			} else
			switch (result) {
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
					$('.xpath-composer-validation[data-status="fail-count"]').find('.xpath-composer-validation-count').html(result);
					$('.xpath-composer-validation[data-status="fail-count"]').show();
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
