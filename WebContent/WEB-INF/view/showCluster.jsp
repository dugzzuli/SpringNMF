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
<title>tSNE CSV web demo</title>
<base href=" <%=basePath%>">
<link href="css/bootstrap.min.css" rel="stylesheet">

<script src="js/jquery-1.11.2.min.js"></script>
<script src="js/d3.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/tsne.js"></script>

<!-- Tracking code -->
<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push([ '_setAccount', 'UA-3698471-13' ]);
	_gaq.push([ '_trackPageview' ]);

	(function() {
		var ga = document.createElement('script');
		ga.type = 'text/javascript';
		ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl'
				: 'http://www')
				+ '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0];
		s.parentNode.insertBefore(ga, s);
	})();
</script>

<style>
svg {
	border: 1px solid #333;
	margin-top: 20px;
}

body {
	font-size: 16px;
}
</style>

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
		.attr("width", 1140).attr("height", 600);
	}

	var gs;
	var cs;
	var ts;

	function drawEmbedding() {

		gs = svg.selectAll(".b").data(data).enter().append("g").attr("class",
				"u");

		cs = gs.append("circle").attr("cx", 0).attr("cy", 0).attr("r", 5).attr(
				'stroke-width', 1).attr('stroke', 'black').attr('fill',
				'rgb(100,100,255)');

		if (labels.length > 0) {
			ts = gs.append("text").attr("text-anchor", "top").attr("transform",
					"translate(5, -5)").attr("font-size", 12).attr("fill",
					"#333").text(function(d, i) {
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
			var cost = T.step(); // do a few steps
			$("#cost").html("iteration " + T.iter + ", cost: " + cost);
		}
		updateEmbedding();
	}

	labels = [];

	function preProLabels() {
		var txt = $("#inlabels").val();
		var lines = txt.split("\n");
		labels = [];
		for (var i = 0; i < lines.length; i++) {
			var row = lines[i];
			if (!/\S/.test(row)) {
				// row is empty and only has whitespace
				continue;
			}
			labels.push(row);
		}
	}

	dataok = false;

	function preProData() {
		var txt = $("#incsv").val();
		var d = $("#deltxt").val();
		var lines = txt.split("\n");
		var raw_data = [];
		var dlen = -1;
		dataok = true;
		for (var i = 0; i < lines.length; i++) {
			var row = lines[i];
			if (!/\S/.test(row)) {
				// row is empty and only has whitespace
				continue;
			}
			var cells = row.split(d);
			var data_point = [];
			for (var j = 0; j < cells.length; j++) {
				if (cells[j].length !== 0) {
					data_point.push(parseFloat(cells[j]));
				}
			}
			var dl = data_point.length;
			if (i === 0) {
				dlen = dl;
			}
			if (dlen !== dl) {
				// TROUBLE. Not all same length.
				console.log('TROUBLE: row ' + i + ' has bad length ' + dlen);
				dlen = dl; // hmmm... 
				dataok = false;
			}
			raw_data.push(data_point);
		}
		data = raw_data; // set global
	}

	dotrain = true;
	iid = -1;
	$(window)
			.load(
					function() {

						initEmbedding();

						$("#stopbut").click(function() {
							dotrain = false;
						});

						$("#inbut")
								.click(
										function() {

											initEmbedding();
											preProData();
											if (!dataok) { // this is so terrible... globals everywhere #fasthacking #sosorry
												alert('there was trouble with data, probably rows had different number of elements. See console for output.');
												return;
											}
											preProLabels();
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
												dim : data[0].length
											};
											T = new tsnejs.tSNE(opt); // create a tSNE instance

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

</head>

<body>

	<div class="container">

		<h1 style="text-align: center;">t-SNE CSV web demo</h1>
	</div>
	<div class="container hidden">
		<div class="row">
			<div class="col-sm-4">
				Delimiter (default is comma (CSV)): <input type="text" id="deltxt"
					maxlength="3" value="," style="width: 20px;"> <br>
				Learning rate: <input type="text" id="lrtxt" maxlength="10"
					value="10" style="width: 40px;"> Perplexity: <input
					type="text" id="perptxt" maxlength="10" value="30"
					style="width: 40px;"> <br>
			</div>
			<div class="col-sm-4">

				My data is:
				<form action="" id="datatypeform">
					<input type="radio" name="rdata" value="raw" checked> Raw
					NxD data (each row are features)<br>
				</form>
			</div>
			<div class="col-sm-4">

				<form action=""></form>

			</div>
		</div>
	</div>

	<div class="container">
		<button type="button" id="inbut" class="btn btn-primary"
			style="width: 200px; height: 50px;">Run t-SNE!</button>
		<button type="button" id="stopbut" class="btn btn-danger"
			style="width: 200px; height: 50px;">Stop</button>

		<br>

		<div id="cost" style="text-align: left; font-family: Impact;"></div>
		<div id="embed"></div>

	</div>


</body>

</html>