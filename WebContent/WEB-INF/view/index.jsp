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

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta name="renderer" content="webkit">
<title>公共安全预警系统</title>
<link rel="icon"
	href="http://puq7bvxwj.bkt.clouddn.com/favicon-20190718110555331.ico"
	type="image/x-icon" id="page_favionc">
<base href="<%=basePath%>" />
<link href="<%=basePath%>lib/layui/css/layui.css" rel="stylesheet" />
<link href="<%=basePath%>lib/animate/animate.min.css" rel="stylesheet" />
<link href="<%=basePath%>lib/font-awesome-4.7.0/css/font-awesome.css"
	rel="stylesheet" />
<link href="<%=basePath%>lib/winui/css/winui.css" rel="stylesheet" />
<style>
body {
	/*在页面顶部加载背景最佳，如有必要这块可以从数据库读取*/
	background-image: url(<%=basePath%>images/bg_01.jpg);
}
</style>

</head>
<body>
	<!-- 桌面 -->
	<div class="winui-desktop"></div>

	<!-- 开始菜单 -->
	<div class="winui-start sp layui-hide">
		<!-- 左边设置 -->
		<div class="winui-start-left">
			<!--   <div class="winui-start-item bottom" data-text="个人中心"><i class="fa fa-user"></i></div> -->
			<div class="winui-start-item winui-start-individuation bottom"
				data-text="主题设置">
				<i class="fa fa-television"></i>
			</div>
			<div class="winui-start-item bottom logout" data-text="注销登录">
				<i class="fa fa-power-off"></i>
			</div>
		</div>
		<!-- 中间导航 -->
		<div class="winui-start-center">
			<div class="layui-side-scroll">
				<ul class="winui-menu layui-nav layui-nav-tree" lay-filter="winuimenu">
				</ul>
			</div>
		</div>
		<!-- 右边磁贴 -->
		<div class="winui-start-right">
			<div class="layui-side-scroll">
				<div class="winui-nav-tile">
					<div class="winui-tilebox">
						<div class="winui-tilebox-head">功能模块</div>
						<div class="winui-tilebox-body">
							<div class="winui-tile winui-tile-normal">
								<i class="fa fa-fw fa-adjust"></i> <span>物理传感</span>
							</div>
						</div>
						<div class="winui-tilebox-body">
							<div class="winui-tile winui-tile-normal">
								<i class="fa fa-fw fa-adjust"></i> <span>网络传感</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 任务栏 -->
	<div class="winui-taskbar">
		<!-- 开始菜单触发按钮 -->
		<div class="winui-taskbar-start sp">
			<i class="fa fa-windows"></i>
		</div>
		<!-- 任务项 -->
		<ul class="winui-taskbar-task"></ul>
		<!-- 任务栏时间 -->
		<div class="winui-taskbar-time"></div>
		<!-- 控制中心 -->
		<div class="winui-taskbar-console sp">
			<i class="fa fa-comment-o"></i>
		</div>
		<!-- 显示桌面 -->
		<div class="winui-taskbar-desktop"></div>
	</div>

	<!--控制中心-->
	<div class="winui-console layui-hide slideOutRight sp">
		<h1>最新通知</h1>
		<div class="winui-message">
			<div class="layui-side-scroll">
				<div class="winui-message-item">
					<h2>马云发来一条信息</h2>
					<div class="content">今天晚上我请客！</div>
				</div>

			</div>
		</div>
		<div class="winui-shortcut">
			<h2>
				<span class="extend-switch sp">展开</span>
			</h2>
			<div class="winui-shortcut-item">
				<i class="fa fa-cog"></i> <span>设置</span>
			</div>
			<div class="winui-shortcut-item">
				<i class="fa fa-cog"></i> <span>设置</span>
			</div>
			<div class="winui-shortcut-item">
				<i class="fa fa-cog"></i> <span>设置</span>
			</div>
			<div class="winui-shortcut-item">
				<i class="fa fa-cog"></i> <span>设置</span>
			</div>
		</div>
	</div>

	<!--layui.js-->
	<script src="<%=basePath%>lib/layui/layui.js"></script>
	<script>
        layui.config({
            base: '<%=basePath%>js/' //指定 index.js 路径
			,
			version : '1.0.1100-beta'
		}).use('index');
        
        function dug(){
        	alert("123");
        }
	</script>
</body>
</html>