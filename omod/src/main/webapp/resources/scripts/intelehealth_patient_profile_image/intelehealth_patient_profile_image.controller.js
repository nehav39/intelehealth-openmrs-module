intelehealthPatientProfileImage.controller('intelehealthPatientProfileImageController', function($scope, $http,
		$timeout, intelehealthPatientProfileImageFactory, $location) {
	$scope.patientImage = [];
	var str = window.location.search.split('=')[1];
	$scope.patientId = str.split('&')[0];

	intelehealthPatientProfileImageFactory.fetchAdditionalDocuments($scope.patientId).then(
			function(data) {
				$scope.patientImage = data.data.results;
			}, function(error) {
				console.log(error);
			})
});