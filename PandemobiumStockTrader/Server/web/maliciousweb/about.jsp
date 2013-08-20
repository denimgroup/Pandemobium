<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 8/9/13
  Time: 2:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Pandemobium Information</title>

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
        <h1>Pandemobium Security Exploits</h1>
    </header>

    <div id="container">
        <a name="sqlinjection">
            <h2 class="about"> SQL Injection</h2>
            <p class="tutorial">
                SQL Injection can target both local and remote databases. Without sanitation a hacker
                can perform malicious queries such as dropping tables, insert and delete records, and so forth.
                <br><br>
                In Pandemobium, the Manage Tips page is vulnerable to SQL injection since it allows for the user
                to submit large blocks of text.
                <br><br>
                <img src="../images/ios/sqlinjection.png">

            </p>
        </a>
        <a name="xss">
            <h2 class="about"> XSS-Cross Site Scripting</h2>
            <p class="tutorial">
                Data is submitted by the client and immediately processed by the server to generate results
                that are sent back to the client. In Pandemobium the results are sent back through a JSON clear text object.
                Due to the JSON object being readable it can be easily captured, modified, and sent back to the client. Due to
                Pandemboium using the result set as a way to verify if interaction with the database is accepted or rejected,
                malicious code can go un-noticed by the user.<br><br>

                In Pandemobium, communication with the Web Service is vulnerable to XSS since the communication
                is un-encrypted, clear text, and queries are passed through the URL call. For example: <br><br>
            <a href="http://localhost:8080/web/user.jsp?method=logIn&username=asalazar&password=password">
                    http://localhost:8080/web/user.jsp?method=logIn&username=asalazar&password=password</a>  <br><br>
            <a href="http://localhost:8080/web/account.jsp?query=select * from account;">
                    http://localhost:8080/web/account.jsp?query=select * from account; </a> <br><br>
            <a href="http://localhost:8080/web/tips.jsp?query=select * from tips;">
                    http://localhost:8080/web/account.jsp?query=select * from tips; </a> <br><br>
            </p>
        </a>

        <a name="locationservice">
            <h2 class="about"> Location Service Exploit</h2>
            <p class="tutorial">
                Pandemobium makes use of the mobile location when a user is signed in. By default, the
                application is intended to only work within 250 miles of San Antonio, Tx. If the mobile
                device goes out of range of the 250 miles it will forcefully sign out the current user. It will
                also not allow anyone to sign on in the device

            </p>
        </a>

        <a name="sslcertificate">
            <h2 class="about"> SSL Certificate</h2>
            <p class="tutorial">
                By default, iOS will ask you whether you a user wants to connect to a non SSL page. <br>
                Pandemobium has overwritten the function that allows for communication with SSL pages. Typically this
                is done only for testing, but sometimes developers will forget about this.

            </p>
        </a>
    </div>
</div>

</body>
</html>