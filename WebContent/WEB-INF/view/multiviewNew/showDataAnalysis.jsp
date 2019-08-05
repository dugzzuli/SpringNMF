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
		<div class="row">
			<div class="col-sm-12" style="margin-top: 10px">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">选择算法</h3>
					</div>
					<div class="panel-body">
						<div class="col-sm-12">
							<div class="input-group">
								<div class="input-group-btn">
									<button type="button" class="btn btn-default dropdown-toggle"
										data-toggle="dropdown">
										选择 <span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li><a class="method" hid="MNMF"
											href="javascript:void(0)">MNMF</a></li>
										<li><a class="method" hid="GMNMF"
											href="javascript:void(0)">GMNMF</a></li>
										<li class="divider"></li>
										<li><a class="method" href="javascript:void(0)">DAE-MNMF</a></li>
									</ul>
								</div>
								<!-- /btn-group -->
								<input type="text" readonly id="methodParam"
									onclick="showCanshu()" class="form-control">
							</div>
							<!-- /input-group -->
						</div>



					</div>

				</div>
			</div>
			<div class="col-sm-12" style="margin-top: 10px">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<a href="javascript:void(0)" onclick="requestByJson()">点击执行</a>
						</h3>
					</div>

					<div class="panel-body" style="margin-top: 10px;">
						<div class="col-sm-6">
							<div class="panel panel-default">
								<div class="panel-heading">
									<h3 class="panel-title">
										聚类结果
									</h3>
								</div>
								<div class="panel-body" id="leftPanel" >
									<textarea class="form-control" id="resultMNMF"
										rows="19" style="background-color:white; min-width: 100%; border:none;" readonly></textarea>
								</div>


							</div>
						</div>
						<div class="col-sm-6">
						<div class="panel panel-default">
						
							<div class="panel-heading">
								<h3 class="panel-title">
									损失函数
								</h3>
							</div>
							<div class="panel-body" id="rightPanel" style="height: 420px;">
								<div id="container"></div>

							</div>
						</div>
						</div>

					</div>
				</div>
			</div>
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


	<!-- 模态框（Modal） -->
	<div class="modal fade" id="chooseAlgorithm" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">参数设置</h4>
				</div>

				<div class="modal-body">
					<input type="hidden" id="method" />
					<div class="col-sm-6" style="display: inline;">
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
					<br /> <br />
				</div>

				<div class="modal-footer">
					<br /> <br />
					<button type="button" class="btn btn-default" onclick="closeM()">更新参数
					</button>
					<button type="button" id="subJson" class="btn btn-primary">运行算法</button>
				</div>
			</div>
			<!-- /.modal-content -->
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
function showCanshu(){
	  $('#chooseAlgorithm').modal({backdrop:'static',keyboard:false});  
}
function hideModal(){  
    $('#myModal').modal('hide');  
}  
var idTime;
var getting = {
        url:'<%=basePath%>/demo/getCurrentStatus',
		dataType : 'json',
		success : function(res) {
			$('#result').html(res.desc);
			/* idTime=setTimeout(function(){$.ajax(getting);},1000);//1秒后定时发送请求 */
		}
	};

	function showModal() {
		$('#myModal').modal({
			backdrop : 'static',
			keyboard : false
		});
	}

	function requestByJson() {
		$.ajax({
			type : 'get',
			url : "demo/getShopInJSON",
			dataType : "json",
			data : {
				method : $("#method").val(),
				maxIter : $("#maxIter").val(),
				relarErr : $("#relarErr").val()
			},
			//设置contentType类型为json
			contentType : 'application/json;charset=utf-8',
			beforeSend : function() {
				showModal();
				window.setTimeout(function() {
					$.ajax(getting)
				}, 3000);
			},
			//请求成功后的回调函数
			success : function(data) {
				setTimeout(hideModal(), 1000);

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
		
		$("#resultMNMF").text(data["clusterResult"]);
	}

	$(document).ready(
			function() {

				
				$(".method").click(
						function() {
							var md = $(this).attr("hid");
							$("#method").val(md);
							$("#methodParam").val(
									md + " " + "-iter" + " " + "100" + " "
											+ "-l" + " " + "0.1");
							$("#maxIter option[value=" + 100 + "]").attr(
									"selected", "selected");
							$("#relarErr option[value=1e-1}]").attr("selected",
									"selected");
						});
				$("#subJson").click(function() {
					$('#chooseAlgorithm').modal('hide');
					requestByJson();
				});

			});

	function closeM() {
		var md = $("#method").val();
		$("#methodParam").val(
				md + " " + "-iter" + " " + $("#maxIter").val() + " " + "-l"
						+ " " + $("#relarErr").val());
		$('#chooseAlgorithm').modal('hide');
	}
</script>