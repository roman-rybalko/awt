var messaging = {
	send_key: 'MgJu7pUHuQMyan9x2Rof8A',
	recv_key: 'zIAQaueFniYDnnoTi8g27l',
	target: null,
	send: function(data) {
		try {
			if (target)
				target.postMessage({data: data, key: this.send_key}, '*');
		} catch (e) {
			if (console)
				console.log('postMessage: ' + e);
		}
	},
	cbs: [],
	onrecv: function(cb) {
		if (cb)
			this.cbs.push(cb);
	},
	ping: function() {
		this.send('ping');
		setTimeout(this.ping, 100);
	}
	init: function(server) {
		if (server) {
			var tmp = this.send_key;
			this.send_key = this.recv_key;
			this.recv_key = tmp;
		}
		$(window).on('message', function(ev) {
			var data = ev.originalEvent.data;
			if (data.key != this.recv_key)
				return;
			var source = ev.originalEvent.source;
			if (source) {
				if (!this.target)
					this.target = source;
				if (source != this.target)
					source.close();
			}
			for (i in this.cbs)
				cbs[i](data.data);
		});
	}
};
