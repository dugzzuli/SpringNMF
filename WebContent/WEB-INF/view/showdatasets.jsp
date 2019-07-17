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
<title>多视角数据集</title>
<base href="<%=basePath%>">
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<div class="col-sm-6" style="padding-left: 0px;">
					<label>&nbsp数据集:</label> <select id=datasets
						class="btn btn-default">
						<option value="3sources">3sources</option>
						<option value="BBCSport">BBCSport</option>
						<option value="HW2sources">HW2sources</option>
					</select>
				</div>

				<div class="col-sm-6">
					<input class="btn btn-primary" id="subJson" type="button"
						value="查看">
				</div>

			</div>

			<div class="col-sm-12" id="container">
				<table class="table">
					<caption>属性展示:</caption>
					<tbody>
						<tr>
							<td>描述:</td>
							<td><span id="desc">
							
							</span></td>
						</tr>
						<tr>
							<td>URL:</td>
							<td><span id="url"></span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>

</html>

<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>

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
<style>
.container {
	margin-left: 0px;
	margin-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
	min-height: 500px;
	width: 100%;
}

.select {
	width: 105px;
}
</style>

<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
<script language="JavaScript">
	function requestByJson() {
		$.ajax({
			type: 'get',
			url: '<%=basePath%>/demo/showdatasetsDetails',
			dataType : "json",
			data : {
				datasetName : $("#datasets").val()
			},
			//设置contentType类型为json
			contentType : 'application/json;charset=utf-8',
			//请求成功后的回调函数
			success : function(data) {
				$("#desc").html(data.desc);
				$("#url").html(data.url);
				$("#url").html(data.url);
				$("#numViews").html(data.numViews);
			},
			fail : function() {

			}

		});

	}
	$(document).ready(function() {
		$("#subJson").click(function() {
			requestByJson();
		});

	});
</script>