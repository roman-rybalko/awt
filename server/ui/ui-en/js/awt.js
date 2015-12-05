$(function() {
	if ($('#side-menu').length)
		$('#side-menu').metisMenu();
	if ($('.modal').length)
		$('.modal').on('shown.bs.modal', function() {
			$(this).find('.form-control').first().focus();
		});
	if ($('#gallery-photobox').length) {
		$('img.gallery-photobox-img').each(function() {
			// strip spaces introduced by XSLT
			var data = $(this).attr('alt');
			if (data) {
				data = data.replace(/^\s+/, '').replace(/\s+$/, '').replace(/\s+/g, ' ');
				$(this).attr('alt', data);
			}
		});
		$('#gallery-photobox').photobox('a.gallery-photobox-a', {
			time: 0,
			loop: false
		});
	}
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
					wrap.find('input').prop('disabled', false);
					wrap.show();
				} else {
					wrap.find('input').prop('disabled', true);
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
	if (typeof task_types !== 'undefined') {
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
	}
	$('#xpath-composer-ok').click(function() {
		var xpath = $('#xpath-composer-result').val();
		$('input.action-xpath-element').val(xpath);
		$('input.action-xpath-expression').val(xpath + '/@class');
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
	$('.form-schedule-task').submit(function() {
		if (! $(this).find('input[name="name"]').val().match(/\S/)) {
			$(this).find('input[name="name"]').focus();
			return false;
		}
		$(this).find('.date input').each(function() {
			$(this).val(moment($(this).val(), datetime_format).unix());
		});
	});
	if (typeof sched_tests !== 'undefined') {
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
	}
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
	if ($('.table-dataTable').length) {  // after .time-unix2human .period-unix2human
		var table = $('.table-dataTable').DataTable();
		var hash = window.location.hash;
		if (hash)
			table.search(hash).draw();
	}
	if ($('.close[data-dismiss="alert"][data-dismiss-state]').length) {
		var storage1 = new Storage('dismiss-state-', 42 /* expire days */);  // var storage is busy
		$('.close[data-dismiss="alert"][data-dismiss-state]').each(function() {
			var name = $(this).attr('data-dismiss-state');
			var value = storage1.get(name);
			if (value)
				$(this).closest('.alert').alert('close');
		});
		$('.close[data-dismiss="alert"][data-dismiss-state]').click(function() {
			var name = $(this).attr('data-dismiss-state');
			storage1.set(name, true);
		});
	}
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
	if ($('#tasks-chart').length) {
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
			label: 'Finished',
			color: '#679dc6',
			bars: {
				fillColor: '#679dc6'
			},
			data: aggregate_day(tasks_finished)
		};
		var data2 = {
			label: 'Failed',
			color: '#cb4b4b',
			bars: {
				fillColor: '#cb4b4b'
			},
			data: aggregate_day(tasks_failed),
		};
		$('#tasks-chart').plot([data1, data2], options);
	}
	if ($('#task-actions-chart').length) {
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
			data: aggregate_day(task_actions_executed)
		};
		$('#task-actions-chart').plot([data1], options);
	}
	if ($('a.apply-data-display-period, form.apply-data-display-period').length) {
		var storage = new Storage('setting-' + awt_login + '-');
		var time = storage.get('data-display-period');
		if (time > 0) {
			time = Math.round(new Date().getTime() / 1000) - time;
			$('a.apply-data-display-period, form.apply-data-display-period').each(function() {
				var attr = 'href';
				if ($(this).attr('action'))
					attr = 'action';
				$(this).attr(attr, $(this).attr(attr) + '&time=' + time);
			});
		}
	}
	if ($('span.apply-data-display-period, div.apply-data-display-period').length) {
		if (awt_time > 0) {
			var period = Math.round(new Date().getTime() / 1000) - awt_time;
			period = period_unix2human(period);
			$('span.apply-data-display-period, div.apply-data-display-period').each(function() {
				$(this).html('(past ' + period + ')');
			});
		}
	}
	if ($('select#setting-data-display-period').length) {
		var storage = new Storage('setting-' + awt_login + '-');
		var time = storage.get('data-display-period') || 0;
		$('select#setting-data-display-period option').each(function() {
			if ($(this).val() == time)
				$(this).prop('selected', true);
		});
		$('select#setting-data-display-period').change(function() {
			time = $(this).val();
			storage.set('data-display-period', time);
			if (time > 0)
				time = Math.round(new Date().getTime() / 1000) - time;
			$('a.apply-data-display-period').each(function() {
				$(this).attr('href', $(this).attr('href') + '&time=' + time);
			});
		});
	}
	if ($('.modal-pending-transaction-code').length) {
		$('.modal-pending-transaction-code').first().modal('show');
	}
});

//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
var sidebarCollapsed = null;
$(function() {
	$(window).bind("load resize", function() {
		var width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
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
	});

	var url = window.location;
	var element = $('ul.nav a').filter(function() {
		return this.href == url || url.href.indexOf(this.href) == 0;
	}).addClass('active').parent().parent().addClass('in').parent();
	if (element.is('li')) {
		element.addClass('active');
	}
});
