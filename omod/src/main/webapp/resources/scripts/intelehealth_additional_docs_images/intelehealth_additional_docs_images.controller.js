intelehealthAdditionalDocs.controller('intelehealthAdditionalDocsController',
		function($scope, $http, $timeout, $location,
				intelehealthAdditionalDocsFactory) {
			$scope.patientImage = [];
			var str = window.location.search.split('=')[1];
			$scope.patientId = str.split('&')[0];
			var path = window.location.search;
			var i = path.indexOf("visitId=");
			var visitId = path.substr(i + 8, path.length);

			intelehealthAdditionalDocsFactory.fetchAdditionalDocuments($scope.patientId, visitId).then(
					function(data) {
						$scope.patientImage = data.data.results;
					}, function(error) {
						console.log(error);
					});

			$scope.openAdditionalDocFullImage = function(url) {
				window.open(url);
			};
		});