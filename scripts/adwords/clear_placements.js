var campaignConfigs = [
	{
		name:'Display PPC',
		excluded: true,
		managed: true
	},
	{
		name:'Display PPM',
		excluded: false,
		managed: true
	},
];

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
 * @param criteria {managed: bool, excluded: bool}
 */
function removePlacements(adGroup, criteria) {
	if (!criteria)
		criteria = {};
	if (typeof(criteria.managed) == 'undefined')
		criteria.managed = true;
	if (typeof(criteria.excluded) == 'undefined')
		criteria.excluded = true;
	Logger.log('Placements: criteria: ' + JSON.stringify(criteria) + ', AdGroup: ' + adGroup.getName() + ', Campaign: ' + adGroup.getCampaign().getName());
	var placements;
	if (criteria.excluded)
		placements = adGroup.display().excludedPlacements().get();
	else
		placements = adGroup.display().placements().get();
	while (placements.hasNext()) {
		var placement = placements.next();
		if (placement.isManaged) {
			if (criteria.managed && !placement.isManaged())
				continue;
			if (!criteria.managed && placement.isManaged())
				continue;
		}
		Logger.log('Remove Placement: id: ' + placement.getId() + ', url: ' + placement.getUrl()
			+ (placement.isManaged ? ', managed: ' + placement.isManaged() : '')
			+ ', AdGroup: ' + placement.getAdGroup().getName() + ', Campaign: ' + placement.getCampaign().getName());
		placement.remove();
	}
}

function main() {
	for (var i in campaignConfigs) {
		campaignConfigs[i].campaign = getCampaignByName(campaignConfigs[i].name);
		var config = campaignConfigs[i];
		Logger.log('Campaign: ' + config.campaign.getName() + ', id: ' + config.campaign.getId() + ', excluded: ' + config.excluded + ', managed: ' + config.managed);
	}
	for (var i in campaignConfigs) {
		var campaign = campaignConfigs[i].campaign;
		var adGroups = campaign.adGroups().get();
		while (adGroups.hasNext()) {
			var adGroup = adGroups.next();
			removePlacements(adGroup, {excluded: campaignConfigs[i].excluded, managed: campaignConfigs[i].managed});
		}
	}
}
