"use strict";

var task = require('./lib/index');

task(function(err, val) {
	console.log('err:', err, 'val:', val);
	if (err && err.stack)
		console.error(err.stack);
});