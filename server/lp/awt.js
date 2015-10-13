var menuBarPoss = [0, 0, 0, 0];

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
	menuBarPoss = [$('#description').offset().top, $('#use-cases').offset().top, $('#features').offset().top, $(document).height()];
}
$(window).resize(reformat);

var menuBarPinUp = false;
var menuBarActive = 0;
var menuBarItems = ['#menubar-item-description', '#menubar-item-use-cases', '#menubar-item-features'];
function updateMenuBar() {
	if (menuBarPinUp) {
		if ($(window).scrollTop() < 110) {
			$('#menubar').removeClass('awt-menubar-pinup');
			$('#menubar-placeholder').hide();
			menuBarPinUp = false;
		}
	} else {
		if ($(window).scrollTop() >= 110) {
			$('#menubar').addClass('awt-menubar-pinup');
			$('#menubar-placeholder').show();
			menuBarPinUp = true;
		}
	}
	var active = 0;
	for (active = 0; active < menuBarItems.length; ++active)
		if ($(window).scrollTop() + $(window).height() * 2 / 3 < menuBarPoss[active + 1])
			break;
	if (active != menuBarActive) {
		for (var i in menuBarItems)
			$(menuBarItems[i]).removeClass('active');
		$(menuBarItems[active]).addClass('active');
		menuBarActive = active;
	}
}
$(window).on('scroll', updateMenuBar);

$(function(){
	reformat();
	updateMenuBar();
});
