$(function() {
	if ($('#side-menu').length)
		$('#side-menu').metisMenu();
	if ($('.table-dataTable').length)
		$('.table-dataTable').DataTable();
	if ($('.modal').length)
		$('.modal').on('shown.bs.modal', function() {
			$(this).find('input').focus();
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
