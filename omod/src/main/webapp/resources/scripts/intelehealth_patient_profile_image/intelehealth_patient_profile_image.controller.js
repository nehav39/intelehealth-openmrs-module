intelehealthPatientProfileImage.controller('intelehealthPatientProfileImageController', function($scope, $http,
		$timeout, intelehealthPatientProfileImageFactory, $location) {
	$scope.patientImage = [];
	$scope.patientId = window.location.search.split('=')[1];
	
	intelehealthPatientProfileImageFactory.fetchAdditionalDocuments().then(
			function(data) {
				$scope.patientImage = data.data.results;
			}, function(error) {
				console.log(error);
			})
});