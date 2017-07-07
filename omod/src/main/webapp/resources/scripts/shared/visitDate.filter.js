recentVisits.filter('visitdate', function() {
	return function(text) {
		text = text || "";

		var str = text;
		var i = str.indexOf("-");
		var res = str.substr(i + 1, 11);
		return res;
	};
});