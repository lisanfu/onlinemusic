package Pluto;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;
import Pluto.DBConnection;
import Pluto.function;

public class login extends ActionSupport {
	private String userName;
	private String userPwd;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String execute() throws IOException, SQLException {
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		HttpSession session = ServletActionContext.getRequest().getSession();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);
		if (function.isInvalid(userName) || function.isInvalid(userPwd)) {
			out.println(function.PlutoJump("用户名或密码不能为空", "index.jsp"));
		} else {
			session.setAttribute("PlutoUser", userName);
			userPwd = function.MD5Encode(userPwd);
			DBConnection conn = new DBConnection();
			ResultSet rs = conn
					.executeQuery("select * from user where name = '"
							+ session.getAttribute("PlutoUser").toString()
							+ "' and pwd = '" + userPwd + "'");
			if (rs.next()) {
				out
						.println("<script language='javascript'>location.href='index.jsp';</script>");
			} else {
				session.removeAttribute("PlutoUser");
				out.println(function.PlutoJump("用户名密码错误", "index.jsp"));
			}
		}
		return null;
	}
}
