<div id="vitals" class="long-info-section" ng-controller="vitalsSummaryController">
	<div class="info-header">
		<i class="icon-vitals"></i>
		<h3>Vitals</h3>
	</div>
	<div class="info-body" ng-cloak>
        <table>
                <tr ng-if="!vitalsPresent"><td>No Data</td></tr>
                <tr ng-if="vitalsPresent" ng-repeat="item in vitalsData | orderBy:'-date'">
                        <td width="100px" style="border: none">{{item.date | vitalsDate | date: 'dd.MMM.yyyy'}}</td>
                        <td style="border:none">
	                    <span ng-if="!item.temperature.includes('-')">Temp: {{(item.temperature * 9/5) + 32 | round}} F</span>
	                    <span ng-if="item.temperature.includes('-')">Temp: {{item.temperature}} </span>
                        </td>
                        <td style="border:none">
                            Height: {{item.height}} cm
                        </td>
                        <td style="border:none">
                            Weight: {{item.weight}} kg
                        </td>
                        <td style="border:none"  ng-if="item.weight.includes('-') || item.height.includes('-')">
                            BMI: N.A.
                        </td>
												<td style="border:none" ng-if="!item.weight.includes('-') || !item.height.includes('-')">
														BMI: {{item.weight/((item.height/100)*(item.height/100)) | round}}
												</td>
                        <td style="border:none">
                            Sp02: {{item.o2sat}}%
                        </td>
                        <td style="border:none">
                            BP: {{item.systolicBP}} / {{item.diastolicBP}}
                        </td>
                        <td style="border:none">
                            HR: {{item.pulse}}
                        </td>
		 </tr>
        </table>
	</div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>

<script>
var app = angular.module('vitalsSummary', ['recentVisit']);

app.filter('vitalsDate', function() {
   return function(text) {
		text = text || "";
		var str = text;
        str = str.substr(7,str.length);
        var date = str.substr(3,2);
		date = date + "/" + str.substr(0,3) + str.substr(7,4);
		var newDate =new Date(date);
        return newDate;
    };
});

app.filter('round', function(){
	return function(x){
  		return x.toFixed(1);
	};
});

app.controller('vitalsSummaryController', function(\$scope, \$http, \$location, recentVisitFactory) {
var path = window.location.search;
var i = path.indexOf("visitId=");
var visitId = path.substr(i + 8, path.length);
\$scope.visitEncounters = [];
\$scope.visitObs = [];
\$scope.vitalsData = [];
\$scope.vitalsPresent = true;
recentVisitFactory.fetchVisitDetails(visitId).then(function(data) {
						\$scope.visitDetails = data.data;
						\$scope.visitEncounters = data.data.encounters;
						if(\$scope.visitEncounters.length !== 0) {
						\$scope.vitalsPresent = true;
						angular.forEach(\$scope.visitEncounters, function(value, key){
							var isVital = value.display;
							if(isVital.match("Vitals") !== null) {
								var encounterUuid = value.uuid;
								var encounterUrl =  "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter/" + encounterUuid;
								\$http.get(encounterUrl).then(function(response) {
								\$scope.visitObs.push(response.data.obs);
								 var answers = {date:response.data.display, temperature:'-', height:'-', weight:'-', o2sat:'-', systolicBP:'-', diastolicBP: '-', pulse: '-'};
								   angular.forEach(response.data.obs, function(value, key){
									if(value.display.includes('TEMP')){
										answers.temperature = Number(value.display.slice(17,value.display.length));
									}
				                                        if(value.display.includes('Height')){
				                                                answers.height = Number(value.display.slice(13,value.display.length));
				                                        }
				                                        if(value.display.includes('Weight')){
				                                                answers.weight = Number(value.display.slice(13,value.display.length));
				                                        }
				                                        if(value.display.includes('BLOOD OXYGEN')){
				                                                answers.o2sat = Number(value.display.slice(25,value.display.length));
				                                        }
				                                        if(value.display.includes('SYSTOLIC')){
				                                                answers.systolicBP = Number(value.display.slice(25,value.display.length));
				                                        }
				                                        if(value.display.includes('DIASTOLIC')){
				                                                answers.diastolicBP = Number(value.display.slice(26,value.display.length));
				                                        }
				                                        if(value.display.includes('Pulse')){
				                                                answers.pulse = Number(value.display.slice(7,value.display.length));
				                                        }
								   })
							      \$scope.vitalsData.push(answers);
										}, function(response) {
											\$scope.error = "Get Encounter Obs Went Wrong";
							        		\$scope.statuscode = response.status;
							    	});
								}
							});
					}
					else {
					\$scope.vitalsPresent = false;
					}

					}, function(error) {
						console.log(error);
					});
});
</script>
<script>

</script>
