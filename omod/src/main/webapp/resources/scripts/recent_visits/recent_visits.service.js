recentVisits.factory('RecentVisitFactory', [ '$http', '$q',
		function($http, $q) {

			return {
				fetchRecentVisits : function() {
					var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/visit?v=custom:(uuid,display,patient:(uuid)";
					return $http.get(url);
				},
				fetchVisitDetails : function(uuid) {
					var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/visit/" + uuid;
					return $http.get(url);
				}
			};

		} ]);