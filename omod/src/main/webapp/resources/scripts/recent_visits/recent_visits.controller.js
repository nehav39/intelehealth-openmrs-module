recentVisits.controller('RecentVisitController', function($scope, $http,
		$timeout, RecentVisitFactory, $location) {
	$scope.recentVisits = [];

	$scope.patientId = window.location.search.split('=')[1];

	RecentVisitFactory.fetchRecentVisits().then(function(data) {
		$scope.recentVisits = data.data.results;
	}, function(error) {
		console.log(error);
	})
});