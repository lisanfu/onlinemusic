<%@ page language="java" import="java.util.*,Pluto.function,java.sql.*"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	if (session.getAttribute("PlutoUser") != null) {
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
		<script type="text/javascript" src="js/audioplayer.js"></script>
		<link href="css/default.css" rel="stylesheet" type="text/css" />
		<link href="css/thickbox.css" rel="stylesheet" type="text/css" />
		<style type="text/css" media="screen">
@import url(css/niceforms.css);
</style>
		<script type="text/javascript">
		$(document).ready(function(){
			$.NiceJForms.build()
		});
		
		function check(){
			var title = $("#title").val();
			var singer = $("#singer").val();
			var special = $("#special").val();
			var value = $("#value").val();
			if(!title || title.length<1){
				$("#tip").html(" <font color=\"red\">歌曲名称不能为空！</font>");
				return false;
			}else if(!singer || singer.length<1){
				$("#tip").html(" <font color=\"red\">歌手不能为空！</font>");
				return false;
			}else if(!special || special.length<1){
				$("#tip").html(" <font color=\"red\">所属专辑不能为空！</font>");
				return false;
			}else if(!value || value.length<10 || value.length>200){
				$("#tip").html(" <font color=\"red\">简介必须大于10个字符且小于200个字符！</font>");
				return false;
			}else {
				$("#tip").html(" ");
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
							上传音乐第一步（上传音乐）
						</h2>

						<div class="entry">
							<p>
							<form id="form1" name="form1" method="post"
								action="upload.action?path=<%=request.getParameter("path")%>"
								class="niceform" onsubmit="return check();">
								<input type="hidden" name="path"
									value="<%=request.getParameter("path")%>" />
								<table width="80%" border="0" align="center">
									<tr>
										<td height="31">
											<div align="center">
												您的音乐已经上传成功，您可以点下面的播放器进行试听！
											</div>
										</td>
									</tr>
									<tr>
										<td height="10">

										</td>
									</tr>
									<tr>
										<td height="23" align="center">
											<object type="application/x-shockwave-flash"
												data="player/audioplayer.swf" width="290" height="24"
												id="audioplayer7643">
												<param name="movie" value="player/audioplayer.swf" />
												<param name="FlashVars"
													value="playerID=7643&soundFile=<%=request.getParameter("path")%>" />
												<param name="quality" value="high" />
												<param name="menu" value="false" />
												<param name="wmode" value="transparent" />
											</object>
										</td>
									</tr>
									<tr>
										<td height="15">

										</td>
									</tr>
									<tr>
										<td>
											<div align="center">
												歌曲名称：
												<input type="text" name="title" id="title" size="15"
													 />
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div align="center">
												歌&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手：
												<input type="text" name="singer" id="singer" size="15"
													 />
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div align="center">
												所属专辑：
												<input type="text" name="special" id="special" size="15"
													 />
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div align="center">
												简&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;介：
												<input type="hidden" />
												<textarea name="value" id="value" cols="25" rows="6"></textarea>
												<br />
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div align="center" id="tip">

											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div align="center">
												<input type="submit" name="button" id="button" value="提交" />
											</div>
										</td>
									</tr>
								</table>
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
						<%
							String userName = session.getAttribute("PlutoUser").toString();
								ResultSet user_rs = conn
										.executeQuery("select id from user where name = '"
												+ userName + "'");
								user_rs.next();
								String message_id = user_rs.getString("id");
								ResultSet message_rs = conn
										.executeQuery("select count(id) as count from message where `to` ="
												+ message_id + " and `new` = 1");
								message_rs.next();
								int myMessage = message_rs.getInt("count");
						%>
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
