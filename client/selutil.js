"use strict";
var wait = require('wait.for');
var config = require('./config');
var selection_html_id = 'selection' + Math.random();

function promise2nodecb(promise, cb) {
	promise.then(function(val) {
		cb(undefined, val);
	}, function(err) {
		cb(err);
	});
}

function selenium_wait(promise) {
	return wait.for(promise2nodecb, promise);
}

function sleep(ms) {
	wait.for(function(cb) {
		setTimeout(function() {
			cb(undefined, 1);
		}, ms);
	});
}

function selenium_wait_timeout(promise) {
	var start_time = new Date().getTime();
	while (new Date().getTime() < start_time + config.selenium_timeout) {
		var result = selenium_wait(promise);
		if (result)
			return result;
		else
			sleep(100);
	}
}

function get_scrn(selenium) {
	var scrn = selenium_wait(selenium.takeScreenshot());
	return {
		data: new Buffer(scrn, 'base64'),
		ext: '.png'
	};
}

function show_selection(selenium, area) {
	var padding_size = 15;
	var border_size = 5;
	area.x -= padding_size;
	area.y -= padding_size;
	area.w += padding_size;
	area.h += padding_size;
	if (area.x < 0)
		area.x = border_size;
	if (area.y < 0)
		area.y = border_size;
	selenium_wait(selenium.executeScript(
		'var el = document.createElement("div");'
		+ 'el.innerHTML = \'<div id="' + selection_html_id + '" style="position: absolute; left: ' + area.x + 'px; top: ' + area.y + 'px; width: ' + area.w + 'px; height: ' + area.h + 'px; border: ' + border_size + 'px dotted red; z-index: 7777777;"></div>\';'
		+ 'document.getElementsByTagName("body")[0].appendChild(el.firstChild);'));
}

function hide_selection(selenium) {
	selenium_wait(selenium.executeScript('var el = document.getElementById("' + selection_html_id + '"); if (el) el.parentElement.removeChild(el);'));
}

function scroll(selenium, pos) {
	var win_size = selenium_wait(selenium.manage().window().getSize());
	pos.x -= Math.round(win_size.width / 2);  // the center of the window
	pos.y -= Math.round(win_size.height / 2);  // the center of the window
	if (pos.x < 0)
		pos.x = 0;
	if (pos.y < 0)
		pos.y = 0;
	selenium_wait(selenium.executeScript('window.scrollTo(' + pos.x + ', ' + pos.y + ');'));
}

function show_element(selenium, xpath) {
	if (!selenium_wait_timeout(selenium.isElementPresent({xpath: xpath})))
		throw new Error('element xpath ' + xpath + ' is not found');
	var el = selenium_wait(selenium.findElement({xpath: xpath}));
	var location = selenium_wait(el.getLocation());
	var size = selenium_wait(el.getSize());
	scroll(selenium, {x: location.x + Math.round(size.width / 2), y: location.y + Math.round(size.height / 2)});
	show_selection(selenium, {x: location.x, y: location.y, w: size.width, h: size.height});
	return el;
}

module.exports = {
	wait: selenium_wait,
	wait_timeout: selenium_wait_timeout,
	get_scrn: get_scrn,
	locate_el: show_element,
	clear: hide_selection
};
