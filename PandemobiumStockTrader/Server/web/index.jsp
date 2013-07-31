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
        <table border="1">
            <tr><th> User Service</th> <th> Account Service</th> <th> Tips </th> <th> History </th></tr>
            <tr>
                <td>
                    <a href="http://localhost:8080/user.jsp?method=logIn&username=user&password=password"> Login with username and password</a>
                </td>
                <td>
                    <a href="http://localhost:8080/account.jsp?query=select%20*%20from%20account;"> Select * from account</a>
                </td>
                <td>
                    <a href="http://localhost:8080/tips.jsp?query=insert%20into%20tips%20(symbol,%20reason,%20userID)%20values%20('GOOG',%20'tesing',%201);"> Insert Tip</a>
                </td>
                <td>
                    <a href="http://localhost:8080/tips.jsp?query=insert%20into%20history%20(log,%20userID)%20values%20('GOOG',%201);"> Insert History </a>
                </td>

            </tr>
            <tr>
                <td>
                    <a href="http://localhost:8080/user.jsp?method=addUser&firstName=first&lastName=last&email=NULL&phone=NULL&userName=user&password=password"> Add User </a>
                </td>
            </tr>
            <tr>
                <td>
                    <a href="http://localhost:8080/user.jsp?method=getUserInfo&userID=1"> Get user Information</a>
                </td>
            </tr>

        </table>



  </body>
</html>