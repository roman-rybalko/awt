"use strict";

var spawn = require('child_process').spawn;
var killchtreecb = require('./lib/killchtreecb');
var wait = require('wait.for');
var config = require('./config');

process.title = config.node_id + '-x';

var args = ['--server-args=-screen 0 ' + config.x_scrsize, '--server-num=' + config.x_display, '--auth-file=' + config.x_auth, 'dwm'];
var options = {stdio: 'inherit'};
var child = spawn('xvfb-run', args, options);
child.on('error', function(err){
	console.log('Server error:', err);
	if (err.stack)
		console.log(err.stack);
});
child.on('exit', function() {
	console.log('Server exited');
});

console.log('Server started');


['SIGTERM', 'SIGINT'].forEach(function(sig) {
	process.on(sig, function() {
		wait.launchFiber(function() {
			killchtreecb(process.pid, sig)();
		});
	});
});
