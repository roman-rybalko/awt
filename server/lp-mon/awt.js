var menuBarPoss = [0, 0, 0, 0, 0, 0];

function reformat() {
	$(".awt-image-floated").each(function() {
		if ($(this).width() / $(this).parent().width() > 0.6) {
			$(this).removeClass("awt-image-floated");
			$(this).addClass("awt-image-centered");
		}
	});
	$(".awt-image-centered").each(function() {
		if ($(this).width() / $(this).parent().width() <= 0.6) {
			$(this).removeClass("awt-image-centered");
			$(this).addClass("awt-image-floated");
		}
	});
	if ($('#menubar').length) {
		$('#menubar').width($('.container').width());
		$('#menubar-placeholder').height($('#menubar').height());
	}
}
$(window).resize(reformat);

var menuBarActive = false;
var menuBarPinUp = false;
function updateMenuBar() {
	if (!$('#menubar').length)
		return;
	if ($(window).width() < 964 && menuBarActive === true) {
		$('#menubar').hide();
		$('#menubar-placeholder').hide();
		$('#menubar-mobile').show();
		menuBarActive = false;
	} else if ($(window).width() >= 964 && menuBarActive === false) {
		$('#menubar-mobile').hide();
		menuBarActive = null;
	}
	if (menuBarActive === null) {
		$('#menubar').show();
		if ($(window).scrollTop() < 110) {
			$('#menubar').removeClass('awt-menubar-pinup');
			$('#menubar-placeholder').hide();
			menuBarPinUp = false;
		} else if ($(window).scrollTop() >= 110) {
			$('#menubar').addClass('awt-menubar-pinup');
			$('#menubar-placeholder').show();
			menuBarPinUp = true;
		}
		menuBarActive = true;
	} else if (menuBarActive) {
		if ($(window).scrollTop() < 110 && menuBarPinUp) {
			$('#menubar').removeClass('awt-menubar-pinup');
			$('#menubar-placeholder').hide();
			menuBarPinUp = false;
		} else if ($(window).scrollTop() >= 110 && !menuBarPinUp) {
			$('#menubar').addClass('awt-menubar-pinup');
			$('#menubar-placeholder').show();
			menuBarPinUp = true;
		}
	}
}
$(window).on('scroll', updateMenuBar);
$(window).resize(updateMenuBar);

$(function(){
	reformat();
	updateMenuBar();

	$('#signup-form').submit(function() {
		var status = true;
		$(this).find('input').each(function() {
			if (!status)
				return;
			if (!$(this).val().match(/\S/)) {
				$(this).focus();
				status = false;
			}
		});
		return status;
	});
});
