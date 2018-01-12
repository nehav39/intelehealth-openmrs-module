<%
    config.require("formFieldName")

    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("intelehealth", "diagnoses/diagnoses.js")
    ui.includeJavascript("intelehealth", "diagnoses/diagnoses-angular.js")
    ui.includeCss("coreapps", "diagnoses/encounterDiagnoses.css")
%>


<style>

hr.style1{
	border-top: 1px solid #8c8b8b;
}
div.error{background-color: #d9edf7;
  color: #31708f;padding: 15px;
  margin-bottom: 10px;border: 1px solid transparent;border-radius: 4px;
  margin-top: 0;  color: inherit
}

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

</style>

<% /* This is an underscore template, since I dont know how to use angular templates programmatically */ %>
<script ng-show="visitStatus" type="text/template" id="autocomplete-render-item">
    <span class="code">
        {{ if (item.code) { }}
        {{- item.code }}
        {{ } else if (item.concept) { }}
        ${ui.message("coreapps.consult.codedButNoCode")}
        {{ } else { }}
        ${ui.message("coreapps.consult.nonCoded")}
        {{ } }}
    </span>
    <strong class="matched-name">
        {{- item.matchedName }}
    </strong>
    {{ if (item.preferredName) { }}
    <span class="preferred-name">
        <small>${ui.message("coreapps.consult.synonymFor")}</small>
        {{- item.concept.preferredName }}
    </span>
    {{ } }}
</script>
<div class="info-body" ng-show="visitStatus">
    <script type="text/ng-template" id="selected-diagnosis" ng-show="visitStatus">
        <div class="diagnosis" data-ng-class="{primary: d.primary}">
            <span class="code">
                <span data-ng-show="d.diagnosis.code">{{ d.diagnosis.code }}</span>
                <span data-ng-show="!d.diagnosis.code && d.diagnosis.concept">
                    ${ui.message("coreapps.consult.codedButNoCode")}
                </span>
                <span data-ng-show="!d.diagnosis.code && !d.diagnosis.concept">
                    ${ui.message("coreapps.consult.nonCoded")}
                </span>
            </span>
            <strong class="matched-name">{{ d.diagnosis.matchedName }}</strong>
            <span class="preferred-name" data-ng-show="d.diagnosis.preferredName">
                <small>${ui.message("coreapps.consult.synonymFor")}</small>
                <span>{{ d.diagnosis.concept.preferredName }}</span>
            </span>

            <div class="actions">
                <label>
                    <input type="checkbox" data-ng-model="d.primary" />
                    ${ui.message("coreapps.Diagnosis.Order.PRIMARY")}
                </label>
                <label>
                    <input type="checkbox" data-ng-model="d.confirmed"/>
                    ${ui.message("coreapps.Diagnosis.Certainty.CONFIRMED")}
                </label>
            </div>
        </div>
        <i data-ng-click="removeDiagnosis(d)" tabindex="-1" class="icon-remove delete-item"></i>
    </script>
</div>
<div id="diagnosis" class="long-info-section" ng-controller="DiagnosesController">
        	<div class="info-header">
        		<i class="icon-diagnosis"></i>
        		<h3>Diagnoses</h3>
        	</div>
        	<div class="info-body">
        	    <form ng-show="visitStatus" id="new-order" class="sized-inputs css-form" name="newOrderForm" novalidate>
        		<br/>
        		<input type="text" ng-model="addMe1" autocomplete itemFormatter="autocomplete-render-item"  class="form-control">
        		<button type="button" class='btn btn-default' ng-click="addAlert()">Add Diagnosis</button>
        		<p>{{errortext}}</p>
        		<br/>
          <div ng-show = "addMe1">
            <input type='text' ng-model= "abc" placeholder="Primary/Secondary">
            <input type='text' ng-model= "def" placeholder="Confirmed/Certainty">
          </div>
          </br>
        		<div uib-alert ng-repeat="alert in alerts" ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}</div>
        	</div>
            <div>
                <a href="#" class="right back-to-top">Back to top</a>
            </div>
        </div>

<script>
var app = angular.module('diagnoses', []);
    app.factory('DiagnosisFactory1', function(\$http, \$filter){
      var patient = "${ patient.uuid }";
      var date = new Date();
      date = \$filter('date')(new Date(), 'yyyy-MM-dd');
      var url = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
          url += "?patient=" + patient;
          url += "&encounterType=" + window.constantConfigObj.encounterTypeVisitNote;
      return {
        async: function(){
          return \$http.get(url).then(function(response){
            return response.data.results;
          });
        }
      };
    });
    app.directive('autocomplete', function(\$compile, \$timeout, \$http, DiagnosisFactory1) {
        return function(scope, element, attrs) {
            // I don't know how to use an angular template programmatically, so use an underscore template instead. :-(
            var itemFormatter = _.template(\$('#' + attrs.itemformatter).html());
            element.autocomplete({
                source: emr.fragmentActionLink("coreapps", "diagnoses", "search"),
                response: function(event, ui) {
                    var query = event.target.value.toLowerCase();
                    var items = ui.content;
                    // remove any already-selected concepts, and look for exact matches by name/code
                    var exactMatch = false;
                    for (var i = items.length - 1; i >= 0; --i) {
                        items[i] = diagnoses.CodedOrFreeTextConceptAnswer(items[i]);
                        if (!exactMatch && items[i].exactlyMatchesQuery(query)) {
                            exactMatch = true;
                        }
                        if (scope.encounterDiagnoses.diagnosisWithConceptId(items[i].conceptId)) {
                            items.splice(i, 1);
                        }
                    }
                    if (!exactMatch) {
                        items.push(diagnoses.CodedOrFreeTextConceptAnswer(element.val()))
                    }
                },
                focus: function( event, ui ) {
                    element.val(ui.item.matchedName);
                    return false;
                },
                select: function( event, ui ) {
                    scope.\$apply(function() {
                        scope.encounterDiagnoses.addDiagnosis(scope.addMe1);
                                    });
                                    return false;
                }
            })
            .data( "autocomplete" )._renderItem = function( ul, item ) {
                var formatted = itemFormatter({item: item});
                return jq('<li>').append('<a>' + formatted + '</a>').appendTo(ul);
            };
        }
    });
    app.controller('DiagnosesController', [ '\$scope', '\$http' , '\$timeout', 'DiagnosisFactory1', 'recentVisitFactory',
        function DiagnosesController(\$scope, \$http, \$timeout, DiagnosisFactory1, recentVisitFactory) {

          \$scope.alerts = [];
          \$scope.respuuid = [];
          var _selected;
          var patient = "${ patient.uuid }";
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
        											if(encounter.match("TELEMEDICINE DIAGNOSIS") !== null) {
        											\$scope.alerts.push({"msg":v.display.slice(23,v.display.length), "uuid": v.uuid});

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



            \$timeout(function () {
                \$scope.test1 = 0;
                \$scope.test2 = 0;
                \$scope.diagnosesToPost = [];
                \$scope.encounterDiagnoses = diagnoses.EncounterDiagnoses();
                \$scope.priorDiagnoses = diagnoses.EncounterDiagnoses();
                \$scope.addPriorDiagnoses = function() {
                        \$scope.encounterDiagnoses.addDiagnoses(angular.copy(\$scope.priorDiagnoses.getDiagnoses()));
                }
                \$scope.removeDiagnosis = function(diagnosis) {
                        \$scope.encounterDiagnoses.removeDiagnosis(diagnosis);
                        \$scope.test2 = \$scope.respuuid;
                        \$scope.test3 = {name:diagnosis.diagnosis.matchedName,confirmed:diagnosis.confirmed,primary:diagnosis.primary};
                };
                \$scope.valueToSubmit = function() {
                        return "[" + _.map(\$scope.encounterDiagnoses.diagnoses, function(d) {
                                return d.valueToSubmit();
                        }).join(", ") + "]";
                };
                \$scope.closeAlert = function(index) {
        	  			if (\$scope.visitStatus) {
        		    		var deleteurl = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs/" + \$scope.alerts[index].uuid + "?purge=true";
        					\$http.delete(deleteurl).then(function(response){
        					\$scope.alerts.splice(index, 1);
         			        		\$scope.errortext = "";
        						\$scope.statuscode = "Success";
        					}, function(response){
        						\$scope.statuscode = "Failed to delete Obs";
        					});
        				}
        	  		};
              }, 2000);

      \$timeout(function () {
      	var promise = DiagnosisFactory1.async().then(function(d){
      		var length = d.length;
    		if(length > 0) {
    			angular.forEach(d, function(value, key){
    				\$scope.data = value.uuid;
    			});
    		}
    		return \$scope.data;
      	});

      	promise.then(function(x){
      		\$scope.addAlert = function() {
            		\$scope.errortext = "";
    			var alertText = "";
    			\$scope.myColor = "white";
            		if (!\$scope.addMe1 | !\$scope.abc | !\$scope.def) {
                    		\$scope.errortext = "Please enter text.";
    				if (!\$scope.addMe1){
    					\$scope.myColor = "#FA787E";
    				}
                    		return;
            		} else {
    				alertText = \$scope.addMe1 + ': ' + \$scope.abc + ' ' + \$scope.def;
    			}
            		if (\$scope.alerts.indexOf(\$scope.addMe1) == -1){

                    		\$scope.alerts.push({msg: alertText})
    				var url2 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs";
                            	\$scope.json = {
                            		concept: window.constantConfigObj.conceptDiagnosis,
                                    	person: patient,
                                    	obsDatetime: date2,
                                    	value: alertText,
                                    	encounter: x
                            	}

    				\$scope.abc = "";
    				\$scope.def = "";
                            	\$http.post(url2, JSON.stringify(\$scope.json)).then(function(response){
                            		if(response.data) {
                                  console.log( x, "Success" );
                                    		\$scope.statuscode = "Success";
                                            	angular.forEach(\$scope.alerts, function(v, k){
     											var encounter = v.msg;
     											if(encounter.match(\$scope.addMe1) !== null) {
     											v.uuid = response.data.uuid;
     											}
     										});
     										\$scope.addMe1 = "";
                                     }
                            	}, function(response){
                            		\$scope.statuscode = "Failed to create Obs";
                                console.log( x, "failure" );
                            	});
            		}
      		};

      		\$scope.closeAlert = function(index) {
      			if (\$scope.visitStatus) {
    				\$scope.myColor = "white";
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
      }, 2000);

    }
  ]);

</script>
