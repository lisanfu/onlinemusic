package Pluto;

import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class sendmusic extends ActionSupport {
	private String to;
	private String value;
	private String hidename;
	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getHidename() {
		return hidename;
	}

	public void setHidename(String hidename) {
		this.hidename = hidename;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String execute() throws Exception {
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		HttpServletRequest request = ServletActionContext.getRequest();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);
		String userName = ServletActionContext.getContext().getSession().get(
				"PlutoUser").toString();

		if (function.isInvalid(to)) {
			out.println(function.PlutoJump("你要发给谁呢？？", "index.jsp"));
		}

		if (function.isInvalid(value)) {
			value = "这家伙很懒，什么都没有留下！";
		}

		DBConnection conn = new DBConnection();

		ResultSet to_rs = conn.executeQuery("select id,name from user where name='"
				+ to + "'");
		if (to_rs.next()) {
			String to_id = to_rs.getString("id");
			String to_name = to_rs.getString("name");
			if(to_name.equals(userName)){
				out.println(function.PlutoJump("不能给自己点歌！", "index.jsp"));
			}
			if ("true".equals(hidename)) {
				userName = "匿名";
			}
			ResultSet music_rs = conn
					.executeQuery("select title,url from music where id=" + id
							+ "");
			music_rs.next();
			int rd_id = new Random().nextInt(9999);
			String music_title = music_rs.getString("title");
			String music_url = music_rs.getString("url");
			music_url = music_url.replace("upload\\", "upload\\\\");
			String title = "[" + userName + "]为您点播了一首[" + music_title + "]";
			String message_value = "<p>他（她）给您的留言：" + value + "</p>";
			message_value += "<p>您可以点击下面的播放器进行试听！<br />";
			message_value += "<object type=\"application/x-shockwave-flash\"	data=\"player/audioplayer.swf\" width=\"290\" height=\"24\"	id=\"audioplayer"
					+ rd_id
					+ "\">	<param name=\"movie\" value=\"player/audioplayer.swf\" /><param name=\"FlashVars\" value=\"playerID="
					+ rd_id
					+ "&soundFile="
					+ music_url
					+ "\" />	<param name=\"quality\" value=\"high\" /><param name=\"menu\" value=\"false\" /><param name=\"wmode\" value=\"transparent\" /></object><br />";
			long time = new Date().getTime();
			boolean insert = conn
					.execute("insert into message(`from`,`to`,`title`,`value`,`time`,`new`) values('"
							+ userName
							+ "',"
							+ to_id
							+ ",'"
							+ title
							+ "','"
							+ message_value + "','" + time + "',1)");
			if (insert) {
				out.println(function.PlutoJump("点播成功！", "index.jsp"));
			} else {
				out.println(function.PlutoJump("点播失败！", "index.jsp"));
			}
		} else {
			out.println(function.PlutoJump("你要发给谁呢？？", "index.jsp"));
		}
		return null;
	}
}
