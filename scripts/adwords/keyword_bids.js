var logMail = 'root@advancedwebtesting.com';
var logBuf = [];
function log(str) {
	logBuf.push(str);
	Logger.log(str);
}
function mailLog(subject) {
	MailApp.sendEmail(logMail, subject, logBuf.join("\n"));
	logBuf = [];
}

function main() {
	var kk = AdWordsApp.keywords().get();
	while (kk.hasNext()) {
		var k = kk.next();
		if (k.getFirstPageCpc() !== null)
			log('text: ' + k.getText() + ', id: ' + k.getId() + ', bid: ' + k.getFirstPageCpc());
	}
	mailLog('Keyword Bids');
}
