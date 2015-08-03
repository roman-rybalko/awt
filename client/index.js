"use strict";
var request = require('request');
var fs = require('fs');
var webdriver = require('selenium-webdriver');
var wait = require('wait.for');
var config = require('./config.js');

function server_req(params) {
	params['token'] = config.server_token;
	var result = wait.for(function(arg, cb){
		request.post(arg, function(err, resp, body) {
			cb(err, [resp, body]);
		});
	}, {
		url: config.server_url,
		formData: params
	});
	var data = {};
	if (result[0].statusCode == 200)
		data = JSON.parse(result[1]);
	return data;
}

function promise2ncb(promise, timeout_ms, cb) {
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
	return wait.for(promise2ncb, promise, config.selenium_timeout);
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

function process() {
	var task = server_req({
		task_type: config.task_type,
		node_id: config.node_id
	});
	if (task.empty)
		return 'no task';
	if (task.fail)
		return task.fail;
	if (!task.task_id)
		throw new Error('task parsing failed');
	var status = server_req({
		task_id: task.task_id,
		status: 'started',
		vnc: 'ws://stub',
	});
	if (status.fail)
		return status.fail;
	if (!status.ok)
		throw new Error('status parsing failed');
	var selenium = new webdriver.Builder().forBrowser(config.selenium_browser).usingServer(config.selenium_server).build();
	var fails = {}, scrns = {};
	for (var i = 0; i < task.task_actions.length; ++i) {
		var action = task.task_actions[i];
		try {
			switch (action.type) {
			case 'open':
				if (!action.selector.match(/^http(s)*:\/\//i))
					action.selector = 'http://' + action.selector;
				selenium_wait(selenium.get(action.selector));
				scrns[action.action_id] = get_scrn(selenium);
				break;
			case 'exists':
				scrns[action.action_id] = get_scrn(selenium);
				if (!selenium_wait(selenium.isElementPresent({xpath: action.selector})))
					throw new Error('xpath is not found');
				break;
			case 'wait':
				var result = selenium_wait_timeout(selenium.isElementPresent({xpath: action.selector}));
				scrns[action.action_id] = get_scrn(selenium);
				if (!result)
					throw new Error('xpath is not found');
				break;
			default:
				scrns[action.action_id] = get_scrn(selenium);
				throw new Error('unsupported action type');
				break;
			}
		} catch (e) {
			fails[action.action_id] = e.message;
			if (!task.task_debug)
				break;
		}
	}
	selenium.quit();
	var params = {
		task_id: task.task_id,
		status: Object.keys(fails).length ? 'failed' : 'succeeded',
	};
	for (var id in fails)
		params['fail' + id] = fails[id];
	for (var id in scrns) {
		params['scrn' + id] = {
			value: scrns[id].data,
			options: {
				filename: id + scrns[id].ext
			}
		};
	}
	status = server_req(params);
	if (status.fail)
		return status.fail;
	if (!status.ok)
		throw new Error('status parsing failed');
}

module.exports = function(cb) {
	wait.launchFiber(function() {
		try {
			cb(undefined, process());
		} catch (e) {
			cb(e);
		}
	});
}
