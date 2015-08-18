$(function() {
	if ($('#side-menu').length)
		$('#side-menu').metisMenu();
	if ($('.table-dataTable').length)
		$('.table-dataTable').DataTable();
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
		for (var i = 0; i < task_types.length; ++i) {
			index[task_types[i].name] = task_types[i];
			index[task_types[i].id] = task_types[i];
			task_types[i].children = [];
		}
		for (var i = 0; i < task_types.length; ++i) {
			if (index[task_types[i].parent_id])
				index[task_types[i].parent_id].children.push(task_types[i]);
		}
		$('.task-type').each(function() {
			var name = $(this).html().replace(/\s+/g, '');
			var type = index[name];
			if (type) {
				var names = [];
				function walk(type) {
					names.push(type.name);
					for (var i = 0; i < type.children.length; ++i)
						walk(type.children[i]);
				}
				walk(type);
				$(this).attr('title', names.join(', '));
			}
		});
	}
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
