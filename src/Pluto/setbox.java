package Pluto;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;
import org.jdom.JDOMException;

import com.opensymphony.xwork2.ActionSupport;

public class setbox extends ActionSupport {
	List<String> array = null;
	private String[] list;
	private String select;

	public String[] getList() {
		return list;
	}

	public void setList(String[] list) {
		this.list = list;
	}

	public String getSelect() {
		return select;
	}

	public void setSelect(String select) {
		this.select = select;
	}

	public String execute() throws IOException, SQLException, JDOMException {
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
			out.println(function.PlutoJump("请选择歌曲！", "musicbox.jsp"));
		} else {
			if ("del".equals(select)) { // 删除歌曲

				DBConnection conn = new DBConnection();
				ResultSet rs = conn
						.executeQuery("select music_box from user where name = '"
								+ userName + "'");
				rs.next();
				String musicList = rs.getString("music_box");
				rs.close();
				// 如果其中只有一首歌，就清空
				if (musicList.length() == 1) {
					boolean update = conn
							.execute("update user set music_box = NULL where name = '"
									+ userName + "'");
					if (update) {
						out.println(function.PlutoJump("删除成功", "musicbox.jsp"));
					} else {
						out.println(function.PlutoJump("出现错误", "musicbox.jsp"));
					}
				} else {
					String[] musicBoxArr = musicList.split(",");
					// 如果是全选就直接清空
					if (musicBoxArr.length == list.length) {
						boolean update = conn
								.execute("update user set music_box = NULL where name = '"
										+ userName + "'");
						if (update) {
							out.println(function.PlutoJump("删除成功",
									"musicbox.jsp"));
						} else {
							out.println(function.PlutoJump("出现错误",
									"musicbox.jsp"));
						}
					} else {
						// 其他情况
						// 使用链表，容易操作
						array = new ArrayList<String>();
						for (int i = 0; i < musicBoxArr.length; i++) {
							array.add(musicBoxArr[i]);
						}
						// 寻找相同元素并从链表中删除
						for (int i = 0; i < array.size(); i++) {
							for (int j = 0; j < list.length; j++) {
								if (array.get(i).toString().equals(list[j])) {
									array.remove(i);
								}
							}
						}
						// 再行成数组
						Object[] newMusicBox = array.toArray();
						// 形成字符串
						String newMusic = newMusicBox[0].toString() + ",";
						for (int i = 1; i < newMusicBox.length; i++) {
							newMusic += newMusicBox[i].toString() + ",";
						}
						// 去掉最后的","
						newMusic = newMusic.substring(0, newMusic.length() - 1);
						boolean update = conn
								.execute("update user set music_box = '"
										+ newMusic + "' where name = '"
										+ userName + "'");
						if (update) {
							out.println(function.PlutoJump("删除成功",
									"musicbox.jsp"));
						} else {
							out.println(function.PlutoJump("出现错误",
									"musicbox.jsp"));
						}
					}
				}
			} else { // 播放歌曲
				// 建立播放列表
				creatXML xml = new creatXML();
				xml.bulidXML(list, request, userName);
				out.println(function.PlutoJump("建立播放列表成功！", "player"));
			}
		}
		return null;
	}
}
