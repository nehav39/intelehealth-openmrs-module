<div id="patientInfo" class="long-info-section" ng-controller="patientInfoController">
	<div class="info-header">
		<i class="icon-book"></i>
		<h3>Patient Information</h3>
	</div>
	<div class="info-body">
	<table ng-cloak>
									<td style="border:none">
											Prison Name: {{var2}}
									</td>
									<td style="border:none">
											Department: {{var4}}
									</td>
									<td style="border:none">
											Commune: {{var5}}
									</td>
									<td style="border:none">
											Cell Number: {{var1}}
									</td>
									<td style="border:none">
											Patient Status: {{var3}}
									</td>
</tr>
	</table>
	</div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>
<script>
var app = angular.module('patientInfo', ['ngAnimate', 'ngSanitize']);
app.controller('patientInfoController', function(\$scope, \$http) {
	  var patient = "${ patient.uuid }";
	  var testurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/person/" + patient;
	 \$http.get(testurl).then(function(response){
			angular.forEach(response.data.attributes, function(v, k){
				var encounter = v.display;
				if(encounter.match("Cell Number") !== null) {
				\$scope.var1 = v.display.slice(13,v.display.length);
				}
				else if(encounter.match("Prison Name") !== null) {
				\$scope.var2 = v.display.slice(13,v.display.length);
				}
				else if(encounter.match("Patient Status") !== null) {
				\$scope.var3 = v.display.slice(16,v.display.length);
				}
				else if(encounter.match("Department") !== null) {
				\$scope.var4 = v.display.slice(12,v.display.length);
				}
				else if(encounter.match("Commune") !== null) {
				\$scope.var5 = v.display.slice(9,v.display.length);
				}
			});
	 });
});

</script>
