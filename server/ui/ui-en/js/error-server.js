function _awt_error_handler(f) {
	var messaging = _awt_messaging;
	return function(arg1, arg2, arg3) {
		try {
			return f(arg1, arg2, arg3);
		} catch (e) {
			if (console)
				console.log('exception:', e, e.stack ? e.stack : '');
			if (messaging) {
				var data = {};
				if (e.name)
					data.name = e.name;
				if (e.message)
					data.message = e.message;
				if (e.fileName)
					data.fileName = e.fileName;
				if (e.lineNumber)
					data.lineNumber = e.lineNumber;
				if (e.columnNumber)
					data.columnNumber = e.columnNumber;
				if (e.stack)
					data.stack = e.stack;
				messaging.send({type: 'error', exception: data});
			}
		}
	};
}
