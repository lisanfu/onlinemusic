package Pluto;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import Pluto.DBConnection;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class upload extends ActionSupport {

	private String title;
	private String singer;
	private String special;
	private String path;
	private String value;

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getSinger() {
		return singer;
	}

	public void setSinger(String singer) {
		this.singer = singer;
	}

	public String getSpecial() {
		return special;
	}

	public void setSpecial(String special) {
		this.special = special;
	}

	@Override
	public String execute() throws Exception {
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpSession session = ServletActionContext.getRequest().getSession();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);

		String filePath = request.getParameter("path");
		if (function.isInvalid(title) || function.isInvalid(singer)
				|| function.isInvalid(special) || function.isInvalid(path)) {
			out.println(function.PlutoJump("任何一项都不能为空！", "upload.jsp?path="
					+ filePath));
		} else {
			// 获取文件后缀
			filePath = filePath.replace("upload", "upload\\");
			DBConnection conn = new DBConnection();
			long time = new Date().getTime();

			if (conn
					.execute("insert into music(title,singer,special,value,time,click,url) values('"
							+ title
							+ "','"
							+ singer
							+ "','"
							+ special
							+ "','"
							+ value + "','" + time + "',0,'" + filePath + "')")) {

				// 添加TIP

				String tip = "[" + session.getAttribute("PlutoUser").toString()
						+ "] 分享了歌曲 [" + title + "]";
				conn.execute("insert into tip(value) values('" + tip + "')");
				out.println(function.PlutoJump("提交成功！", "index.jsp"));

			} else {
				out.println(function.PlutoJump("提交失败！", "upload.jsp?path="
						+ filePath));
			}
		}
		return null;
	}

}
