package Pluto;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class register extends ActionSupport {
	private String userName = null;
	private String userPwd = null;
	private String confirmPwd = null;

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

	public String getConfirmPwd() {
		return confirmPwd;
	}

	public void setConfirmPwd(String confirmPwd) {
		this.confirmPwd = confirmPwd;
	}

	public String execute() throws SQLException, IOException{
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);
		if(function.isInvalid(userName) || function.isInvalid(userPwd) || function.isInvalid(confirmPwd)){
			out.println(function.PlutoJump("用户名或密码输入错误！", "index.jsp"));
		}
		if(!userPwd.equals(confirmPwd)){
			out.println(function.PlutoJump("两次输入的密码不一致！", "index.jsp"));
		}
		DBConnection conn = new DBConnection();
		ResultSet rs = conn.executeQuery("select * from user where name = '"+userName+"'");
		if(rs.next()){
			out.println(function.PlutoJump("用户名已存在！", "index.jsp"));
		}else{
			boolean insert = conn.execute("insert into user(name,pwd) values('"+userName+"','"+function.MD5Encode(userPwd)+"')");
			if(insert){
				out.println(function.PlutoJump("注册成功，请登陆！", "index.jsp"));
			}else{
				out.println(function.PlutoJump("注册失败！", "index.jsp"));
			}
		}
		return null;
	}
}
