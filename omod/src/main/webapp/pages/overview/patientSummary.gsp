<%
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js")
    ui.includeCss("intelehealth", "overview/patientSummary.css")
    ui.includeCss("intelehealth", "overview/ui-carousel.css")
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("uicommons", "angular-app.js")
    ui.includeJavascript("uicommons", "angular-resource.min.js")
    ui.includeJavascript("uicommons", "angular-common.js")
    ui.includeJavascript("intelehealth", "jquery/jquery.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeJavascript("intelehealth", "angular-ui-bootstrap/dist/ui-bootstrap-tpls.js")
    ui.includeJavascript("intelehealth", "angular-ui-carousel/dist/ui-carousel.js")
    ui.includeJavascript("intelehealth", "constants.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.module.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_additional_comments/intelehealth_additional_comments.module.js")
    ui.includeJavascript("intelehealth", "intelehealth_additional_comments/intelehealth_additional_comments.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_additional_comments/intelehealth_additional_comments.controller.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_profile_image/intelehealth_patient_profile_image.module.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_profile_image/intelehealth_patient_profile_image.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_profile_image/intelehealth_patient_profile_image.controller.js")
    ui.includeJavascript("intelehealth", "intelehealth_additional_docs_images/intelehealth_additional_docs_images.module.js")
    ui.includeJavascript("intelehealth", "intelehealth_additional_docs_images/intelehealth_additional_docs_images.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_additional_docs_images/intelehealth_additional_docs_images.controller.js")
    ui.includeJavascript("intelehealth", "intelehealth_physical_exam_images/intelehealth_physical_exam_images.module.js")
    ui.includeJavascript("intelehealth", "intelehealth_physical_exam_images/intelehealth_physical_exam_images.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_physical_exam_images/intelehealth_physical_exam_images.controller.js")
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/referenceapplication/home.page' },
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
    <i class="icon-comment"><a href="#complaints">Presenting Complaints</a></i>
    <i class="icon-stethoscope"><a href="#exam">On Examination</a></i>
<br/>
    <i class="icon-heart-empty"><a href="#diagnosis">Diagnoses</a></i>
    <i class="icon-medicine"><a href="#meds">Prescribed Medication</a></i>
    <i class="icon-beaker"><a href="#orderedTests">Prescribed Tests</a></i>
    <i class="icon-comments"><a href="#advice">Medical Advice</a></i>
    <i class="icon-list-alt"><a href="#comments">Additional Comments</a></i>
</div>

<div class="clear"></div>
    <div class="dashboard clear" ng-app="patientSummary" ng-controller="PatientSummaryController">
        <div class="long-info-container column">
                ${ui.includeFragment("intelehealth", "overview/vitals", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/famhist", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/history", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/complaint", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/exam", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/physicalExamImages", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/additionalDocsImages", [patient: patient])}
                ${ui.includeFragment("intelehealth", "diagnosis/encounterDiagnoses", [patient: patient, formFieldName: 'Consultation'])}
				${ui.includeFragment("intelehealth", "overview/meds", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/orderedTests", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/advice", [patient: patient])}
                ${ui.includeFragment("intelehealth", "overview/additionalComments", [patient: patient])}
	 </div>
    </div>

<script>
var visitNoteEncounterUuid = "";
var path = window.location.search;
var i = path.indexOf("visitId=");
var visitId = path.substr(i + 8, path.length);
var isVisitNotePresent = false;

var app = angular.module('patientSummary', ['ngAnimate', 'ngSanitize', 'recentVisit', 'vitalsSummary', 'famhistSummary', 'historySummary', 'complaintSummary', 'examSummary', 'diagnoses', 'medsSummary', 'orderedTestsSummary', 'adviceSummary', 'intelehealthPatientProfileImage', 'intelehealthPhysicalExamination', 'intelehealthAdditionalDocs', 'ui.bootstrap', 'ui.carousel', 'intelehealthAdditionalComments']);

app.factory('PatientSummaryFactory1', function(\$http, \$filter){
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

app.factory('PatientSummaryFactory2', function(\$http){
  var patient = "${ patient.uuid }";
  var url1 = "/" + OPENMRS_CONTEXT_PATH + "/ws/rest/v1/encounter";
  var date2 = new Date();
  var json = {
      patient: patient,
      encounterType: window.constantConfigObj.encounterTypeVisitNote,
      visit: visitId,
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

app.controller('PatientSummaryController', function(\$scope, \$http, PatientSummaryFactory1, PatientSummaryFactory2, recentVisitFactory) { 
\$scope.isLoading = true;
\$scope.visitEncounters = [];
\$scope.visitObs = [];
\$scope.visitNoteData = [];
\$scope.visitStatus = false;  
recentVisitFactory.fetchVisitDetails(visitId).then(function(data) {
						\$scope.visitDetails = data.data;
						\$scope.visitEncounters = data.data.encounters; 
						if(\$scope.visitEncounters.length !== 0) {
							angular.forEach(\$scope.visitEncounters, function(value, key){
								var encounter = value.display;
								if(encounter.match("Visit Note") !== null) {
									var encounterUuid = value.uuid;
									visitNoteEncounterUuid = encounterUuid;
									isVisitNotePresent = true;
								}
							});
						}
						if (isVisitNotePresent == false || \$scope.visitEncounters.length == 0) {
									PatientSummaryFactory2.async().then(function(d2){
      	  								\$scope.data2 = d2;
      	  								visitNoteEncounterUuid = d2;
    								});
						}
					}, function(error) {
						console.log(error);
					});
});

</script>

<script>
</script>

