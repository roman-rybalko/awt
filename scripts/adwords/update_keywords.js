var adGroupLabelUrlMap = {
	UPD_SBS_DATA_MINING: 'http://deploy.hosts.advancedwebtesting.net/adwords/sbs_data_mining.txt',
	UPD_SBS_PROGRAMMING_AUTOMATION: 'http://deploy.hosts.advancedwebtesting.net/adwords/sbs_programming_automation.txt',
	UPD_SBS_PROGRAMMING_CRAWLER: 'http://deploy.hosts.advancedwebtesting.net/adwords/sbs_programming_crawler.txt',
	UPD_SBS_SOFTWARE: 'http://deploy.hosts.advancedwebtesting.net/adwords/sbs_software.txt',
	UPD_S_TESTING: 'http://deploy.hosts.advancedwebtesting.net/adwords/s_testing.txt',
	UPD_S_AUTOMATION: 'http://deploy.hosts.advancedwebtesting.net/adwords/s_automation.txt',
	UPD_S_MONITORING: 'http://deploy.hosts.advancedwebtesting.net/adwords/s_monitoring.txt',
	UPD_D_GENERAL: 'http://deploy.hosts.advancedwebtesting.net/adwords/d_general.txt',
	UPD_D_TESTING: 'http://deploy.hosts.advancedwebtesting.net/adwords/d_testing.txt',
	UPD_D_AUTOMATION: 'http://deploy.hosts.advancedwebtesting.net/adwords/d_automation.txt',
	UPD_D_MONITORING: 'http://deploy.hosts.advancedwebtesting.net/adwords/d_monitoring.txt',
};

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

function fetchKeywords(url) {
	var response = UrlFetchApp.fetch(url);
	var code = response.getResponseCode();
	if (code < 200 || code > 299)
		throw 'Url "' + url + '" fetch failed, code: ' + code;
	var strings = response.getContentText().split(/\s*\n/).filter(function(str){return str != '';});
	return strings;
}

function main() {
	var delKeywords = [];
	var addKeywords = [];
	for (var label in adGroupLabelUrlMap) {
		var labels = AdWordsApp.labels().withCondition('Name = ' + label).get();
		if (!labels.hasNext())
			throw 'Label "' + label + '" is not found.';
		var adGroups = labels.next().adGroups().get();
		if (!adGroups.hasNext())
			throw 'No AdGroups with label "' + adGroupsLabel + '" found.';
		while (adGroups.hasNext()) {
			var adGroup = adGroups.next();
			var newKeywords = fetchKeywords(adGroupLabelUrlMap[label]);
			var oldKeywords = [];
			var keywords = adGroup.keywords().get();
			while (keywords.hasNext()) {
				var keyword = keywords.next();
				oldKeywords.push({keyword: keyword, text: keyword.getText()});
			}
			var added = 0;
			var removed = 0;
			var unchanged = 0;
			oldKeywords.sort(function(a,b){return a.text == b.text ? 0 : a.text > b.text ? 1 : -1;});   /// ascending
			newKeywords.sort(function(a,b){return a == b ? 0 : a > b ? 1 : -1;});  /// ascending
			var o = 0;
			var n = 0;
			while (o < oldKeywords.length && n < newKeywords.length)
				if (oldKeywords[o].text == newKeywords[n]) {
					++unchanged;
					++o;
					++n;
				} else if (oldKeywords[o].text > newKeywords[n]) {  /// sorted ascending
					addKeywords.push({adGroup: adGroup, text: newKeywords[n]});
					++added;
					++n;
				} else {
					delKeywords.push(oldKeywords[o].keyword);
					++removed;
					++o;
				}
			while (o < oldKeywords.length) {
				delKeywords.push(oldKeywords[o].keyword);
				++removed;
				++o;
			}
			while (n < newKeywords.length) {
				addKeywords.push({adGroup: adGroup, text: newKeywords[n]});
				++added;
				++n;
			}
			log('Label: ' + label + ', AdGroup: ' + adGroup.getName() + ', removed: ' + removed + ', added: ' + added + ', unchanged: ' + unchanged);
		}
	}
	log('total modifications: ' + (delKeywords.length + addKeywords.length));
	for (var i in delKeywords)
		delKeywords[i].remove();
	for (var i in addKeywords)
		addKeywords[i].adGroup.newKeywordBuilder().withText(addKeywords[i].text).build();
	mailLog('Update Keywords');
}
