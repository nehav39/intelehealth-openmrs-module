<%
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
%>

<div id="vitals" class="long-info-section"  ng-app="vitalsSummary" ng-controller="VitalsSummaryController">
	<div class="info-header">
		<i class="icon-vitals"></i>
		<h3>Vitals</h3>
	</div>
	<div class="info-body">
        <table>
                <tr ng-repeat="item in vitals | orderBy:'-date'">
                        <td width="100px" style="border: none">{{item.date | dateFormat}}</td>
                        <td style="border:none">
	                    Temp: {{(item.temperature * 9/5) + 32 | round}} F
                        </td>
                        <td style="border:none">
                            Height: {{item.height}} cm
                        </td>
                        <td style="border:none">
                            Weight: {{item.weight}} kg
                        </td>
                        <td style="border:none">
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
var app = angular.module('vitalsSummary', []);

app.filter('dateFormat', function() {
    return function(x) {
        var txt = '';
        txt = x.slice(7,x.length);
        return txt;
    };
});

app.filter('round', function(){
	return function(x){
  		return x.toFixed(1);
	};
});

app.controller('VitalsSummaryController', function(\$scope, \$http) {
    var patient = "${ patient.uuid }";
    var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
        url += "?patient=" + patient;
        url += "&encounterType=" + "67a71486-1a54-468f-ac3e-7091a9a79584";
    \$http.get(url)
    	  .then(function(response) {
        	\$scope.vitalEncounters = response.data.results;
		\$scope.vitalEncountersUrl = [];
		\$scope.url2 = [];
		angular.forEach(\$scope.vitalEncounters, function(value, key){
			\$scope.vitalEncountersUrl.push(value.uuid);
		});
		angular.forEach(\$scope.vitalEncountersUrl, function(value, key){
        		var url2 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter/";
	        	    url2 += value;
                	\$scope.url2.push(url2);
		});
                var objects = [];
		\$scope.vitals = [];
		\$scope.obs = \$scope.url2.length;
		angular.forEach(\$scope.url2, function(item){
			\$http.get(item)
			      .then(function(response) {
		  		   objects.push(response.data);
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
                                        if(value.display.includes('OXYGEN')){
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
			      \$scope.vitals.push(answers);
			      }, function(response) {
	       			   \$scope.error = "Get Encounter Observations Went Wrong";
	       		           \$scope.statuscode = response.status;
			      });
		});
          }, function(response) {
		\$scope.error = "Get Visit Encounters Went Wrong";
        	\$scope.statuscode = response.status;
    	});
});
</script>
<script>
    angular.bootstrap("#vitals", ['vitalsSummary']);
</script>  
