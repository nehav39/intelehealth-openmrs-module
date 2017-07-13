<div id="complaint" class="long-info-section" ng-controller="ComplaintSummaryController">
	<br/>
	<div class="info-header">
		<i class="icon-comment"></i>
		<h3>Presenting Complaints</h3>
	</div>
	<div class="info-body">
	<table>
		<tr ng-repeat="item in objects | orderBy:'-encounterDatetime'">
			<td width="100px" style="border: none">{{item.display | dateFormat}}</td>
	                <td style="border:none" ng-repeat="ob in item.obs | filter : 'CURRENT COMPLAINT' | orderBy:'-display'">
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
var app = angular.module('complaintSummary', []);

app.filter('dateFormat', function() {
 return function(text) {
		text = text || "";
		var str = text;
        str = str.substr(13,str.length);
        var date = str.substr(3,2);
		date = date + "/" + str.substr(0,3) + str.substr(7,4);
		var newDate =new Date(date);
        return newDate;
    };
});

app.filter('valueFormat', function() {
return function(text) {
		text = text || "";
		var str = text;
        var text = '';
        text = text.substr(19,text.length);
        return text;
    };
});

app.controller('ComplaintSummaryController', function(\$scope, \$http) {
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
