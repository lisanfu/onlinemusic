<%@ page language="java" import="java.util.*,java.sql.*,Pluto.function"
	pageEncoding="UTF-8"%>
<jsp:useBean id="conn" class="Pluto.DBConnection" scope="session" />
<%
	response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control",
			"no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	int nowpage = function.strToInt(request.getParameter("page"));
	int pagesize = 15; //每页容纳的条数
	int limit = 0; //从多少条开始
	int maxPage = 0; //一共多少页
	if (nowpage != 0) {
		limit = (nowpage - 1) * pagesize;
	} else {
		nowpage = 1;
	}
	String userName = session.getAttribute("PlutoUser").toString();
	ResultSet user_rs = conn
			.executeQuery("select music_box from user where name = '"
					+ userName + "'");
	user_rs.next();
	String music_box = user_rs.getString("music_box");
	String[] music_box_arr = music_box.split(",");
	int count = music_box_arr.length;
	maxPage = (count % pagesize == 0) ? (count / pagesize) : (count
			/ pagesize + 1);
%>
<p>
	<%
		if (music_box != null) {
			//音乐盒中存在音乐！
	%>

<form method="post" name="form2" id="form2" action="setbox.action">
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
					<input type="checkbox" name="chkAll" value="" title="全选/取消" onclick="selectAll();">
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
						out.println("<TD>" + music_box_arr[i] + "</TD>");
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
				out.println("<div class=\"yahoo2\">"
      				+ function
      						.page(maxPage, nowpage, pagesize, "musicbox_ajax.jsp")
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