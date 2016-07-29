<%@ page language="java" import="java.util.*,java.sql.*,Pluto.function"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	if (session.getAttribute("PlutoUser") != null) {
		int nowpage = function.strToInt(request.getParameter("page"));
		int pagesize = 20; //每页容纳的条数
		int limit = 0; //从多少条开始
		int maxPage = 0; //一共多少页
		if (nowpage != 0) {
			limit = (nowpage - 1) * pagesize;
		} else {
			nowpage = 1;
		}
		String userName = session.getAttribute("PlutoUser").toString();
		ResultSet user_rs = conn
				.executeQuery("select id,music_box from user where name = '"
						+ userName + "'");
		user_rs.next();

		String id = user_rs.getString("id");
		ResultSet message_rs = conn
				.executeQuery("select count(id) as count from message where `to` ="
						+ id + " and `new` = 1");
		message_rs.next();
		int myMessage = message_rs.getInt("count");
		String music_box = user_rs.getString("music_box");
		if (function.isInvalid(music_box)) {
			out.println(function.PlutoJump("对不起，您的音乐盒中没有任何音乐，请先添加！",
					"index.jsp"));
		} else {
			String[] music_box_arr = music_box.split(",");
			int count = music_box_arr.length;
			maxPage = (count % pagesize == 0) ? (count / pagesize)
					: (count / pagesize + 1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>OnlineMusic</title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<script type="text/javascript" src="js/audioplayer.js"></script>
		<link href="css/table.css" rel="stylesheet" type="text/css" />
		<link href="css/page.css" rel="stylesheet" type="text/css" />
		<link href="css/default.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="css/LoadingStatus.css" type="text/css" />
		<link href="css/thickbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
		function selectAll(chk)
		{
			var chk = document.form2.chkAll.checked;
			for (i=0;i<document.all.length;i++) {
				if (document.all[i].name=="list") {
					document.all[i].checked=chk;
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
							我的音乐盒
						</h2>
						<div id="LoadingStatus">
							<img src="images/ajax-loader.gif" />
						</div>
						<div class="entry" id="musicbox">
							<p>
								<%
									if (music_box != null) {
												//音乐盒中存在音乐！
								%>
							
							<form method="post" name="form2" id="form2"
								action="setbox.action">
								<TABLE width="100%" align="center" class="mytable">
									<THEAD>
										<TR class=odd>
											<TH scope=col width="5">
												ID
											</TH>
											<TH scope=col>
												歌曲
											</TH>
											<TH scope=col>
												歌手
											</TH>
											<TH scope=col>
												试听
											</TH>
											<TH scope=col>
												<input type="checkbox" name="chkAll" value="" title="全选/取消"
													onclick="selectAll();" />
											</TH>
										</TR>
									</THEAD>
									<TFOOT></TFOOT>
									<%
										int maxSong = limit + pagesize;
													for (int i = limit; i < maxSong; i++) {
														try {
															ResultSet music_rs = conn
																	.executeQuery("select title,singer,url from music where id="
																			+ music_box_arr[i] + "");
															music_rs.next();
															String title = music_rs.getString("title");
															String singer = music_rs.getString("singer");
															String url = music_rs.getString("url");
															if (i % 2 == 0) {
																out.println("<TBODY><TR>");
															} else {
																out.println("<TBODY><TR class=odd>");
															}
															out
																	.println("<TD>" + music_box_arr[i]
																			+ "</TD>");
															out.println("<TD>" + title + "</TD>");
															out.println("<TD>" + singer + "</TD>");
															Random rd = new Random();
															int rd_id = rd.nextInt(9999);
															String player = "<object type=application/x-shockwave-flash data=player/audioplayer.swf width=200 height=15 id=audioplayer"
																	+ rd_id
																	+ "> <param name=movie value=player/audioplayer.swf /><param name=FlashVars value=playerID="
																	+ rd_id
																	+ "&soundFile="
																	+ url
																	+ " /><param name=quality value=high /><param name=menu value=false /><param name=wmode value=transparent /></object>";
															out.println("<TD>" + player + "</TD>");
															out
																	.println("<TD><input type=\"checkbox\" name=\"list\" id=\"list"
																			+ music_box_arr[i]
																			+ "\" value=\""
																			+ music_box_arr[i] + "\"></TD>");
														} catch (Exception e) {
															//数组越界就跳过

														}
													}
													out.println("</TBODY></TABLE>");
													boolean noAjax = false;
													out.println("<div class=\"yahoo2\">"
															+ function.page(maxPage, nowpage, pagesize,
																	"musicbox.jsp", noAjax)
															+ "</div><br />");
													out
															.println("<div align=center> <label>选中项：<select name=select id=select class=width_100> <option value=play>播放</option><option value=del>删除</option> </select> </label> <label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type=\"submit\"  value=提交> </label>  </div></FORM>");
													out.println("");
												} else {
													out.println("对不起，暂时您的音乐盒中没有任何音乐！");
												}
									%>

									<p class="meta">

									</p>
									</div>
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
	}
	} else {
		out.println(function.PlutoJump("请登陆后再访问!", "index.jsp"));
	}
%>
