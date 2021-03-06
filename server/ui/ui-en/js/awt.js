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
				$("#page-wrapper").css('min-height', '0');
				sidebarCollapsed = true;
			}
		} else {
			if (sidebarCollapsed === null || sidebarCollapsed === true) {
				$('div.navbar-collapse').removeClass('collapse');
				$("#page-wrapper").css('min-height', 'calc(100vh - 51px - 51px)');  // viewport - header - footer (with borders)
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
	var dataTablesDefer = 0;
	function dataTablesInit() {
		if (dataTablesDefer)
			return;
		if ($('.table-dataTable').length) error_handler(function() {
			var table = $('.table-dataTable').DataTable({
				responsive: true
			});
			var hash = window.location.hash;
			if (hash) {
				table.search(hash).draw();
				$('.table-dataTable').closest('.collapse').collapse('show');
			}
		})();
	}
	// before others to start the ajax early
	if ($('.task-type').length) {
		++dataTablesDefer;
		$.get('./?task_types=1&xml=1').done(error_handler(function(data) {
			var task_types = [];
			$(data).find('task_types type').each(function() {
				task_types.push({name: $(this).attr('name'), id: $(this).attr('id'), parent_id: $(this).attr('parent_id')});
			});
			var index = [];
			var set = {};
			for (var tt in task_types) {
				set[task_types[tt].name] = 1;
				index[task_types[tt].name] = task_types[tt];
				index[task_types[tt].id] = task_types[tt];
				task_types[tt].children = [];
			}
			for (var tt in task_types)
				if (index[task_types[tt].parent_id])
					index[task_types[tt].parent_id].children.push(task_types[tt]);
			// before others
			$('select.task-type').each(function() {
				var select = $(this);
				var selected = select.attr('data-selected');
				for (var type in set) {
					var option = $(document.createElement('option'));
					option.attr('value', type);
					option.attr('class', 'task-type');
					option.text(type);
					if (type == selected)
						option.prop('selected', true);
					select.append(option);
				}
			});
			// before others
			$('div.task-type').each(function() {
				var div = $(this);
				for (var type in set) {
					var button = $(document.createElement('button'));
					button.attr('type', 'submit');
					button.attr('name', 'type');
					button.attr('value', type);
					button.attr('class', 'btn btn-success btn-outline space-x space-y task-type');
					button.text(type);
					div.append(button);
				}
			});
			var cache = {};
			$('.task-type').not('select, div').each(function() {
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
		})).always(error_handler(function() {
			--dataTablesDefer;
			dataTablesInit();
		}));
	}
	// before others to start the ajax early
	if ($('.test-id2name').length) {
		++dataTablesDefer;
		$.get('./?tests=1&xml=1').done(error_handler(function(data) {
			var tests = {};
			$(data).find('tests test').each(function() {
				if ($(this).attr('deleted'))
					return;  // continue
				tests[$(this).attr('id')] = $(this).attr('name');
			});
			$('select.test-id2name').each(function() {
				var select = $(this);
				var selected = select.attr('data-selected');
				for (var id in tests) {
					var option = $(document.createElement('option'));
					option.attr('value', id);
					option.text(tests[id]);
					if (id == selected)
						option.prop('selected', true);
					select.append(option);
				}
			});
			$('.test-id2name').not('select').each(function() {
				var id = $(this).html().replace(/\s+/g, '');
				if (tests[id])
					$(this).html(tests[id]);
				else {
					$(this).html('<i class="fa fa-times text-failure" title="Deleted"></i><span style="display: none;">' + id + ' (order data)</span>');
					$(this).closest('tr').toggleClass('danger', true);
				}
			});
		})).always(error_handler(function() {
			--dataTablesDefer;
			dataTablesInit();
		}));
	}
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
	$('.form-schedule-job').submit(error_handler(function() {
		if (! $(this).find('input[name="name"]').val().match(/\S/)) {
			$(this).find('input[name="name"]').focus();
			return false;
		}
		$(this).find('.date input').each(function() {
			$(this).val(moment($(this).val(), datetime_format).unix());
		});
	}));
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
	dataTablesInit();  // after .time-unix2human .period-unix2human
	if ($('.tip-state').length) error_handler(function() {
		var storage = new Storage('tip-state-', 42 /* expire days */);
		$('.tip-state').each(function() {
			var name = $(this).attr('data-tip-state');
			var value = storage.get(name);
			if (value)
				$(this).closest('.alert').alert('close');
		});
		$('.tip-state').click(error_handler(function() {
			var name = $(this).attr('data-tip-state');
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
		$('input.control-state[type="checkbox"]').change(error_handler(function() {
			var name = $(this).attr('data-control-state');
			storage.set(name, $(this).prop('checked'));
		}));
		$('input.control-state[type="radio"]').change(error_handler(function() {
			var name = $(this).attr('name');
			$('input.control-state[type="radio"][name="' + name + '"]').each(function() {
				var name = $(this).attr('data-control-state');
				if (name)
					storage.set(name, false);
			});
			var name = $(this).attr('data-control-state');
			storage.set(name, $(this).prop('checked'));
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
			data: aggregate_day(tasks_started),
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
			if (console)
				console.log('set data-display-period to ' + time);
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
		$('select#setting-data-display-period').change(error_handler(function() {
			time = $(this).val();
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

var xpath_composer_autoadd = false;
$(error_handler(function($) {
	if (!$('.action-autoadd-control').length)
		return;

	$('.xpath-browser-collapse').on('show.bs.collapse', error_handler(function() {
		var id = $(this).attr('data-id');
		$('.xpath-browser-collapse[data-id != "' + id + '"]').collapse('hide');
		var state_data = $('#action-user-data-' + id).val();
		xpath_composer_autoadd = $('.action-autoadd-control[data-id="' + id + '"]').prop('checked');  // true/false/undefined
		$(document).triggerHandler('xpath-browser', [id, state_data]);
	}));
	$('.action-autoadd-control').change(error_handler(function() {
		xpath_composer_autoadd = $(this).prop('checked');
	}));

	var queue = [];
	function queue_process() {
		if (!queue.length)
			return;
		if (!xpath_composer_autoadd) {
			queue = [];
			return;
		}
		var op = queue[0];
		loader.show();  // global loader, see user.xsl
		var params = {add: 1, selector: op.xpath, user_data: op.user_data};
		if (op.value) {
			params.type = 'enter';
			params.data = op.value;
		} else if (op.selection) {
			params.type = 'exists';
		} else {
			params.type = 'click';
		}
		$.post(document.location.href, params).done(error_handler(function() {
			var op = queue.shift();
			if (op.value) {
				$('#action-autoadd-template-enter .action-autoadd-enter-xpath').html(op.xpath);
				$('#action-autoadd-template-enter .action-autoadd-enter-value').html(op.value);
				$('#action-autoadd-container').append($('#action-autoadd-template-enter').html());
			} else if (op.selection) {
				$('#action-autoadd-template-exists .action-autoadd-exists-xpath').html(op.xpath);
				$('#action-autoadd-container').append($('#action-autoadd-template-exists').html());
			} else {
				$('#action-autoadd-template-click .action-autoadd-click-xpath').html(op.xpath);
				$('#action-autoadd-container').append($('#action-autoadd-template-click').html());
			}
		})).fail(error_handler(function(error) {
			var op = queue.shift();
			if (op.value) {
				$('#action-autoadd-template-enter .action-autoadd-enter-xpath').html('FAILED: ' + op.xpath);
				$('#action-autoadd-template-enter .action-autoadd-enter-value').html('FAILED: ' + op.value);
				$('#action-autoadd-container').append($('#action-autoadd-template-enter').html());
			} else if (op.selection) {
				$('#action-autoadd-template-exists .action-autoadd-exists-xpath').html('FAILED: ' + op.xpath);
				$('#action-autoadd-container').append($('#action-autoadd-template-exists').html());
			} else {
				$('#action-autoadd-template-click .action-autoadd-click-xpath').html('FAILED: ' + op.xpath);
				$('#action-autoadd-container').append($('#action-autoadd-template-click').html());
			}
			if (console)
				console.log('xpath-composer action autoadd fail:', error.status, error.statusText);
		})).always(error_handler(function() {
			loader.hide();
			queue_process();
		}));
	}

	$(document).on('xpath-browser-done', error_handler(function(ev, id, xpath, data, state_data) {
		if (xpath_composer_autoadd) {
			var start = ! queue.length;
			queue.push({xpath: xpath, value: data.value, selection: data.selection, user_data: state_data});
			if (start)
				queue_process();
		} else {
			$('#action-user-data-' + id).val(state_data);
			$('input.action-xpath-element[data-id="' + id + '"]').val(xpath);
			$('input.action-xpath-expression[data-id="' + id + '"]').val(xpath + '/@class');
		}
	}));
}));
