"use strict";

var selenium = require('selenium-standalone');
var config = require('./config');

process.title = config.node_id + '-selenium';

var env = JSON.parse(JSON.stringify(process.env));
env['DISPLAY'] = ':' + config.xdisplay;
env['XAUTHORITY'] = config.xauth;
selenium.start({
	spawnOptions: {env: env, stdio: 'inherit'},
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
