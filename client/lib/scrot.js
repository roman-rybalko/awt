"use strict";

var spawn = require('child_process').spawn;
var tempfile = require('create-temp-file')( /* generator */ );
var fs = require('fs');
var wait = require('wait.for');

function scrot(cb) {
	var ext = '.jpg';
	var tf = tempfile(ext);
	var ch = spawn('scrot', [tf.path], {stdio: 'inherit'});
	ch.on('error', function(err) {
		tf.cleanupSync();
		cb(err);
	});
	ch.on('exit', function(code) {
		if (code) {
			tf.cleanupSync();
			cb(new Error('scrot exit code = ' + code));
			return;
		}
		fs.readFile(tf.path, function(err, data) {
			tf.cleanupSync();
			if (err)
				cb(err);
			else
				cb(undefined, {data: data, ext: ext});
		});
	});
}

module.exports = {
	get_scrn: function() {return wait.for(scrot);}
}