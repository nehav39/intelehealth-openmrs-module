intelehealthPatientProfileImage.factory('intelehealthPatientProfileImageFactory', [ '$http', '$q',
		function($http, $q) {
			return {
				fetchAdditionalDocuments : function(patientUuid) {
					var url = "http://139.59.73.230:1338/parse/classes/Profile?where={\"PatientID\":\"" + patientUuid +"\"}";
					var headers = {headers:  {
				        'X-Parse-Application-Id': 'app2',
				        'X-Parse-REST-API-Key': 'undefined'
							}
						};
					return $http.get(url, headers);
				},
				fetchVisitDetails : function(uuid) {
					var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/visit/" + uuid;
					return $http.get(url);
				}
			};

		} ]);