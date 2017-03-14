<%
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeJavascript("intelehealth", "angular-bootstrap/ui-bootstrap-tpls.js")
%>

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

</style>

<div id="test3" class="long-info-section"  ng-app="test3Summary" ng-controller="Test3SummaryController">
	<div class="info-header">
		<i class="icon-comments"></i>
		<h3>Medical Advice</h3>
	</div>
	<div class="info-body">
	{{results}}
	<br/>
        <input type="text" ng-model="foo" auto-complete/>
                  Foo = {{foo}}
	</div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
    <br/>
</div>

<script>
var app = angular.module('test3Summary', []);
app.controller('Test3SummaryController',['\$scope', '\$http', function(\$scope, \$http) {
        var testurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/concept/0308000d-77a2-46e0-a6fa-a8c1dcbc3141";
        \$http.get(testurl).then(function(response){
		var test = [];
		angular.forEach(response.data.answers, function(item){
			test.push(item.display)
		});
		\$scope.results = test;
        });
}]);

app.factory('autoCompleteDataService', ['\$http', function(\$http) {
	var testurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/concept/0308000d-77a2-46e0-a6fa-a8c1dcbc3141";
	\$http.get(testurl).then(function(response){
                var test = [];
                angular.forEach(response.data.answers, function(item){
                        test.push(item.display)
                });
return {
    getSource: function() {
        return hello;
    }
}

	});
}]);

app.directive('autoComplete', function(autoCompleteDataService) {
return {
    restrict: 'A',
    link: function(scope, elem, attr, ctrl) {
                // elem is a jquery lite object if jquery is not present,
                // but with jquery and jquery ui, it will be a full jquery object.
        debugger
        elem.autocomplete({
            source: autoCompleteDataService.getSource(), //from your service
            minLength: 1
        });
    }
};
});

</script>

<script>
    angular.bootstrap("#test3", ['test3Summary']);
</script>  
