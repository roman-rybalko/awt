"use strict";

var wait = require('wait.for');

var wait_timeout = 30000; // msec

function promise2nodecb(promise, cb) {
	var t = setTimeout(function(){
		promise.cancel('Timeout');
	}, wait_timeout);
	promise.then(function(val) {
		clearTimeout(t);
		cb(undefined, val);
	}, function(err) {
		clearTimeout(t);
		cb(err);
	});
}

function wait_promise(promise) {
	return wait.for(promise2nodecb, promise);
}

function sleep(ms) {
	wait.for(function(cb) {
		setTimeout(function() {
			cb(undefined, ms);
		}, ms);
	});
}

function wait_condition(condition) {
	var start_time = new Date().getTime();
	while (new Date().getTime() < start_time + wait_timeout)
		if (condition())
			return true;
		else
			sleep(100);
	return false;
}

function get_scrn(selenium) {
	if (selenium) {
		var scrn = wait_promise(selenium.takeScreenshot());
		return {
			data: new Buffer(scrn, 'base64'),
			ext: '.png'
		};
	}
	return {};
}

var selection_id = Math.round(Math.random() * 10000000);
var selection_html_id = null;

function show_selection(selenium, area) {
	var padding_size = 15;
	var border_size = 5;
	area.x -= padding_size;
	area.y -= padding_size;
	area.w += padding_size * 2;
	area.h += padding_size * 2;
	area.x -= border_size;
	area.y -= border_size;
	area.w -= border_size;
	area.h -= border_size;
	if (area.x < 0)
		area.x = 0;
	if (area.y < 0)
		area.y = 0;
	hide_selection(selenium);  // before selection_html_id update
	selection_html_id = 'selection' + (++selection_id);
	wait_promise(selenium.executeScript(function() {
		var id = arguments[0];
		var area = JSON.parse(arguments[1]);
		var border = arguments[2];
		var el = document.createElement('div');
		el.innerHTML = '<div id="' + id + '" style="position: absolute;'
			+ ' left: ' + area.x + 'px; top: ' + area.y + 'px;'
			+ ' width: ' + area.w + 'px; height: ' + area.h + 'px;'
			+ ' border: ' + border + 'px dotted red; z-index: 7777777;"></div>';
		document.getElementsByTagName("body")[0].appendChild(el.firstChild).appendChild(el);
		el.parentElement.removeChild(el);  // garbage collection
	}, selection_html_id, JSON.stringify(area), border_size));
}

function hide_selection(selenium) {
	if (selection_html_id)
		wait_promise(selenium.executeScript(function() {
			var id = arguments[0];
			var el = document.getElementById(id);
			if (el)
				el.parentElement.removeChild(el);
		}, selection_html_id));
	selection_html_id = null;
}

function scroll(selenium, pos) {
	var win_size = wait_promise(selenium.executeScript(function() {
		return {width: window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth,
			height: window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight};
	}, 0 /* args */));
	pos.x -= Math.round(win_size.width / 2);  // the center of the window
	pos.y -= Math.round(win_size.height / 2);  // the center of the window
	if (pos.x < 0)
		pos.x = 0;
	if (pos.y < 0)
		pos.y = 0;
	wait_promise(selenium.executeScript(function() {
		var pos = JSON.parse(arguments[0]);
		window.scrollTo(pos.x, pos.y);
	}, JSON.stringify(pos)));
}

function show_element(selenium, xpath) {
	if (!wait_condition(function(){return wait_promise(selenium.isElementPresent({xpath: xpath}));}))
		throw new Error('element xpath ' + xpath + ' is not found');
	var el = wait_promise(selenium.findElement({xpath: xpath}));
	var location = wait_promise(el.getLocation());
	var size = wait_promise(el.getSize());
	scroll(selenium, {x: location.x + Math.round(size.width / 2), y: location.y + Math.round(size.height / 2)});
	show_selection(selenium, {x: location.x, y: location.y, w: size.width, h: size.height});
	return el;
}

function select_window(selenium, condition) {
	var handle_idx = -1;
	var handles = wait_promise(selenium.getAllWindowHandles());
	for (var h in handles) {
		wait_promise(selenium.switchTo().window(handles[h]));
		if (condition()) {
			handle_idx = h;
			break;
		}
	}
	if (handle_idx != -1) {
		for (var h in handles) {
			wait_promise(selenium.switchTo().window(handles[h]));
			if (h != handle_idx)
				wait_promise(selenium.close());
		}
		wait_promise(selenium.switchTo().window(handles[handle_idx]));
	}
	return handle_idx != -1;
}

function select_element(selenium, el) {
	var location = wait_promise(el.getLocation());
	var size = wait_promise(el.getSize());
	scroll(selenium, {x: location.x + Math.round(size.width / 2), y: location.y + Math.round(size.height / 2)});
	show_selection(selenium, {x: location.x, y: location.y, w: size.width, h: size.height});
}

module.exports = {
	set_timeout: function(timeout) {
		wait_timeout = timeout;
	},
	wait: function(arg) {
		if (typeof(arg) == 'function')
			return wait_condition(arg);
		else
			return wait_promise(arg);
	},
	get_scrn: get_scrn,
	select_element: select_element,
	select_window: select_window,
	hide_selection: hide_selection
};
