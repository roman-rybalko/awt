function error_handler(f) {
	return function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) {
		try {
			return f(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
		} catch (e) {
			if (console)
				console.log('exception:', e, e.stack ? e.stack : '');
			try {
				if (!$)
					return;
				var data = [];
				if (e.name)
					data.push('Name: ' + e.name);
				if (e.message)
					data.push('Message: ' + e.message);
				if (e.fileName)
					data.push('FileName: ' + e.fileName);
				if (e.lineNumber)
					data.push('LineNumber: ' + e.lineNumber);
				if (e.columnNumber)
					data.push('ColumnNumber: ' + e.columnNumber);
				if (e.stack)
					data.push('Stack: ' + e.stack);
				$.post('ui-en/php/error.php', {data: data.join(', ')});
			} catch (e) {
				if (console)
					console.log('exception:', e, e.stack ? e.stack : '');
			}
		}
	};
}
