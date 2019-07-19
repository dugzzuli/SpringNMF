<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!doctype html>
<html>

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
		<title>默认样式</title>
		<link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css" />
		<style>
			html,
			body,
			#container {
				height: 100%;
				width: 100%;
				overflow:hidden;
			}
		</style>
	</head>

	<body>
		<div id="container"></div>
		<div class="info">
			<div id="centerCoord">显示.....</div>
			<div id="tips"></div>
		</div>
		<div id="container"></div>
		<div class="input-card">
			<label style='color:grey'>灾害预测</label>
			<div class="input-item">
				<div class="input-item-prepend">
					<span class="input-item-text">名称:</span>
				</div>
				<input id='district' type="text" value='朝阳区'>

			</div>
			<input id="addMarers" type="button" class="btn" value="添加标记" />
			<input id="draw" type="button" class="btn" value="灾害预测" />
		</div>

	</body>

</html>
<script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.15&key=c9272cc38b1ed417b253c8ed614858be&plugin=AMap.MouseTool"></script>
 <script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>
<script type="text/javascript">
	var lnglat = new AMap.LngLat(116.397, 39.918);

	var map = new AMap.Map("container", {
		center: lnglat,
		zoom: 4,
		resizeEnable: true
	});

	//创建右键菜单
	var contextMenu = new AMap.ContextMenu();

	//右键放大
	contextMenu.addItem("放大一级", function() {
		map.zoomIn();
	}, 0);

	//右键缩小
	contextMenu.addItem("缩小一级", function() {
		map.zoomOut();
	}, 1);

	//右键显示全国范围
	contextMenu.addItem("缩放至全国范围", function(e) {
		map.setZoomAndCenter(4, [108.946609, 34.262324]);
	}, 2);

	//右键添加Marker标记
	contextMenu.addItem("添加标记", function(e) {
		var marker = new AMap.Marker({
			map: map,
			position: contextMenuPositon //基点位置
		});
	}, 3);

	//地图绑定鼠标右击事件——弹出右键菜单
	map.on('rightclick', function(e) {
		contextMenu.open(map, e.lnglat);
		contextMenuPositon = e.lnglat;
	});

	//  contextMenu.open(map, lnglat);

	$("#draw").click(function() {

		map.clearMap(); // 清除地图覆盖物

		var markers = [{
			icon: '//a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-1.png',
			position: [106.205467, 39.907761]
		}, {
			icon: '//a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-2.png',
			position: [76.368904, 39.913423]
		}, {
			icon: '//a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-3.png',
			position: [116.305467, 39.807761]
		}];
		addMarker(markers);

	});

	function addMarker(markers) {
		// 添加一些分布不均的点到地图上,地图上添加三个点标记，作为参照
		markers.forEach(function(marker) {
			new AMap.Marker({
				map: map,
				icon: marker.icon,
				position: [marker.position[0], marker.position[1]],
				offset: new AMap.Pixel(-13, -30)
			}).setLabel({
				offset: new AMap.Pixel(20, 20), //设置文本标注偏移量
				content: "<div>我</div>", //设置文本标注内容
				direction: 'right' //设置文本标注方位
			});
		});

		var newCenter = map.setFitView();

	}
	$("#addMarers").click(function() {

		var driveUri = "http://restapi.amap.com/v3/config/district?key=c9272cc38b1ed417b253c8ed614858be&keywords=" + $("#district").val()+"&subdistrict=0&extensions=base";
		$.get(driveUri, {}, function(data) {
			console.log(data.districts[0].center);
			var cen = data.districts[0].center
			var arr = cen.split(',')
			new AMap.Marker({
				map: map,
				icon: '//a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-1.png',
				position: [arr[0], arr[1]],
				offset: new AMap.Pixel(-13, -30)
			}).setLabel({
				offset: new AMap.Pixel(20, 20), //设置文本标注偏移量
				content: "<div>我</div>", //设置文本标注内容
				direction: 'right' //设置文本标注方位
			});
		});
	});
	
	
	 AMap.plugin(['AMap.ToolBar'], function() {
        map.addControl(new AMap.ToolBar({
            map: map
        }));
    });
    
    
    function addDIYMarker()
    {
    	AMapUI.loadUI(['overlay/SimpleMarker'], function(SimpleMarker) {

        var lngLats = getGridLngLats(map.getCenter(), 5, 5);

        new SimpleMarker({
            iconLabel: '1',
            //自定义图标地址
            iconStyle: '//webapi.amap.com/theme/v1.3/markers/b/mark_r.png',

            //设置基点偏移
            offset: new AMap.Pixel(-19, -60),

            map: map,

            showPositionPoint: true,
            position: lngLats[0],
            zIndex: 100
        });

        new SimpleMarker({
            iconLabel: '2',
            //自定义图标节点(img)的属性
            iconStyle: {

                src: '//webapi.amap.com/theme/v1.3/markers/b/mark_b.png',
                style: {
                    width: '20px',
                    height: '30px'
                }
            },

            //设置基点偏移
            offset: new AMap.Pixel(-10, -30),

            map: map,
            showPositionPoint: true,
            position: lngLats[1],
            zIndex: 200
        });

        new SimpleMarker({
            iconLabel: '3',
            //自定义图标节点(img)的属性
            iconStyle: {

                src: '//webapi.amap.com/theme/v1.3/markers/b/mark_b.png',
                style: {
                    width: '20px',
                    height: '60px'
                }
            },

            //设置基点偏移
            offset: new AMap.Pixel(-10, -60),

            map: map,
            showPositionPoint: true,
            position: lngLats[2]
        });

        new SimpleMarker({
            iconLabel: '4',
            //直接设置html(需要以"<"开头并且以">"结尾)
            iconStyle: '<div style="background:red;width:20px;height:60px;"></div>',

            //设置基点偏移
            offset: new AMap.Pixel(-10, -60),

            map: map,
            showPositionPoint: true,
            position: lngLats[3]
        });

        new SimpleMarker({
            iconLabel: '5',
            //直接使用dom节点
            iconStyle: document.getElementById('myIcon'),

            //设置基点偏移
            offset: new AMap.Pixel(-10, -60),

            map: map,
            showPositionPoint: true,
            position: lngLats[4]
        });
    });
    }
    
    
     /**
     * 返回一批网格排列的经纬度

     * @param  {AMap.LngLat} center 网格中心
     * @param  {number} colNum 列数
     * @param  {number} size  总数
     * @param  {number} cellX  横向间距
     * @param  {number} cellY  竖向间距
     * @return {Array}  返回经纬度数组
     */
    function getGridLngLats(center, colNum, size, cellX, cellY) {

        var pxCenter = map.lnglatToPixel(center);

        var rowNum = Math.ceil(size / colNum);

        var startX = pxCenter.getX(),
            startY = pxCenter.getY();

        cellX = cellX || 70;

        cellY = cellY || 70;


        var lngLats = [];

        for (var r = 0; r < rowNum; r++) {

            for (var c = 0; c < colNum; c++) {

                var x = startX + (c - (colNum - 1) / 2) * (cellX);

                var y = startY + (r - (rowNum - 1) / 2) * (cellY);

                lngLats.push(map.pixelToLngLat(new AMap.Pixel(x, y)));

                if (lngLats.length >= size) {
                    break;
                }
            }
        }
        return lngLats;
    }
    </script>
</script>