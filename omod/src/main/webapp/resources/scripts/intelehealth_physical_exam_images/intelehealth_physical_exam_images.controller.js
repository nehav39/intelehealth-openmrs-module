intelehealthPhysicalExamination.controller(
		'intelehealthPhysicalExaminationController', function($scope, $http,
				$timeout, $location, intelehealthPhysicalExaminationFactory) {
			
			$scope.patientImage = [];
			var str = window.location.search.split('=')[1];
			$scope.patientId = str.split('&')[0];
			var path = window.location.search;
			var i = path.indexOf("visitId=");
			var visitId = path.substr(i + 8, path.length);
			$scope.physicalExamPresent = false;
			
			intelehealthPhysicalExaminationFactory.fetchPhysicalExamination($scope.patientId, visitId).then(
					function(data) {
						if (data.data.results.length !== 0) {
							$scope.physicalExamPresent = true;
							$scope.patientImage = data.data.results;	
						} else {
							$scope.physicalExamPresent = false;
						}
					}, function(error) {
						console.log(error);
					});
			
			$scope.openPhysicalExamFullImage = function(url) {
				window.open(url);
			};
		});