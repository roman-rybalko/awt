"use strict";

var webdriver = require('selenium-webdriver');
var wait = require('wait.for');
var selutil = require('./selutil');
var srv = require('./srv');
var xpath = require('./xpath');
var scrot = require('./scrot');
var config = require('../config');

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
	selutil.wait(selenium.manage().timeouts().pageLoadTimeout(config.selenium_timeout));  // throws
	selutil.wait(selenium.manage().timeouts().setScriptTimeout(config.selenium_timeout));  // throws
	if (config.selenium_fullscreen)
		selutil.wait(selenium.manage().window().maximize());  // throws
	var fails = {}, scrns = {}, vars = {};
	function apply_vars(data) {
		var v;
		while (v = data.match(/\{(\S+)\}/)) {
			v = v[1];
			var r = vars[v] ? vars[v] : '';
			data = data.replace(/\{\S+\}/, r);
		}
		return data;
	}
	for (var i = 0; i < task.task_actions.length; ++i) {
		var action = task.task_actions[i];
		if (action.data)
			action.data = apply_vars(action.data);
		else
			action.data = '';
		try {
			selutil.hide_selection(selenium);
			switch (action.type) {
			case 'open':
				var url = action.data;
				if (!url.match(/^http(s)*:\/\//i))
					url = 'http://' + url;
				selutil.wait(selenium.get(url));
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				break;
			case 'exists':
				selutil.locate_el(selenium, action.selector);
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				break;
			case 'click':
				var el = selutil.locate_el(selenium, action.selector);
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				selutil.hide_selection(selenium);
				selutil.wait(el.click());
				break;
			case 'enter':
				var el = selutil.locate_el(selenium, action.selector);
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				selutil.hide_selection(selenium);
				selutil.wait(el.clear());
				selutil.wait(el.sendKeys(action.data));
				break;
			case 'match':
				var elxp = xpath.el(action.selector);
				var el = selutil.locate_el(selenium, elxp);
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				selutil.hide_selection(selenium);
				var attr = xpath.attr(action.selector);
				var data = selutil.wait(selenium.executeScript(function() {
					var el = arguments[0];
					var attr = arguments[1];
					if (attr)
						if (attr.match(/^value$/i))
							return el.value;
						else
							return el.getAttribute(attr);
					else
						return el.innerHTML;
				}, el, attr));
				if (!data)
					data = '';
				if (!data.match(new RegExp(action.data)))
					throw new Error('RegExp "' + action.data + '" for element "' + elxp + '"' + (attr ? ' attribute "' + attr + '"' : ' text') + ' is not matched');
				break;
			case 'modify':
				var elxp = xpath.el(action.selector);
				var el = selutil.locate_el(selenium, elxp);
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				selutil.hide_selection(selenium);
				var attr = xpath.attr(action.selector);
				selutil.wait(selenium.executeScript(function() {
					var el = arguments[0];
					var attr = arguments[1];
					var data = arguments[2];
					if (attr)
						if (attr.match(/^value$/i))
							el.value = data;
						else
							el.setAttribute(attr, data);
					else
						el.innerHTML = data;
				}, el, attr, action.data));
				break;
			case 'set':
				vars[action.selector] = action.data;
				break;
			case 'get':
				var elxp = xpath.el(action.selector);
				var el = selutil.locate_el(selenium, elxp);
				scrns[action.action_id] = wait.for(scrot.get_scrn);
				selutil.hide_selection(selenium);
				var attr = xpath.attr(action.selector);
				var data = selutil.wait(selenium.executeScript(function() {
					var el = arguments[0];
					var attr = arguments[1];
					if (attr)
						return el.getAttribute(attr);
					else
						return el.innerHTML;
				}, el, attr));
				vars[action.data] = data;
				break;
			default:
				throw new Error('unsupported action type');
				break;
			}
		} catch (e) {
			scrns[action.action_id] = wait.for(scrot.get_scrn);
			fails[action.action_id] = e.message;
			if (!task.task_debug)
				break;
		}
	}
	selutil.wait(selenium.quit());  // throws
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
