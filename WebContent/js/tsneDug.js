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
	// if (labels.length > 0) {
	// ts = gs.append("text").attr("text-anchor", "top").attr("transform",
	// "translate(5, -5)").attr("font-size", 12).attr("fill", function (d, i) {
	// /* console.log(d); */
	// return colorData[labels[i % colorData.length]];
	// }).text(function (d, i) {
	// return labels[i];
	// });
	// }
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
		url : jsonurl,
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
											perplexity : parseInt($("#perptxt")
													.val()),
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