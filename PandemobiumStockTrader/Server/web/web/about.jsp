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
        <a name="about">
            <h2 class="about"> About Pandemobium</h2>
            <p class="about">
                Pandemobium Stock Trader is a mobile app for Android and iPhone with vulnerabilities included for security testing purposes.
                Copyright (c) 2013 Denim Group, Ltd. All rights reserved worldwide.
                <br><br>
                Pandemobium Stock Trader is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
                as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
                <br><br>
                This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
                MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
                <br><br>
                You should have received a copy of the GNU General Public License along with Pandemobium Stock Trader. If not, see
                <br><br><a href="http://www.gnu.org/licenses/">http://www.gnu.org/licenses/</a>
            </p>
        </a>
        <a name="UserService">
            <h2 class="about"> User Service</h2>
            <p class="about">
                The User Service class allows for the application to Log In, Add User, and Retrieve User Information. <br>
                The class is accessible through web/users.jsp
            </p>
        </a>

        <a name="AccountService">
            <h2 class="about"> Account Service</h2>
            <p class="about">
                The Account Service allows for the application to make changes to the users account. <br>
                It has been designed for the user to have multiple accounts, however in our version of <br>
                Pandemobium we are limiting the user to a single account. <br>
                <br>
                The Account Service allows to update account balance, and has access to the Stock table. <br>
                With the Stock the application is able to Buy/Sell Stocks. Due to the ever changing stock prices <br>
                the price and value of each stock should be determined on the application side.
            </p>
        </a>

        <a name="Tips">
            <h2 class="about"> Tips</h2>
            <p class="about">
                The Tips page allows for the application to submit tips on behalf of the user. <br>
                The basic tip consists of a stock symbol and a reason for why they are submitting the tip. <br>
                The application currently allows for a registered user to submit a tip that is viewable to everyone. <br>

            </p>
        </a>
        <a name="History">
            <h2 class="about"> History</h2>
            <p class="about">
                The History page allows for the application to log actions performed by user. The basic structure of <br>
                the page is to allow the application to submit the 'log' of the activity and the page will add the <br>
                time stamp that the log was received. <br><br>

                At this time the application will only display the history log that pertains to logged in user.

            </p>
        </a>

   </div>
</div>

</body>
</html>