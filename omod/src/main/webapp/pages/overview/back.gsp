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

    Handlebars.registerHelper('display', function (obj) {
        return obj ? (obj.display ? obj.display : obj) : "";
    });
    Handlebars.registerHelper('date', function (obj) {
        return obj ? new Date(obj).toLocaleString() : "";
    });
    var lastEncounterTemplate = Handlebars.compile(jq('#last-encounter-template').html());
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

<div class="container">

    <div class="dashboard clear">
        ${ui.includeFragment("intelehealth", "overview/test", [patient: patient])}
    </div>
    <div class="dashboard clear">
	${ui.includeFragment("intelehealth", "overview/vitals", [patient: patient])}
    </div>
    <div class="dashboard clear">
        ${ui.includeFragment("intelehealth", "overview/famhist", [patient: patient])}
    </div>
    <div class="dashboard clear">
        ${ui.includeFragment("coreapps", "clinicianfacing/diagnosisWidget", [patient: patient])}
        ${ui.includeFragment("coreapps", "diagnosis/encounterDiagnoses", [patient: patient, formFieldName: 'Consultation'])}
    </div>
    <div class="dashboard clear">
        ${ui.includeFragment("intelehealth", "overview/activeDrugOrders", [patient: patient])}
    </div>
    <div class="dashboard clear">
	${ui.includeFragment("intelehealth", "overview/orderedTests", [patient: patient])}
    </div>
    <div class="dashboard clear">
        ${ui.includeFragment("intelehealth", "overview/advice", [patient: patient])}
    </div>
</div>
