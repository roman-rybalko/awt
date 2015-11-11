var pstree = require('ps-tree');
var wait = require('wait.for');

function killchtree(pid, sig, cb) {
	pstree(pid, function(err, children) {
		if (err) {
			cb(err);
			console.error('pstree error:', err);
		} else {
			var val = [];
			for (i in children) {
				var ch = children[i];
				val.push(JSON.stringify(ch));
				try {
					process.kill(ch.PID, sig);
				} catch (e) {}
			};
			function wait() {
				for (i in children) {
					var ch = children[i];
					try {
						process.kill(ch.PID, 0);
						setTimeout(wait, 100);
						return;
					} catch (e) {}
				}
				cb(undefined, val);
				if (val.length)
					console.log('kill: ' + val.join(', '));
			}
			wait();
		}
	});
};

module.exports = function(pid, sig) {
	return function() {
		try {
			return -wait.for(killchtree, pid, sig);
		} catch (e) {
			console.log('killchtreecb failed, e:', e);
			return -255;
		}
	};
};
