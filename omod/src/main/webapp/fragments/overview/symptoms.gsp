<%
    ui.includeJavascript("intelehealth", "overview/tabletappForDesktop.js")
    ui.includeJavascript("intelehealth", "tabletapp/formentry/question-builder.js")
    ui.includeJavascript("intelehealth", "tabletapp/formentry/common-metadata.js")
    ui.includeJavascript("intelehealth", "tabletapp/formentry/questions.js")
    ui.includeJavascript("intelehealth", "tabletapp/constants.js")
    ui.includeJavascript("intelehealth", "tabletapp/filters.js")

    ui.includeJavascript("intelehealth", "overview/symptomsSummary.js")
    ui.includeCss("intelehealth", "overview/symptomsSummary.css")

%>

<div id="symptoms" class="long-info-section"  ng-controller="SymptomsSummaryController"
ng-init="init({patientUuid:'${patient.patient.uuid}'})">

    <div class="info-header" >
        <i class="icon-medkit"></i>

        <h3>Symptoms</h3>
        <span>
            <a href="" ng-click="getSymptomsEncounters(3)" ng-class="{'disabled': !showAll}">Show last 3 observations</a>
            <a href="" ng-click="getSymptomsEncounters()" ng-class="{'disabled': showAll}">View All</a>
        </span>
    </div>

    <div class="info-body">
        <div ng-if="symptomsEncounters.length == 0">
            ${ui.message("coreapps.none")}
        </div>

        <table >
            <tr ng-repeat="encounter in symptomsEncounters">
                <td width="100px" style="border: none">{{encounter.dateCreated | simpleDate }}</td>
                <td style="border:none">
                    <div ng-repeat="row in getObsDesc(encounter.obs)">
                        {{row}}

                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
    <br/>


</div>

<script>
    angular.bootstrap("#symptoms", ['symptomsSummary']);
</script>
