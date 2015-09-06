"use strict";

var webdriver = require('selenium-webdriver');
var selutil = require('./selutil');
var srv = require('./srv');
var xputil = require('./xputil');
var scrot = require('./scrot');
var config = require('../config');

function process() {
	var resp = srv.req({
		task_type: config.task_type,
		node_id: config.node_id
	});
	if (resp.empty)
		return 'no task';
	if (resp.fail)
		return resp.fail;
	if (!resp.task || !resp.task.id)
		throw new Error('response parsing failed');
	var task = resp.task;
	var resp = srv.req({
		task_id: task.id,
		status: 'running',
		node_id: config.node_id
	});
	if (resp.fail)
		return resp.fail;
	if (!resp.ok)
		throw new Error('response[2] parsing failed');
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
	task.actions.sort(function(a, b){return a.id - b.id;});
	for (var i = 0; i < task.actions.length; ++i) {
		var action = task.actions[i];
		if (action.data)
			action.data = apply_vars(action.data);
		else
			action.data = '';
		if (action.selector)
			action.selector = apply_vars(action.selector);
		else
			action.selector = '';
		try {
			selutil.hide_selection(selenium);
			switch (action.type) {
			case 'open':
				var url = action.selector;
				if (!url.match(/^\w+:\/\//i))
					url = 'http://' + url;
				selutil.wait(selenium.get(url));
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'exists':
				var xpath = action.selector;
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						return selutil.wait(selenium.isElementPresent({xpath: xpath}));
					});
				}))
					throw new Error('Element XPATH "' + xpath + '" is not found');
				selutil.select_element(selenium, selutil.wait(selenium.findElement({xpath: xpath})));
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'click':
				var xpath = action.selector;
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						return selutil.wait(selenium.isElementPresent({xpath: xpath}));
					});
				}))
					throw new Error('Element XPATH "' + xpath + '" is not found');
				var el = selutil.wait(selenium.findElement({xpath: xpath}));
				selutil.select_element(selenium, el);
				scrns[action.id] = scrot.get_scrn();
				selutil.hide_selection(selenium);
				selutil.wait(el.click());
				break;
			case 'enter':
				var xpath = action.selector;
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						return selutil.wait(selenium.isElementPresent({xpath: xpath}));
					});
				}))
					throw new Error('Element XPATH "' + xpath + '" is not found');
				var el = selutil.wait(selenium.findElement({xpath: xpath}));
				selutil.wait(el.clear());
				selutil.wait(el.sendKeys(action.data));
				selutil.select_element(selenium, el);
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'modify':
				var xpath = xputil.el(action.selector);
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						return selutil.wait(selenium.isElementPresent({xpath: xpath}));
					});
				}))
					throw new Error('Element XPATH "' + xpath + '" is not found');
				var el = selutil.wait(selenium.findElement({xpath: xpath}));
				var attr = xputil.attr(action.selector);
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
				selutil.select_element(selenium, el);
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'url':
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						var data = selutil.wait(selenium.getCurrentUrl());
						if (!data)
							data = '';
						return data.match(new RegExp(action.selector, 'i'));
					});
				}))
					throw new Error('RegExp "' + action.selector + '" for URL is not matched');
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'title':
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						var data = selutil.wait(selenium.getTitle());
						if (!data)
							data = '';
						return data.match(new RegExp(action.selector, 'i'));
					});
				}))
					throw new Error('RegExp "' + action.selector + '" for Title is not matched');
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'var_regexp':
				var name = action.selector.replace(/\s+/g, '');
				if (!vars[name])
					vars[name] = '';
				var data = vars[name].match(new RegExp(action.data, 'i'));
				if (!data)
					throw new Error('RegExp "' + action.data + '" for Variable "' + vars[name] + '" is not matched');
				vars[name] = data[0];
				break;
			case 'var_xpath':
				var xpath = xputil.el(action.data);
				if (!selutil.wait(function() {
					return selutil.select_window(selenium, function() {
						return selutil.wait(selenium.isElementPresent({xpath: xpath}));
					});
				}))
					throw new Error('Element XPATH "' + xpath + '" is not found');
				var el = selutil.wait(selenium.findElement({xpath: xpath}));
				var attr = xputil.attr(action.data);
				var data = selutil.wait(selenium.executeScript(function() {
					var el = arguments[0];
					var attr = arguments[1];
					if (attr)
						return el.getAttribute(attr);
					else
						return el.innerHTML;
				}, el, attr));
				var name = action.selector.replace(/\s+/g, '');
				vars[name] = data;
				selutil.select_element(selenium, el);
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'var_url':
				var data = selutil.wait(selenium.getCurrentUrl());
				var name = action.selector.replace(/\s+/g, '');
				vars[name] = data;
				scrns[action.id] = scrot.get_scrn();
				break;
			case 'var_title':
				var data = selutil.wait(selenium.getTitle());
				var name = action.selector.replace(/\s+/g, '');
				vars[name] = data;
				scrns[action.id] = scrot.get_scrn();
				break;
			default:
				throw new Error('unsupported action type');
				break;
			}
		} catch (e) {
			scrns[action.id] = scrot.get_scrn();
			fails[action.id] = e.message;
			if (!task.debug)
				break;
		}
	}
	selutil.wait(selenium.quit());  // throws
	var params = {
		task_id: task.id,
		status: Object.keys(fails).length ? 'failed' : 'succeeded',
		node_id: config.node_id
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
	var resp = srv.req(params);
	if (resp.fail)
		return resp.fail;
	if (!resp.ok)
		throw new Error('response[3] parsing failed');
}

module.exports = function(cb) {
	try {
		cb(undefined, process());
	} catch (e) {
		cb(e);
	}
}
