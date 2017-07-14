intelehealthPatientProfileImage.controller('IntelehealthPatientProfileImageController', function($scope, $http,
		$timeout, IntelehealthPatientProfileImageFactory, $location) {
	console.log("ctrl says hi");
//	debugger;
	$scope.recentVisits = [];
	$scope.visitList = [];
	$scope.visitDetails = {};
	$scope.patientId = window.location.search.split('=')[1];
	
//	$scope.fetchPatientProfileImage = function() {
		console.log("controller");
		debugger;
	IntelehealthPatientProfileImageFactory.fetchAdditionalDocuments().then(
			function(data) {
				$scope.visitList = data.data.results;
				debugger;
				$scope.links = [];
//				angular.forEach($scope.visitList, function(value, key) {
//					if($scope.patientId === value.patient.uuid){
//						$scope.recentVisits.push(value);	
//						var uuid = value.uuid;
//						IntelehealthPatientProfileImageFactory.fetchVisitDetails(uuid).then(function(data) {
//							$scope.visitDetails = data.data;
//							if ($scope.visitDetails.stopDatetime == null || $scope.visitDetails.stopDatetime == undefined) {
//								$scope.recentVisits[key].visitStatus = "Active";
//							}
//						}, function(error) {
//							console.log(error);
//						})
//					}	
//				});
			}, function(error) {
				console.log(error);
			})
			
//	}
	
//	var init = function () {
//		console.log("controller");
//		$scope.fetchPatientProfileImage();
//	}
//	
//	init();
});