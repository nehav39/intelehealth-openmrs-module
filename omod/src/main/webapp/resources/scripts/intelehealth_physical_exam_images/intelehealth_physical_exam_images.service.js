intelehealthPhysicalExamination.factory('intelehealthPhysicalExaminationFactory', [ '$http', '$q',
		function($http, $q) {
			return {
				fetchPhysicalExamination : function() {
					var url = "http://139.59.73.230:1338/parse/classes/AdditionalDocuments";
					var headers = {headers:  {
				        'X-Parse-Application-Id': 'app2',
				        'X-Parse-REST-API-Key': 'undefined'
							}
						};
					return $http.get(url, headers);
				}
			};
		}]);