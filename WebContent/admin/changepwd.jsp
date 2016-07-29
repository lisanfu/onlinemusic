<%@ page language="java" import="java.util.*,java.sql.*,Pluto.function"
	pageEncoding="utf-8"%>
<%
if (session.getAttribute("PlutoAdmin")!=null) {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>无标题文档</title>
</head>

<body>
<form id="form1" name="form1" method="post" action="admin_changepwd.action">
  <label>旧 密 码： 
  <input type="text" name="oldpwd" id="textfield" />
  </label>
  <br />
  <label>新 密 码： 
  <input type="text" name="newpwd1" id="textfield2" />
  </label>
  <br />
  <label>确认密码：
  <input type="text" name="newpwd2" id="textfield3" />
  </label>
    <p>
    <label>
    <input type="submit" name="button" id="button" value="提交" />
    </label>
    <label>
    <input type="reset" name="button2" id="button2" value="重置" />
    </label>
  </p>
</form>
</body>
</html>
<%
}else {
	out.println(function.PlutoJump("非法请求或您的登陆已经超时！","index.jsp"));
}
%>