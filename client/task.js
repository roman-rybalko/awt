var task = require('./index');
task(function(err, val) {
	console.log('err:', err, 'val:', val);
	if (err && err.stack)
		console.error(err.stack);
});