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
    <meta charset="utf-8" />
    <title>多视角聚类分析</title>
    <%--  <base href="<%=basePath%>"> --%>
    <link href="<%=basePath%>lib/layui/css/layui.css" rel="stylesheet" />
    <link href="<%=basePath%>lib/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href="<%=basePath%>lib/winui/css/winui.css" rel="stylesheet" />
    <style>
        ol {
            padding-left: 20px;
        }

            ol > li {
                list-style-type: decimal;
                font-size: 13px;
                color: #444
            }
    </style>
</head>
<body class="winui-window-body">
    <div class="winui-tab" style="height:100%">
        <div class="winui-tab-left" style=" height: 450px;width: 221px;        ">
            <div class="winui-scroll-y" style="height:auto;position:absolute;top:0;bottom:0;">
                <ul class="winui-tab-nav">
                    <li class="winui-this"><i class="fa fa-info-circle fa-fw"></i>数据集</li>
                    <li><i class="fa fa-clock-o fa-fw"></i>多视角聚类</li>
                    <li><i class="fa fa-bug fa-fw"></i>可视化</li>
                </ul>
            </div>
        </div>
        <div class="winui-tab-right" style="left: 202px;">
            <div class="winui-scroll-y">
                <div class="winui-tab-content">
                    <div class="winui-tab-item layui-show">
                       <iframe src="http://localhost:8080/SpringNMF/demo/yangxiao" frameborder=0 style="width:100%; height:500px;" ></iframe>
                    </div>
                    <div class="winui-tab-item">
                        <iframe src="http://localhost:8080/SpringNMF/demo/showDataAnalysis" frameborder=0 style="width:100%; height:700px;"></iframe>
                    </div>
                    <div class="winui-tab-item">
                       <iframe src="http://localhost:8080/SpringNMF/demo/showCluster" frameborder=0 style="width:100%; height:700px;"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="<%=basePath%>lib/layui/layui.js"></script>
    <script type="text/javascript">
        layui.config({
            base: '<%=basePath%>lib/winui/' //指定 winui 路径
        }).use(['winui']);

        window.onload = function () {
            winui.init();
        }
    </script>
</body>
</html>