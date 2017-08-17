<style>

.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    border: 0
}

.alert {
    padding: 15px;
    margin-bottom: 10px;
    border: 1px solid transparent;
    border-radius: 4px
}
.alert h4 {
    margin-top: 0;
    color: inherit
}
.alert .alert-link {
    font-weight: 700
}
.alert-info {
    color: #31708f;
    background-color: #d9edf7;
    border-color: #bce8f1
}
.alert-info hr {
    border-top-color: #a6e1ec
}
.alert-info .alert-link {
    color: #245269
}
.close {
    float: right;
    font-size: 21px;
    font-weight: 700;
    line-height: 1;
    color: #000;
    text-shadow: 0 1px 0 #fff;
    filter: alpha(opacity=20);
    opacity: .2
}
.close:focus,
.close:hover {
    color: #000;
    text-decoration: none;
    cursor: pointer;
    filter: alpha(opacity=50);
    opacity: .5
}
button.close {
    -webkit-appearance: none;
    padding: 0;
    cursor: pointer;
    background: 0 0;
    border: 0
}

form.css-form input.ng-invalid.ng-touched {
  background-color: #FA787E;
}
form.css-form input.ng-invalid.ng-touched:focus {
  background-color: white;
}
form.css-form input[type="number"] {
  width: 55px;
}

form#new-order {
  background-color: white;
  padding-left: 10px;
  padding-right: 10px;
}
form#new-order .dosing-type span {
  margin-right: 15px;
}
form#new-order .dosing-type a {
  font-size: 0.9em;
  display: inline-block;
  padding-right: 15px;
}
form#new-order .dosing-type a.active {
  font-family: "OpenSansBold";
  font-weight: normal;
}
form#new-order label.disabled {
  color: #bbbbbb;
}

.css-form .ng-dirty.ng-invalid {
  background-color: #ff6666;
}
.css-form .ng-dirty.ng-invalid:focus {
  background-color: white;
}

form.sized-inputs input {
  min-width: 0%;
  display: inline;
}
form.sized-inputs label {
  display: inline;
}
form.sized-inputs label.heading {
  display: block;
}

</style>

<div id="meds" class="long-info-section" ng-controller="MedsSummaryController">
	<div class="info-header">
		<i class="icon-comments"></i>
		<h3>Prescribed Medication</h3>
	</div>
	<div class="info-body">
	    <form ng-show="visitStatus" id="new-order" class="sized-inputs css-form" name="newOrderForm" novalidate>
		<br/>
		<input type="text" ng-model="addMe" uib-typeahead="test for test in medslist | filter:\$viewValue | limitTo:8" class="form-control">
		<button type="button" class='btn btn-default' ng-click="addAlert()">Add Medication</button>
		<p>{{errortext}}</p>
		<br/>
		<div id="new-order" ng-show="addMe">
			<input ng-model="dose" type="number" placeholder="Dose" min="0">
			<input type="text" ng-model="doseUnits" uib-typeahead="test for test in doseunitlist | filter:\$viewValue" placeholder="Units" class="form-control">
			<input type="text" ng-model="frequency" uib-typeahead="test for test in frequencylist | filter:\$viewValue" placeholder="Frequency" class="form-control">
			<input type="text" ng-model="route" uib-typeahead="test for test in routelist | filter:\$viewValue" placeholder="Route (optional)" class="form-control">
			<br/>
			As needed for
			<input ng-model="asNeededCondition" type="text" size="30" placeholder="reason (optional)"/>
			<br/>
			For
			<input ng-model="duration" type="number" min="0" placeholder="Duration">
			<input type="text" ng-model="durationUnits" uib-typeahead="test for test in durationlist | filter:\$viewValue" placeholder="Units" class="form-control">
			total
			<br/>
			<textarea ng-model="dosingInstructions" rows="2" cols="60" placeholder="Additional instruction not covered above"></textarea>
			<br/>
		</div>
	    </form>
		<br/>
		<br/>
		<div uib-alert ng-repeat="alert in alerts" ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}</div>
	</div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>

<script>
var app = angular.module('medsSummary', ['ngAnimate', 'ngSanitize', 'recentVisit']);

app.factory('CurrentEncountersFactory1', function(\$http, \$filter){
  var patient = "${ patient.uuid }";
  var date = new Date();
  date = \$filter('date')(new Date(), 'yyyy-MM-dd');
  var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
      url += "?patient=" + patient;
      url += "&encounterType=" + window.constantConfigObj.encounterTypeVisitNote;
      url += "&fromdate=" + date;
  return {
    async: function(){
      return \$http.get(url).then(function(response){
        return response.data.results;
      });
    }
  };
});

app.factory('NewEncounterFactory2', function(\$http){
  var patient = "${ patient.uuid }";
  var url1 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
  var date2 = new Date();
  var json = {
      patient: patient,
      encounterType: window.constantConfigObj.encounterTypeVisitNote,
      encounterDatetime: date2
  };
  return {
    async: function(){
      return \$http.post(url1, JSON.stringify(json)).then(function(response){
        return response.data.uuid;
      });
    }
  };
});

app.factory('MedsListFactory3', function(\$http){
  return {
    async: function(uuid){
      var testurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/concept/" + uuid;
      return \$http.get(testurl).then(function(response){
        var data = [];
        angular.forEach(response.data.answers, function(value, key){
          data.push(value.display);
        });
        return data;
      });
    }
  };
});

app.factory('MedsListFactory4', function(\$http){
  return {
    async: function(uuid){
      var testurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/concept/" + uuid;
      return \$http.get(testurl).then(function(response){
        var data = [];
        angular.forEach(response.data.setMembers, function(value, key){
          data.push(value.display);
        });
        return data;
      });
    }
  };
});

app.controller('MedsSummaryController', function(\$scope, \$http, \$timeout, CurrentEncountersFactory1, NewEncounterFactory2, MedsListFactory3, MedsListFactory4, recentVisitFactory) {
\$scope.alerts = [];
\$scope.respuuid = [];
var _selected;
var patient = "${ patient.uuid }";
var date2 = new Date();

var path = window.location.search;
var i = path.indexOf("visitId=");
var visitId = path.substr(i + 8, path.length);
\$scope.visitEncounters = [];
\$scope.visitObs = [];
\$scope.visitNoteData = [];
\$scope.visitNotePresent = true;
\$scope.visitStatus = false;
\$scope.encounterUuid = "";
recentVisitFactory.fetchVisitEncounterObs(visitId).then(function(data) {
						\$scope.visitDetails = data.data;
							if (\$scope.visitDetails.stopDatetime == null || \$scope.visitDetails.stopDatetime == undefined) {
								\$scope.visitStatus = true;
							}
							else {
								\$scope.visitStatus = false;
							}
						\$scope.visitEncounters = data.data.encounters; 
						if(\$scope.visitEncounters.length !== 0) {
						\$scope.visitNotePresent = true;
							angular.forEach(\$scope.visitEncounters, function(value, key){
								var isVital = value.display;
								if(isVital.match("Visit Note") !== null) {
									\$scope.encounterUuid = value.uuid;
									var encounterUrl =  "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter/" + \$scope.encounterUuid;
									\$http.get(encounterUrl).then(function(response) {
										angular.forEach(response.data.obs, function(v, k){
											var encounter = v.display;
											if(encounter.match("MEDICATIONS") !== null) {
											\$scope.alerts.push({"msg":v.display.slice(16,v.display.length), "uuid":v.uuid});
											}
										});
									}, function(response) {
										\$scope.error = "Get Encounter Obs Went Wrong";
								    	\$scope.statuscode = response.status;
								    });				
								}
							});
						}
						else {
							\$scope.visitNotePresent = false;
						}
						}, function(error) {
						console.log(error);
					});

  var promiseMeds = MedsListFactory3.async(window.constantConfigObj.conceptPrescription).then(function(d){
        return d;
  });

  promiseMeds.then(function(x){
        \$scope.medslist = x;
  })

  var promiseDoses = MedsListFactory4.async(window.constantConfigObj.conceptDoseUnit).then(function(d){
        return d;
  });

  promiseDoses.then(function(x){
        \$scope.doseunitlist = x;
  })

  var promiseFrequencies = MedsListFactory3.async(window.constantConfigObj.conceptFrequency).then(function(d){
        return d;
  });

  promiseFrequencies.then(function(x){
        \$scope.frequencylist = x;
  })

  var promiseRoutes = MedsListFactory4.async(window.constantConfigObj.conceptRoutesOfAdministration).then(function(d){
        return d;
  });
        
  promiseRoutes.then(function(x){
        \$scope.routelist = x;
  }) 

  var promiseDurations = MedsListFactory3.async(window.constantConfigObj.conceptDurationUnit).then(function(d){
        return d;
  });

  promiseDurations.then(function(x){
        \$scope.durationlist = x;
  })

  \$timeout(function () {
  	var promise = CurrentEncountersFactory1.async().then(function(d){
  		var length = d.length;
		if(length > 0) {
			angular.forEach(d, function(value, key){
				\$scope.data = value.uuid;
			});
		} else {
			\$scope.data2 = "Created an Encounter";
			NewEncounterFactory2.async().then(function(d2){
				\$scope.data = d2;
			})
		};
		return \$scope.data;
  	});

  	promise.then(function(x){
  		\$scope.addAlert = function() {
        		\$scope.errortext = "";
			var alertText = "";
			\$scope.myColor = "white";
        		if (!\$scope.addMe | !\$scope.dose | !\$scope.doseUnits | !\$scope.frequency | !\$scope.duration | \$scope.durationUnits) {
                		\$scope.errortext = "Please enter text.";
				if (!\$scope.addMe){
					\$scope.myColor = "#FA787E";
				}
                		return;
        		} else {
				alertText = \$scope.addMe + ': ' + \$scope.dose.toString() + ' ' + \$scope.doseUnits.toLowerCase();
				if (\$scope.route) {
					alertText += ' (' + \$scope.route + ')';
				} 
				alertText += ', ' + \$scope.frequency.toLowerCase();
				if (\$scope.asNeededCondition) {
                                        alertText += ' as needed for ' + \$scope.asNeededCondition;
                                }
				alertText += ' for ' + \$scope.duration.toString() + ' ' + \$scope.durationUnits.toLowerCase() + ' total.  ';
				if (\$scope.dosingInstructions) {
                                        alertText += \$scope.dosingInstructions;
                                }
			}
        		if (\$scope.alerts.indexOf(\$scope.addMe) == -1){
				
                		\$scope.alerts.push({msg: alertText})
				var url2 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs";
                        	\$scope.json = {
                        		concept: window.constantConfigObj.conceptMedication,
                                	person: patient,
                                	obsDatetime: date2,
                                	value: alertText,
                                	encounter: \$scope.encounterUuid
                        	}
                        	
				\$scope.dose = "";
				\$scope.doseUnits = "";
				\$scope.route = "";
				\$scope.frequency = "";
				\$scope.asNeededCondition = "";
				\$scope.dosingInstructions = "";
				\$scope.duration = "";
				\$scope.durationUnits = "";
                        	\$http.post(url2, JSON.stringify(\$scope.json)).then(function(response){
                        		if(response.data) {
                                		\$scope.statuscode = "Success";
                                        	angular.forEach(\$scope.alerts, function(v, k){
 											var encounter = v.msg;
 											if(encounter.match(\$scope.addMe) !== null) {
 											v.uuid = response.data.uuid;
 											}
 										});
 										\$scope.addMe = "";
                                 }
                        	}, function(response){
                        		\$scope.statuscode = "Failed to create Obs";
                        	});
        		}
  		};

  		\$scope.closeAlert = function(index) {
  			if (\$scope.visitStatus) {
				\$scope.myColor = "white";
				\$scope.deleteurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs/" + \$scope.alerts[index].uuid + "?purge=true";
                \$http.delete(\$scope.deleteurl).then(function(response){
                \$scope.alerts.splice(index, 1);
        		\$scope.errortext = "";
                	\$scope.statuscode = "Success";
                }, function(response){
                	\$scope.statuscode = "Failed to delete Obs";
                });
			}
  		};
  	});
  }, 2000);


});
</script>

<script>
</script>  
