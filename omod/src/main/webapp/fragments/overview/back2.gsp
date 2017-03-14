<%
    ui.includeJavascript("intelehealth", "jquery/jquery.js")
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular/angular-resource.js")
    ui.includeJavascript("intelehealth", "angular/angular-resource.min.js")
%>

<div id="test2" class="long-info-section"  ng-app="test2Summary" ng-controller="Test2SummaryController">
	{{fromFactory}}
	<br/>
	{{res}}
</div>

<script>
var app = angular.module('test2Summary', ['ngResource']);

app.controller('Test2SummaryController', function(\$scope, \$http, \$location, \$filter, testFactory) {
	\$scope.fromFactory = testFactory.sayHello("World");

        \$scope.res = testFactory.getData();
});

app.factory('testFactory', function(\$http, \$filter){
    return {

        sayHello: function(text){
            return "Factory says \"Hello " + text + "\"";
        },
        sayGoodbye: function(text){
            return "Factory says \"Goodbye " + text + "\"";
        },  
        getData: function(){
            var patient = "${ patient.uuid }";
            var date = new Date();
            var date2 = new Date();
            date = \$filter('date')(new Date(), 'yyyy-MM-dd');
            var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
            url += "?patient=" + patient;
            url += "&encounterType=" + "d7151f82-c1f3-4152-a605-2f9ea7414a79";
            url += "&fromdate=" + date;
	    \$http.get(url)
		  .then(function(response){
			var length = response.data.results.length;
                	if(length > 0) {
                        	angular.forEach(response.data.results, function(value, key){
                                	var encuuid = value.uuid;
					return encuuid;
                        	});
                	} else {
                        	var url1 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
                        	var json = {
                                	patient: patient,
                                	encounterType: "d7151f82-c1f3-4152-a605-2f9ea7414a79",
                                	encounterDatetime: date2
                        	};
                        	\$http.post(url1, JSON.stringify(\$scope.json)).then(function(response){
                                	if(response.data)
                                        	length  = "Success";
                                        	var encuuid = response.data.uuid;
						return length;
                        	}, function(response){
                                	length = "Failed to create Encounter";
					return length;
                        	});
                	};
	    }, function(response){
		  var length = "failure";
		  return length;
	    });
        }
    }               
});

</script>

<script>
    angular.bootstrap("#test2", ['test2Summary']);
</script>  
