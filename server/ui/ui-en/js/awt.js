/**
 * Loads the correct sidebar on window load,
 * collapses the sidebar on window resize.
 */
$(error_handler(function($) {
	var sidebarCollapsed = null;
	$(window).bind("load resize", error_handler(function() {
		var width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
		if (width < 768) {
			if (sidebarCollapsed === null || sidebarCollapsed === false) {
				$('div.navbar-collapse').addClass('collapse');
				$("#page-wrapper").css("min-height", "0");
				sidebarCollapsed = true;
			}
		} else {
			if (sidebarCollapsed === null || sidebarCollapsed === true) {
				$('div.navbar-collapse').removeClass('collapse');
				$("#page-wrapper").css("min-height", "calc(100vh - 51px - 51px)");  // viewport - header - footer (with borders)
				sidebarCollapsed = false;
			}
		}
	}));

	var url = window.location;
	var element = $('ul.nav a').filter(function() {
		return this.href == url || url.href.indexOf(this.href) == 0;
	}).addClass('active').parent().parent().addClass('in').parent();
	if (element.is('li')) {
		element.addClass('active');
	}

	if ($('#side-menu').length)
		$('#side-menu').metisMenu();
}));

$(error_handler(function($) {
	if (navigator && navigator.userAgent.match(/MSIE\s*[23456789]/)) error_handler(function() {
		var showed = document.cookie.match(/msie_support_alert/);
		if (!showed) {
			var d = new Date();
		    d.setTime(d.getTime() + 24*60*60*1000);
		    document.cookie = 'msie_support_alert=1; expires=' + d.toUTCString();
		}
		if (!showed) {
			alert('Internet Explorer is not fully supported. Please, consider to upgrade to Google Chrome, Opera, Firefox or Safari.');
		}
	})();
	$('.location-path').html(document.location.href.replace(/\/[^\/]*$/,'/'));
	$('a.location-href').attr('href', document.location.href);
	$('.action-type').each(function() {
		var select = $(this);
		var id = select.attr('data-id');
		var options = select.find('option');
		options.each(function() {
			var type = $(this).attr('value');
			var descr = $('#action-type-' + type + '-' + id).html();
			if (descr)
				$(this).html(descr);
		});
		var action_form_update = function() {
			options.each(function() {
				var type = $(this).attr('value');
				var wrap = $('#action-wrap-type-' + type + '-' + id);
				if ($(this).prop('selected')) {
					wrap.find('input, select').prop('disabled', false);
					wrap.show();
				} else {
					wrap.find('input, select').prop('disabled', true);
					wrap.hide();
				}
			});
		}
		action_form_update();
		select.on('change', action_form_update);
	});
	$('.action-wrap-data-proxy').each(function() {
		var wrap = $(this);
		var id = wrap.attr('data-id');
		var action_data_update = function() {
			if ($('#action-selector-proxy-' + id + ' option:selected').attr('value') == 'custom') {
				$('#action-data-proxy-' + id).prop('disabled', false);
				wrap.show();
			} else {
				$('#action-data-proxy-' + id).prop('disabled', true);
				wrap.hide();
			}
		}
		action_data_update();
		$('#action-selector-proxy-' + id).on('change', action_data_update);
	});
	if (typeof task_types !== 'undefined') error_handler(function() {
		var index = [];
		for (var tt in task_types) {
			index[task_types[tt].name] = task_types[tt];
			index[task_types[tt].id] = task_types[tt];
			task_types[tt].children = [];
		}
		for (var tt in task_types)
			if (index[task_types[tt].parent_id])
				index[task_types[tt].parent_id].children.push(task_types[tt]);
		var cache = {};
		$('.task-type').each(function() {
			var name = $(this).html().replace(/\s+/g, '');
			if (!cache[name]) {
				var type = index[name];
				if (type) {
					var names = [];
					function walk(type) {
						if (names.indexOf(type.name) == -1)
							names.push(type.name);
						for (var c in type.children)
							walk(type.children[c]);
					}
					walk(type);
					cache[name] = names.join(', ');
				} else {
					cache[name] = name;
				}
			}
			$(this).attr('title', cache[name]);
		});
	})();
	$('#xpath-composer-ok').click(error_handler(function(ev) {
		var xpath = $('#xpath-composer-result').val();
		$('input.action-xpath-element').val(xpath);
		$('input.action-xpath-expression').val(xpath + '/@class');
	}));
	var datetime_format = 'YYYY-MM-DD HH:mm:ss';
	$('.date input').each(function() {
		var value = $(this).val();
		if (value.match(/^\s*$/))
			$(this).val(moment(new Date().getTime() + 3600000).format(datetime_format));
		if (value.match(/^\s*\d+\s*$/))
			$(this).val(moment.unix(value).format(datetime_format));
	});
	if ($('.date').length)
		$('.date').datetimepicker({
			allowInputToggle: true,
			format: datetime_format
		});
	$('.form-schedule-task').submit(error_handler(function(ev) {
		if (! $(ev.target).find('input[name="name"]').val().match(/\S/)) {
			$(ev.target).find('input[name="name"]').focus();
			return false;
		}
		$(ev.target).find('.date input').each(function() {
			$(this).val(moment($(this).val(), datetime_format).unix());
		});
	}));
	if (typeof sched_tests !== 'undefined') error_handler(function() {
		var tests = [];
		for (var st in sched_tests)
			tests[sched_tests[st].id] = sched_tests[st].name;
		$('.test-id2name').each(function() {
			var id = $(this).html().replace(/\s+/g, '');
			if (tests[id])
				$(this).html(tests[id]);
			else {
				$(this).html('<i class="fa fa-times text-failure" title="Deleted"></i><span style="display: none;">' + id + ' (order data)</span>');
				$(this).closest('tr').toggleClass('danger', true);
			}
		});
	})();
	function period_unix2human(period) {
		var data = [];
		var units = 0;
		if (units = period % 60)
			data.unshift(units + (units == 1 ? ' second' : ' seconds'));
		period = (period - units) / 60;
		if (units = period % 60)
			data.unshift(units + (units == 1 ? ' minute' : ' minutes'));
		period = (period - units) / 60;
		if (units = period % 24)
			data.unshift(units + (units == 1 ? ' hour' : ' hours'));
		period = (period - units) / 24;
		if (units = period % 7)
			data.unshift(units + (units == 1 ? ' day' : ' days'));
		period = (period - units) / 7;
		if (period)
			data.unshift(period + (period == 1 ? ' week' :' weeks'));
		return data.join(' ');
	}
	$('.period-unix2human').each(function() {
		var period = $(this).html().replace(/\s+/g, '');
		period = period_unix2human(period);
		$(this).html(period);
	});
	$('.time-unix2human').each(function() {
		var time = $(this).html().replace(/\s+/g, '');
		$(this).html(moment.unix(time).format(datetime_format));
	});
	if ($('.table-dataTable').length) error_handler(function() {  // after .time-unix2human .period-unix2human
		var table = $('.table-dataTable').DataTable({
			responsive: true			
		});
		var hash = window.location.hash;
		if (hash)
			table.search(hash).draw();
	})();
	if ($('.tip-state').length) error_handler(function() {
		var storage = new Storage('tip-state-', 42 /* expire days */);
		$('.tip-state').each(function() {
			var name = $(this).attr('data-tip-state');
			var value = storage.get(name);
			if (value)
				$(this).closest('.alert').alert('close');
		});
		$('.tip-state').click(error_handler(function(ev) {
			var name = $(ev.target).attr('data-tip-state');
			storage.set(name, true);
		}));
	})();
	if ($('.control-state').length) error_handler(function() {
		var storage = new Storage('control-state-' + awt_login + '-');
		$('input.control-state[type="checkbox"], input.control-state[type="radio"]').each(function() {
			var name = $(this).attr('data-control-state');
			var value = storage.get(name);
			if (value)
				$(this).click();
		});
		$('input.control-state[type="checkbox"]').change(error_handler(function(ev) {
			var name = $(ev.target).attr('data-control-state');
			storage.set(name, $(ev.target).prop('checked'));
		}));
		$('input.control-state[type="radio"]').change(error_handler(function(ev) {
			var name = $(ev.target).attr('name');
			$('input.control-state[type="radio"][name="' + name + '"]').each(function() {
				var name = $(ev.target).attr('data-control-state');
				if (name)
					storage.set(name, false);
			});
			var name = $(ev.target).attr('data-control-state');
			storage.set(name, $(ev.target).prop('checked'));
		}));
	})();
	function aggregate_day(data) {
		var d = new Date();
		var offset = d.getTime() - d.getTime() % 86400000 - new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0, 0).getTime();
		function day_start(time) {
			return time - (time + offset) % 86400000;
		}
		var result = {};
		for (var i in data) {
			var time = day_start(data[i][0]);
			if (!result[time])
				result[time] = 0;
			result[time] += data[i][1];
		}
		var result2 = [];
		for (var i in result)
			result2.push([i, result[i]]);
		return result2.sort(function(a,b){return a[0]-b[0];});
	}
	if ($('#tasks-chart').length) error_handler(function() {
		var options = {
			series: {
				bars: {
					show: true,
					barWidth: 86400000,
					fill: true
				}
			},
			xaxis: {
				mode: "time",
				timeformat: "%d",
				minTickSize: [1, "day"]
			},
			yaxis: {
				tickDecimals: 0
			},
			grid: {
				hoverable: true // for tooltp
			},
			tooltip: true,
			tooltipOpts: {
				content: "%y"
			}
		};
		var data1 = {
			label: 'Started',
			color: '#679dc6',
			bars: {
				fillColor: '#679dc6'
			},
			data: aggregate_day(tasks_added),
		};
		var data2 = {
			label: 'Finished',
			color: '#5cb85c',
			bars: {
				fillColor: '#5cb85c'
			},
			data: aggregate_day(tasks_finished)
		};
		var data3 = {
			label: 'Failed',
			color: '#cb4b4b',
			bars: {
				fillColor: '#cb4b4b'
			},
			data: aggregate_day(tasks_failed),
		};
		$('#tasks-chart').plot([data1, data2, data3], options);
	})();
	if ($('#task-actions-chart').length) error_handler(function() {
		var options = {
			series: {
				bars: {
					show: true,
					barWidth: 86400000,
				}
			},
			xaxis: {
				mode: "time",
				timeformat: "%d",
				minTickSize: [1, "day"]
			},
			yaxis: {
				tickDecimals: 0
			},
			grid: {
				hoverable: true // for tooltp
			},
			tooltip: true,
			tooltipOpts: {
				content: "%y"
			}
		};
		var data1 = {
			label: 'Executed',
			color: '#edc240',
			data: aggregate_day(actions_executed)
		};
		$('#task-actions-chart').plot([data1], options);
	})();
	if ($('a.apply-data-display-period, form.apply-data-display-period').length) error_handler(function() {
		var storage = new Storage('setting-' + awt_login + '-');
		var time = storage.get('data-display-period');
		if (time === null && awt_login == '') {  /// set default for demo login
			time = 86400;
			storage.set('data-display-period', time);
		}
		if (time > 0) {
			time = Math.round(new Date().getTime() / 1000) - time;
			$('a.apply-data-display-period, form.apply-data-display-period').each(function() {
				var attr = 'href';
				if ($(this).attr('action'))
					attr = 'action';
				$(this).attr(attr, $(this).attr(attr) + '&time=' + time);
			});
		}
	})();
	if ($('span.apply-data-display-period, div.apply-data-display-period').length) error_handler(function() {
		if (typeof(awt_time) != 'undefined' && awt_time > 0) {
			var period = Math.round(new Date().getTime() / 1000) - awt_time;
			period = period_unix2human(period);
			$('span.apply-data-display-period, div.apply-data-display-period').each(function() {
				$(this).html('(past ' + period + ')');
			});
		}
	})();
	if ($('select#setting-data-display-period').length) error_handler(function() {
		var storage = new Storage('setting-' + awt_login + '-');
		var time = storage.get('data-display-period') || 0;
		$('select#setting-data-display-period option').each(function() {
			if ($(this).val() == time)
				$(this).prop('selected', true);
		});
		$('select#setting-data-display-period').change(error_handler(function(ev) {
			time = $(ev.target).val();
			storage.set('data-display-period', time);
			if (time > 0)
				time = Math.round(new Date().getTime() / 1000) - time;
			$('a.apply-data-display-period').each(function() {
				$(this).attr('href', $(this).attr('href') + '&time=' + time);
			});
		}));
	})();
	$('.modal').on('shown.bs.modal', function() {
		$(this).find('.form-control').first().focus();
	});
	$('.modal-pending-transaction-code').first().modal('show');
}));

var xpath_composer_autoadd_queue = [];
var xpath_composer_autoadd = error_handler(function(xpath, value) {
	if (!$('#action-autoadd-control').prop('checked'))
		return false;
	var start = ! xpath_composer_autoadd_queue.length;
	xpath_composer_autoadd_queue.push({xpath: xpath, value: value});
	function process_queue() {
		if (!xpath_composer_autoadd_queue.length)
			return;
		if (!$('#action-autoadd-control').prop('checked')) {
			xpath_composer_autoadd_queue = [];
			return;
		}
		var op = xpath_composer_autoadd_queue[0];
		loader.show();
		var params = {add: 1, selector: op.xpath};
		if (op.value) {
			params.type = 'enter';
			params.data = op.value;
		} else {
			params.type = 'click';
		}
		$.post(document.location.href, params).done(error_handler(function() {
			var op = xpath_composer_autoadd_queue.shift();
			if (op.value) {
				$('#action-autoadd-template-enter .action-autoadd-enter-xpath').html(op.xpath);
				$('#action-autoadd-template-enter .action-autoadd-enter-value').html(op.value);
				$('#action-autoadd-container').append($('#action-autoadd-template-enter').html());
			} else {
				$('#action-autoadd-template-click .action-autoadd-click-xpath').html(op.xpath);
				$('#action-autoadd-container').append($('#action-autoadd-template-click').html());
			}
		})).fail(error_handler(function(error) {
			var op = xpath_composer_autoadd_queue.shift();
			if (op.value) {
				$('#action-autoadd-template-enter .action-autoadd-enter-xpath').html('FAILED: ' + op.xpath);
				$('#action-autoadd-template-enter .action-autoadd-enter-value').html('FAILED: ' + op.value);
				$('#action-autoadd-container').append($('#action-autoadd-template-enter').html());
			} else {
				$('#action-autoadd-template-click .action-autoadd-click-xpath').html('FAILED: ' + op.xpath);
				$('#action-autoadd-container').append($('#action-autoadd-template-click').html());
			}
			if (console)
				console.log('xpath-composer action autoadd fail:', error.status, error.statusText);
		})).always(error_handler(function() {
			loader.hide();
			process_queue();
		}));
	}
	if (start)
		process_queue();
	return true;
});
