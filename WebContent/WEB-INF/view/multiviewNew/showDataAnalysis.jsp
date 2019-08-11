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
			<div class="col-sm-12">
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
			<div class="col-sm-12">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<a href="javascript:void(0)" onclick="requestByJson()">点击执行</a>
						</h3>
					</div>

					<div class="panel-body">
						<textarea class="form-control" id="resultMNMF" rows="10"
							style="background-color: white; border: none;" readonly></textarea>
					</div>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<a href="javascript:void(0)" onclick="requestByJson()">点击执行</a>
						</h3>
					</div>

					<div class="panel-body">
						<div class="col-sm-6">
							<div class="panel panel-default">
								<div class="panel-heading">
									<h3 class="panel-title">聚类结果</h3>
								</div>
								<div class="panel-body" id="leftPanel"></div>


							</div>
						</div>
						<div class="col-sm-6">
							<div class="panel panel-default">

								<div class="panel-heading">
									<h3 class="panel-title">损失函数</h3>
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
			<!-- <p>
				当前状态:<span id="result">等待结果....</span>
			</p> -->
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

	<div class="row hidden">
		<div class="panel panel-default">
			<div class="panel-heading ">
				<h3 class="panel-title">参数选择</h3>
			</div>
			<div class="panel-body">
				<div class="col-sm-12">

					<div style="display: none;">
						学习率: <input type="text" id="lrtxt" maxlength="10" value="10"
							style="width: 40px;"> 困惑度: <input type="text"
							id="perptxt" maxlength="10" value="30" style="width: 40px;">
						<button type="button" id="loadData" class="btn btn-primary">加载数据</button>
					</div>


					<button type="button" id="inbut" class="btn btn-primary">可视化</button>
					<button type="button" id="stopbut" class="btn btn-danger">停止</button>

				</div>
				<div class="col-sm-6 hidden">
					Delimiter (default is comma (CSV)): <input type="text" id="deltxt"
						maxlength="3" value="," style="width: 20px;"> <br>

				</div>
				<div class="col-sm-6 hidden">

					My data is:
					<form action="" id="datatypeform">
						<input type="radio" name="rdata" value="raw" checked> Raw
						NxD data (each row are features)<br>
					</form>
				</div>

			</div>
		</div>

	</div>
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

<script src="js/d3.min.js"></script>
<script src="js/tsne.js"></script>
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
				requestByJsonLoadData();
				/* $("#leftPanel").contents().find("#loadData").click();
				$("#leftPanel").contents().find("#inbut").click();
				$("#leftPanel").contents().find("#loadData").click(); */
				

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
							$("#relarErr option[value='1e-1'}]").attr("selected",
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

<script>

var T, opt;

var Y; // tsne result stored here
var data;

function updateEmbedding() {

	// get current solution
	var Y = T.getSolution();
	// move the groups accordingly
	gs.attr("transform", function(d, i) {
		return "translate(" + ((Y[i][0] * 20 * ss + tx) + 400) + ","
				+ ((Y[i][1] * 20 * ss + ty) + 400) + ")";
	});

}

var svg;

function initEmbedding() {
	$("#leftPanel").empty();
	var div = d3.select("#leftPanel");
	svg = div.append("svg") // svg is global
	.attr("width", 440).attr("height", 394);
	
	
	
	
	
}

function initEmbedding2(nodes,links) {
	
	var force = d3.layout.force() //layout将json格式转化为力学图可用的格式
	.nodes(d3.values(nodes)) //设定节点数组
	.links(links) //设定连线数组
	.size([width, height]) //作用域的大小
	.linkDistance(120) //连接线长度
	.charge(-1500) //顶点的电荷数。该参数决定是排斥还是吸引，数值越小越互相排斥
	.on("tick", tick) //指时间间隔，隔一段时间刷新一次画面
	.start(); //开始转换
	
	var drag = force.drag()
	.on("dragstart", dragstart)
	.on("dragend", dragend);
	
	
	
}


function dragstart(d) {
	d3.event.sourceEvent.stopPropagation();
	d3.select(this).classed("fixed", d.fixed = true);
}

function dragend(d) {
	d3.event.sourceEvent.stopPropagation();
	d3.select(this).classed("fixed", d.fixed = true);
}
//设置圆圈和文字的坐标
function transform1(d) {
	return "translate(" + d.x + "," + d.y + ")";
}

function transform2(d) {
	return "translate(" + (d.x) + "," + d.y + ")";
}

var gs;
var cs;
var ts;
var colorData = [ "#3366cc", "#dc3912", "#ff9900", "#109618", "#990099",
		"#0099c6", "#dd4477", "#66aa00", "#b82e2e", "#316395", "#994499",
		"#22aa99", "#aaaa11", "#6633cc", "#e67300", "#8b0707", "#651067",
		"#329262", "#5574a6", "#3b3eac" ];

function drawEmbedding() {

	
	
	gs = svg.selectAll(".b").data(data).enter().append("g").attr("class", "u");

	cs = gs.append("circle").attr("cx", 0).attr("cy", 0).attr("r", 5).attr(
			'stroke-width', 1).attr('stroke', 'black').attr('fill',
			function(d, i) {
				console.log(d, i);
				return colorData[i % colorData.length];
			});
	
	/* 'rgb(100,100,255)' */

	if (labels.length > 0) {
			ts = gs.append("text").attr("text-anchor", "middle").attr("transform",
					"translate(5, -5)").attr("font-size", 12).attr("fill",
					function(d, i) {
						/* console.log(d); */
						return colorData[labels[i % colorData.length]];
					}).text(function(d, i) {
				return labels[i];
			});
		}
		var zoomListener = d3.behavior.zoom().scaleExtent([ 0.1, 10 ]).center(
				[ 0, 0 ]).on("zoom", zoomHandler);
		zoomListener(svg);
	}

	var tx = 0, ty = 0;
	var ss = 1;

	function zoomHandler() {
		tx = d3.event.translate[0];
		ty = d3.event.translate[1];
		ss = d3.event.scale;
	}

	var stepnum = 0;

	function step() {
		if (dotrain) {
			if (T.iter > 2000) {
				dotrain = false;
			}
			var cost = T.step(); // do a few steps
			$("#cost").html("iteration " + T.iter + ", cost: " + cost);

		}
		updateEmbedding();
	}

	labels = [];
	function requestByJsonLoadData() {
		$.ajax({
			type : 'POST',
			url : '<%=basePath%>demo/getJsonCluster',
			dataType : "json",
			/*
			 * data: {method:$("#method").val(),
			 * maxIter:$("#maxIter").val(),relarErr:$("#relarErr").val()},
			 */
			// 设置contentType类型为json
			contentType : 'application/json;charset=utf-8',

			// 新增content-type头部属性
			heads : {
				'content-type' : 'application/x-www-form-urlencoded'
			},
			// 请求成功后的回调函数
			success : function(datajson) {

				data = datajson["clusterVector"];

				labels = datajson["label"];
				dataok = true;
				drawTSNE();
			},
			fail : function() {

			}

		});

	}

	dataok = false;

	dotrain = true;
	iid = -1;
	$(window).load(function() {

		$("#stopbut").click(function() {
			dotrain = false;
		});
	});

	function drawTSNE() {

		initEmbedding();

		if (!dataok) { // this is so
			// terrible... globals
			// everywhere
			// #fasthacking #sosorry
			alert('there was trouble with data, probably rows had different number of elements. See console for output.');
			return;
		}

		if (labels.length > 0) {
			if (data.length !== labels.length) {
				alert('number of rows in Text labels (' + labels.length
						+ ') does not match number of rows in Data ('
						+ data.length + ')! Aborting.');
				return;
			}
		}

		// ok lets do this
		opt = {
			epsilon : parseFloat($("#lrtxt").val()),
			perplexity : parseInt($("#perptxt").val()),
			dim : 2
		};
		T = new tsnejs.tSNE(opt); // create a
		// tSNE
		// instance

		var dfv = $('input[name=rdata]:checked', '#datatypeform').val();
		if (dfv === 'raw') {
			console.log('raw');
			T.initDataRaw(data);

		}

		drawEmbedding();
		iid = setInterval(step, 10);
		dotrain = true;
	}
</script>