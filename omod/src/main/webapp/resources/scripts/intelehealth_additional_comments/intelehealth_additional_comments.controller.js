intelehealthAdditionalComments.controller('intelehealthAdditionalCommentsController', function($scope, $http,
				$timeout, $location, recentVisitFactory, AdditionalCommentsFactory1, AdditionalCommentsFactory2, AdditionalCommentsFactory3) {
	$scope.alerts = [];
	$scope.respuuid = [];
	var _selected;
	var str = window.location.search.split('=')[1];
	$scope.patient = str.split('&')[0];
	var date2 = new Date();

	var path = window.location.search;
	var i = path.indexOf("visitId=");
	var visitId = path.substr(i + 8, path.length);
	$scope.visitEncounters = [];
	$scope.visitObs = [];
	$scope.visitNoteData = [];
	$scope.visitNotePresent = true;
	$scope.visitStatus = false;
	$scope.encounterUuid = "";
	recentVisitFactory.fetchVisitEncounterObs(visitId).then(function(data) {
							$scope.visitDetails = data.data;
								if ($scope.visitDetails.stopDatetime == null || $scope.visitDetails.stopDatetime == undefined) {
									$scope.visitStatus = true;
								}
								else {
									$scope.visitStatus = false;
								}
							$scope.visitEncounters = data.data.encounters; 
							if($scope.visitEncounters.length !== 0) {
							$scope.visitNotePresent = true;
								angular.forEach($scope.visitEncounters, function(value, key){
									var isVital = value.display;
									if(isVital.match("Visit Note") !== null) {
										$scope.encounterUuid = value.uuid;
										var encounterUrl =  "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter/" + $scope.encounterUuid;
										$http.get(encounterUrl).then(function(response) {
											angular.forEach(response.data.obs, function(v, k){
												var encounter = v.display;
												if(encounter.match("Additional Comments") !== null) {
												$scope.alerts.push({"msg":v.display.slice(21,v.display.length), "uuid": v.uuid});
												}
											});
										}, function(response) {
											$scope.error = "Get Encounter Obs Went Wrong";
									    	$scope.statuscode = response.status;
									    });				
									}
								});
							}
							else {
								$scope.visitNotePresent = false;
							}
						}, function(error) {
							console.log(error);
						});

	  var promiseAdditionalComments = AdditionalCommentsFactory3.async().then(function(d){
		return d;
	  });

	  promiseAdditionalComments.then(function(x){
		$scope.testlist = x;
	  })

	  $timeout(function () {
	        var promise = AdditionalCommentsFactory1.async().then(function(d){
	                var length = d.length;
	                if(length > 0) {
	                        angular.forEach(d, function(value, key){
	                                $scope.data = value.uuid;
	                        });
	                } else {
	                        $scope.data2 = "Created an Encounter";
	                        AdditionalCommentsFactory2.async().then(function(d2){
	                                $scope.data = d2;
	                        })
	                };
	                return $scope.data;
	        });

	        promise.then(function(x){
	                $scope.data3 = x;

	                $scope.addAlert = function() {
	                        $scope.errortext = "";
	                        if (!$scope.addMe) {
	                                $scope.errortext = "Please enter text.";
	                                return;
	                        }
	    			if ($scope.alerts.indexOf($scope.addMe) == -1){
	    				$scope.alerts.push({msg: $scope.addMe})
	    				var url2 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs";
	    				$scope.json = {
	         				concept: window.constantConfigObj.conceptAdditionalComments,
	         				person: $scope.patient,
	         				obsDatetime: date2,
	         				value: $scope.addMe,
	         				encounter: $scope.encounterUuid
	        			}
	    				$http.post(url2, JSON.stringify($scope.json)).then(function(response){
	        				if(response.data) {
	                				$scope.statuscode = "Success";
	                				angular.forEach($scope.alerts, function(v, k){
											var encounter = v.msg;
											if(encounter.match($scope.addMe) !== null) {
											v.uuid = response.data.uuid;
											}
									});
									$scope.addMe = "";
	                        }
	    				}, function(response){
	                			$scope.statuscode = "Failed to create Obs";
	    				});
	    			}
	  		};

		  		$scope.closeAlert = function(index) {
		  			if ($scope.visitStatus) {
			    		var deleteurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs/" + $scope.alerts[index].uuid + "?purge=true";
						$http.delete(deleteurl).then(function(response){
						$scope.alerts.splice(index, 1);
	 			        		$scope.errortext = "";
							$scope.statuscode = "Success";
						}, function(response){
							$scope.statuscode = "Failed to delete Obs";
						});
					}
		  		};  
	        });
	  }, 2000);

		});

intelehealthAdditionalComments.factory('AdditionalCommentsFactory1', function($http, $filter){
	  var patient = "${ patient.uuid }";
	  var date = new Date();
	  date = $filter('date')(new Date(), 'yyyy-MM-dd');
	  var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
	      url += "?patient=" + patient;
	      url += "&encounterType=" + window.constantConfigObj.encounterTypeVisitNote;
	      url += "&fromdate=" + date;
	  return {
	    async: function(){
	      return $http.get(url).then(function(response){
	        return response.data.results;
	      });
	    }
	  };
	});

	intelehealthAdditionalComments.factory('AdditionalCommentsFactory2', function($http){
	  var patient = "${ patient.uuid }";
	  var url1 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
	  var date2 = new Date();
	  var path = window.location.search;
	  var i = path.indexOf("visitId=");
	  var visitId = path.substr(i + 8, path.length);
	  var json = {
	      patient: patient,
	      encounterType: window.constantConfigObj.encounterTypeVisitNote,
	      encounterDatetime: date2,
	      visit: visitId,
	      obs: []
	  };
	  return {
	    async: function(){
	      return $http.post(url1, JSON.stringify(json)).then(function(response){
	        return response.data.uuid;
	      });
	    }
	  };
	});

	intelehealthAdditionalComments.factory('AdditionalCommentsFactory3', function($http){
	  var commentsurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/concept/" + window.constantConfigObj.conceptAdditionalComments;
	  return {
	    async: function(){
	      return $http.get(commentsurl).then(function(response){
		var data = [];
		angular.forEach(response.data.answers, function(value, key){
		  data.push(value.display);
		});
	        return data;
	      });
	    }
	  };
	});