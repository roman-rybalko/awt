"use strict";

var selenium = require('selenium-standalone');
var config = require('./config');

process.title = config.node_id + '-selenium';
if (config.x_display)
	process.env['DISPLAY'] = ':' + config.x_display;
if (config.x_auth)
	process.env['XAUTHORITY'] = config.x_auth;
console.log('HOME=' + process.env['HOME']);

selenium.start({
	spawnOptions: {stdio: 'inherit'},
	seleniumArgs: ["-port", config.selenium_port],
	version: config.selenium_version
}, function(err, child){
	if (err)
		throw err;
	var signals = ['SIGTERM', 'SIGINT'];
	signals.forEach(function(signal) {
		process.on(signal, function() {
			child.kill('SIGTERM');
		});
	});
	console.log('Server started');
});
