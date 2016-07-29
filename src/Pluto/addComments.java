package Pluto;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class addComments extends ActionSupport {
	private String name;
	private String comments;
	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String execute() throws IOException {
		ServletActionContext.getResponse().setCharacterEncoding("UTF-8");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);

		if (name == null || function.isInvalid(comments)
				|| function.isInvalid(id)) {
			out.println("非法访问！");
			return null;
		} else {
			
			//comments = Escape.unescape(comments);
			
			if ("".equals(name)) {
				name = "游客";
			}
			long time = new Date().getTime();

			DBConnection conn = new DBConnection();
			boolean insert = conn
					.execute("insert into comments(value,name,music_id,time) values('"
							+ comments
							+ "','"
							+ name
							+ "',"
							+ id
							+ ",'"
							+ time
							+ "')");
			if (insert) {
				out.println("评论添加成功！");
			} else {
				out.println("评论添加失败！");
			}
		}
		return null;
	}
}
