intelehealthAdditionalDocs.controller('intelehealthAdditionalDocsController',
		function($scope, $http, $timeout, $location,
				intelehealthAdditionalDocsFactory) {
			$scope.patientImage = [];
			$scope.patientId = window.location.search.split('=')[1];

			intelehealthAdditionalDocsFactory.fetchAdditionalDocuments().then(
					function(data) {
						$scope.patientImage = data.data.results;
					}, function(error) {
						console.log(error);
					});

			$scope.openFullImage = function() {
				alert("hi");
				// debugger;
				// window.open(url);
			};
		});