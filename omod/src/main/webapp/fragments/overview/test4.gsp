<%
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeJavascript("intelehealth", "angular-bootstrap/ui-bootstrap-tpls.js")
%>

<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/angular_material/1.0.0/angular-material.min.css">
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-animate.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-aria.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-messages.min.js"></script>

<!-- Angular Material Library -->
<script src="http://ajax.googleapis.com/ajax/libs/angular_material/1.0.4/angular-material.min.js"></script>

<div ng-app="myApp" ng-controller="myCtrl"> 

<p>Country to Select:</p>
<md-content>
<md-autocomplete
          ng-disabled="isDisabled"
          md-no-cache="noCache"
          md-selected-item="selectedItem"
          md-search-text="searchText"
          md-items="item in searchTextChange(searchText)"
          md-item-text="item.country"
          md-min-length="0"
          placeholder="Which is your favorite Country?">
        <md-item-template>
          <span md-highlight-text="searchText" md-highlight-flags="^i">{{item.country}}</span>
        </md-item-template>
        <md-not-found>
          No Person matching "{{searchText}}" were found.
        </md-not-found>
      </md-autocomplete>
      </md-content>
      <br/>
</div>

<script>
    var app = angular.module('myApp', ['ngMaterial']);

    app.controller('myCtrl', function (\$scope, \$http, \$q, GetCountryService) {

        \$scope.searchText = "";
        \$scope.Person = [];
        \$scope.selectedItem = [];
        \$scope.isDisabled = false;
        \$scope.noCache = false;

        \$scope.selectedItemChange = function (item) {
            //alert("Item Changed");
        }
        \$scope.searchTextChange = function (str) {
			return GetCountryService.getCountry(str);
        }

    });
	
	app.factory('GetCountryService', function (\$http, \$q) {
        return {
            getCountry: function(str) {
                // the \$http API is based on the deferred/promise APIs exposed by the \$q service
                // so it returns a promise for us by default
				var url = "https://www.bbminfo.com/sample.php?token="+str;
                return \$http.get(url)
                    .then(function(response) {
                        if (typeof response.data.records === 'object') {
                            return response.data.records;
                        } else {
                            // invalid response
                            return \$q.reject(response.data.records);
                        }

                    }, function(response) {
                        // something went wrong
                        return \$q.reject(response.data.records);
                    });
            }
        };
    });
</script>




<script>
    angular.bootstrap("#test4", ['myApp']);
</script>  
