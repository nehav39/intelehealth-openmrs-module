recentVisits.filter('visitdate', function() {
	return function(text) {
		text = text || "";

		var str = text;
		var i = str.indexOf("-");
		var str = str.substr(i + 1, 11);
		var date = str.substr(4,2);
		date = date + "/" + str.substr(1,3) + str.substr(7,4);
		var newDate =new Date(date);
		return newDate;
	};
});