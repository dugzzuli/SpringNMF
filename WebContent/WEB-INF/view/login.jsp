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
<link href="<%=basePath%>lib/winui/css/login.css" rel="stylesheet" />
<script src="https://code.jquery.com/jquery-2.2.4.min.js"
	integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
	crossorigin="anonymous"></script>
<style>
body {
	/*在页面顶部加载背景最佳，如有必要这块可以从数据库读取*/
	background-image: url(<%=basePath%>images/bg_04.jpg);
}
/* #login_div{
float: right; margin-right: 2%;
} */
</style>

</head>
<body>

	<div class="lock-body_login">
		<div id="login_div" class="animated fadeIn">
			<img src="images/os_windows.png" /> <br>
			<div class="winui-from-group">
				<input name="user" id="user" value="" placeholder="输入用户名"
					height="36" />
			</div>

			<br>
			<div class="winui-from-group">
				<input type="password" name="password" id="pwd" value=""
					placeholder="输入密码" height="36" />
				<button class="login">
					<i class="fa fa-arrow-right"></i>
				</button>
			</div>
			<br>


		</div>
		<div class="version" style="border: none;">
			<p class="">Version:0.01</p>
			<p class="">完成时间:2019-08-05</p>
			<p class="">完成单位:云南大学信息学院</p>
			<p class="">
				项目名称:<br />基于传感数据的公共安全事件预警关键技术研究
			</p>
		</div>
		<div id="date_time" class="animated fadeIn"></div>
	</div>
	<script type="text/javascript">
		var Week = [ '日', '一', '二', '三', '四', '五', '六' ];
		var dateTime = new Date();
		document.getElementById('date_time').innerHTML = '<p id="time">'
				+ (dateTime.getHours() > 9 ? dateTime.getHours().toString()
						: '0' + dateTime.getHours())
				+ ':'
				+ (dateTime.getMinutes() > 9 ? dateTime.getMinutes().toString()
						: '0' + dateTime.getMinutes()) + '</p><p id="date">'
				+ (dateTime.getMonth() + 1) + '月' + dateTime.getDate() + '日,星期'
				+ Week[dateTime.getDay()] + '</p>';
	</script>

	<!--layui.js-->
	<script src="<%=basePath%>js/login.js"></script>

</body>
</html>