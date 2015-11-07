"use strict";

var task = require('./lib/task');
var wait = require('wait.for');
var config = require('./config');

process.title = config.node_id + '-task';
if (config.x_display)
	process.env['DISPLAY'] = ':' + config.x_display;
if (config.x_auth)
	process.env['XAUTHORITY'] = config.x_auth;
console.log('HOME=' + process.env['HOME']);

wait.launchFiber(function(){
	task(function(err, val) {
		console.log('err:', err, 'val:', val);
		if (err && err.stack)
			console.error(err.stack);
	});
});