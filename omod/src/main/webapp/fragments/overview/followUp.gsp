<div ng-controller="Ctrl">
<div class="info-header">
		<i class="icon-book"></i>
		<h3>Follow Up</h3>
	</div>
	<div class="info-body">
		<br/>
		<div >
		    <div class="input-append">
					From
		        <input style = 'margin-left : 10px;  ' type="text" b-datepicker ng-model="from" />
		        <button type="button" class="btn" data-toggle="datepicker"> <i class="icon-calendar"></i>
		        </button>
		    </div>
				<div class="input-append">
					To
		        <input style = 'margin-left : 30px; margin-top : 10px;' type="text" b-datepicker ng-model="to" />
		        <button type="button" class="btn" data-toggle="datepicker"> <i class="icon-calendar"></i>
		        </button>
		    </div>
				<br/>
				<button type="button" style = 'margin-left : 0px;' ng-click = 'addtype()' ng-disabled = "isDiasbled" style=" margin-left: 30px;" ng-show = "alerts.length == 0">Schedule a Follow Up</button>
				<div uib-alert ng-repeat="alert in alerts" ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}</div>
		</div>
		</div>
		<div>
		<p>*please delete current schedule to schedule a new follow up.</p>
	</div>
	<div>
			<a href="#" class="right back-to-top">Back to top</a>
	</div>
</div>
<script>
var myApp = angular.module('FollowUp', ['recentVisit']);

app.factory('FollowUpFactory1', function(\$http, \$filter){
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
	app.factory('FollowUpFactory2', function(\$http){
	  var patient = "${ patient.uuid }";
	  var url1 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
	  var date2 = new Date();
	  var json = {
	      patient: patient,
	      encounterType: "window.constantConfigObj.encounterTypeVisitNote",
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

myApp.controller('Ctrl', function(\$scope, \$http, \$timeout, FollowUpFactory1, FollowUpFactory2, recentVisitFactory){
		var patient = "${patient.uuid}";
		\$scope.alerts = [];
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
		\$scope.isDiasbled = false;
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
								if(encounter.match("Follow Up Visit") !== null) {
									\$scope.alerts.push({"msg":v.display.slice(16,v.display.length), "uuid": v.uuid});
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

	\$timeout(function(){
		var promise = FollowUpFactory1.async().then(function(d){
			var length = d.length;
		if(length > 0) {
			angular.forEach(d, function(value, key){
				\$scope.data = value.uuid;
			});
		} else {
			\$scope.data2 = "Created an Encounter";
			FollowUpFactory2.async().then(function(d2){
				\$scope.data = d2;
			})
		};
		return \$scope.data;
		});
		promise.then(function(x){
			\$scope.addtype = function(){
				\$scope.isDiasbled = true;
				if(\$scope.to != '' | \$scope.from != ''){
				if (\$scope.alerts.indexOf(\$scope.treatment) == -1){
debugger;
					\$scope.treatment = \$scope.to + ' to ' +  \$scope.from;
								\$scope.alerts.push({msg: \$scope.treatment})
								  var url2 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs";
											\$scope.json = {
															concept: '79968663-20d8-4083-8aba-7ddffec1f25f',
															person: patient,
															obsDatetime: date2,
															value: \$scope.treatment,
															encounter: \$scope.encounterUuid
											}
											\$http.post(url2, JSON.stringify(\$scope.json)).then(function(response){
												if(response.data){
																\$scope.statuscode = "Success";
																angular.forEach(\$scope.alerts, function(v, k){
									var encounter = v.msg;
									if(encounter.match(\$scope.treatment) !== null) {
									v.uuid = response.data.uuid;
									}
								});
								\$scope.treatment = "";
														}
											}, function(response){
												\$scope.statuscode = "Failed to create Obs";
											});
				}
			};
}
			\$scope.closeAlert = function(index) {
	  		if (\$scope.visitStatus) {
					\$scope.isDiasbled = false;
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
	},2000);
});

myApp.directive('bDatepicker', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attr) {
            el.datepicker({});
            var component = el.siblings('[data-toggle="datepicker"]');
            if (component.length) {
                component.on('click', function () {
                    el.trigger('focus');
                });
            }
        }
    };
});
</script>
