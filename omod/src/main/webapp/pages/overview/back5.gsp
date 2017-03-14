<%
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js")
    ui.includeCss("intelehealth", "overview/patientSummary.css")
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("uicommons", "angular-app.js")
    ui.includeJavascript("uicommons", "angular-resource.min.js")
    ui.includeJavascript("uicommons", "angular-common.js")
    ui.includeJavascript("intelehealth", "jquery/jquery.js")
    ui.includeJavascript("intelehealth", "overview/vitalsSummary.js")
    ui.includeJavascript("intelehealth", "overview/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeJavascript("intelehealth", "angular-bootstrap/ui-bootstrap-tpls.js")
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }" ,
            link: '${ui.pageLink("intelehealth", "overview/patientSummary", [patientId: patient.id])}'}
    ]
    jq(function(){
        jq(".tabs").tabs();
        // make sure we reload the page if the location is changes; this custom event is emitted by by the location selector in the header
        jq(document).on('sessionLocationChanged', function() {
            window.location.reload();
        });
    });
    var patient = { id: ${ patient.id } };
</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient]) }

<div class="info-body jump-header">
    <span class="jump-label">Jump to:</span>
    <i class="icon-vitals"><a href="#vitals">Vitals</a></i>
    <i class="icon-group"><a href="#famhist">Family History</a></i>
    <i class="icon-book"><a href="#history">Past Medical History</a></i>
    <i class="icon-medkit"><a href="#prescriptions">Previous Prescriptions</a></i>
    <i class="icon-comment"><a href="#complaints">Presenting Complaints</a></i>
    <i class="icon-stethoscope"><a href="#exam">On Examination</a></i>
    <i class="icon-heart-empty"><a href="#diagnosis">Diagnoses</a></i>
    <i class="icon-medicine"><a href="#meds">Prescribed Medication</a></i>
    <i class="icon-beaker"><a href="#orderedTests">Prescribed Tests</a></i>
    <i class="icon-comments"><a href="#advice">Medical Advice</a></i>
    <i class="icon-list-alt"><a href="#comments">Additional Comments</a></i>
</div>

<div class="clear"></div>
    <div class="dashboard clear" ng-app="patientSummary" ng-controller="PatientSummaryController">
{{ encuuid }}
<br/>
{{ test }}
<br/>
{{ mylist }}
<br/>
        <div class="long-info-container column">
                ${ui.includeFragment("intelehealth", "overview/vitals", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/famhist", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/history", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/complaint", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/exam", [patient: patient])}
                ${ui.includeFragment("coreapps", "clinicianfacing/diagnosisWidget", [patient: patient])}
                ${ui.includeFragment("intelehealth", "diagnosis/encounterDiagnoses", [patient: patient, formFieldName: 'Consultation'])}
                ${ui.includeFragment("intelehealth", "overview/activeDrugOrders", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/orderedTests", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/advice", [patient: patient])}
	 </div>
    </div>


<script>
var app = angular.module('patientSummary', []);

app.factory('PatientSummaryFactory', function(\$q, \$timeout) {
    var deferred = \$q.defer();
    \$timeout(function() {
        // Simulated slow fetch from an HTTP server
        deferred.resolve(['Item 1', 'Item 2', 'Item 3'])
    }, 3000);
    return deferred.promise;
});

app.controller('PatientSummaryController', function(\$scope, \$http, \$filter, \$window, PatientSummaryFactory) { 
    \$scope.mylist = PatientSummaryFactory;
    var patient = "${ patient.uuid }";
    var date = new Date();
    date = \$filter('date')(new Date(), 'yyyy-MM-dd');
    var url = "http://openmrs.amal.io:8080" + "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
        url += "?patient=" + patient;
        url += "&encounterType=" + "d7151f82-c1f3-4152-a605-2f9ea7414a79";
	url += "&fromdate=" + date;
    \$http.get(url)
          .then(function(response) {
		var length = response.data.results.length;
		if(length > 0) {
                        \$scope.test = 1;
			angular.forEach(response.data.results, function(value, key){
				\$scope.encuuid = value.uuid;
			});
		} else {
			\$scope.test = 0;
			var url1 = "http://openmrs.amal.io:8080" + "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
			var date2 = new Date();
                        \$scope.json = {
                               	patient: patient,
                               	encounterType: "d7151f82-c1f3-4152-a605-2f9ea7414a79",
                               	encounterDatetime: date2
                        };
			\$http.post(url1, JSON.stringify(\$scope.json)).then(function(response){
				if(response.data){
      					\$scope.statuscode = "Success";
					\$scope.encuuid = response.data.uuid;
				} else {
					\$window.location.reload();
				};
			}, function(response){
				\$scope.error = "Failed to create Encounter";
				\$scope.ready = false; 
			});
		};
          }, function(response) {
                \$scope.error = "Get Visit Note Encounters Went Wrong";
                \$scope.statuscode = response.status;
        });
});
</script>

<script>
    angular.bootstrap("#patientSummary", ['patientSummary']);
</script>

