<%
    config.require("formFieldName")

    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("intelehealth", "diagnoses/diagnoses.js")
    ui.includeJavascript("intelehealth", "diagnoses/diagnoses-angular.js")
    ui.includeCss("coreapps", "diagnoses/encounterDiagnoses.css")
%>

<% /* This is an underscore template, since I dont know how to use angular templates programmatically */ %>
<script type="text/template" id="autocomplete-render-item">
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

<div id="encounter-diagnoses-app">
<div class="info-header">
        <i class="icon-diagnosis"></i>
        <h3>${ ui.message("coreapps.clinicianfacing.diagnoses").toUpperCase() }</h3>
    </div>
    
    <div class="info-body">
    <script type="text/ng-template" id="selected-diagnosis">
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
                    <input type="checkbox" data-ng-model="d.primary"/>
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
    <div data-ng-controller="DiagnosesController">

        <div id="diagnosis-search-container">
            <label for="diagnosis-search">${ ui.message("coreapps.consult.addDiagnosis") }</label>
            <input id="diagnosis-search" type="text" placeholder="${ ui.message("coreapps.consult.addDiagnosis.placeholder") }" autocomplete itemFormatter="autocomplete-render-item"/>

            <% if(jsForPrior.size > 0) { %>
                <button type="button" ng-click="addPriorDiagnoses()">${ ui.message("coreapps.consult.priorDiagnoses.add") }</button>
            <% } %>
        </div>

        <div id="display-encounter-diagnoses-container">
            <h3>${ui.message("coreapps.consult.primaryDiagnosis")}</h3>

            <div data-ng-show="encounterDiagnoses.primaryDiagnoses().length == 0">
                ${ui.message("coreapps.consult.primaryDiagnosis.notChosen")}
            </div>
            <ul>
                <li data-ng-repeat="d in encounterDiagnoses.primaryDiagnoses()">
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
          url += "&fromdate=" + date;
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
    app.controller('DiagnosesController', [ '\$scope', '\$timeout', 'DiagnosisFactory1', 'DiagnosisFactory2',
        function DiagnosesController(\$scope, \$timeout, DiagnosisFactory1, DiagnosisFactory2) {
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
              }, 2000);
        }
    ]);

    // manually bootstrap, in case there are multiple angular apps on a page

    // add any existing diagnoses
    setTimeout(function(){
    angular.element('#encounter-diagnoses-app').scope().\$apply(function() {
        var encounterDiagnoses = angular.element('#encounter-diagnoses-app > .ng-scope').scope().encounterDiagnoses;
        <% jsForExisting.each { %>
            encounterDiagnoses.addDiagnosis(diagnoses.Diagnosis(${ it }));
        <% } %>
    });

    // add any prior diagnoses
    angular.element('#encounter-diagnoses-app').scope().\$apply(function() {
        var priorDiagnoses = angular.element('#encounter-diagnoses-app > .ng-scope').scope().priorDiagnoses;
        <% jsForPrior.each { %>
            priorDiagnoses.addDiagnosis(diagnoses.Diagnosis(${ it }));
        <% } %>
    });
    
    },1000);
    

</script>
