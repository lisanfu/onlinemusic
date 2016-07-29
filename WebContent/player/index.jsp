<%@ page language="java"
	import="java.util.*,Pluto.function,java.sql.*,java.io.*"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control",
			"no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	if (session.getAttribute("PlutoUser") != null) {
		ResultSet rs = conn
				.executeQuery("select id from user where name = '"
						+ session.getAttribute("PlutoUser").toString()
						+ "'");
		rs.next();
		String user_id = rs.getString("id");
		ResultSet message_rs = conn
				.executeQuery("select count(id) as count from message where `to` ="
						+ user_id + " and `new` = 1");
		message_rs.next();
		int myMessage = message_rs.getInt("count");
		String path = request.getSession().getServletContext()
				.getRealPath("player/xml/");
		File f = new File(path, user_id + ".xml");
		if (!f.exists()) {
			out.println(function.PlutoJump("抱歉你从未创建过播放列表！",
					"../index.jsp"));
		} else {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Pluto Music 80.f</title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<link href="../css/default.css" rel="stylesheet" type="text/css" />

	</head>
	<body>
		<div id="header">
			<div id="logo">
				<h1>
					Pluto Music
				</h1>
				<h2>
					80.f
				</h2>
			</div>
			<div id="menu">
				<ul>
					<li class="active">
						<a href="../index.jsp" accesskey="1" title="">首页</a>
					</li>
					<li>
						<a href="../musicbox.jsp" accesskey="2" title="">音乐盒</a>
					</li>
					<li>
						<a href="../message.jsp" accesskey="3" title="">短消息</a>
					</li>
					<li>
						<a href="../uploadmusic.jsp" accesskey="3" title="">分享歌曲</a>
					</li>
					<li>
						<a href="#" accesskey="4" title="">播放列表</a>
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
							我的播放列表
						</h2>
						<div class="entry">
							<p>
							<div align="center">
								<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
									width="300" height="320" id="mp3player"
									codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0">
									<param name="movie"
										value="mp3player.swf?config=config_2.xml&file=xml\<%=user_id%>.xml?<%=new Random().nextInt() %>" />
									<embed
										src="mp3player.swf?config=config_2.xml&file=xml\<%=user_id%>.xml?<%=new Random().nextInt() %>"
										allowScriptAccess="always" width="300" height="320"
										name="mp3player" type="application/x-shockwave-flash"
										pluginspage="http://www.macromedia.com/go/getflashplayer" />
								</object>
							</div>

						</div>
						<p class="meta">

						</p>
					</div>
				</div>
				<!-- end contentn -->
				<div id="sidebar">
					<div id="about-box" style="font-size: 12px">
						<p>
							<%=session.getAttribute("PlutoUser")
											.toString()%>，欢迎您回来！
						</p>
						<p>
							您有<%=(myMessage==0)?(myMessage):("<font color=red><strong>" + myMessage + "</strong></font>")%>封未读短消息，请
							<a href="../message.jsp" style="color: red">查看</a>！
							<br />
							播放我上次创建的
							<a href="#" style="color: red">[播放列表]</a>！
							<br />
							如果您有音乐分享，您可以点我进行
							<a href="../uploadmusic.jsp" style="color: red">[上传音乐]</a>！
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
										out.println("<a href=\""+link_value+"\">");
										out.println(link_title+"</a>");
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
				(c) 2008 Pluto Music All rights reserved. Design by
				Jessica(Www.TankMe.Cn).
			</p>
		</div>
	</body>
</html>
<%
	}
	} else {
		out.println(function.PlutoJump("请登陆后再访问!","../index.jsp"));
	}
%>
