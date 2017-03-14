<%
    def patient = config.patient
    def dateFormat = new java.text.SimpleDateFormat("dd MMM yyyy hh:mm a")
    ui.includeCss("coreapps", "patientHeader.css")
    ui.includeJavascript("coreapps", "patientdashboard/patient.js")
    appContextModel.put("returnUrl", ui.thisUrl())
%>

<h1> Hello World! </h1>

