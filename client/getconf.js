"use strict";
var config = require('./config');
var value = config[process.argv[2]];
if (typeof(value) != 'undefined')
	console.log(value);
