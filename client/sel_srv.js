"use strict";

var selenium = require('selenium-standalone');
var config = require('./config');

process.title = config.node_id + '-selenium';
process.env['DISPLAY'] = ':' + config.xdisplay;
process.env['XAUTHORITY'] = config.xauth;

selenium.start({
	spawnOptions: {stdio: 'inherit'},
	seleniumArgs: ["-port", config.selenium_port]
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
