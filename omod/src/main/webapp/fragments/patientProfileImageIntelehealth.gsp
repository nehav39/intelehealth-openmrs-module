<div class="info-section" >
    <div class="info-header">
        <h3>PROFILE IMAGE</h3>
    </div>
    <div class="info-body" ng-controller="intelehealthPatientProfileImageController">
    <div ng-repeat="img in patientImage">
<img ng-src="{{img.Image.url}}" height="200px" width="200px">
</div>
    </div>
</div>