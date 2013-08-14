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
<%
    initDatabase db = new initDatabase();
    db.initDatabase();
%>

<html>
  <head>
      <title>Pandemobium Stock Trader</title>

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
          <h1>Pandemobium Stock Trader</h1>
      </header>

      <div id="container">
          <ul>
              <a href="http://localhost:8080/web/about.jsp#about"><li class="clearfix">
                  <h2>About Pandemobium</h2>
                  <p class="desc">Purpose and Use of Pandemobium </p>
              </li></a>


              <a href="http://localhost:8080/web/about.jsp#UserService"><li class="clearfix">
                  <h2>User Service</h2>
                  <p class="desc">Access and retrieve users information</p>

              </li></a>
              <a href="http://localhost:8080/web/about.jsp#AccountService"><li class="clearfix">
                  <h2>Account Service</h2>
                  <p class="desc">Access and retrieve users account and stocks</p>
               </li></a>

              <a href="http://localhost:8080/web/newAccount.jsp"><li class="clearfix">
                  <h2>Create New Account</h2>
                  <p class="desc">Register a user and create a new accountr</p>

              </li></a>
              <a href="http://finance.yahoo.com"><li class="clearfix">
                  <h2>Financial News</h2>
                  <p class="desc">View Yahoo! Financial News</p>

              </li></a>

              <a href="http://localhost:8080/web/about.jsp#Tips"><li class="clearfix">
                  <h2>Tips</h2>
                  <p class="desc">Access and retrieve tips</p>

              </li></a>
              <a href="http://localhost:8080/web/about.jsp#History"><li class="clearfix">
                  <h2>History</h2>
                  <p class="desc">Access and retrieve history</p>

              </li></a>

              <a href="http://localhost:8080/maliciousweb/index.jsp"><li class="clearfix">
                  <h2>Malicious Web</h2>
                  <p class="desc">Where nightmares come from</p>
              </li></a>
              <a href="http://localhost:8080/web/walkthrough.jsp"><li class="clearfix">
                  <h2>iOS</h2>
                  <p class="desc">iOS App walkthough</p>
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