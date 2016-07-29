<%@ page language="java"
	import="java.util.*,Pluto.function,java.sql.*,java.util.Date,java.text.SimpleDateFormat;"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	if (request.getParameter("id") != null) {
		String id = request.getParameter("id");
		conn.execute("update music set click=click+1 where id=" + id
				+ "");
		ResultSet rs = conn
				.executeQuery("select * from music where id = " + id
						+ "");
		if (rs.next()) {
			String title = rs.getString("title");
			String singer = rs.getString("singer");
			String special = rs.getString("special");
			String value = rs.getString("value");
			long time = rs.getLong("time");
			Date date = new Date(time);
			SimpleDateFormat sdf = new SimpleDateFormat(
					"yyyy年MM月dd日 HH:mm:ss");
			String music_time = sdf.format(date);
			String click = rs.getString("click");
			String filePath = rs.getString("url");
			Random rd = new Random();
			int rd_id = rd.nextInt(9999);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>OnlineMusic</title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/jquery.form.js"></script>
		<script type="text/javascript" src="js/nicejforms.js"></script>
		<script type="text/javascript" src="js/audioplayer.js"></script>
		<link href="css/table.css" rel="stylesheet" type="text/css" />
		<link href="css/page.css" rel="stylesheet" type="text/css" />
		<link href="css/default.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="css/LoadingStatus.css" type="text/css" />
		<link href="css/thickbox.css" rel="stylesheet" type="text/css" />
		<style type="text/css" media="screen">
@import url(css/niceforms.css);
</style>
		<script type="text/javascript">
		$(document).ready(function(){
			dopage('show_ajax.jsp?id=<%=id%>');
			$.NiceJForms.build();
			var options = {
				target:        '#message',   //输出信息
				beforeSubmit:  validate,  //验证
				success:       dosuccess,  //成功时回调
				clearForm:	   true,
				timeout:       30000
			};
			$('#myForm').submit(function() {
				$(this).ajaxSubmit(options);
				return false;
			});
		});
		
		function validate(formData, jqForm, options) {
			var Value = $("#valueid").val();
			if (!Value || Value.length<=10) {
				$('#valueTip').html("<font color=\"red\">评论必须大于10个字符！</font>");
				return false;
			}else {
				$('#valueTip').html(" ");
			}
		}
		
		function dosuccess(){
			dopage('show_ajax.jsp?id=<%=id%>');
		}
		
		function addbox(music_id){
			$.ajax({url: 'addtobox.action?music_id=' + music_id,
			type: 'GET',
			dataType: 'html',
			timeout: 30000,
			async : false,
			error: function(){
				alert("出现错误！");
			},
			success: function(html){
				//window.location="#article_md";
				alert(html);
			}
			});
		}
		
		function dopage(ajaxurl){
			$('#LoadingStatus').show();
			$.ajax({url: ajaxurl,
			type: 'GET',
			dataType: 'html',
			timeout: 30000,
			async : false,
			error: function(){$('#comments').html('<table  width="50%" border="0" align="center"> <tr> <td class="center_article" align="center">获取文章失败，请刷新此页面！！！</td></tr></table>');$('#LoadingStatus').hide(500);
			},
			success: function(html){
				//window.location="#article_md";
				$('#LoadingStatus').hide(1000);
				$('#comments').html(html);
			}
			});
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
							<%=title%>
						</h2>
						<h3 class="date">
							<%=music_time%>
						</h3>
						<div class="entry">
							<p>
								试听：
								<object type="application/x-shockwave-flash"
									data="player/audioplayer.swf" width="290" height="24"
									id="audioplayer<%=rd_id%>">
									<param name="movie" value="player/audioplayer.swf" />
									<param name="FlashVars"
										value="playerID=<%=rd_id%>&soundFile=<%=filePath%>" />
									<param name="quality" value="high" />
									<param name="menu" value="false" />
									<param name="wmode" value="transparent" />
								</object>
								<br />
								歌手：
								<%=singer%><br />
								所在专辑：
								<%=special%><br />
								下载：
								<a href="<%=filePath%>"><%=filePath%></a>
								<br />
								<%=value%>
							</p>

						</div>
						<p class="meta">
							<%
								if (session.getAttribute("PlutoUser") != null) {
							%>
							<a href="JavaScript:addbox('<%=id%>');" class="comments">添加到我的音乐盒</a>
							<%
								}
							%>
						</p>
					</div>
					<div class="post">
						<h2 class="title">
							我要留言
						</h2>
						<h3 class="date">
							&nbsp;
						</h3>
						<div class="entry">
							<p>
							<table width="80%" border="0" align="center">
								<tr>
									<td>
										<form id="myForm" name="myForm" method="post"
											action="addcomments.action?id=<%=id%>" class="niceform">
											<label>
												昵称：
												<br />
												<input type="text" name="name" id="textfield" maxlength="16" />
												(不填为游客)
											</label>
											<br />
											<label>
												留言：
												<input type="hidden" />
												<textarea name="comments" id="valueid" cols="20" rows="5"></textarea>
											</label>
											<div id="valueTip"></div>
											<label>
												<br />
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="submit" name="button" id="button" value="提交" />
											</label>
											<div id="message"></div>
										</form>
									</td>
								</tr>
							</table>

						</div>
						<p class="meta">
						</p>
					</div>
					<div id="LoadingStatus">
						<img src="images/ajax-loader.gif" />
					</div>
					<div class="post">
						<h2 class="title">
							最近留言
						</h2>
						<h3 class="date">
							&nbsp;
						</h3>
						<div class="entry" id="comments">
							<p>
							</p>
						</div>
						<p class="meta">
						</p>
					</div>
				</div>
				<!-- end content -->
				<div id="sidebar">
					<div id="about-box" style="font-size: 12px">
						<p>
							<%
								if (session.getAttribute("PlutoUser") == null) {
							%>
						
						<form action="login.action" method="post" class="niceform">
							<label for="textinput">
								&nbsp;&nbsp;用户名：
							</label>
							<br />
							&nbsp;&nbsp;
							<input type="text" id="textinput" name="userName" size="15"
								maxlength="16" />
							<br />
							<label for="passwordinput">
								&nbsp;&nbsp;密 码：
							</label>
							<br />
							&nbsp;&nbsp;
							<input type="password" id="passwordinput" name="userPwd"
								size="15" maxlength="16" />
							<br />
							<br />
							&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="register.jsp?height=175&width=300&modal=true"
								class="thickbox" title="我要注册">我要注册</a> &nbsp;&nbsp;
							<input type="submit" value="登  陆" />

						</form>


						<p></p>
						<%
							} else {
						%>
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
							您有<%=(myMessage==0)?(myMessage):("<font color=red><strong>" + myMessage + "</strong></font>")%>封未读短消息，请
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
						<%
							}
						%>
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
			response.sendRedirect("index.jsp");
		}
	} else {
		response.sendRedirect("index.jsp");
	}
%>
