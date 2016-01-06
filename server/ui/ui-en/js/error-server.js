function error_handler(f) {
	return function(arg1, arg2, arg3) {
		try {
			return f(arg1, arg2, arg3);
		} catch (e) {
			if (this.messaging)
				this.messaging.send({type: 'error', exception: e});
		}
	};
}
error_handler.messaging = messaging;
