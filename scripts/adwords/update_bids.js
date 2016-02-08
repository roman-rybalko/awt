var adGroupsLabel = 'UPD_BIDS';

// update to 1st page bid
function update(keyword) {
	var target = keyword.getFirstPageCpc();
	var current = keyword.bidding().getCpc();
	if (!target && current) {
		keyword.bidding().clearCpc();
		return -1;
	}
	if (target != current) {
		keyword.bidding().setCpc(target);
		return target;
	}
	return 0;
}

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
	var labels = AdWordsApp.labels().withCondition('Name = ' + adGroupsLabel).get();
	if (!labels.hasNext())
		throw 'Label "' + adGroupsLabel + '" is not found.';
	var adGroups = labels.next().adGroups().get();
	if (!adGroups.hasNext())
		throw 'No AdGroup with label "' + adGroupsLabel + '" found.';
	while (adGroups.hasNext()) {
		var adGroup = adGroups.next();
		var keywords = adGroup.keywords().get();
		var total = 0;
		var updated = 0;
		var maxBid = 0;
		var minBid = 0;
		while (keywords.hasNext()) {
			var keyword = keywords.next();
			var newBid = update(keyword);
			if (newBid) {
				++updated;
				if (maxBid < newBid)
					maxBid = newBid;
				if (!minBid || (newBid > 0 && minBid > newBid))
					minBid = newBid;
			}
			++total;
		}
		log('Campaign: ' + adGroup.getCampaign().getName() + ', AdGroup: ' + adGroup.getName() + ', total cnt: ' + total + ', updated cnt: ' + updated + ', min bid: ' + minBid + ', max bid: ' + maxBid);
	}
	mailLog('Update Bids');
}
