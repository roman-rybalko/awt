"use strict";
var wait = require('wait.for');
var config = require('./config');
var selection_border_size = 20;

function promise2nodecb(promise, timeout_ms, cb) {
	var timer = setTimeout(function() {
		if (timer) {
			timer = null;
			cb(new Error('timeout'));
		}
	}, timeout_ms);
	promise.then(function(val) {
		if (timer) {
			clearTimeout(timer);
			timer = null;
			cb(undefined, val);
		}
	}, function(err) {
		if (timer) {
			clearTimeout(timer);
			timer = null;
			cb(err);
		}
	});
}

function selenium_wait(promise) {
	return wait.for(promise2nodecb, promise, config.selenium_timeout);
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
	if (area.x < 0)
		area.x = 0;
	if (area.y < 0)
		area.y = 0;
}

function hide_selection(selenium) {
	
}

function scroll(selenium, pos) {
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
	scroll(selenium, {x: location.x - selection_border_size * 2, y: location.y - selection_border_size * 2});
	show_selection(selenium, {x: location.x - selection_border_size, y: location.y - selection_border_size,
		w: size.width + selection_border_size, h: size.height + selection_border_size});
	return el;
}

module.exports = {
	wait: selenium_wait,
	wait_timeout: selenium_wait_timeout,
	get_scrn: get_scrn,
	locate_el: show_element,
	clear: hide_selection
};
