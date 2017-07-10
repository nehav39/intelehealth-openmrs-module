<%
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular-sanitize/angular-sanitize.js")
    ui.includeJavascript("intelehealth", "angular-animate/angular-animate.js")
    ui.includeJavascript("intelehealth", "angular-bootstrap/ui-bootstrap-tpls.js")
	ui.includeJavascript("intelehealth", "shared/visitDate.filter.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.module.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.service.js")
    ui.includeJavascript("intelehealth", "recent_visits/recent_visits.controller.js")
%>
<div class="info-section">
    <div class="info-header">
        <i class="icon-calendar"></i>
        <h3>RECENT VISITS</h3>
    </div>
    <div class="info-body" ng-controller="RecentVisitController">
	       <div ng-repeat="visit in recentVisits" class="clear">
		       	<a href='/openmrs/intelehealth/overview/patientSummary.page?patientId={{patientId}}&visitId={{visit.uuid}}' class="visit-link">{{visit.display | visitdate | date: 'dd.MMM.yyyy'}}</a>
		       	<div class="tag" ng-if="visit.visitStatus">{{visit.visitStatus}}</div>
	       </div>
    </div>
</div>