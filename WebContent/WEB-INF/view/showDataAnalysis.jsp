<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	// 获得本项目的地址(例如: http://localhost:8080/MyApp/)赋值给basePath变量 
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	// 将 "项目路径basePath" 放入pageContext中，待以后用EL表达式读出。 
	pageContext.setAttribute("basePath", basePath);
%>
<html>

<head>
<meta charset="UTF-8" />
<title>Highcharts 教程 | 菜鸟教程(runoob.com)</title>
<base href="<%=basePath%>">
<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="js/highcharts/highcharts.js"></script>
<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- HTML5 shim 和 Respond.js 是为了让 IE8 支持 HTML5 元素和媒体查询（media queries）功能 -->
<!-- 警告：通过 file:// 协议（就是直接将 html 页面拖拽到浏览器中）访问页面时 Respond.js 不起作用 -->
<!--[if lt IE 9]>
      <script src="https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/respond.js@1.4.2/dest/respond.min.js"></script>
    <![endif]-->
</head>

<body>
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
					aria-expanded="false">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">系统</a>
			</div>

			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse"
				id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Link <span class="sr-only">(current)</span></a>
					</li>
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">算法模块 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="#">Action</a></li>
							<li><a href="#">Another action</a></li>
							<li><a href="#">Something else here</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#">Separated link</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#">One more separated link</a></li>
						</ul></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a href="#">系统简介</a></li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</div>
		<!-- /.container-fluid -->
	</nav>
	<div class="container"
		style="margin-top: 30px; padding-top: 10px; padding-bottom: 10px; min-height: 800px; background-color: floralwhite;">
		<h1>损失函数</h1>
		<div class="row">
			<div class="col-md-12">
			<div class="col-md-3">
			<label>方法:</label>
				<select id="method" class="btn btn-default">
					<option value="MNMF">MNMF</option>
				</select>
				</div>
				<div class="col-md-3">
				<label>迭代次数:</label>
				<select id="maxIter" class="btn btn-default">
					<option value="100">100</option>
					<option value="500">500</option>
					<option value="1000">1000</option>
					<option value="5000">5000</option>
					<option value="10000">10000</option>
				</select>
				</div>
				
				<div class="col-md-3">
				<label>相对误差:</label>
				
				<select id="relarErr" class="btn btn-default">
					<option value="1">1e-1</option>
					<option value="2">1e-2</option>
					<option value="3">1e-3</option>
					<option value="4">1e-4</option>
					<option value="5">1e-5</option>
				</select>
				</div>
				<div class="col-md-3">
				 <input class="btn btn-default" id="subJson" type="button" value="提交">
				 </div>

			</div>
			<div class="col-md-12" id="container" style="margin-top:10px; backgroud:2px solid black"></div>
		</div>
	</div>
	<nav class="navbar navbar-inverse navbar-fixed-bottom">
		<div class="container">dugking</div>
	</nav>
</body>

</html>
<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
<script language="JavaScript">
	function requestByJson() {

		$.ajax({
			type: 'get',
			url: '<%=basePath%>/demo/getShopInJSON',
			 dataType: "json",
			data: {method:$("#method").val(), maxIter:$("#maxIter").val(),relarErr:$("#relarErr").val()},
			//设置contentType类型为json
			contentType : 'application/json;charset=utf-8',
			//请求成功后的回调函数
			success : function(data) {

				drawChart(data);
			},
			fail : function() {

			}

		});

	}

	function drawChart(data) {
		var title = data["title"];
		var subtitle = data["subTitle"];
		var xAxis = data["xAxis"];
		var yAxis = data["yAxis"];

		var tooltip = data["tootip"]

		var legend = data["lengend"];

		var series = data["arrSeries"];

		var json = {};

		json.title = title;
		json.subtitle = subtitle;
		json.xAxis = xAxis;
		json.yAxis = yAxis;
		json.tooltip = tooltip;
		json.legend = legend;
		json.series = series;

		$('#container').highcharts(json);
	}
	$(document).ready(function() {
		$("#subJson").click(function(){
			requestByJson();	
		});
		
	});
</script>