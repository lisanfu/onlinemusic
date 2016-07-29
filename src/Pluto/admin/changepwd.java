package Pluto.admin;

import java.io.PrintWriter;
import java.sql.ResultSet;

import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import Pluto.DBConnection;
import Pluto.function;

import com.opensymphony.xwork2.ActionSupport;

public class changepwd extends ActionSupport {
	private String oldpwd;
	private String newpwd1;
	private String newpwd2;

	public String getOldpwd() {
		return oldpwd;
	}

	public void setOldpwd(String oldpwd) {
		this.oldpwd = oldpwd;
	}

	public String getNewpwd1() {
		return newpwd1;
	}

	public void setNewpwd1(String newpwd1) {
		this.newpwd1 = newpwd1;
	}

	public String getNewpwd2() {
		return newpwd2;
	}

	public void setNewpwd2(String newpwd2) {
		this.newpwd2 = newpwd2;
	}

	@Override
	public String execute() throws Exception {
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);
		String adminName = ServletActionContext.getContext().getSession().get(
				"PlutoAdmin").toString();

		if (function.isInvalid(oldpwd) || function.isInvalid(newpwd1)
				|| function.isInvalid(newpwd2)) {
			out.println(function.PlutoJump("请填写密码！", "changepwd.jsp"));
		}
		if (newpwd1.equals(newpwd2)) {
			DBConnection conn = new DBConnection();
			ResultSet rs = conn
					.executeQuery("select pwd from admin where name = '"
							+ adminName + "'");
			rs.next();
			if (function.MD5Encode(oldpwd).equals(rs.getString("pwd"))) {
				boolean update = conn.execute("update admin set pwd  = '"
						+ function.MD5Encode(newpwd1) + "' where name='"
						+ adminName + "'");
				if (update) {
					out.println(function.PlutoJump("修改成功！", "changepwd.jsp"));
				} else {
					out.println(function.PlutoJump("修改失败！", "changepwd.jsp"));
				}
			} else {
				out.println(function.PlutoJump("旧密码不对！", "changepwd.jsp"));
			}
		} else {
			out.println(function.PlutoJump("两次输入的密码不一致！", "changepwd.jsp"));
		}

		return null;
	}

}
