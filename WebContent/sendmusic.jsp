<%@ page language="java" import="java.util.*,Pluto.function"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%
	String id = request.getParameter("id");
	if (function.isInvalid(id)) {
		out.println(function.PlutoJump("非法访问！", "index.jsp"));
	}
%>
<HTML>
	<HEAD>
		<META http-equiv=Content-Type content="text/html; charset=utf-8">
		<META content="MSHTML 6.00.2900.3157" name=GENERATOR>
	</HEAD>
	<BODY>
		<DIV style="TEXT-ALIGN: center">
			<form action="sendmusic.action?id=<%=id%>" method="post">
				<TABLE style="MARGIN: 0px auto" cellSpacing=3 cellPadding=3 border=0>
					<TBODY>
						<TR>
							<TD colspan="2">
								<div align="center">
									点播歌曲
								</div>
							</TD>
						</TR>
						<TR>
							<TD width="85">
								&nbsp;
							</TD>
							<TD width="332">
								&nbsp;
							</TD>
						</TR>
						<TR>
							<TD>
								<LABEL>
									用户名：
								</LABEL>
							</TD>
							<TD>
								<div align="left">
									<INPUT type="text" name="to" maxlength="16" />
								</div>
							</TD>
						</TR>
						<TR>
							<TD>
								<br>
							</TD>
							<TD>
								<div align="left">
									<label>
										<input type="checkbox" name="hidename" value="true"
											id="checkbox">
										匿名点歌
									</label>
								</div>
							</TD>
						</TR>
						<TR>
							<TD>
								<LABEL>
									留言：
								</LABEL>
							</TD>
							<TD>
								<label>
									<div align="left">
										<textarea name="value" id="textarea" cols="45" rows="5"></textarea>
									</div>
								</label>
							</TD>
						</TR>
						<TR>
							<TD>
								<br>
							</TD>
							<TD>
								<br>
							</TD>
						</TR>
						<TR align=right>
							<TD colSpan=2>
								<div align="center">
									<INPUT id=Login type=submit value="确 定">
									&nbsp;
									<INPUT type="reset" onclick=tb_remove() value="取 消" />
								</div>
							</TD>
						</TR>
					</TBODY>
				</TABLE>
			</form>
		</DIV>
	</BODY>
</HTML>
