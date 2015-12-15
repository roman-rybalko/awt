var campaignNames = ['Display PPC', 'Display PPM'];
var adGroupNames = ['Data Mining', 'Automation', 'General', 'Monitoring', 'Development & Testing'];
var phraseMatch = false;
var exactMatch = false;
var broadMatchModifiers = false;  /// removes modifiers but keeps negatives

function mangle(text) {
	text = text.replace('[', '');
	text = text.replace(']', '');
	text = text.replace('"', '');
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
	for (var c in campaignNames) {
		var campaignName = campaignNames[c];
		var campaigns = AdWordsApp.campaigns().withCondition('Name = "' + campaignName + '"').get();
		if (!campaigns.hasNext()) {
			Logger.log('Campaign "' + campaignName + '" is not found.');
			continue;
		}
		var campaign = campaigns.next();
		for (var g in adGroupNames) {
			var adGroupName = adGroupNames[g];
			var adGroups = campaign.adGroups().withCondition('Name = "' + adGroupName + '"').get();
			if (!adGroups.hasNext()) {
				Logger.log('AdGroup "' + adGroupName + '" in Campaign "' + campaignName + '" is not found.');
				continue;
			}
			var adGroup = adGroups.next();
			var addKeywords = {};
			var removeKeywords = [];
			var keywords = adGroup.keywords().get();
			while (keywords.hasNext()) {
				var keyword = keywords.next();
				var text = keyword.getText();
				var newText = mangle(text);
				if (text != newText) {
					Logger.log('Campaign: ' + campaignName + ', AdGroup: ' + adGroupName + ', text: <' + text + '> -> <' + newText + '>');
					addKeywords[newText] = 1;
					removeKeywords.push(keyword);
				}
			}
			for (var i in removeKeywords)
				removeKeywords[i].remove();
			for (var keyword in addKeywords)
				adGroup.newKeywordBuilder().withText(keyword).build();
		}
	}
}
