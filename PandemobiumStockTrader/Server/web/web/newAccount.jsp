<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 7/23/13
  Time: 2:34 PM
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
    <title>Create Account</title>
    <style type="text/css">
        input[type=text], input[type=url], input[type=email], input[type=password], input[type=tel] {
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
            var firstName = form.firstName.value;
            var lastName = form.lastName.value;
            var eMail = form.eMail.value;
            var phone = form.phone.value;
            var username = form.username.value;
            var pass = form.password.value;
            var pass2 = form.password2.value;

            if(firstName =="" || lastName == "")
            {
                alert("Must be valid First and Last Name");

            }
            else
            {

                if((pass == pass2) && pass != "")
                {
                    var txt = new String("firstName=" + firstName + "&lastName=" + lastName + "&email=" + eMail + "&phone=" + phone + "&userName=" + username + "&password="+ pass);

                    url="user.jsp?method=addUser&" + txt;
                    window.location=url;


                }
                else
                {
                    alert("Password cannot be blank and must match");


                }
            }
        }
    </script>

</head>
<body>

<div class="newUser">
    <h1 align="center"> New User</h1>
    <form width="100%" name="newUser" id="newUser" onsubmit="submitPressed(this.form); return false">
        <label for="firstName">First Name</label>
        <input type="text" name="firstName" placeholder="First" id="firstName"> <br>
        <label for="lastName">Last Name</label>
        <input type="text" name="lastName" placeholder="Last" id="lastName"> <br>
        <label for="eMail">E-Mail</label>
        <input type="email" name="eMail" placeholder="user@gmail.com" id="eMail"> <br>
        <label for="phone">Phone #</label>
        <input type="tel" name="phone" placeholder="Your telephone number" id="phone"> <br>
        <label for="username">Username</label>
        <input type="text" name="username" placeholder="Username" id="username"> <br>
        <label for="password">Password</label>
        <input type="password" name="password" placeholder="Password" id="password"> <br>
        <label for="password2">Re-Enter Password</label>
        <input type="password" name="password2" placeholder="Re-Enter Password" id="password2"> <br>
        <button type="submit" name="submit" onclick="submitPressed(this.form); return false; ">Submit</button><br>
    </form>

</div>




</body>
</html>