<div class="info-section" >
    <div class="info-header">
        <h3>ADDITIONAL DOCUMENTS</h3>
    </div>
    <div class="info-body" ng-controller="intelehealthAdditionalDocsController">
    
  <ui-carousel slides="patientImage" slides-to-show="3" slides-to-scroll="3" dots="true">
  <carousel-item>
  <div>
    <img ng-click="\$parent.\$parent.openAdditionalDocFullImage(item.Image.url)" src="{{ item.Image.url }}" alt="{{ item.Image.name }}" width="200px" height="200px" />
    </div>

  </carousel-item>
</ui-carousel>
    
    </div>
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>

