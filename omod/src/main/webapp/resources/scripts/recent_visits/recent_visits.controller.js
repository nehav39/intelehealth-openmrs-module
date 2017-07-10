recentVisits.controller('RecentVisitController', function($scope, $http,
		$timeout, RecentVisitFactory, $location) {
	$scope.recentVisits = [];
	$scope.visitDetails = {};
	$scope.patientId = window.location.search.split('=')[1];

	RecentVisitFactory.fetchRecentVisits().then(
			function(data) {
				$scope.recentVisits = data.data.results;
				$scope.links = [];
				angular.forEach($scope.recentVisits, function(value, key) {
					var uuid = value.uuid;
					RecentVisitFactory.fetchVisitDetails(uuid).then(function(data) {
						$scope.visitDetails = data.data;
						if ($scope.visitDetails.stopDatetime == null || $scope.visitDetails.stopDatetime == undefined) {
							$scope.recentVisits[key].visitStatus = "Active";
						}
					}, function(error) {
						console.log(error);
					})
				});
			}, function(error) {
				console.log(error);
			})
});