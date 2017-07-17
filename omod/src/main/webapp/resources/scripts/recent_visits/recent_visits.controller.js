recentVisits.controller('recentVisitController', function($scope, $http,
		$timeout, recentVisitFactory, $location) {
	$scope.recentVisits = [];
	$scope.visitList = [];
	$scope.visitDetails = {};
	$scope.patientId = window.location.search.split('=')[1];
	recentVisitFactory.fetchRecentVisits().then(
			function(data) {
				$scope.visitList = data.data.results;
				$scope.links = [];
				angular.forEach($scope.visitList, function(value, key) {
					if($scope.patientId === value.patient.uuid){
						$scope.recentVisits.push(value);	
						var uuid = value.uuid;
						recentVisitFactory.fetchVisitDetails(uuid).then(function(data) {
							$scope.visitDetails = data.data;
							if ($scope.visitDetails.stopDatetime == null || $scope.visitDetails.stopDatetime == undefined) {
								$scope.recentVisits[key].visitStatus = "Active";
							}
						}, function(error) {
							console.log(error);
						})
					}	
				});
			}, function(error) {
				console.log(error);
			})
});