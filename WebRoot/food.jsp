<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>My JSP 'food.jsp' starting page</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		<script type="text/javascript">
function sendAjax(url,methodType,param,returnFuntion){
	var xmlhttp=null;
	//兼容所有的浏览器创建XHR对象
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp = new XMLHttpRequest();
	} else {// code for IE6, IE5
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	//回调函数
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			returnFuntion(xmlhttp.responseText);
		}
	}
	if(methodType=="get" || methodType=="GET"){
		xmlhttp.open("GET",url+"?"+param,true);
		xmlhttp.send();
	}else{
		xmlhttp.open("POST",url,true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded;charset=UTF-8");
		xmlhttp.send(param);
	}
}
//无刷新，获取数据，数据通过dom方式添加到table中
//ajax（异步 JavaScript 和 XML）
function query() {
	var foodName=document.getElementsByName("foodName")[0].value;
	sendAjax("${pageContext.request.contextPath}/queryFoodList","GET","foodName="+foodName,function(responseText){
		//返回的是字符串的json
		var resultJson = responseText;
		//转换为js对象
		var resultObj = JSON.parse(resultJson);
		//获取表格对象
		var table = document.getElementById("myTable");
		//将所有名字为dataTr的tr全部删除
		var allDataTr=document.getElementsByName("dataTr");
		for(var i=0;i<allDataTr.length;i++){
			table.removeChild(allDataTr[0]);
		}
		//根据json的行数追加多个tr
		for(var i=0;i<resultObj.length;i++){
			var obj=resultObj[i];
			var td=document.createElement("td");
			td.innerText=obj.foodname;
			var td1=document.createElement("td");
			td1.innerText=obj.price;
			var td2=document.createElement("td");
			//删除按钮
			var ib=document.createElement("button");
			ib.innerText="删除";
			//修改按钮
			var ib1=document.createElement("button");
			ib1.innerText="修改";
			td2.appendChild(ib);
			td2.appendChild(ib1);
			var tr=document.createElement("tr");
			//将当前行的json对象绑定到当前按钮上
			ib.foodObj=obj;
			////将当前行的tr绑定到当前按钮上
			ib.myLineTr=tr;
			//删除按钮事件
			ib.addEventListener("click",function(){
				//获取当前按钮
				var eventSrc=event.srcElement;
				//删除当前行，发送ajax请求到后台，删除数据库
				table.removeChild(eventSrc.myLineTr);
				sendAjax("${pageContext.request.contextPath}/food/"+ib.foodObj.foodid,"POST","_method=delete",function(responseText){
					if(responseText==1){
						alert("删除成功");
					}else{
						alert("删除失败");
					}
					
				});
			});
			ib1.foodObj=obj;
			ib1.addEventListener("click",function(){
				var eventSrc=event.srcElement;
				document.getElementById('updateDiv').style.display='block';
				document.getElementsByName("uMyFoodName")[0].value=eventSrc.foodObj.foodname;
				document.getElementsByName("uMyFoodPrice")[0].value=eventSrc.foodObj.price;
				document.getElementsByName("uMyFoodId")[0].value=eventSrc.foodObj.foodid;
			});
			tr.setAttribute("name","dataTr");
			tr.appendChild(td);
			tr.appendChild(td1);
			tr.appendChild(td2);
			table.appendChild(tr);
			
		}
	});
		
	
	//open方法表示产生一个请求的关联（get提交）
	/*
	  一个ajax线程是否执行完成，可以通过回调函数是否执行完成来判断
	  异步，多个线程同时执行无法判断谁先执行    true
	  同步，一次只允许一个线程执行    false  造成页面假死
	*/
	/*xmlhttp.open("GET", "${pageContext.request.contextPath}/queryFood?foodname="+foodname, true);
	xmlhttp.send();
	
	xmlhttp.open("POST","${pageContext.request.contextPath}/queryFood",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded;charset=UTF-8");
	xmlhttp.send("foodname="+foodname);*/
}
function saveFood(){
	var myFoodName=document.getElementsByName("myFoodName")[0].value;
	var myFoodPrice=document.getElementsByName("myFoodPrice")[0].value;
	sendAjax("${pageContext.request.contextPath}/food","POST","foodName="+myFoodName+"&price="+myFoodPrice,function(responseText){
		if(responseText==1){
			document.getElementById('addDiv').style.display='none';
			query();
			alert("新增成功");
		}else{
			alert("新增失败");
		}		
	});
}

function updateFood(){
	var uMyFoodName=document.getElementsByName("uMyFoodName")[0].value;
	var uMyFoodPrice=document.getElementsByName("uMyFoodPrice")[0].value;
	var uMyFoodId=document.getElementsByName("uMyFoodId")[0].value;
	sendAjax("${pageContext.request.contextPath}/food"+uMyFoodId,"POST","_method=put&foodName="+uMyFoodName+"&price="+uMyFoodPrice,function(responseText){
		if(responseText==1){
			document.getElementById('updateDiv').style.display='none';
			query();
			alert("修改成功");
		}else{
			alert("修改失败");
		}		
	});
}
</script>
	</head>

	<body>
		<input type="text" name="foodName" />
		<input type="button" value="查询" onclick="query()" />
		<input type="button" value="新增" onclick="document.getElementById('addDiv').style.display='block'" />
		<table id="myTable">
			<tr>
				<th>菜品名</th>
				<th>菜品价格</th>
				<th>操作</th>
			</tr>
		</table>
		<div id="addDiv" style="display: none;border:1px solid black;width:300px;height:150px;position: absolute;left:40%;top:35%">
			菜品名：<input type="text" name="myFoodName" /><br/><br/>
			价&nbsp;&nbsp;&nbsp;格：<input type="text" name="myFoodPrice" /><br/><br/>
			<input type="button" value="添加" onclick="saveFood()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="关闭" onclick="document.getElementById('addDiv').style.display='none'" />
		</div>
		<div id="updateDiv" style="display: none;border:1px solid black;width:300px;height:150px;position: absolute;left:40%;top:35%">
			<input type="hidden" name="uMyFoodId" /><br/>
			菜品名：<input type="text" name="uMyFoodName" /><br/><br/>
			价&nbsp;&nbsp;&nbsp;格：<input type="text" name="uMyFoodPrice" /><br/><br/>
			<input type="button" value="修改" onclick="updateFood()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="关闭" onclick="document.getElementById('updateDiv').style.display='none'" />
		</div>
	</body>
</html>
