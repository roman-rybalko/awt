var adGroupsLabel = 'ADG_SEARCH';
var phraseMatch = true;
var exactMatch = false;
var broadMatchModifiers = false;  /// adds/removes modifiers but keeps negatives

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

function mangle(text) {
	text = text.replace(/\[/g, '');
	text = text.replace(/\]/g, '');
	text = text.replace(/"/g, '');
	var words = text.split(' ').filter(function(word){return word == '' ? false : true;});
	for (var i in words) {
		words[i] = words[i].replace(/^\+/, '');
		if (broadMatchModifiers)
			words[i] = '+' + words[i];
	}
	text = words.join(' ');
	if (phraseMatch)
		text = '"' + text + '"';
	if (exactMatch)
		text = '[' + text + ']';
	return text;
}

function main() {
	var labels = AdWordsApp.labels().withCondition('Name = ' + adGroupsLabel).get();
	if (!labels.hasNext())
		throw 'Label "' + adGroupsLabel + '" is not found.';
	var adGroups = labels.next().adGroups().get();
	if (!adGroups.hasNext())
		throw 'No AdGroups with label "' + adGroupsLabel + '" found.';
	while (adGroups.hasNext()) {
		var adGroup = adGroups.next();
		var addKeywords = {};
		var removeKeywords = [];
		var keywords = adGroup.keywords().get();
		while (keywords.hasNext()) {
			var keyword = keywords.next();
			var text = keyword.getText();
			var newText = mangle(text);
			if (text != newText) {
				log('Campaign: ' + keyword.getCampaign().getName() + ', AdGroup: ' + keyword.getAdGroup().getName() + ', text: <' + text + '> -> <' + newText + '>');
				addKeywords[newText] = 1;
				removeKeywords.push(keyword);
			}
		}
		for (var i in removeKeywords)
			removeKeywords[i].remove();
		for (var keyword in addKeywords)
			adGroup.newKeywordBuilder().withText(keyword).build();
	}
	mailLog('Fix Keywords');
}
