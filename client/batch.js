"use strict";

var task = require('./lib/task');
var wait = require('wait.for');
var config = require('./config');
var count = 0;
var timer;
var stop = false;

process.title = config.node_id + '-batch';
if (config.x_display)
	process.env['DISPLAY'] = ':' + config.x_display;
if (config.x_auth)
	process.env['XAUTHORITY'] = config.x_auth;
console.log('HOME=' + process.env['HOME']);

function cb(err, val) {
	console.info('task done, err:', err, 'val:', val);
	if (config.batch_finish_cb)
		config.batch_finish_cb(err, val);
	if (err && err.stack)
		console.error(err.stack);
	--count;
	if (stop)
		return;
	if (val || err) {
		if (!timer)
			timer = setTimeout(start, config.batch_timeout);
	} else {
		start();
	}
}

function new_task() {
	wait.launchFiber(function(){
		if (config.batch_start_cb)
			config.batch_start_cb();
		task(cb);
	});
	++count;
}

function stop_timer() {
	if (timer) {
		clearTimeout(timer);
		timer = null;
	}
}

function start() {
	stop_timer();
	if (stop)
		return;
	if (count < config.batch_count)
		new_task();
	if (count < config.batch_count)
		new_task();
}

process.on('SIGINT', function() {
	console.info('SIGINT received, exiting ...');
	stop = true;
	stop_timer();
});

process.on('SIGTERM', function() {
	console.info('SIGTERM received, exiting ...');
	stop = true;
	stop_timer();
});

process.on('SIGUSR1', function() {
	console.info('SIGUSR1 received, starting a task ...');
	start();
});

start();
