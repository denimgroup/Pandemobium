<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 8/22/13
  Time: 2:20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Image</title>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="author" content="Jake Rocheleau">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="HandheldFriendly" content="true">
    <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script type="text/javascript" src="http://code.jquery.com/jquery.min.js"></script>
    <!--[if lt IE 9]>
    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
    <![endif]-->


</head>
<body>

<div id="view">
    <header>
        <h1>iOS Tutorial</h1>
    </header>
    <div id="container">
        <%
            String image = request.getParameter("image");
            out.println("<img src=\"" + image +"\" width=100% >");

        %>
    </div>

</body>
</html>