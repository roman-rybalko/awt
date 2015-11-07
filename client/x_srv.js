"use strict";

var spawn = require('child_process').spawn;
var pstree = require('ps-tree');
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
child.on('exit', function(){
	console.log('Server exited');
});
console.log('Server started');
['SIGTERM', 'SIGINT'].forEach(function(signal){
	process.on(signal, function(){
		console.log('Exiting...');
		pstree(child.pid, function(err, children){
			if (err)
				console.log('pstree error:', err);
			else
				children.forEach(function(ch){
					var pid = ch.PID;
					console.log('Terminating pid ' + pid);
					try {
						process.kill(pid, 'SIGTERM');
					} catch (e) {
						console.error('pid ' + pid + ' does not exist');
					}					
				});
			child.kill('SIGTERM');
		});
	});
});