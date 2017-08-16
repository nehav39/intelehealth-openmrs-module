<%
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeCss("intelehealth", "overview/patientSummary.css")
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeCss("coreapps", "clinicianfacing/patient.css")
    ui.includeJavascript("intelehealth", "constants.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_dashboard/intelehealth_patient_dashboard.module.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_dashboard/intelehealth_patient_dashboard.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_dashboard/intelehealth_patient_dashboard.controller.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.module.js")
    ui.includeJavascript("intelehealth", "shared/visitDate.filter.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.service.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.controller.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_profile_image/intelehealth_patient_profile_image.module.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_profile_image/intelehealth_patient_profile_image.service.js")
    ui.includeJavascript("intelehealth", "intelehealth_patient_profile_image/intelehealth_patient_profile_image.controller.js")
%>

<script type="text/javascript">
    var breadcrumbs = [
		{ icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/referenceapplication/home.page' },
        { label: "${ ui.escapeJs(ui.encodeHtmlContent(ui.format(patient.patient))) }" ,
            link: '${ ui.urlBind("/" + contextPath + dashboardUrl, [ patientId: patient.patient.id ] ) }'}
    ];

    jq(function(){
        jq(".tabs").tabs();

        // make sure we reload the page if the location is changes; this custom event is emitted by by the location selector in the header
        jq(document).on('sessionLocationChanged', function() {
            window.location.reload();
        });
    });

    var patient = { id: ${ patient.id } };
</script>

<% if(includeFragments){

    includeFragments.each {
        // create a base map from the fragmentConfig if it exists, otherwise just create an empty map
        def configs = [:];
        if(it.extensionParams.fragmentConfig != null){
            configs = it.extensionParams.fragmentConfig;
        }

        configs.patient = patient;   // add the patient to the map %>
        ${ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment, configs)}
    <%}
} %>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient.patient, activeVisit: activeVisit, appContextModel: appContextModel ]) }

<div class="clear"></div>
<div class="container">
    <div class="dashboard clear" ng-app="intelehealthPatientDashboard" ng-controller="intelehealthPatientDashboardController">
        <div class="info-container column">
            <% if (firstColumnFragments) {
			    firstColumnFragments.each {
                    // create a base map from the fragmentConfig if it exists, otherwise just create an empty map
                    def configs = [:];
                    if(it.extensionParams.fragmentConfig != null){
                        configs = it.extensionParams.fragmentConfig;
                    }
                    configs << [ patient: patient, patientId: patient.patient.id, app: it.appId ]
            %>
			        ${ ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment, configs)}
			<%  }
			} %>

        </div>
        <div class="info-container column">
            <%/*
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-medicine"></i>
                    <h3>${ ui.message("coreapps.clinicianfacing.prescribedMedication").toUpperCase() }</h3>
                </div>
                <div class="info-body">
                    <ul>
                        <li></li>
                    </ul>
                    <a class="view-more">${ ui.message("coreapps.clinicianfacing.showMoreInfo") } ></a>
                </div>
            </div>
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-medical"></i>
                    <h3>${ ui.message("coreapps.clinicianfacing.allergies").toUpperCase() }</h3>
                </div>
                <div class="info-body">
                    <ul>
                        <li></li>
                    </ul>
                </div>
            </div>
            */%>
            
            <% if (secondColumnFragments) {
			    secondColumnFragments.each {
                    // create a base map from the fragmentConfig if it exists, otherwise just create an empty map
                    def configs = [:];
                    if(it.extensionParams.fragmentConfig != null){
                        configs = it.extensionParams.fragmentConfig;
                    }
                    configs << [ patient: patient, patientId: patient.patient.id, app: it.appId ]
            %>
			        ${ ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment, configs)}
			<%   }
			} %>
			
		<div>
	${ui.includeFragment("intelehealth", "intelehealthPatientDashboard/recentVisitsIntelehealth", [patient: patient])}
	</div>
</div>
<div class="action-container column">
	${ui.includeFragment("intelehealth", "intelehealthPatientDashboard/patientProfileImageIntelehealth", [patient: patient])}
</div>