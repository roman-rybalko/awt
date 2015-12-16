var srcCampaignName = 'Display PPC';
var dstCampaignName = 'Display PPM';
var minCtr = 0.2;
var minImpressions = 1;
var filterRegexp = /^mobileapp::/;
var range = 'YESTERDAY';  // TODAY | YESTERDAY | LAST_7_DAYS | THIS_WEEK_SUN_TODAY | THIS_WEEK_MON_TODAY | LAST_WEEK | LAST_14_DAYS | LAST_30_DAYS | LAST_BUSINESS_WEEK | LAST_WEEK_SUN_SAT | THIS_MONTH*

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

function fatal(str) {
	throw str;
}

function getCampaignByName(name) {
	var campaigns = AdWordsApp.campaigns().withCondition('Name = "' + name + '"').get();
	if (!campaigns.hasNext())
		fatal('Campaign "' + name + '" is not found.');
	var campaign = campaigns.next();
	if (campaigns.hasNext())
		fatal('Campaign name "' + name + '" matches more than one campaign :-/');
	return campaign;
}

/**
 * @return {src: {dst: {srcName: dstObj srcId: dstObj}, srcName: srcObj, srcId: srcObj}, dst: {dstName: dstObj, dstId: dstObj}}
 */
function getAdGroupsMap(srcCampaign, dstCampaign) {
	var adGroupsMap = {};
	var dstAdGroups = dstCampaign.adGroups().get();
	while (dstAdGroups.hasNext()) {
		var adGroup = dstAdGroups.next();
		if (!adGroupsMap._dst)
			adGroupsMap._dst = {};
		adGroupsMap._dst[adGroup.getName()] = adGroup;
		adGroupsMap._dst[adGroup.getId()] = adGroup;
	}
	var srcAdGroups = srcCampaign.adGroups().get();
	while (srcAdGroups.hasNext()) {
		var adGroup = srcAdGroups.next();
		if (adGroup.getName() == '_dst')
			fatal('AdGroup name "' + adGroup.getName() + '" is reserved. Set a different name.');
		if (!adGroupsMap._dst[adGroup.getName()])
			fatal('AdGroup "' + adGroup.getName() + '" in the dest campaign "' + dstCampaign.getName() + '" is not found.');
		if (!adGroupsMap._src)
			adGroupsMap._src = {};
		adGroupsMap._src[adGroup.getName()] = adGroup;
		adGroupsMap._src[adGroup.getId()] = adGroup;
		if (!adGroupsMap._src._dst)
			adGroupsMap._src._dst = {};
		adGroupsMap._src._dst[adGroup.getName()] = adGroupsMap._dst[adGroup.getName()];
		adGroupsMap._src._dst[adGroup.getId()] = adGroupsMap._dst[adGroup.getName()];
	}
	return adGroupsMap;
}

/**
 * @param criteria {minCtr: double, minClicks: int, minImpressions: int, filterRegexp: regexp,
 * range string TODAY | YESTERDAY | LAST_7_DAYS | THIS_WEEK_SUN_TODAY | THIS_WEEK_MON_TODAY | LAST_WEEK | LAST_14_DAYS | LAST_30_DAYS | LAST_BUSINESS_WEEK | LAST_WEEK_SUN_SAT | THIS_MONTH*
 * reportName string AUTOMATIC_PLACEMENTS_PERFORMANCE_REPORT | PLACEMENT_PERFORMANCE_REPORT
 * }
 * @return {domain: string, ctr: double, clicks: int, impressions: int, adGroupId: int, adGroupName: string}[]
 */
function getPlacements(campaign, criteria) {
	if (!criteria)
		criteria = {};
	if (!criteria.minCtr)
		criteria.minCtr = 0.02;
	if (!criteria.minClicks)
		criteria.minClicks = 1;
	if (!criteria.minImpressions)
		criteria.minImpressions = 1;
	if (!criteria.range)
		criteria.range = 'YESTERDAY';
	if (!criteria.reportName)
		criteria.reportName = 'AUTOMATIC_PLACEMENTS_PERFORMANCE_REPORT';
	log('getPlacements: criteria: ' + JSON.stringify(criteria));
	var report = AdWordsApp.report(
		'SELECT Domain, Clicks, Impressions, AdGroupId, AdGroupName'
		+ ' FROM ' + criteria.reportName
		+ ' WHERE CampaignId = ' + campaign.getId() + ' AND Clicks >= ' + criteria.minClicks + ' AND Impressions >= ' + criteria.minImpressions
		+ ' DURING ' + criteria.range
	);
	var placements = [];
	var reportRows = report.rows();
	while (reportRows.hasNext()) {
		var reportRow = reportRows.next();
		if (criteria.filterRegexp && criteria.filterRegexp.exec(reportRow['Domain']))
			continue;
		var ctr = reportRow['Clicks'] / reportRow['Impressions'];
		if (ctr < criteria.minCtr)
			continue;
		placements.push({
			domain: reportRow['Domain'],
			ctr: ctr,
			clicks: reportRow['Clicks'],
			impressions: reportRow['Impressions'],
			adGroupId: reportRow['AdGroupId'],
			adGroupName: reportRow['AdGroupName']
		});
	}
	return placements;
}

/**
 * @param placement {url: string, cpc: double, cpm: double, banned: bool}
 */
function addPlacement(adGroup, placement) {
	if (!placement)
		placement = {};
	if (!placement.url)
		fatal('addPlacement: placement.url is required');
	var builder = adGroup.display().newPlacementBuilder();
	builder = builder.withUrl(placement.url);
	if (placement.cpc)
		builder = builder.withCpc(placement.cpc);
	if (placement.cpm)
		builder = builder.withCpm(placement.cpm);
	var result;
	if (placement.banned)
		result = builder.exclude();
	else
		result = builder.build();
	log('addPlacement: new' + (placement.banned ? ' excluded' : '') + ' placement: ' + JSON.stringify(placement) + ', status: ' + result.isSuccessful() + ', errors: ' + JSON.stringify(result.getErrors()));
}

function main() {
	var srcCampaign = getCampaignByName(srcCampaignName);
	var dstCampaign = getCampaignByName(dstCampaignName);
	var adGroupsMap = getAdGroupsMap(srcCampaign, dstCampaign);
	var placements = getPlacements(srcCampaign, {minCtr: minCtr, minImpressions: minImpressions, filterRegexp: filterRegexp, range: range});
	for (var i in placements) {
		var placement = placements[i];
		log('placement: ' + JSON.stringify(placement));
		addPlacement(adGroupsMap._src._dst[placement.adGroupId], {url: placement.domain});
		addPlacement(adGroupsMap._src[placement.adGroupId], {url: placement.domain, banned: true});
	}
	mailLog('Display Optimization');
}
