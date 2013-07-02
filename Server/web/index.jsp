<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 7/1/13
  Time: 12:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="JSON.JSONObject" %>
<html>
  <head>
    <title></title>
  </head>
  <body>
        <p>
            <a href="http://localhost:8080/account.jsp?method=logIn&username=user&password=password"> Login with username and password</a>
        </p>
        <p>
            <a href="http://localhost:8080/account.jsp?method=addUser&firstName=first&lastName=last&email=NULL&phone=NULL&userName=user&password=password"> Add User </a>
        </p>
        <p>
            <a href="http://localhost:8080/account.jsp?method=getUserInfo&userID=1"> Get user Information</a>
        </p>

  </body>
</html>