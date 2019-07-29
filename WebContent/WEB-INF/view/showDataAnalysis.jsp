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
<title>多视角聚类</title>
<base href="<%=basePath%>">
<body>
	<div class="container">
		<div class="row" style="align: left;">
			<div class="col-sm-12">
				<div class="col-sm-6">
					<label>&nbsp&nbsp数 据 集:</label> <select id=datasets
						class="btn btn-default ddlWidth">
						<option value="3sources">3sources</option>
						<option value="BBCSport">BBCSport</option>
						<option value="HW2sources">HW2sources</option>
						<option value="LP1">LP1</option>
						<option value="LP2">LP2</option>
						<option value="LP3">LP3</option>
						<option value="LP4">LP4</option>
						<option value="LP5">LP5</option>
						

					</select>
				</div>

				<div class="col-sm-6">

					<!-- <div class="form-group">
						<div class="col-sm-6" style="padding-left: 0px;">
							<div class="input-group">
								<input id='location' class="form-control"
									onclick="$('#i-file').click();"> <label
									class="input-group-btn"> <input type="button"
									id="i-check" value="浏览文件" class="btn btn-primary"
									onclick="$('#i-file').click();">
								</label>
							</div>
						</div>
						<input type="file" name="file" id='i-file' accept=".xls, .xlsx"
							onchange="$('#location').val($('#i-file').val());"
							style="display: none">
					</div> -->

				</div>

			</div>

			<div class="col-sm-12" style="margin-top: 10px">

				<div class="col-sm-6">
					<label>迭代次数:</label> <select id="maxIter"
						class="btn btn-default ddlWidth">
						<option value="100">100</option>
						<option value="500">500</option>
						<option value="1000">1000</option>
						<option value="5000">5000</option>
						<option value="10000">10000</option>
					</select>
				</div>

				<div class="col-sm-6">
					<label>相对误差:</label> <select id="relarErr"
						class="btn btn-default ddlWidth">
						<option value="1">1e-1</option>
						<option value="3">1e-3</option>
						<option value="5">1e-5</option>
						<option value="7">1e-7</option>
						<option value="9">1e-9</option>
					</select>
				</div>


			</div>
			<div class="col-sm-12" style="margin-top: 10px">

				<div class="col-sm-6">
					<label>方&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 法:</label> <select
						id="method" class="btn btn-default ddlWidth">
						<option value="MNMF">MNMF</option>
						<option value="GMNMF">GMNMF</option>
					</select>
				</div>
				<div class="col-sm-6" style="padding-left: 0px;">
					&nbsp&nbsp&nbsp <input class="btn btn-primary ddlWidth"
						id="subJson" type="button" value="提交">
				</div>
			</div>

			<div class="col-sm-12" id="container"
				style="margin-top: 10px; backgroud: 2px solid black"></div>
		</div>
	</div>

	<div class="modal fade" id="myModal">
		<div class="modal-dialog modal-sm">
			<p>
				当前状态:<span id="result">等待结果....</span>
			</p>
			<img alt=""
				src="data:image/gif;base64,R0lGODlhGQAZAJECAK7PTQBjpv///wAAACH/C05FVFNDQVBFMi4wAwEAAAAh/wtYTVAgRGF0YVhNUDw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo5OTYyNTQ4Ni02ZGVkLTI2NDUtODEwMy1kN2M4ODE4OWMxMTQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RUNGNUFGRUFGREFCMTFFM0FCNzVDRjQ1QzI4QjFBNjgiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RUNGNUFGRTlGREFCMTFFM0FCNzVDRjQ1QzI4QjFBNjgiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjk5NjI1NDg2LTZkZWQtMjY0NS04MTAzLWQ3Yzg4MTg5YzExNCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo5OTYyNTQ4Ni02ZGVkLTI2NDUtODEwMy1kN2M4ODE4OWMxMTQiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4B//79/Pv6+fj39vX08/Lx8O/u7ezr6uno5+bl5OPi4eDf3t3c29rZ2NfW1dTT0tHQz87NzMvKycjHxsXEw8LBwL++vby7urm4t7a1tLOysbCvrq2sq6qpqKempaSjoqGgn56dnJuamZiXlpWUk5KRkI+OjYyLiomIh4aFhIOCgYB/fn18e3p5eHd2dXRzcnFwb25tbGtqaWhnZmVkY2JhYF9eXVxbWllYV1ZVVFNSUVBPTk1MS0pJSEdGRURDQkFAPz49PDs6OTg3NjU0MzIxMC8uLSwrKikoJyYlJCMiISAfHh0cGxoZGBcWFRQTEhEQDw4NDAsKCQgHBgUEAwIBAAAh+QQFCgACACwAAAAAGQAZAAACTpSPqcu9AKMUodqLpAb0+rxFnWeBIUdixwmNqRm6JLzJ38raqsGiaUXT6EqO4uIHRAYQyiHw0GxCkc7l9FdlUqWGKPX64mbFXqzxjDYWAAAh+QQFCgACACwCAAIAFQAKAAACHYyPAsuNH1SbME1ajbwra854Edh5GyeeV0oCLFkAACH5BAUKAAIALA0AAgAKABUAAAIUjI+py+0PYxO0WoCz3rz7D4bi+BUAIfkEBQoAAgAsAgANABUACgAAAh2EjxLLjQ9UmzBNWo28K2vOeBHYeRsnnldKBixZAAA7" />

		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</body>

</html>

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
<style>
/* div{
margin:0 !important;
padding:0 !important;
} */
.container {
	margin-left: 0px;
	margin-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
	min-height: 500px;
	width: 100%;
}

.ddlWidth {
	text-align: center;
	width: 110px;
	height: auto;
}
</style>

<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
<script language="JavaScript">

function hideModal(){  
    $('#myModal').modal('hide');  
}  
var idTime;
var getting = {
        url:'<%=basePath%>/demo/getCurrentStatus',
        dataType:'json',
        success:function(res) {
          $('#result').html(res.desc);
          /* idTime=setTimeout(function(){$.ajax(getting);},1000);//1秒后定时发送请求 */
        }
};

function showModal(){  
    $('#myModal').modal({backdrop:'static',keyboard:false});  
}  

	function requestByJson() {
		$.ajax({
			type: 'get',
			url: '<%=basePath%>/demo/getShopInJSON',
			dataType : "json",
			data : {
				datasets : $("#datasets").val(),
				method : $("#method").val(),
				maxIter : $("#maxIter").val(),
				relarErr : $("#relarErr").val()
			},
			//设置contentType类型为json
			contentType : 'application/json;charset=utf-8',
			beforeSend : function() {
				showModal();
				window.setTimeout(function(){$.ajax(getting)},3000);
			},
			//请求成功后的回调函数
			success : function(data) {
				setTimeout(hideModal(),1000);
				
				/* window.clearTimeout(idTime); */
				
				drawChart(data);
				
			},
			fail : function() {
				alert("失败....");
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
		$("#subJson").click(function() {
			requestByJson();
		});

	});
</script>