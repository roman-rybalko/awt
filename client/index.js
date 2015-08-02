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
	var failed_action_id = 0, failed_action_descr, scrns = {};
	for (var i = 0; i < task.task_actions.length; ++i) {
		var action = task.task_actions[i];
		try {
			switch (action.type) {
			case 'open':
				selenium_wait(selenium.get(action.selector));
				scrns[action.action_id] = get_scrn(selenium);
				break;
			default:
				scrns[action.action_id] = get_scrn(selenium);
				throw new Error('unsupported action type');
				break;
			}
		} catch (e) {
			failed_action_id = action.action_id;
			failed_action_descr = e.message;
			break;
		}
	}
	selenium.quit();
	var params = {
		task_id: task.task_id,
		status: failed_action_id ? 'failed' : 'succeeded',
	};
	if (failed_action_id) {
		params['failed_action_id'] = failed_action_id;
		params['failed_action_descr'] = failed_action_descr;
	}
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
	return failed_action_id;
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
