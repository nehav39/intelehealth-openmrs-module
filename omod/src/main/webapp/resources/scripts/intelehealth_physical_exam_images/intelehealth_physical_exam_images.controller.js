intelehealthPhysicalExamination.controller(
		'intelehealthPhysicalExaminationController', function($scope, $http,
				$timeout, $location, intelehealthPhysicalExaminationFactory) {
			
			$scope.patientImage = [];
			$scope.patientId = window.location.search.split('=')[1];
			
			intelehealthPhysicalExaminationFactory.fetchPhysicalExamination().then(
					function(data) {
						$scope.patientImage = data.data.results;
					}, function(error) {
						console.log(error);
					});
			
			$scope.openFullImage = function () {
//				debugger;
//				window.open(url);
			};
		});