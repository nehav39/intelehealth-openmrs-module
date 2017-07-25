<div class="long-info-section" >
    <div class="info-header">
        <h3>PHYSICAL EXAMINATION</h3>
    </div>
    <div class="info-body" ng-controller="intelehealthPhysicalExaminationController">
    
  <ui-carousel slides="patientImage" slides-to-show="3" slides-to-scroll="3" dots="true">
  <carousel-item>
  <div>
    <img ng-click="openFullImage()" src="{{ item.Image.url }}" alt="{{ item.Image.name }}" width="200px" height="200px" />
    </div>

  </carousel-item>
</ui-carousel>
    
    </div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>