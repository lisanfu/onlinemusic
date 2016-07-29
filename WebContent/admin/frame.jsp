<%@ page language="java" import="java.util.*,java.sql.*,Pluto.function"
	pageEncoding="UTF-8"%>
<%
if (session.getAttribute("PlutoAdmin")!=null) {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>后台管理</title>
	</head>

	<frameset rows="*" cols="150,*" frameborder="no" border="1"
		framespacing="0">
		<frame src="left.jsp" name="leftFrame" id="index" scrolling="no"
			noresize="noresize" id="leftFrame" title="leftFrame" />
		<frame src="main.jsp" name="MainContent" id="MainContent"
			title="MainContent" />

	</frameset>
	<noframes>
		<body>
		</body>
	</noframes>
</html>
<%
}else {
	out.println(function.PlutoJump("非法请求或您的登陆已经超时！","index.jsp"));
}
%>