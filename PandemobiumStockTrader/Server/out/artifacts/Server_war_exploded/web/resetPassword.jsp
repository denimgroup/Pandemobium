<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 8/14/13
  Time: 4:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevent caching at the proxy server
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Forgot Password</title>
    <style type="text/css">
        input[type=text], input[type=url], input[type=email], input[type=tel] {
            -webkit-appearance: none; -moz-appearance: none;
            display: block;
            margin: 0;
            width: 100%; height: 40px;
            line-height: 40px; font-size: 17px;
            border: 1px solid #bbb;
        }
        button[type=submit] {
            -webkit-appearance: none; -moz-appearance: none;
            display: block;
            margin: 1.5em 0;
            font-size: 1em; line-height: 2.5em;
            color: #333;
            font-weight: bold;
            height: 2.5em; width: 100%;
            background: #fdfdfd; background: -moz-linear-gradient(top, #fdfdfd 0%, #bebebe 100%); background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fdfdfd), color-stop(100%,#bebebe)); background: -webkit-linear-gradient(top, #fdfdfd 0%,#bebebe 100%); background: -o-linear-gradient(top, #fdfdfd 0%,#bebebe 100%); background: -ms-linear-gradient(top, #fdfdfd 0%,#bebebe 100%); background: linear-gradient(to bottom, #fdfdfd 0%,#bebebe 100%);
            border: 1px solid #bbb;
            -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px;
        }

        body {
            font-family: Helvetica, arial, sans-serif;
        }
        .congrats {
            font-size: 16pt;
            padding: 6px;
            text-align: center;
        }
        .step {
            background: white;
            border: 1px #ccc solid;
            border-radius: 14px;
            padding: 4px 10px;
            margin: 10px 0;
        }
        .instructions {
            font-size: 10pt;
        }
        .arrow {
            font-size: 15pt;
        }

    </style>
    <script type="text/javascript">
        function submitPressed(form)
        {

            var username = form.username.value;
            var email = form.eMail.value;
            var phone = form.phone.value;

            if(username == "" || email == "" || phone == "")
            {
                alert("Please fill in the form completely.");
            }
            else
            {
                txt = "userName=" + username + "&eMail="+ email + "&phone=" + phone;

                url="http://localhost:8080/web/user.jsp?method=forgotPassword&" + txt;
                window.location=url;
            }
        }
    </script>
</head>
<body>

<div class="Forgot Password">
    <h1 align="center"> Update User</h1>
    <form width="100%" name="updateUser" id="updateUser" onsubmit="submitPressed(this.form); return false">

        <label for="username">Username</label>
        <input type="text" name="username" placeholder="Username" id="username"> <br>

        <label for="eMail">E-Mail</label>
        <input type="email" name="eMail" placeholder="user@gmail.com" id="eMail"> <br>

        <label for="phone">Phone #</label>
        <input type="tel" name="phone" placeholder="Your telephone number" id="phone"> <br>

        <button type="submit" name="submit" onclick="submitPressed(this.form); return false; ">Submit</button><br>
    </form>
</div>
</body>
</html>