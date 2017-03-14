<%
    ui.decorateWith("appui", "standardEmrPage")

    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("uicommons", "angular-app.js")
    ui.includeJavascript("uicommons", "angular-resource.min.js")
    ui.includeJavascript("uicommons", "angular-common.js")
    ui.includeJavascript("uicommons", "angular-ui/ui-bootstrap-tpls-0.11.2.js")
    ui.includeJavascript("uicommons", "ngDialog/ngDialog.js")
    ui.includeJavascript("uicommons", "filters/display.js")
    ui.includeJavascript("uicommons", "filters/serverDate.js")
    ui.includeJavascript("uicommons", "services/conceptService.js")
    ui.includeJavascript("uicommons", "services/drugService.js")
    ui.includeJavascript("uicommons", "services/encounterService.js")
    ui.includeJavascript("uicommons", "services/orderService.js")
    ui.includeJavascript("uicommons", "services/session.js")
    ui.includeJavascript("uicommons", "directives/select-concept-from-list.js")
    ui.includeJavascript("uicommons", "directives/select-order-frequency.js")
    ui.includeJavascript("uicommons", "directives/select-drug.js")
    ui.includeJavascript("intelehealth", "test-order-model.js")
    ui.includeJavascript("intelehealth", "test-order-entry.js")
    ui.includeJavascript("intelehealth", "testOrders.js")

    ui.includeCss("uicommons", "ngDialog/ngDialog.min.css")
    ui.includeCss("intelehealth", "drugOrders.css")
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }" ,
            link: '${ui.pageLink("intelehealth", "overview/patientSummary", [patientId: patient.id])}'},
        { label: "Ordered Tests" }
    ]
    window.OpenMRS = window.OpenMRS || {};
    window.OpenMRS.drugOrdersConfig = ${ jsonConfig };
</script>

${ ui.includeFragment("appui", "messages", [ codes: [
        "intelehealth.pastAction.REVISE",
        "intelehealth.pastAction.DISCONTINUE"
] ])}

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }

<div id="drug-orders-app" ng-controller="DrugOrdersCtrl" ng-init='init()'>
	<form id="new-order" class="sized-inputs css-form" name="newOrderForm" novalidate
 
	</form>
</div>

<script type="text/javascript">
    // manually bootstrap angular app, in case there are multiple angular apps on a page
    angular.bootstrap('#test-orders-app', ['testOrders']);
</script>
