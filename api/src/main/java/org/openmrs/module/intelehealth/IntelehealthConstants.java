package org.openmrs.module.intelehealth;

public class IntelehealthConstants {

    public static final String GP_DEFAULT_PATIENT_IDENTIFIER_LOCATION = "intelehealth.defaultPatientIdentifierLocation";

    public static final String GP_DASHBOARD_URL = "intelehealth.dashboardUrl";
    public static final String GP_VISITS_PAGE_URL = "intelehealth.visitsPageUrl";
    public static final String GP_VISITS_PAGE_WITH_SPECIFIC_URL = "intelehealth.visitsPageWithSpecificVisitUrl";

    public static final String GP_SEARCH_DELAY_SHORT = "intelehealth.searchDelayShort";
    public static final String GP_SEARCH_DELAY_LONG = "intelehealth.searchDelayLong";

    public static final String HTMLFORMENTRY_CODED_OR_FREE_TEXT_OBS_TAG_NAME = "codedOrFreeTextObs";
    public static final String HTMLFORMENTRY_ENCOUNTER_DIAGNOSES_TAG_NAME = "encounterDiagnoses";
    public static final String HTMLFORMENTRY_ENCOUNTER_DISPOSITION_TAG_NAME = "encounterDisposition";
    public static final String HTMLFORMENTRY_ENCOUNTER_DIAGNOSES_TAG_INCLUDE_PRIOR_DIAGNOSES_ATTRIBUTE_NAME = "includePriorDiagnosesFromMostRecentEncounterWithDispositionOfType";

    public static final String VITALS_ENCOUNTER_TYPE_UUID = "67a71486-1a54-468f-ac3e-7091a9a79584";

    public static final String PRIVILEGE_PATIENT_DASHBOARD = "App: intelehealth.patientDashboard";
    public static final String PRIVILEGE_PATIENT_VISITS = "App: intelehealth.patientVisits";
	public static final String PRIVILEGE_START_VISIT = "Task: intelehealth.createVisit";
	public static final String PRIVILEGE_END_VISIT = "Task: intelehealth.endVisit";
    public static final String PRIVILEGE_DELETE_PATIENT = "Task: intelehealth.deletePatient";
    
	public static final String GP_RECENT_DIAGNOSIS_PERIOD_IN_DAYS = "intelehealth.recentDiagnosisPeriodInDays";

    public static final String ENCOUNTER_TEMPLATE_EXTENSION = "org.openmrs.referenceapplication.encounterTemplate";

    public static final String AWAITING_ADMISSION = "intelehealth.app.awaitingAdmission";

    @Deprecated  // no longer used, to override set intelehealth.dashboardUrl instead
    public static final String GP_DEFAULT_DASHBOARD = "intelehealth.defaultDashboard";
}
