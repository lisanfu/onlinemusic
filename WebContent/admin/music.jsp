<%@ page language="java" import="java.util.*,Pluto.function,java.sql.*" pageEncoding="utf-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	if (session.getAttribute("PlutoAdmin") != null) {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
		<title>无标题文档</title>
		<style type="text/css">
<!--
.STYLE2 {
	color: #FF0000
}
-->
</style>
	</head>

	<body>
		<table width="80%" border="1" align="center">
			<tr align="center">
				<td >
					<span class="STYLE2">标题（点击进入详细信息）</span>
				</td>
				<td >
					<span class="STYLE2">删除</span>
				</td>
			</tr>
			<%
				ResultSet rs = conn
							.executeQuery("select * from music order by id DESC");
					while (rs.next()) {
						String id = rs.getString("id");
						String title = rs.getString("title");
						out.println("<tr align=\"center\">");
						out.println("<td><a href=\"../show.jsp?id="+id+"\" target=\"_blank\">" + title + "</a></td>");
						out.println("<td><a href=\"admin_delmusic.action?id=" + id
								+ "\">删除</a></td>");
						out.println("</tr>");
					}
			%>
		</table>
		<p align="center">
		</p>
	</body>
</html>
<%
	} else {
		out.println(function.PlutoJump("非法请求或您的登陆已经超时！", "index.jsp"));
	}
%>