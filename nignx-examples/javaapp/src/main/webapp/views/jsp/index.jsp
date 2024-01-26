<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="io.github.dunwu.Main" %>

<%
    String domain = request.getScheme() + "://" + request.getServerName() + request.getContextPath();
    String host = request.getRemoteHost();
    String tomcatConnectorPort = Main.getTomcatConnectorPort();
    Integer port = Integer.parseInt(tomcatConnectorPort);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>spring-embed-tomcat-demo</title>
</head>

<body>
<h1>spring-embed-tomcat-demo</h1>
<h2><%= "当前服务器信息：" %></h2>
<ul>
    <li><%= "domain：" + domain %></li>
    <li><%= "host：" + host %></li>
    <li><%= "port：" + port %></li>
</ul>
</body>
</html>
