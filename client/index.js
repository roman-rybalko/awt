"use strict";
var webdriver = require('selenium-webdriver');
var wait = require('wait.for');
var selutil = require('./selutil');
var srv = require('./srv');
var xpath = require('./xpath');
var config = require('./config');

function process() {
	var task = srv.req({
		task_type: config.task_type,
		node_id: config.node_id
	});
	if (task.empty)
		return 'no task';
	if (task.fail)
		return task.fail;
	if (!task.task_id)
		throw new Error('task parsing failed');
	var status = srv.req({
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
			selutil.clear();
			scrns[action.action_id] = selutil.get_scrn(selenium);
			switch (action.type) {
			case 'open':
				if (!action.selector.match(/^http(s)*:\/\//i))
					action.selector = 'http://' + action.selector;
				selutil.wait(selenium.get(action.selector));
				scrns[action.action_id] = selutil.get_scrn(selenium);
				if (!selutil.wait_timeout(selenium.isElementPresent({xpath: '//html'})))
					throw new Error('page open failed');
				break;
			case 'exists':
				if (!selutil.wait(selenium.isElementPresent({xpath: action.selector})))
					throw new Error('xpath is not found');
				selutil.locate_el(selenium, action.selector);
				break;
			case 'wait':
				selutil.locate_el(selenium, action.selector);
				break;
			case 'check':
				var elxp = xpath.el(action.selector);
				var el = selutil.locate_el(selenium, elxp);
				var attr = xpath.attr(action.selector);
				var data;
				if (attr)
					data = selutil.wait(el.getAttribute(attr));
				else
					data = selutil.wait(el.getText());
				if (!data.match(new RegExp(action.data)))
					throw new Error('RegExp ' + action.data + ' for element ' + elxp + (attr ? ' attribute ' + attr : ' text') + ' is not matched');
				break;
			case 'click':
				var el = selutil.locate_el(selenium, action.selector);
				selutil.wait(el.click());
				break;
			case 'modify':
				throw new Error('Action modify is not supported yet');
				break;
			case 'enter':
				var el = selutil.locate_el(selenium, action.selector);
				selutil.wait(el.clear());
				selutil.wait(el.sendKeys(action.data));
				break;
			default:
				scrns[action.action_id] = selutil.get_scrn(selenium);
				throw new Error('unsupported action type');
				break;
			}
			scrns[action.action_id] = selutil.get_scrn(selenium);
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
	status = srv.req(params);
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
