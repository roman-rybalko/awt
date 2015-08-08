"use strict";

var task = require('./lib/index');

process.title = config.node_id + '-task';

task(function(err, val) {
	console.log('err:', err, 'val:', val);
	if (err && err.stack)
		console.error(err.stack);
});