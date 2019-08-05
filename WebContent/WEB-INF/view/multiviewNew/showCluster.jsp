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
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<title>可视化</title>
<base href=" <%=basePath%>">
<link href="css/bootstrap.min.css" rel="stylesheet">

<script src="js/jquery-1.11.2.min.js"></script>
<script src="js/d3.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/tsne.js"></script>



<style>
svg {
	border: 1px solid #333;
	margin-top: 20px;
}

body {
	font-size: 16px;
}

.container {
	margin-right: 0px;
	margin-left: 0px;
	width: 100%;
}
</style>


</head>

<body>

	<div class="container">


		<div class="row">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">参数选择</h3>
				</div>
				<div class="panel-body">
					<div class="col-sm-12">

						学习率: <input type="text" id="lrtxt" maxlength="10"
							value="10" style="width: 40px;"> 
						困惑度: <input
							type="text" id="perptxt" maxlength="10" value="30"
							style="width: 40px;"> 

						<button type="button" id="loadData" class="btn btn-primary">加载数据</button>
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

	</div>

	<div class="container" style="padding-left: 0px;padding-right: 0px;">

			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">表征展示</h3>
				</div>
				<div class="panel-body">
					<div class="col-sm-12">

		<div id="cost"
			style="display: inline; text-align: left; font-family: Impact;"></div>

		<div id="embed"></div>
		</div>
		</div>
		</div>


	</div>


</body>

</html>

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
	$("#embed").empty();
	var div = d3.select("#embed");
	svg = div.append("svg") // svg is global
	.attr("width", $(document.body).width() - 50).attr("height", 500);
	
	
	
	
	
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

				alert("加载成功...");
				data = datajson["clusterVector"];

				labels = datajson["label"];
				dataok = true;
			},
			fail : function() {

			}

		});

	}

	dataok = false;

	dotrain = true;
	iid = -1;
	$(window)
			.load(
					function() {
						

						$("#loadData").click(function() {
							requestByJsonLoadData();
						});

						$("#stopbut").click(function() {
							dotrain = false;
						});

						$("#inbut")
								.click(
										function() {

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
													alert('number of rows in Text labels ('
															+ labels.length
															+ ') does not match number of rows in Data ('
															+ data.length
															+ ')! Aborting.');
													return;
												}
											}

											// ok lets do this
											opt = {
												epsilon : parseFloat($("#lrtxt")
														.val()),
												perplexity : parseInt($(
														"#perptxt").val()),
												dim : 2
											};
											T = new tsnejs.tSNE(opt); // create a
											// tSNE
											// instance

											var dfv = $(
													'input[name=rdata]:checked',
													'#datatypeform').val();
											if (dfv === 'raw') {
												console.log('raw');
												T.initDataRaw(data);

											}

											drawEmbedding();
											iid = setInterval(step, 10);
											dotrain = true;

										});
					});
</script>