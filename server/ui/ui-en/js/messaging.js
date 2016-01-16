var Messaging = function(server) {
	var send_key;
	var recv_key;
	if (server) {
		send_key = 'MgJu7pUHuQMyan9x2Rof8A';
		recv_key = 'zIAQaueFniYDnnoTi8g27l';
	} else {
		send_key = 'zIAQaueFniYDnnoTi8g27l';
		recv_key = 'MgJu7pUHuQMyan9x2Rof8A';
	}
	var target = null;
	var set_target = this.set_target = function(new_target) {
		if (target && target != new_target)
			target.close();
		target = new_target;
	}
	this.send = function(data) {
		try {
			if (target)
				target.postMessage({data: data, key: send_key}, '*');
			if (data != 'ping' && console)
				console.log('send:', data);
		} catch (e) {
			if (console)
				console.log('postMessage: ' + e);
		}
	};
	var cbs = [];
	this.recv = function(cb) {
		if (cb)
			cbs.push(cb);
	};
	var send = this.send;
	var ping = this.ping = function() {
		send('ping');
		setTimeout(ping, 100);
	};
	$(window).on('message', function(ev) {
		try {
			var data = ev.originalEvent.data;
			if (data.key != recv_key)
				return;
			var source = ev.originalEvent.source;
			if (source)
				set_target(source);
			if (data.data != 'ping' && console)
				console.log('recv:', data.data);
			for (i in cbs)
				cbs[i](data.data);
		} catch (e) {
			if (console)
				console.log('message: ' + e);
		}
	});
};
