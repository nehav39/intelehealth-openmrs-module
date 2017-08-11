intelehealthPhysicalExamination.controller(
		'intelehealthPhysicalExaminationController', function($scope, $http,
				$timeout, $location, intelehealthPhysicalExaminationFactory) {
			
			$scope.patientImage = [];
			var str = window.location.search.split('=')[1];
			$scope.patientId = str.split('&')[0];
			var path = window.location.search;
			var i = path.indexOf("visitId=");
			var visitId = path.substr(i + 8, path.length);
			console.log("patientId");
			console.log($scope.patientId);
			
			intelehealthPhysicalExaminationFactory.fetchPhysicalExamination($scope.patientId, visitId).then(
					function(data) {
						$scope.patientImage = data.data.results;
					}, function(error) {
						console.log(error);
					});
			
			$scope.openPhysicalExamFullImage = function(url) {
				window.open(url);
			};
		});