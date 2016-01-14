// var xpath_composer_autoadd = function(xpath, value) {return false;}
$(error_handler(function($) {
	var old_title = null;
	function highlight_stop() {
		if (!old_title)
			return;
		document.title = old_title;
		old_title = null;
		$(window).off('focus', highlight_stop);
	}
	function highlight(title_prefix) {
		if (old_title)
			return;
		old_title = document.title;
		function title_update() {
			if (!old_title)
				return;
			if (document.title == old_title)
				document.title = title_prefix + ' ' + old_title;
			else
				document.title = old_title;
			setTimeout(title_update, 500);
		}
		title_update();
		$(window).one('focus', highlight_stop);
	}

	function tag_title_update(tag_id) {
		var tag = tags[tag_id];
		var title = '//' + tag.name;
		var preds = [];
		for (var p in tag.preds)
			if (tag.preds[p].enabled)
				if (!tag.preds[p]['nth-of-type'])
					preds.push(tag.preds[p].expr);
				else
					title += '[' + tag.preds[p].expr + ']';
		if (preds.length)
			title += '[' + preds.join(' and ') + ']';
		$('#xpath-composer-tags .xpath-composer-tag-title[data-tag-id=' + tag_id +']').html(title);
	}
	function xpath_update() {
		var xpath = '';
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
						if (!tags[t].preds[p]['nth-of-type'])
							preds.push(tags[t].preds[p].expr);
						else
							xpath += '[' + tags[t].preds[p].expr + ']';
				if (preds.length)
					xpath += '[' + preds.join(' and ') + ']';
			}
		$('#xpath-composer-result').val(xpath);
	}
	function ui_update() {
		for (var t in tags) {
			tag_title_update(t);
			if (tags[t].enabled)
				$('#xpath-composer-tags .xpath-composer-tag-control[data-tag-id=' + t + ']').prop('checked', true);
			else
				$('#xpath-composer-tags .xpath-composer-tag-control[data-tag-id=' + t + ']').prop('checked', false);
			for (var p in tags[t].preds)
				if (tags[t].preds[p].enabled)
					$('#xpath-composer-tags .xpath-composer-pred-control[data-tag-id=' + t + '][data-pred-id=' + p + ']').prop('checked', true);
				else
					$('#xpath-composer-tags .xpath-composer-pred-control[data-tag-id=' + t + '][data-pred-id=' + p + ']').prop('checked', false);
		}
		xpath_update();
	}

	function guess() {
		var tag_cnt = 2;  // enable at least 2 tags
		for (var t in tags) {
			var tag = tags[t];
			if (tag.enabled)
				--tag_cnt;
			for (var p in tag.preds) {
				var pred = tag.preds[p];
				// enable key attributes
				if (pred.expr.match(/@id|@name|@type|@role|contains.+@src|contains.+@action/i))
					pred.enabled = true;
				// OPTION tag has const value attr
				if (tag.name.toLowerCase() == 'option' && pred.expr.match(/@value/i))
					pred.enabled = true;
				// A, BUTTON, H1 tags has a unique text
				if (tag.name.match(/^(a|button|h\d)$/i) && pred.text)
					pred.enabled = true;
			}
		}
		function tag_enable(t) {
			if (t < 0)
				return;
			if (tags[t].enabled)
				return;
			tags[t].enabled = true;
			--tag_cnt;
		}
		// enable the last tag (target)
		tag_enable(tags.length - 1);
		// enable key tags
		for (var t in tags)
			if (tags[t].name.match(/form|input|button|select|option/i))
				tag_enable(t);
		// enable remaining tags having enabled predicates
		for (var t = tags.length-1; t >= 0 && tag_cnt > 0; --t)
			for (var p in tags[t].preds)
				if (tags[t].preds[p].enabled) {
					tag_enable(t);
					break;
				}
		// enable remaining tags
		for (var t = tags.length-1; t >= 0 && tag_cnt > 0; --t)
			tag_enable(t);
		// enable index predicate for enabled tags without enabled predicates
		for (var t in tags) {
			if (!tags[t].enabled)
				continue;
			var enabled = false;
			for (var p in tags[t].preds)
				if (tags[t].preds[p].enabled) {
					enabled = true;
					break;
				}
			if (enabled)
				continue;
			for (var p in tags[t].preds)
				if (tags[t].preds[p]['nth-of-type']) {
					tags[t].preds[p].enabled = true;
					// enable parent since index predicate works only with parent tag
					tag_enable(t-1);
					break;
				}
		}
	}
	$('#xpath-composer-guess').change(error_handler(function() {
		if (!$('#xpath-composer-guess').prop('checked'))
			return;
		optimization_reset();
		guess();
		ui_update();
		validate();
		$('#xpath-composer-guess').prop('checked', false);
	}));

	var tags = [];
	function xpath_composer_elements(elements) {
		tags = [];
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
			if (elements[e].text > '')
				preds.push({expr: 'contains(text(), "' + elements[e].text + '")', text: elements[e].text, enabled: false});
			if (elements[e]['nth-of-type'] > 0)
				preds.push({expr: '' + elements[e]['nth-of-type'], 'nth-of-type': elements[e]['nth-of-type'], enabled: false});
			tags[e] = {name: elements[e].name, preds: preds, enabled: false};
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
					css += ']';
				} else {
					if (preds[p].text)
						css += ':contains("' + preds[p].text + '")';
					if (preds[p]['nth-of-type'])
						css += ':nth-of-type(' + preds[p]['nth-of-type'] + ')';
				}
				$('#xpath-composer-pred-template .xpath-composer-pred-text').html(preds[p].expr);
				$('#xpath-composer-pred-template .xpath-composer-pred-text').attr('title', css);
				$('#xpath-composer-pred-template .xpath-composer-pred-control').attr('data-tag-id', e);
				$('#xpath-composer-pred-template .xpath-composer-pred-control').attr('data-pred-id', p);
				$('#xpath-composer-tag-template .xpath-composer-tag-text').append($('#xpath-composer-pred-template').html());
			}
			$('#xpath-composer-tag-template .xpath-composer-tag-toggle').attr('data-tag-id', e);
			$('#xpath-composer-tag-template .xpath-composer-tag-collapsed').attr('data-tag-id', e);
			$('#xpath-composer-tag-template .xpath-composer-tag-control').attr('data-tag-id', e);
			$('#xpath-composer-tags').append($('#xpath-composer-tag-template').html());
		}
		$('#xpath-composer-tags .xpath-composer-tag-collapsed').collapse({
			parent: '#xpath-composer-tags',
			toggle: false
		});
		$('#xpath-composer-tags .xpath-composer-tag-toggle').click(error_handler(function(ev) {
			var tag_id = $(ev.target).attr('data-tag-id');
			$('#xpath-composer-tags .xpath-composer-tag-collapsed[data-tag-id=' + tag_id +']').collapse('toggle');
		}));
		//$('#xpath-composer-tags .xpath-composer-tag-collapsed').last().collapse('show');
		$('#xpath-composer-tags .xpath-composer-tag-control').change(error_handler(function(ev) {
			var tag_id = $(ev.target).attr('data-tag-id');
			tags[tag_id].enabled = $(ev.target).prop('checked');
			tag_title_update(tag_id);
			xpath_update();
			validate();
		}));
		$('#xpath-composer-tags .xpath-composer-pred-control').change(error_handler(function(ev) {
			var tag_id = $(ev.target).attr('data-tag-id');
			var pred_id = $(ev.target).attr('data-pred-id');
			tags[tag_id].preds[pred_id].enabled = $(ev.target).prop('checked');
			tag_title_update(tag_id);
			xpath_update();
			validate();
		}));
		optimization_reset();
		guess();
		ui_update();
		validate();
		$('#modal-xpath-composer').modal('show');
		highlight('[XPATH Composer]');
		if (xpath_composer_autoadd) {
			var call = true;
			while (true) {
				if (!tags.length)
					break;
				var tag = tags[tags.length-1];
				if (tag.name.toLowerCase() != 'input')
					break;
				for (var p in tag.preds)
					if (tag.preds[p].name && tag.preds[p].name.toLowerCase() == 'type' && tag.preds[p].value.toLowerCase() == 'text') {
						call = false;
						break;
					}
				break;
			}
			if (call && xpath_composer_autoadd($('#xpath-composer-result').val())) {
				highlight_stop();
				$('#modal-xpath-composer').modal('hide');
			}
		}
	}
	function xpath_composer_input(value) {
		if (xpath_composer_autoadd && xpath_composer_autoadd($('#xpath-composer-result').val(), value)) {
			highlight_stop();
			$('#modal-xpath-composer').modal('hide');
		}
	}
	$('#xpath-composer-result').on('keyup', error_handler(function() {
		validate();
	}));

	var optimization_state = null;
	function optimization(count) {
		if (!$('#xpath-composer-optimization').prop('checked'))
			return;
		if (!tags[tags.length - 1].enabled) {  // enable the last tag since it's the key one
			tags[tags.length - 1].enabled = true;
			optimization_state = null;
		} else if (optimization_state) {
			if (typeof(optimization_state.count) == 'string' || optimization_state.count < 1) {
				if (typeof(count) == 'string' || count < 1) {
					for (var t = 0; t < tags.length; ++t) {
						var tag = tags[t];
						if (!tag.enabled)
							continue;
						for (var p = 0; p < tag.preds.length; ++p) {
							var pred = tag.preds[p];
							if (!pred.enabled)
								continue;
							break;
						}
						break;
					}
					optimization_state.count = count;
					if (t < tags.length) {
						if (p < tag.preds.length) {
							pred.enabled = false;
						} else {
							tag.enabled = false;
						}
					} else {
						optimization_reset();  // end
					}
				} else {
					optimization_state = null;
					optimization(count);
					return;
				}
			} else if (optimization_state.count == 1) {
				if (count != 1) {
					if (typeof(optimization_state.tag_id) != 'undefined' && optimization_state.tag_id < tags.length) {
						var tag = tags[optimization_state.tag_id];
						if (optimization_state.pred_id < tag.preds.length) {
							var pred = tag.preds[optimization_state.pred_id];
							pred.enabled = true;
						} else {
							tag.enabled = true;
						}
					}
				}
				if (typeof(optimization_state.tag_id) != 'undefined' && optimization_state.tag_id < tags.length) {
					var tag_id_start = optimization_state.tag_id;
					if (optimization_state.pred_id < tags[tag_id_start].preds.length) {
						var pred_id_start = optimization_state.pred_id + 1;
					} else {
						tag_id_start += 1;
						var pred_id_start = 0;
					}
				} else {
					var tag_id_start = 0;
					var pred_id_start = 0;
				}
				(function() {
					for (var t = tag_id_start; t < tags.length; ++t, tag_id_start = t, pred_id_start = 0) {
						var tag = tags[t];
						if (!tag.enabled)
							continue;
						for (var p = pred_id_start; p < tag.preds.length; ++p) {
							var pred = tag.preds[p];
							if (!pred.enabled)
								continue;
							pred.enabled = false;
							optimization_state.tag_id = t;
							optimization_state.pred_id = p;
							return;
						}
						if (p >= tag.preds.length) {
							if (t >= tags.length - 1) {  // keep the last tag
								optimization_reset();  // end
							} else {
								tag.enabled = false;
								optimization_state.tag_id = t;
								optimization_state.pred_id = p;
							}
							return;
						}
					}
				})();
				if (tag_id_start >= tags.length) {
					optimization_reset();  // end
				}
			} else if (optimization_state.count > 1) {
				if (count == 1) {
					optimization_state = null;
					optimization(count);
					return;
				}
				if (typeof(count) == 'string' || count < 1) {
					if (typeof(optimization_state.tag_id) != 'undefined' && optimization_state.tag_id >= 0) {
						var tag = tags[optimization_state.tag_id];
						if (optimization_state.pred_id >= 0) {
							var pred = tag.preds[optimization_state.pred_id];
							pred.enabled = false;
						} else {
							tag.enabled = false;
						}
					}
				}
				if (typeof(optimization_state.tag_id) != 'undefined' && optimization_state.tag_id >= 0) {
					var tag_id_start = optimization_state.tag_id;
					if (optimization_state.pred_id >= 0) {
						var pred_id_start = optimization_state.pred_id - 1;
					} else {
						var pred_id_start = tags[tag_id_start].preds.length - 1;
					}
				} else {
					var tag_id_start = tags.length - 1;
					var pred_id_start = tags[tag_id_start].preds.length - 1;
				}
				(function() {
					var notext = $('#xpath-composer-optimization-notext').prop('checked');
					var noattr = $('#xpath-composer-optimization-noattr').prop('checked');
					var noindex = $('#xpath-composer-optimization-noindex').prop('checked');
					var nocontains = $('#xpath-composer-optimization-nocontains').prop('checked');
					for (var t = tag_id_start; t >= 0; (function() {
						--t;
						tag_id_start = t;
						if (t >= 0)
							pred_id_start = tags[t].preds.length - 1;
					})()) {
						var tag = tags[t];
						if (!tag.enabled) {
							tag.enabled = true;
							optimization_state.tag_id = t;
							optimization_state.pred_id = -1;
							return;
						}
						for (var p = pred_id_start; p >= 0; --p) {
							var pred = tag.preds[p];
							if (pred.enabled)
								continue;
							if (pred.text && notext)
								continue;
							if ((pred.expr.substr(0, 1) == '@') && noattr)
								continue;
							if (pred['nth-of-type'] && noindex)
								continue;
							if ((pred.expr.substr(0, 9) == 'contains(') && nocontains)
								continue;
							pred.enabled = true;
							optimization_state.tag_id = t;
							optimization_state.pred_id = p;
							return;
						}
					}
				})();
				if (tag_id_start < 0) {
					optimization_reset();  // end
				}
			} else {
				throw new Error('xpath optimization: unexpected state: ' + JSON.stringify(optimization_state));
			}
		} else {
			optimization_state = {
				count: count
			};
			optimization(count);
			return;
		}
		ui_update();
		validate();
	}
	function optimization_reset(enable) {
		optimization_state = null;
		$('#xpath-composer-optimization').prop('checked', enable ? true : false);
	}
	$('#xpath-composer-optimization').change(error_handler(function() {
		if (!$('#xpath-composer-optimization').prop('checked'))
			return;
		optimization_reset('enable');
		validate();
	}));

	function validate() {
		$('.xpath-composer-validation').hide();
		$('.xpath-composer-validation[data-status="process"]').show();
		messaging.send({type: 'xpath-composer-validate', xpath: $('#xpath-composer-result').val()});
	}
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
		optimization(result);
	}

	function clear() {
		for (t in tags) {
			tags[t].enabled = false;
			for (p in tags[t].preds)
				tags[t].preds[p].enabled = false;
		}
	}
	$('#xpath-composer-clear').click(error_handler(function() {
		clear();
		ui_update();
	}));

	messaging.recv(error_handler(function(data) {
		switch (data.type) {
			case 'xpath-composer-elements':
				xpath_composer_elements(data.elements.reverse());
				break;
			case 'xpath-composer-input':
				xpath_composer_input(data.value);
				break;
			case 'xpath-composer-validate-result':
				validate_result(data.result);
				break;
		}
	}));
}));
