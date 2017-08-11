recentVisits.factory('recentVisitFactory', [ '$http', '$q',
		function($http, $q) {
			return {
				fetchRecentVisits : function() {
					var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/visit?v=custom:(uuid,display,patient:(uuid))";
					return $http.get(url);
				},
				fetchVisitEncounterObs : function(visitId) {
					var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/visit/" + visitId + "?v=custom:(uuid,display,startDatetime,stopDatetime,encounters:(display,uuid,obs:(display,uuid,value)),patient:(uuid))";
					return $http.get(url);
				},
				fetchVisitDetails : function(visitId) {
					var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/visit/" + visitId;
					return $http.get(url);
				}
			};

		} ]);