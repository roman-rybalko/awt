"use strict";
var wait = require('wait.for');
var config = require('./config');

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

module.exports = {
	wait: selenium_wait,
	wait_timeout: selenium_wait_timeout,
	get_scrn: get_scrn
};
