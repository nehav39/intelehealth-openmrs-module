intelehealthPatientProfileImage.controller('intelehealthPatientProfileImageController', function($scope, $http,
		$timeout, intelehealthPatientProfileImageFactory, $location) {
	$scope.patientImage = [];
	var str = window.location.search.split('=')[1];
	$scope.patientId = str.split('&')[0];
	$scope.profileImagePresent = false;
	
	intelehealthPatientProfileImageFactory.fetchAdditionalDocuments($scope.patientId).then(
			function(data) {
				if (data.data.results.length !== 0) {
					$scope.profileImagePresent = true;
					$scope.patientImage = data.data.results;	
				} else {
					$scope.profileImagePresent = false;
				}
			}, function(error) {
				console.log(error);
			})
});