<style>
.comments {
height: 50px;
width: 450px;
resize: none
}
</style>

<div id="orderedTests" class="long-info-section" ng-controller="intelehealthAdditionalCommentsController">
	<div class="info-header">
		<h3>Additional Comments</h3>
	</div>
	<div class="info-body">
			<textarea row="3" cols="50" class="comments" ng-show="visitStatus" type="text" ng-model="addMe" class="form-control"></textarea>
			<button ng-show="visitStatus" type="button" class='btn btn-default' ng-click="addAlert()">Add Comment</button>
			<p>{{errortext}}</p>
			<br/>
			<br/>
			<div uib-alert ng-repeat="alert in alerts" ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}</div>
	</div>
	
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>