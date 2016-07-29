package Pluto;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;
import org.jdom.JDOMException;

import com.opensymphony.xwork2.ActionSupport;

public class delmessage extends ActionSupport {
	private String[] list;

	public String[] getList() {
		return list;
	}

	public void setList(String[] list) {
		this.list = list;
	}
	public String execute() throws IOException, SQLException {
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		HttpServletRequest request = ServletActionContext.getRequest();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);
		String userName = ServletActionContext.getContext().getSession().get(
				"PlutoUser").toString();
		if (list == null) {
			out.println(function.PlutoJump("请选择短消息！", "message.jsp"));
		} else {
			DBConnection conn = new DBConnection();
			if (list.length == 1) {
				boolean del = conn.execute("delete from message where id="+list[0]+" limit 1");
				if(del){
					out.println(function.PlutoJump("删除成功！", "message.jsp"));
				}else{
					out.println(function.PlutoJump("删除失败！", "message.jsp"));
				}
			}else {
				String sql = "delete from message where id=" + list[0];
				for(int i=1;i<list.length;i++){
					sql += " or id=" + list[i];
				}
				boolean del = conn.execute(sql);
				if(del){
					out.println(function.PlutoJump("删除成功！", "message.jsp"));
				}else{
					out.println(function.PlutoJump("删除失败！", "message.jsp"));
				}
			}
			
		}
		return null;
	}
}
