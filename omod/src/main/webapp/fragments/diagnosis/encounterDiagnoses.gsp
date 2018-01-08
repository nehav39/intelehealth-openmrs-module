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

<div id="diagnosis">
<div class="info-header">
        <i class="icon-diagnosis"></i>
        <h3>${ ui.message("coreapps.clinicianfacing.diagnoses").toUpperCase() }</h3>
    </div>

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
    <div data-ng-controller="DiagnosesController" >

        <div id="diagnosis-search-container" ng-show="visitStatus">
            <label  for="diagnosis-search">${ ui.message("coreapps.consult.addDiagnosis") }</label>
            <input  id="diagnosis-search" type="text" placeholder="${ ui.message("coreapps.consult.addDiagnosis.placeholder") }" autocomplete itemFormatter="autocomplete-render-item"/>

            <% if(jsForPrior.size > 0) { %>
                <button type="button" ng-show="visitStatus" ng-click="addPriorDiagnoses()">${ ui.message("coreapps.consult.priorDiagnoses.add") }</button>
            <% } %>
        </div>

        <div id="display-encounter-diagnoses-container" ng-show="visitStatus">
            <h3>${ui.message("coreapps.consult.primaryDiagnosis")}</h3>

            <div data-ng-show="encounterDiagnoses.primaryDiagnoses().length == 0">
                ${ui.message("coreapps.consult.primaryDiagnosis.notChosen")}
            </div>
            <ul>
                <li data-ng-repeat="d in encounterDiagnoses.primaryDiagnoses()" >
                    <span data-ng-include="'selected-diagnosis'"></span>
                </li>

            </ul>
            <br/>

            <h3>${ui.message("coreapps.consult.secondaryDiagnoses")}</h3>

            <div data-ng-show="encounterDiagnoses.secondaryDiagnoses().length == 0">
                ${ui.message("coreapps.consult.secondaryDiagnoses.notChosen")}
            </div>
            <ul>
                <li data-ng-repeat="d in encounterDiagnoses.secondaryDiagnoses()">
                    <span data-ng-include="'selected-diagnosis'"></span>
                </li>
            </ul>

        </div>

        <div>
          <input type="text" ng-model = "fetchEncouter">
        </div>

<br ng-show ="recentVisit">
  <div ng-show ="recentVisit" style= "font-size: 17px;">
  Previous Diagnoses:
  </div>
<hr ng-show ="recentVisit" class="style1">
          <div class="errror" > {{test}}
          <p>{{errortext}}</p>
    			<br/>
    			<br/>
            <div class="error"
            uib-alert ng-repeat="alert in alerts"  ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}

        </div>
        <div>
            <a href="#" class="right back-to-top">Back to top</a>
        </div>
    </div>
    <br/>



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
    app.factory('DiagnosisFactory2', function(\$http){
      var patient = "${ patient.uuid }";
      var url1 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
      var date2 = new Date();
      var json = {
          patient: patient,
          encounterType: window.constantConfigObj.encounterTypeVisitNote,
          encounterDatetime: date2
      };
      return {
        async: function(){
          return \$http.post(url1, JSON.stringify(json)).then(function(response){
            return response.data.uuid;
          });
        }
      };
    });
    app.directive('autocomplete', function(\$compile, \$timeout, \$http, DiagnosisFactory1, DiagnosisFactory2) {
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
                        scope.encounterDiagnoses.addDiagnosis(diagnoses.Diagnosis(ui.item));
                        var topost = diagnoses.Diagnosis(ui.item);
                        \$timeout(function () {
                                var promise = DiagnosisFactory1.async().then(function(d){
                                        var length = d.length;
                                        if(length > 0) {
                                                angular.forEach(d, function(value, key){
                                                        scope.data = value.uuid;
                                                });
                                        } else {
                                                scope.data2 = "Created an Encounter";
                                                DiagnosisFactory2.async().then(function(d2){
                                                        scope.data = d2;
                                                })
                                        };
                                        return scope.data;
                                });
				scope.test1 = topost;
                                scope.patient = "${ patient.uuid }";
				var order = [];
				var confirmed = [];

                                scope.diagnosesToPost = {name:topost.diagnosis.matchedName,confirmed:topost.confirmed,primary:topost.primary};
				promise.then(function(x){
					var date2 = new Date();
                			scope.respuuid = [];
					var url2 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/obs";
                                	scope.json = {
                                        	concept: window.constantConfigObj.conceptDiagnosis,
                                        	person: patient,
                                        	obsDatetime: date2,
                                        	value: topost.diagnosis.matchedName,
                                        	encounter: x
                                	}
                                	\$http.post(url2, JSON.stringify(scope.json)).then(function(response){
                                        	if(response.data)
                                                	scope.statuscode = "Success";
                                                	scope.respuuid.push(response.data.uuid);
                                		}, function(response){
                                        		scope.statuscode = "Failed to create Obs";
                                	});
				});
                        }, 2000);
                        element.val('');
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
    app.controller('DiagnosesController', [ '\$scope', '\$http' , '\$timeout', 'DiagnosisFactory1', 'DiagnosisFactory2', 'recentVisitFactory',
        function DiagnosesController(\$scope, \$http, \$timeout, DiagnosisFactory1, DiagnosisFactory2, recentVisitFactory) {

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

        }
    ]);

    // manually bootstrap, in case there are multiple angular apps on a page

    // add any existing diagnoses
    setTimeout(function(){
    angular.element('#diagnosis').scope().\$apply(function() {
        var encounterDiagnoses = angular.element('#diagnosis > .ng-scope').scope().encounterDiagnoses;
        <% jsForExisting.each { %>
            encounterDiagnoses.addDiagnosis(diagnoses.Diagnosis(${ it }));
        <% } %>
    });

    // add any prior diagnoses
    angular.element('#diagnosis').scope().\$apply(function() {
        var priorDiagnoses = angular.element('#diagnosis > .ng-scope').scope().priorDiagnoses;
        <% jsForPrior.each { %>
            priorDiagnoses.addDiagnosis(diagnoses.Diagnosis(${ it }));
        <% } %>
    });

    },1000);


</script>
