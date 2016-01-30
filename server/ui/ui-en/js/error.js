function error_handler(f) {
	return function() {
		try {
			return f.apply(this, arguments);
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
