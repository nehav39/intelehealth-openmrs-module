<div class="info-section" >
    <div class="info-header">
        <h3>PROFILE IMAGE</h3>
    </div>
    <div class="info-body" ng-controller="IntelehealthPatientProfileImageController">
    <div ng-repeat="visit in visitList">
<img ng-src="{{visit.Image.url}}" height="200px" width="200px">
</div>
    </div>
</div>