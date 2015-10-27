"use strict";

var spawn = require('child_process').spawn;
var wait = require('wait.for');

function launch(path, args, cb) {
	var child = spawn(path, args, {stdio: 'inherit', env: process.env});
	child.on('error', function(err){
		cb(err);
	});
	child.on('exit', function(code) {
		cb(undefined, code);
	});
}

module.exports = function(path, args) {
	if (!args)
		args = [];
	return function() {
		try {
			return -wait.for(launch, path, args);
		} catch (e) {
			console.log('spawncb for path=' + path + ' failed: ' + e);
			return -255;
		}
	};
}
