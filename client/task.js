"use strict";

var task = require('./lib/index');
var config = require('./config');

process.title = config.node_id + '-task';
process.env['DISPLAY'] = ':' + config.xdisplay;
process.env['XAUTHORITY'] = config.xauth;

task(function(err, val) {
	console.log('err:', err, 'val:', val);
	if (err && err.stack)
		console.error(err.stack);
});