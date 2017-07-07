<%
    ui.includeJavascript("intelehealth", "jquery/jquery.js")
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
%>

<div id="exam" class="long-info-section" ng-controller="ExamSummaryController">
	<br/>
	<div class="info-header">
		<i class="icon-stethoscope"></i>
		<h3>On Examination</h3>
	</div>
	<div class="info-body">
	<table>
		<tr ng-repeat="item in objects | orderBy:'-encounterDatetime'">
			<td width="100px" style="border: none">{{item.display | dateFormat}}</td>
	                <td style="border:none" ng-repeat="ob in item.obs | filter : 'PHYSICAL EXAMINATION' | orderBy:'-display'">
                	    {{ob.display | valueFormat}}
                	</td>
		</tr>
	</table>
	</div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>

<script>
var app = angular.module('examSummary', []);

app.filter('dateFormat', function() {
    return function(x) {
        var txt = '';
        txt = x.slice(13,x.length);
        return txt;
    };
});
app.filter('valueFormat', function() {
    return function(x) {
        var txt = '';
        txt = x.slice(22,x.length);
        return txt;
    };
});

app.controller('ExamSummaryController', function(\$scope, \$http) {
    var patient = "${ patient.uuid }";
    var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
        url += "?patient=" + patient;
        url += "&encounterType=" + "8d5b27bc-c2cc-11de-8d13-0010c6dffd0f";
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
		\$scope.obs = \$scope.url2.length;
		angular.forEach(\$scope.url2, function(item){
			\$http.get(item)
			      .then(function(response) {
		  		   objects.push(response.data);
			      }, function(response) {
	       			   \$scope.error = "Get Encounter Observations Went Wrong";
	       		           \$scope.statuscode = response.status;
			      });
		});
		\$scope.objects = objects;
          }, function(response) {
		\$scope.error = "Get Visit Encounters Went Wrong";
        	\$scope.statuscode = response.status;
    	});
});
</script>
<script>
</script>  
