"use strict";

var spawn = require('child_process').spawn;
var tempfile = require('create-temp-file')( /* generator */ );
var fs = require('fs');
var config = require('../config');

function scrot(cb) {
	var ext = '.jpg';
	var tf = tempfile(ext);
	var env = JSON.parse(JSON.stringify(process.env));
	env['DISPLAY'] = ':' + config.xdisplay;
	env['XAUTHORITY'] = config.xauth;
	var ch = spawn('scrot', [tf.path], {env: env, stdio: 'inherit'});
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
	get_scrn: scrot
}