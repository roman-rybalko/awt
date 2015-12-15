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
	$('#menubar').width($('.container').width());
	$('#menubar-placeholder').height($('#menubar').height());
	menuBarPoss = [$('#description').offset().top, $('#use-cases').offset().top, $('#features').offset().top,
	               $('#pricing').offset().top, $(document).height()];
}
$(window).resize(reformat);

var menuBarActive = false;
var menuBarPinUp = false;
var menuItemActive = 0;
var menuItems = ['#menubar-item-description', '#menubar-item-use-cases', '#menubar-item-features', '#menubar-item-pricing'];
function updateMenuBar() {
	if ($(window).width() < 964 && menuBarActive === true) {
		$('#menubar').hide();
		$('#menubar-placeholder').hide();
		$('#menubar-mobile').show();
		menuBarActive = false;
	} else if ($(window).width() >= 964 && menuBarActive === false) {
		$('#menubar').show();
		$('#menubar-mobile').hide();
		menuBarActive = null;
	}
	if (menuBarActive === null) {
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
	var active = 0;
	for (active = 0; active < menuItems.length; ++active)
		if ($(window).scrollTop() + $(window).height() * 2 / 3 < menuBarPoss[active + 1])
			break;
	if (active != menuItemActive) {
		for (var i in menuItems)
			$(menuItems[i]).removeClass('active');
		$(menuItems[active]).addClass('active');
		menuItemActive = active;
	}
}
$(window).on('scroll', updateMenuBar);
$(window).resize(updateMenuBar);

$(function(){
	reformat();
	updateMenuBar();
});
