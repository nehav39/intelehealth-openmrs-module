<%
    ui.includeJavascript("intelehealth", "jquery/jquery.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeJavascript("intelehealth", "angular-bootstrap/ui-bootstrap-tpls.js")
%>

<div id="images"></div>

<script>
(function() {
  var flickerAPI = "http://api.flickr.com/services/feeds/photos_public.gne?jsoncallback=?";
  \$.getJSON( flickerAPI, {
    tags: "grand canyon",
    tagmode: "any",
    format: "json"
  })
    .done(function( data ) {
      \$.each( data.items, function( i, item ) {
        \$( "<img>" ).attr( "src", item.media.m ).appendTo( "#images" );
        if ( i === 3 ) {
          return false;
        }
      });
    });
})();

</script>

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
    margin-bottom: 20px;
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
.alert>p,
.alert>ul {
    margin-bottom: 0
}
.alert>p+p {
    margin-top: 5px
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

<div id="test" ng-app="ui.bootstrap.demo">

<script type="text/ng-template" id="customPopupTemplate.html">
  <div class="custom-popup-wrapper"
     ng-style="{top: position().top+'px', left: position().left+'px'}"
     style="display: block;"
     ng-show="isOpen() && !moveInProgress"
     aria-hidden="{{!isOpen()}}">
    <p class="message">select location from drop down.</p>

    <ul class="dropdown-menu" role="listbox">
      <li class="uib-typeahead-match" ng-repeat="match in matches track by \$index" ng-class="{active: isActive(\$index) }"
        ng-mouseenter="selectActive(\$index)" ng-click="selectMatch(\$index)" role="option" id="{{::match.id}}">
        <div uib-typeahead-match index="\$index" match="match" query="query" template-url="templateUrl"></div>
      </li>
    </ul>
  </div>
</script>

<div ng-controller="AlertDemoCtrl">
  <script type="text/ng-template" id="alert.html">
    <div ng-transclude></div>
  </script>
    <input type="text" ng-model="addMe" uib-typeahead="test for test in getTest() | filter:\$viewValue | limitTo:8" class="form-control">
  <button type="button" class='btn btn-default' ng-click="addAlert()">Add Alert</button>
  <p>{{errortext}}</p>
  <div uib-alert ng-repeat="alert in alerts" ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}</div>
<div class="container">
        <table>
                <tr ng-repeat="item in getTest()">
                        <td width="100px" style="border: none">{{item}}</td>
                </tr>
        </table>
</div>

</div>

</div>


<script>

angular.module('ui.bootstrap.demo', ['ngAnimate', 'ngSanitize', 'ui.bootstrap']);
angular.module('ui.bootstrap.demo').controller('AlertDemoCtrl', function (\$scope, \$http) {
  \$scope.alerts = [];
  var _selected;

  \$scope.selected = undefined;
  \$scope.getTest = function() {
    return \$http.get('//openmrs.amal.io:8080/openmrs/ws/rest/v1/concept/98c5881f-b214-4597-83d4-509666e9a7c9').then(function(response){
      return response.data.answers.map(function(item){
        return item.display;
      });
    });
  };

  \$scope.addAlert = function() {
    \$scope.errortext = "";
    if (!\$scope.addMe) {
        \$scope.errortext = "Please enter text.";
        return;
    }
    if (\$scope.alerts.indexOf(\$scope.addMe) == -1){
    \$scope.alerts.push({msg: \$scope.addMe})
    \$scope.addMe = "";  
    }
  };

  \$scope.closeAlert = function(index) {
    \$scope.alerts.splice(index, 1);
    \$scope.errortext = "";
  };
});

</script>

<script>
    angular.bootstrap("#test", ['ui.bootstrap.demo']);
</script>
