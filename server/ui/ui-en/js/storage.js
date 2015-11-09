// require jquery.cookie
// require jquery.storageapi

function Storage(name_prefix, expire_days) {
	this.prefix = name_prefix;
	this.expire = expire_days ? expire_days : 0;
	this.set = function(name, value) {
		name = this.prefix + name;
		var data = {
			value: value,
			expire: this.expire ? new Date().getTime() + this.expire * 86400000 : 0
		};
		$.localStorage.set(name, data);
	}
	this.get = function(name) {
		name = this.prefix + name;
		var data = $.localStorage.get(name);
		if (data)
			if (!data.expire || data.expire > new Date().getTime())
				return data.value;
			else
				$.localStorage.remove(name);
		return null;
	}
}
