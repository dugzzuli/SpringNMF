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
<body style="overflow: hidden;">
	<div class="container">
		<div class="row">
			<div class="col-sm-12 panel panel-default"
				style="border: transparent;">

				<div class="col-sm-4">
					<div class="input-group">
						<!-- 							<input id='location' class="form-control"
								onclick="$('#i-file').click();"> -->
						<label class="input-group-btn"> <input type="button"
							id="i-check" value="加载数据集" class="btn btn-primary"
							onclick="$('#i-file').click();">
						</label> <input type="file" name="file" id='i-file' accept=".mat"
							onchange="$('#location').val($('#i-file').val()); submit()"
							style="display: none">
					</div>

				</div>
				<div class="col-sm-8"></div>
			</div>
			<div class="col-sm-6">
				<div class="col-sm-12 panel panel-default table-responsive">
					<div class="panel-heading">
						<h3 class="panel-title">数据集信息</h3>
					</div>
					<table class="table text-center ">
						<tbody>
							<tr>
								<td>关系:</td>
								<td><span id="relation" style="float: left"> </span></td>
								<td style="display: none;">属性:</td>
								<td style="display: none;"><span id="attributes"
									style="float: left"> </span></td>
							</tr>
							<tr>
								<td>样本:</td>
								<td><span id="sample" style="float: left"></span></td>
								<td>视角:</td>
								<td><span id="view" style="float: left"> </span></td>
							</tr>
						</tbody>
					</table>
				</div>

				
				<div class="col-sm-12 panel panel-default table-responsive">
				<div class="panel-heading">
						<h3 class="panel-title">视角</h3>
					</div>
							<table class="table text-center "> <tr>
								<td colspan="2"><a href="javascript:void(0)"
									onclick="lastView()">上一个视角</a></td>

								<td colspan="2"><a href="javascript:void(0)"
									onclick="nextView()">下一个视角</a></td>

							</tr></table>
					<table id="table-javascript">

					</table>
				</div>
			</div>

			<div class="col-sm-6">
				<div class="col-sm-12 panel panel-default table-responsive">
					<div class="panel-heading">
						<h3 class="panel-title">当前视角信息</h3>
					</div>
					<table class="table text-center ">
						<tbody>
							
							<tr>
								<td>当前视角:</td>
								<td><span id="curView" style="float: left"> </span></td>
								<td>属性:</td>
								<td><span id="curAttributesNum" style="float: left">
								</span></td>
							</tr>

						</tbody>
					</table>

					<div class="panel-heading">
						<h3 class="panel-title">选中属性</h3>
					</div>
					<table
						class="table text-center table-striped table-hover table-condensed">

						<thead>
							<tr>
								<td>统计</td>
								<td>值</td>
							</tr>
						</thead>
						<tbody>

							<tr>
								<td><span>最大值:</span></td>
								<td><span id="zuidazhi"> 2</span></td>
							</tr>
							<tr>
								<td><span> 最小值:</span></td>
								<td><span id="zuixiaozhi"> 2</span></td>
							</tr>
							<tr>
								<td><span> 平均值:</span></td>
								<td><span id="mean"> 2</span></td>
							</tr>
							<tr>
								<td><span> 方差:</span></td>
								<td><span id="std"> 2</span></td>
							</tr>

						</tbody>
					</table>
				</div>


				<div class="col-sm-12 panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">属性可视化</h3>
					</div>
					<div class="panel-body " style="height: 285px;">
						<canvas id="myChart">
							</canvas>
					</div>
				</div>

			</div>


		</div>
	</div>
</body>

</html>
<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
	rel="stylesheet">


<link href="css/lianxi.css" rel="stylesheet">

<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
<script
	src="https://cdn.bootcss.com/Chart.js/2.8.0-rc.1/Chart.bundle.js"></script>
<link
	href="https://cdn.bootcss.com/bootstrap-table/1.15.3/bootstrap-table.css"
	rel="stylesheet">
<script
	src="https://cdn.bootcss.com/bootstrap-table/1.15.3/bootstrap-table.js"></script>
<script
	src="https://cdn.bootcss.com/bootstrap-table/1.15.3/locale/bootstrap-table-zh-CN.js"></script>

<!-- HTML5 shim 和 Respond.js 是为了让 IE8 支持 HTML5 元素和媒体查询（media queries）功能 -->
<!-- 警告：通过 file:// 协议（就是直接将 html 页面拖拽到浏览器中）访问页面时 Respond.js 不起作用 -->
<!--[if lt IE 9]>
      <script src="https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/respond.js@1.4.2/dest/respond.min.js"></script>
    <![endif]-->
</head>
<style>
.container {
	width: 100%;
}

.select {
	width: 105px;
}

div {
	/* border:1px red solid; */
	padding-left: 5px !important;
	padding-right: 5px !important;
}

        body {
	background: #d4d0c8;
}

td, tr {
	border: 1px solid transparent !important;
}
</style>


<script>

$(function(){
	$('#table-javascript').bootstrapTable({
		height : 410,

		minimunCountColumns : 2
	});
});


var GlobalcurView=0;
function submit() {    
    var formData = new FormData();
    var file = document.getElementById("i-file").files[0];
    formData.append("file", file);
    $.ajax({
      url:"<%=basePath%>demo/upload",
      type:"POST",
      data:formData,
      processData : false,
      contentType : false,
      dataType : 'json',
      async : false,
      success : function (result) {
    	  getDatasetattr();
        //成功后的回调事件
        
        $("#curView").html(GlobalcurView);
    	  initTable(GlobalcurView);
    	  getDatasetattr();
    	 
    	  loadAttrDetial(GlobalcurView,0);
    	  getIndexAttrDetail(GlobalcurView,0);
    	  
    	  
      }    
    })  
}
function lastView(){
	GlobalcurView=GlobalcurView-1;
	  initTable(GlobalcurView);
	  getDatasetattr();
	 
	  loadAttrDetial(GlobalcurView,0);
	  getIndexAttrDetail(GlobalcurView,0);
}
function nextView(){
	GlobalcurView=GlobalcurView+1;
	  initTable(GlobalcurView);
	  getDatasetattr();
	 
	  loadAttrDetial(GlobalcurView,0);
	  getIndexAttrDetail(GlobalcurView,0);
	
}
	function getIndexAttrDetail(curView,index){
		 $.ajax({
		      url:"<%=basePath%>demo/getIndexAttrDetail",
		      data:{curView:curView,index:index},
		      type:"get",
		      dataType : 'json',
		      async : false,
		      success : function (result) {
		    	  loadChart(result.label,result.arr)
		        
		      }    
		    })  
	}
	function getDatasetattr(){
		 $.ajax({
		      url:"<%=basePath%>demo/getDataSETAtt",
		      type:"get",
		      dataType : 'json',
		      async : false,
		      success : function (result) {
		    	$("#relation").html(result.datasetname);
		  		$("#sample").html(result.samples);
		  		$("#view").html(result.numViews);
		  		
		        
		      }    
		    })  
	}
	
	function loadAttrDetial(curView,index){
		 $.ajax({
		      url:"<%=basePath%>demo/getIndexDetail",
		      type:"get",
		      data:{curView:curView,index:index},
		      dataType : 'json',
		      async : false,
		      success : function (result) {
		    	$("#zuidazhi").html(result.zuidazhi);
		  		$("#zuixiaozhi").html(result.zuixiaozhi);
		  		$("#mean").html(result.mean);
		  		$("#std").html(result.std);
		  		$("#curAttributesNum").html(result.dim);
		  		
		  		$("#curView").html(parseInt(result.curView));
		  		GlobalcurView=result.curView;
		  		
		        
		      }    
		    })  
	}
	function loadChart(labelsJson, dataJson) {
		var data = {
			//折线图需要为每个数据点设置一标签。这是显示在X轴上。
			labels : labelsJson,
			//数据集（y轴数据范围随数据集合中的data中的最大或最小数据而动态改变的）
			datasets : [ {
				label : '属性曲线图',
				backgroundColor : "#fff", //背景填充色
				borderColor : "#36A2EB", //路径颜色
				pointBackgroundColor : "#36A2EB", //数据点颜色
				pointBorderColor : "#fff", //数据点边框颜色
				data : dataJson
			//对应的值
			} ]
		};
		var c=document.getElementById("myChart");
		var ctx = c.getContext('2d');
		
		ctx.clearRect(0,0,c.width,c.height); 

		var myLineChart = new Chart(ctx, {
			type : 'line',
			data : data,
		});
	}

	function initTable(curView) {

		var queryUrl = "<%=basePath%>demo/getTableJson?rnd=" + Math.random()
				+ '&curView=' + curView;
		$('#table-javascript').bootstrapTable("destroy");
		
		$table = $('#table-javascript').bootstrapTable({

			method : 'get',

			url : queryUrl,

			height : 410,

			striped : true,

			pagination : true,

			pageSize : 8,
			clickToSelect : true,//是否启用点击选中行
			sortable : true, //是否启用排序
			pageList : [ 5, 10, 25, 50, 100, 200 ],
			sidePagination : "client",
			//showColumns : true,

			minimunCountColumns : 2,
			onClickRow : function(row, $element) {
				loadAttrDetial(curView, row.number);
				getIndexAttrDetail(curView, row.number);

			},
			columns : [ {

				field : 'state',

				checkbox : true

			}, {
				field : 'number',
				title : 'Number',//标题  可不加
				align : 'left',
				width : 100,
				formatter : function(value, row, index) {
					return index + 1;
				}
			}, {

				field : 'name',

				title : '属性名称',

				align : 'left',

				valign : 'middle',

				sortable : true

			} ]

		});

	}
</script>