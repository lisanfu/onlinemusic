<%@ page language="java"
	import="java.util.*,Pluto.function,java.sql.*,java.util.Date,java.text.SimpleDateFormat;"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	if (session.getAttribute("PlutoUser") != null) {
		String userName = session.getAttribute("PlutoUser").toString();
		ResultSet user_rs = conn
				.executeQuery("select id from user where name = '"
						+ userName + "'");
		user_rs.next();
		String id = user_rs.getString("id");
		ResultSet message_rs = conn
				.executeQuery("select count(id) as count from message where `to` ="
						+ id + " and `new` = 1");
		message_rs.next();
		int myMessage = message_rs.getInt("count");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>OnlineMusic</title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/nicejforms.js"></script>
		<script type="text/javascript" src="js/thickbox.js"></script>
		<link href="css/table.css" rel="stylesheet" type="text/css" />
		<link href="css/default.css" rel="stylesheet" type="text/css" />
		<link href="css/thickbox.css" rel="stylesheet" type="text/css" />
		<style type="text/css" media="screen">
@import url(css/niceforms.css);
</style>
		<script type="text/javascript">
		$(document).ready(function(){
			$.NiceJForms.build()
		});
		
		function selectAll(chk)
		{
			var chk = document.form2.chkAll.checked;
			for (i=0;i<document.all.length;i++) {
				if (document.all[i].name=="list") {
					document.all[i].checked=chk;
					//chkRow(document.all[i]);
				}
			}
		}
		</script>
	</head>
	<body>
		<div id="header">
			<div id="logo">
				<h1>
					OnlineMusic
				</h1>
				<h2>
			
				</h2>
			</div>
			<div id="menu">
				<ul>
					<li class="active">
						<a href="index.jsp" accesskey="1" title="">首页</a>
					</li>
					<li>
						<a href="musicbox.jsp" accesskey="2" title="">音乐盒</a>
					</li>
					<li>
						<a href="message.jsp" accesskey="3" title="">短消息</a>
					</li>
					<li>
						<a href="uploadmusic.jsp" accesskey="3" title="">分享歌曲</a>
					</li>
					<li>
						<a href="player" accesskey="4" title="">播放列表</a>
					</li>
				</ul>
			</div>
		</div>
		<hr />
		<div id="page">
			<div id="bg">
				<div id="content">
					<div class="post">
						<h2 class="title">
							我的短消息！
						</h2>

						<div class="entry">
							<%
								ResultSet rs = conn
											.executeQuery("select * from message where `to` = "
													+ id + "");
									if (rs.next()) {
										int i = 0;
							%>
							<form method="post" name="form2" id="form2"
								action="delmessage.action">
								<TABLE width="100%" align="center" class="mytable">
									<THEAD>
										<TR class=odd>
											<TH scope=col>
												发件人
											</TH>
											<TH scope=col>
												时间
											</TH>
											<TH scope=col>
												标题
											</TH>
											<TH scope=col>
												<input type="checkbox" name="chkAll" value="" title="全选/取消"
													onclick="selectAll();" />
											</TH>
										</TR>
									</THEAD>
									<TFOOT></TFOOT>
									<%
										do {
													String message_id = rs.getString("id");
													String from = rs.getString("from");
													String title = rs.getString("title");
													long time = rs.getLong("time");
													Date date = new Date(time);
													SimpleDateFormat sdf = new SimpleDateFormat(
															"yyyy年MM月dd日 HH:mm:ss");
													String message_time = sdf.format(date);
													int isNew = rs.getInt("new");
													if (i % 2 == 0) {
														out.println("<TBODY><TR>");
													} else {
														out.println("<TBODY><TR class=odd>");
													}
													out.println("<TD>" + from + "</TD>");
													out.println("<TD>" + message_time + "</TD>");
													if (isNew == 1) {
														out
																.println("<TD><strong><a href=showmessage.jsp?id="
																		+ message_id
																		+ "&height=500&width=650 class=\"thickbox\" title=\"查看短消息\"\">"
																		+ title + "</a></strong></TD>");
													} else {
														out
																.println("<TD><a href=showmessage.jsp?id="
																		+ message_id
																		+ "&height=500&width=650 class=\"thickbox\" title=\"查看短消息\"\">"
																		+ title + "</a></TD>");
													}

													out
															.println("<TD><input type=\"checkbox\" name=\"list\" id=\"list"
																	+ message_id
																	+ "\" value=\""
																	+ message_id + "\"></TD>");

												} while (rs.next());
												out.println("</TBODY></TABLE>");
												//boolean noAjax = false;
												//out.println("<div class=\"yahoo2\">"
												//		+ function.page(maxPage, nowpage, pagesize,
												//				"musicbox.jsp", noAjax) + "</div><br />");
												out
														.println("<div align=center>  <input type=\"submit\"  value=删除选中项>  </div></FORM>");
											} else {
												out.println("对不起，您暂时没有任何短消息！");
											}
									%>

									</div>
									<p class="meta">

									</p>
									</div>
									<div class="post">
										<h2 class="title">
											发送短消息！
										</h2>

										<div class="entry">
											<form id="form1" name="form1" method="post"
												action="message.action" class="niceform">
												<label>
													收件人：
													<br />
													<input type="text" name="to" id="textfield" maxlength="16" />
												</label>
												<br />
												<label>
													标 题：
													<br />
													<input type="text" name="title" id="textfield"
														maxlength="16" />
												</label>
												<br />
												<label>
													内容：
													<input type="hidden" />
													<textarea name="value" id="textarea" cols="30" rows="5"></textarea>
												</label>
												<p>
													<br />
													<label>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input type="submit" name="button" id="button" value="提交" />
													</label>
												</p>
											</form>
										</div>
										<p class="meta">

										</p>
									</div>
									</div>
									<!-- end content -->
									<div id="sidebar">
										<div id="about-box" style="font-size: 12px">
											<p>
												<%=session.getAttribute("PlutoUser").toString()%>，欢迎您回来！
											</p>
											<p>
												您有<%=(myMessage == 0) ? (myMessage)
								: ("<font color=red><strong>" + myMessage + "</strong></font>")%>封未读短消息，请
												<a href="message.jsp" style="color: red">查看</a>！
												<br />
												播放我上次创建的
												<a href="player" style="color: red">[播放列表]</a>！
												<br />
												如果您有音乐分享，您可以点我进行
												<a href="uploadmusic.jsp" style="color: red">[上传音乐]</a>！
												<br />
											</p>
											<p>
												退出请点
												<a href="logout.action" style="color: #FF0000">[注销登陆]</a>！
											</p>
										</div>
										<ul>
											<li>
												<h2>
													最新消息
												</h2>
												<ul>
													<%
														ResultSet tip_rs = conn
																	.executeQuery("SELECT * FROM `tip` ORDER BY id DESC LIMIT 10");
															while (tip_rs.next()) {
																String tip = tip_rs.getString("value");
																out.println("<li>");
																out.println(tip);
																out.println("</li>");
															}
													%>
												</ul>
											</li>
											<li>
												<h2>
													友情链接
												</h2>
												<ul>
													<%
														ResultSet link_rs = conn
																	.executeQuery("SELECT * FROM `link` ORDER BY id DESC LIMIT 20");
															while (link_rs.next()) {
																String link_title = link_rs.getString("title");
																String link_value = link_rs.getString("value");
																out.println("<li>");
																out.println("<a href=\"" + link_value + "\">");
																out.println(link_title + "</a>");
																out.println("</li>");
															}
													%>
												</ul>
											</li>
										</ul>
									</div>
									<!-- end sidebar -->
									<div style="clear: both;">
										&nbsp;
									</div>
									</div>
									</div>
									<!-- end page -->
									<hr />
									<div id="footer">
										<p>
											(c) 2008 onlinemusic
										</p>
									</div>
	</body>
</html>
<%
	} else {
		out.println(function.PlutoJump("请登陆后再访问!", "index.jsp"));
	}
%>
