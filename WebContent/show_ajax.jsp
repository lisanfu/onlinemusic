<%@ page language="java"
	import="java.util.*,java.sql.*,Pluto.function,java.util.Date,java.text.SimpleDateFormat;"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<TABLE width="80%" align="center" class="mytable">

	<%
		response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
		response.setHeader("Cache-Control",
				"no-store, no-cache, must-revalidate");
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		response.setHeader("Pragma", "no-cache");
		int id = function.strToInt(request.getParameter("id"));
		int nowpage = function.strToInt(request.getParameter("page"));
		int pagesize = 10; //每页容纳的条数
		int limit = 0; //从多少条开始
		int maxPage = 0; //一共多少页
		if (nowpage != 0) {
			limit = (nowpage - 1) * pagesize;
		} else {
			nowpage = 1;
		}
		ResultSet rs = conn
				.executeQuery("select count(id) as count from comments where music_id = "
						+ id + "");
		rs.next();
		int count = rs.getInt("count");
		maxPage = (count % pagesize == 0) ? (count / pagesize) : (count
				/ pagesize + 1);
		rs.close();
		rs = conn.executeQuery("select * from comments where music_id="
				+ id + " LIMIT " + limit + "," + pagesize + "");
		if (rs.next()) {
			do {
				String value = rs.getString("value");
				String name = rs.getString("name");
				long time = rs.getLong("time");
				Date date = new Date(time);
				SimpleDateFormat sdf = new SimpleDateFormat(
						"yyyy年MM月dd日 HH:mm:ss");
				String comments_time = sdf.format(date);
	%>
	<TBODY>
		<TR class=odd>
			<TD>
				<div align="left">
					[<%=name%>] 发表于
					<%=comments_time%>
				</div>
			</TD>
		</TR>
	</TBODY>
	<TFOOT></TFOOT>
	<TBODY>
		<TR>
			<TD>
				<div align="left">
					<%=value%>
				</div>
			</TD>
		</TR>
	</TBODY>
	<%
		} while (rs.next());
			out.println("</TABLE>");
			out
					.println("<div class=\"yahoo2\">"
							+ function.page(maxPage, nowpage, pagesize,
									"show_ajax.jsp?id=" + id + "")
							+ "</div><br />");
		} else {
	%>
	<TBODY>
		<TR class=odd>
			<TD>
				<div align="left">
					对不起，暂无任何评论！
				</div>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<%
	}
%>

