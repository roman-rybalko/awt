"use strict";
var request = require('request');
var wait = require('wait.for');
var config = require('./config');

function server_req(params) {
	params['token'] = config.server_token;
	var result = wait.for(function(arg, cb){
		request.post(arg, function(err, resp, body) {
			cb(err, [resp, body]);
		});
	}, {
		url: config.server_url,
		formData: params
	});
	var data = {};
	if (result[0].statusCode == 200)
		data = JSON.parse(result[1]);
	return data;
}

module.exports = {
	req: server_req
};