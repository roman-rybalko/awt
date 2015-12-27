function error_handler(f) {
	return function(arg1, arg2, arg3) {
		try {
			return f(arg1, arg2, arg3);
		} catch (e) {
			try {
				if (!$)
					return;
				var data = [];
				if ($.browser && $.browser.version)
					data.push('Browser: ' + $.browser.version);
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
				$.post('error.php', {data: data.join(', ')});
			} catch (e) {}
		}
	};
}
