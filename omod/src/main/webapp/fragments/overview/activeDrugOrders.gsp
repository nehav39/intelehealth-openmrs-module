<%
    def careSettings = activeDrugOrders.collect{it.careSetting}.unique()
%>

<div id="meds" class="long-info-section">

    <div class="info-header">
        <i class="icon-medicine"></i>
        <h3>Prescribed Medication</h3>
        <% if (context.hasPrivilege("App: intelehealth.drugOrders")) { %>
            <a href="${ ui.pageLink("intelehealth", "drugOrders", [patient: patient.id, returnUrl: ui.thisUrl()]) }">
                <i class="icon-share-alt edit-action right" title="${ ui.message("coreapps.edit") }"></i>
            </a>
        <% } %>
    </div>
    <div class="info-body active-drug-orders">
	<% if (!activeDrugOrders) { %>
            ${ ui.message("emr.none") }
        <% } else { %>
            <% careSettings.each { careSetting -> %>
                <ul>
                    <% activeDrugOrders.findAll{ it.careSetting == careSetting }.each { %>
                    <li>
                        <label>${ ui.format(it.drug ?: it.concept) }</label>
                        <small>${ it.dosingInstructionsInstance.getDosingInstructionsAsString(sessionContext.locale) }</small>
                    </li>
                    <% } %>
                </ul>
            <% } %>
        <% } %>
    </div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
    <br/>
</div>

<script>
    angular.bootstrap("#meds", ['medsSummary']);
</script>  
