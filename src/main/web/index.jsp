<%--
  Created by IntelliJ IDEA.
  User: chj
  Date: 2016/11/14
  Time: 13:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>metadata</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/echarts.min.js"></script>
    <script type="text/javascript">
        function loadInfo() {
            $("#mbsb").removeClass("active")
            $("#info").removeClass("active")
            $("#info").addClass("active")
            $("#camera").html("")
            $("#content").html("<div class=\"col-md-offset-1 col-md-10 alert alert-info\">各颜色车辆图片数量按月统计图</div>" +
                    "<div id=\"timeinfo\" class=\"col-md-offset-1 col-md-10  thumbnail\" style=\"height: 500px\"></div>")

            $("#content").append("<div id=\"colorinfo\" class=\"col-md-offset-1 col-md-4  thumbnail\" style=\"height: 200px\"></div>" +
                    "<div id=\"typeinfo\" class=\"col-md-offset-1 col-md-4  thumbnail\" style=\"height: 200px\"></div>")
            var myChart = echarts.init(document.getElementById('timeinfo'));
            var option = {
                title: {
                    text: '各颜色车辆图片数量按月统计图'
                },
                tooltip: {},
                legend: {
                    data: ['车辆图片数量']
                },
                xAxis: {
                    data: ["2016年1月", "2016年2月", "2016年3月", "2016年4月", "2016年5月", "2016年6月", "2016年7月", "2016年8月", "2016年9月", "2016年10月", "2016年11月", "2016年12月"]
                },
                yAxis: {},
                series: [{
                    name: '红色',
                    color: 'red',
                    type: 'bar',
                    data: [6610, 6610, 6610, 6610, 6610, 6610, 6610, 6610, 6610, 6610, 6610, 6610]
                },
                    {
                        name: '白色',
                        color: 'white',
                        type: 'bar',
                        data: [29000, 66100, 66100, 66100, 66100, 66100, 66100, 66100, 66100, 66100, 66100, 66100]
                    }]
            };
            myChart.setOption(option);
            var myChart1 = echarts.init(document.getElementById('typeinfo'));
            var option1 = {
                title: {
                    text: 'ECharts 入门示例'
                },
                tooltip: {},
                legend: {
                    data: ['销量']
                },
                xAxis: {
                    data: ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
                },
                yAxis: {},
                series: [{
                    name: '销量',
                    type: 'bar',
                    data: [5, 20, 36, 10, 10, 20]
                }]
            };
            myChart1.setOption(option1);
            var myChart2 = echarts.init(document.getElementById('colorinfo'));
            var option2 = {
                title: {
                    text: 'ECharts 入门示例'
                },
                tooltip: {},
                legend: {
                    data: ['销量']
                },
                xAxis: {
                    data: ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
                },
                yAxis: {},
                series: [{
                    name: '销量',
                    type: 'bar',
                    data: [5, 20, 36, 10, 10, 20]
                }]
            };
            myChart2.setOption(option2);
        }
        function loadCamera() {
            $("#mbsb").removeClass("active")
            $("#info").removeClass("active")
            $("#mbsb").addClass("active")
            $.ajax({
                type: "GET",
                url: "/metadata/v1/camera",
                async: false,
                success: function (data) {
                    for (var key in data) {
                        $("#camera").append("<button  type=\"button\" class=\"btn btn-primary\" onclick='showType(" + data[key] + ")'>" + data[key] + "</button>")
                    }
                },
                dataType: "json"
            });
        }

        function showType(geohash) {
            $("#cameratype").html("")
            $("#time").html("")
            $("#img").html("")
            $("#commit").html("")
            $("#commit2").html("")
            $.ajax({
                type: "GET",
                url: "/metadata/v1/type/" + geohash,
                async: false,
                success: function (data) {
                    $("#time").html("")
                    $("#cameratype").append(" <label for=\"name\">选择属性</label>")
                    $("#cameratype").append("<select class=\"form-control\"  id=\"shuxing\">")
                    $("#cameratype").append("</select >")
                    var Data = data;
                    var flag = false

                    for (var key in Data) {
                        flag = true
                        $("#shuxing").append("<option>" + key + ":" + Data[key] + "</option>");
                    }

                    if (flag) {
                        $("#time").append(" StartTime: <input type=\"datetime-local\" name=\"starttime\" id=\"starttime\"/><br />")
                        $("#time").append(" EndTime: <input type=\"datetime-local\" name=\"endtime\" id=\"endtime\"/><br />")
                        $("#commit").append(" <button  type=\"button\" class=\"btn btn-primary\" onclick='showImg(" + geohash + ",1)'> 按时间进行查询</button><br />")

                        $("#commit2").append(" 查询条件：<input  type=\"text\" id=\"text\"\\><br />")
                        $("#commit2").append(" <button  type=\"button\" class=\"btn btn-primary\" onclick='showImg2(" + geohash + ",1)'> 按条件进行查询</button>")

                    }

                },
                dataType: "json"
            });
        }


        function showImg(geohash, page) {
            var start = document.getElementById('starttime');
            var starttime = new Date(start.value).getTime() / 1000 - 28800;
            var end = document.getElementById('endtime');
            var endtime = new Date(end.value).getTime() / 1000 - 28800;//两边好像不统一，这边快28800

            var name = document.getElementById("shuxing").value.split(":")[0];

            $.ajax({
                type: "GET",
                url: "/metadata/v1/rowkeys?typename=" + name + "&starttime=" + starttime + "&endtime=" + endtime + "&geohash=" + geohash + "&page=" + page,
                async: false,
                success: function (data) {
                    $("#img").html("")
                    var flag = true
                    for (var key in data) {
                        if (flag) {
                            $("#img").append("<p>共有" + data[key] + "条满足条件的结果</p>")
                            $("#img").append("<button  type=\"button\" class=\"btn btn-primary\" onclick=\"download(" + "\'" + name + "\'" + "," + starttime + "," + +endtime + "," + +geohash + ")\"> 下载全部照片</button>")
                            $("#img").append("<ul class=\"pager\">" +
                                    "<li class=\"previous disabled\"><a onclick=\"showImg(" + geohash + "," + (page - 1) + ")\">&larr; Older</a></li>" +
                                    "<li class=\"next\"><a onclick=\"showImg(" + geohash + "," + (page + 1) + ")\">Newer &rarr;</a></li>" +
                                    "</ul>")
                            flag = false
                        }
                        else {
                            $("#img").append("<div class=\"col-sm-4\" style='height: 500px;'>" +
                                    " <a href=\"#\" class=\"thumbnail\"  style='height: 400px;'>" +
                                    " <img src=\"http://10.103.249.190:8080/metadata/v1/image?rowkey=" + data[key].split("`")[0] + " \"border=0 width='300' />" +
                                    "</a><p><a onclick=\"showModal(" + "\'" + data[key].split("`")[1] + "\'" + "," + geohash + ")\">data: " + data[key].split("`")[1] + "</a></p></div>")
                        }
                    }
                },
                dataType: "json"
            });
        }

        function showModal(time, geohash) {
            $("#kuangbody").html("")
            $("#kuangbody").append("<video controls=\"controls\" width=\"550\">" +
                    "<source src=\"http://10.103.249.190:8080/metadata/v1/video?time=" + time + "&geohash=" + geohash + "\" type=\"video/mp4\" />" +
                    "Your browser does not support the video tag." +
                    "</video>")

            $("#kuang").modal('show')
        }

        function download(name, starttime, endtime, geohash) {
            window.open("metadata/v1/download?typename=" + name + "&starttime=" + starttime + "&endtime=" + endtime + "&geohash=" + geohash)
        }

        function showImg2(geohash, page) {
            var start = document.getElementById('starttime');
            var starttime = new Date(start.value).getTime() / 1000 - 28800;
            var end = document.getElementById('endtime');
            var endtime = new Date(end.value).getTime() / 1000 - 28800;//两边好像不统一，这边快28800

            var name = document.getElementById("shuxing").value.split(":")[0];
            var keyword = document.getElementById("text").value;
            $("#img").html("")
            $.ajax({
                type: "GET",
                url: "/metadata/v1/rowkeysfromMap?keyword=" + keyword + "&typename=" + name + "&starttime=" + starttime + "&endtime=" + endtime + "&geohash=" + geohash,
                async: false,
                success: function (data) {
                    for (var key in data) {
                        $("#img").append("<div class=\"col-sm-4\">" +
                                " <a href=\"#\" class=\"thumbnail\">" +
                                " <img src=\"http://10.103.249.190:8080/metadata/v1/image?rowkey=" + data[key] + " \"border=0  />" +
                                "</a> </div>")
                    }
                },
                dataType: "json"
            });
        }
    </script>
</head>

<body>
<div class="container">


    <div class="modal fade" id="kuang">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                    </button>
                    <h4 class="modal-title">视频播放</h4>
                </div>
                <div class="modal-body" id="kuangbody">

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <nav class="navbar navbar-inverse" role="navigation">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">交通监控视频数据存储展示平台</a>
        </div>
        <div>
            <ul class="nav navbar-nav">
                <li class="" id="info"><a onclick="loadInfo()">存储情况概览</a></li>
                <li class="active" id="mbsb"><a onclick="loadCamera()">车辆检索</a></li>
            </ul>
        </div>
    </nav>
    <div class="container">
        <div class="container panel-group" id="content">
        </div>
        <div class="container" id="camera">
            <h4>Camera id:</h4>
        </div>
        <div class="container" id="cameratype">
        </div>

        <div class="container" id="time"></div>
        <div class="container" id="commit"></div>
        <div class="container" id="commit2"></div>
        <div class="container" id="img"></div>

    </div>
</div>


</body>
</html>
