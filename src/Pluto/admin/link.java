package Pluto.admin;

import java.io.PrintWriter;

import org.apache.struts2.ServletActionContext;

import Pluto.DBConnection;
import Pluto.function;

import com.opensymphony.xwork2.ActionSupport;

public class link extends ActionSupport {
	private String title;
	private String value;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);

		if (function.isInvalid(title) || function.isInvalid(value)) {
			out.println(function.PlutoJump("请填入网站名称和地址！", "link.jsp"));
		}

		DBConnection conn = new DBConnection();
		boolean insert = conn.execute("insert into link(title,value) values('"
				+ title + "','" + value + "')");
		if(insert){
			out.println(function.PlutoJump("添加成功！", "link.jsp"));
		}else{
			out.println(function.PlutoJump("添加失败！", "link.jsp"));
		}
		return null;
	}

}
