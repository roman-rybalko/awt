error_handler(function() {
	messaging.recv(error_handler(function(data) {
		switch (data.type) {
			case 'error':
				throw data.exception;
		}
	}));
})();
