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
	$('[data-action-type-id]').each(function() {
		var id = $(this).attr('data-action-type-id');
		$('[data-action-type-id="' + id + '"] option').each(function() {
			var type = $(this).attr('value');
			var descr = $('#action-type-' + type + '-' + id).html();
			if (descr)
				$(this).html(descr);
		});
		var action_form_update = function() {
			$('[data-action-type-id="' + id + '"] option').each(function() {
				var type = $(this).attr('value');
				if ($(this).prop('selected')) {
					$('[data-action-id="' + id + '"][data-action-type="' + type + '"] input').prop('disabled', false);
					$('[data-action-id="' + id + '"][data-action-type="' + type + '"]').show();
				} else {
					$('[data-action-id="' + id + '"][data-action-type="' + type + '"] input').prop('disabled', true);
					$('[data-action-id="' + id + '"][data-action-type="' + type + '"]').hide();
				}
			});
		}
		action_form_update();
		$('[data-action-type-id="' + id + '"]').on('change', action_form_update);
	});
	if (typeof task_types !== 'undefined' && task_types.length) {
		var index = [];
		for (var tt in task_types) {
			index[task_types[tt].name] = task_types[tt];
			index[task_types[tt].id] = task_types[tt];
			task_types[tt].children = [];
		}
		for (var tt in task_types)
			if (index[task_types[tt].parent_id])
				index[task_types[tt].parent_id].children.push(task_types[tt]);
		$('.task-type').each(function() {
			var name = $(this).html().replace(/\s+/g, '');
			var type = index[name];
			if (type) {
				var names = [];
				function walk(type) {
					names.push(type.name);
					for (var c in type.children)
						walk(type.children[c]);
				}
				walk(type);
				$(this).attr('title', names.join(', '));
			}
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
		$(this).find('.date input').each(function() {
			$(this).val(moment($(this).val(), datetime_format).unix());
		});
	});
	if (typeof task_tests !== 'undefined' && task_tests.length) {
		var tests = [];
		for (var tt in task_tests)
			tests[task_tests[tt].id] = task_tests[tt].name;
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
	$('.period-unix2human').each(function() {
		var period = $(this).html().replace(/\s+/g, '');
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
		if (period)
			data.unshift(period + (period == 1 ? ' day' :' days'));
		$(this).html(data.join(' '));
	});
	$('.time-unix2human').each(function() {
		var time = $(this).html().replace(/\s+/g, '');
		$(this).html(moment.unix(time).format(datetime_format));
	});
	if ($('.table-dataTable').length)  // the last
		$('.table-dataTable').DataTable();
});

//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
$(function() {
    $(window).bind("load resize", function() {
        topOffset = 50;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
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
