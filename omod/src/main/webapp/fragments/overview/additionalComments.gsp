<style>
.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    border: 0
}

.alert {
    padding: 15px;
    margin-bottom: 10px;
    border: 1px solid transparent;
    border-radius: 4px
}
.alert h4 {
    margin-top: 0;
    color: inherit
}
.alert .alert-link {
    font-weight: 700
}
.alert-info {
    color: #31708f;
    background-color: #d9edf7;
    border-color: #bce8f1
}
.alert-info hr {
    border-top-color: #a6e1ec
}
.alert-info .alert-link {
    color: #245269
}
.close {
    float: right;
    font-size: 21px;
    font-weight: 700;
    line-height: 1;
    color: #000;
    text-shadow: 0 1px 0 #fff;
    filter: alpha(opacity=20);
    opacity: .2
}
.close:focus,
.close:hover {
    color: #000;
    text-decoration: none;
    cursor: pointer;
    filter: alpha(opacity=50);
    opacity: .5
}
button.close {
    -webkit-appearance: none;
    padding: 0;
    cursor: pointer;
    background: 0 0;
    border: 0
}

.comments {
height: 50px;
width: 450px;
resize: none
}
</style>

<div id="orderedTests" class="long-info-section" ng-controller="intelehealthAdditionalCommentsController">
	<div class="info-header">
		<i class="icon-comments"></i>
		<h3>Doctor's Note</h3>
	</div>
	<div class="info-body">
			<textarea row="3" cols="50" class="comments" ng-show="visitStatus" type="text" ng-model="addMe" class="form-control"></textarea>
			<button ng-show="visitStatus" type="button" class='btn btn-default' ng-click="addAlert()">Add Note</button>
			<p>{{errortext}}</p>
			<br/>
			<br/>
			<div uib-alert ng-repeat="alert in alerts" ng-class="'alert-' + (alert.type || 'info')" close="closeAlert(\$index)">{{alert.msg}}</div>
	</div>
	
    <div>
        <a href="#" class="right back-to-top">Back to top</a>
    </div>
</div>