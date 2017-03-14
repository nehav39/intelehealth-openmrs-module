<%
    ui.includeJavascript("intelehealth", "jquery/jquery.js")
    ui.includeJavascript("intelehealth", "angular/angular.min.js")
    ui.includeJavascript("intelehealth", "angular/angular.js")
    ui.includeJavascript("intelehealth", "angular/angular-resource.js")
    ui.includeJavascript("intelehealth", "angular/angular-resource.min.js")

    def id = config.id
    def props = config.properties ?: ["encounterType", "encounterDatetime", "location", "provider"]
%>

<%= ui.resourceLinks() %>

<script>
jq = jQuery;

jq(function() {
    jq('#${ id }_button').click(function() {
        jq.getJSON('${ ui.actionLink("getEncounters") }',
            {
              'start': '${ config.start }',
              'end': '${ config.end }',
              'properties': [ <%= props.collect { "'${it}'" }.join(",") %> ]
            })
        .success(function(data) {
            jq('#${ id } > tbody > tr').remove();
            var tbody = jq('#${ id } > tbody');
            for (index in data) {
                var item = data[index];
                var row = '<tr>';
                <% props.each { %>
                    row += '<td>' + item.${ it } + '</td>';
                <% } %>
                row += '</tr>';
                tbody.append(row);
            }
        })
        .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
    });
});
</script>

<input id="${ id }_button" type="button" value="Refresh"/>

<table id="${ id }">
    <thead>
        <tr>
            <% props.each { %>
                <th>${ ui.message("Encounter." + it) }</th>
            <% } %>
        </tr>
    </thead>
    <tbody>
        <% if (encounters) { %>
            <% encounters.each { enc -> %>
                <tr>
                    <% props.each { prop -> %>
                        <td><%= ui.format(enc."${prop}") %></td>
                    <% } %>
                </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="4">${ ui.message("general.none") }</td>
            </tr>
        <% } %>
    </tbody>
</table>

<script>
    angular.bootstrap("#test2", ['test2Summary']);
</script>  
