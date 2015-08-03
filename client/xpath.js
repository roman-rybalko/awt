"use strict";

function element(xpath) {
	if(xpath.match(/\/@/) || xpath.match(/\/attribute::/i))
		return xpath.replace(/\/[^\/]+$/, '');
	return xpath;
}

function attribute_name(xpath) {
	var attr = xpath.match(/\/@.+/);
	if (attr)
		attr = attr[0].match(/@(\S+)/);
	else {
		attr = xpath.match(/\/attribute::.+/i);
		if (attr)
			attr = attr[0].match(/attribute::(\S+)/i);
		else
			return;
	}
	return attr[1];
}

module.exports = {
	el: element,
	attr: attribute_name
};