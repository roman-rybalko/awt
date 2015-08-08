"use strict";

var task = require('./lib/index');
var wait = require('wait.for');
var config = require('./config');
var count = 0;
var timer;
var stop = false;

process.title = config.node_id + '-batch';

function cb(err, val) {
	console.info('task done, err:', err, 'val:', val);
	if (err && err.stack)
		console.error(err.stack);
	--count;
	if (stop)
		return;
	if (val) {
		if (!timer)
			timer = setTimeout(start, config.batch_timeout);
	} else {
		start();
	}
}

function new_task() {
	wait.launchFiber(function(){
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
