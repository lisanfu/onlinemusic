<%@ page language="java" import="java.util.*,Pluto.function,java.sql.*"
	pageEncoding="utf-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	if (session.getAttribute("PlutoAdmin") != null) {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<META http-equiv=Content-Type content="text/html; charset=utf-8">
		<META content="MSHTML 6.00.2900.3157" name=GENERATOR>
		<style type="text/css">
<!--
.STYLE2 {
	color: #FF0000
}
-->
</style>
	</HEAD>
	<BODY>
		<DIV style="TEXT-ALIGN: center">
			<form action="admin_link.action" method="post">
				<TABLE style="MARGIN: 0px auto" cellSpacing=3 cellPadding=3 border=0>
					<TBODY>
						<TR>
							<TD colspan="2">
								<div align="center">
									添加友情连接
								</div>
							</TD>
						</TR>
						<TR>
							<TD>
								&nbsp;
							</TD>
							<TD>
								&nbsp;
							</TD>
						</TR>
						<TR>
							<TD>
								<LABEL>
									网站名称：
								</LABEL>
							</TD>
							<TD>
								<INPUT type="text" name="title" maxlength="16" />
							</TD>
						</TR>
						<TR>
							<TD>
								<LABEL>
									网站地址：
								</LABEL>
							</TD>
							<TD>
								<INPUT type="text" name="value" />
							</TD>
						</TR>
						<TR align=center>
							<TD colSpan=2>
								*网站地址必须以http://开头
							</TD>
						</TR>
						<TR align=right>
							<TD colSpan=2>
								<div align="center">
									<INPUT id=Login type=submit value="确 定">
									&nbsp;
									<INPUT type="reset" value="取 消" />
								</div>
							</TD>
						</TR>
					</TBODY>
				</TABLE>
			</form>
		</DIV>

<table width="80%" border="1" align="center">
			<tr align="center">
				<td >
					<span class="STYLE2">网站名称</span>
				</td>
				<td >
					<span class="STYLE2">网站地址</span>
				</td>
				<td >
					<span class="STYLE2">删除</span>
				</td>
			</tr>
			<%
				ResultSet rs = conn
							.executeQuery("select * from link order by id DESC");
					while (rs.next()) {
						String id = rs.getString("id");
						String title = rs.getString("title");
						String value = rs.getString("value");
						out.println("<tr align=\"center\">");
						out.println("<td>" + title + "</td>");
						out.println("<td>" + value + "</td>");
						out.println("<td><a href=\"admin_dellink.action?id=" + id
								+ "\">删除</a></td>");
						out.println("</tr>");
					}
			%>
		</table>
	</BODY>
</HTML>

<%
	} else {
		out.println(function.PlutoJump("非法请求或您的登陆已经超时！", "index.jsp"));
	}
%>
