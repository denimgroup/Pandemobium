<%--
 * Pandemobium Stock Trader is a mobile app for Android and iPhone with
 * vulnerabilities included for security testing purposes.
 * Copyright (c) 2011 Denim Group, Ltd. All rights reserved worldwide.
 *
 * This file is part of Pandemobium Stock Trader.
 *
 * Pandemobium Stock Trader is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Pandemobium Stock Trader.  If not, see
 * <http://www.gnu.org/licenses/>.
--%>

<%@ page        language="java"
                contentType="text/html; charset=ISO-8859-1"
                pageEncoding="ISO-8859-1"
%>

<%@ page import="services.userService" %>
<%@ page import="services.accountService" %>
<%@ page import="JSON.JSONObject" %>
<%@ page import="JSON.JSONArray" %>
<%@ page import="services.initDatabase" %>

<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevent caching at the proxy server
%>

<%
   // initDatabase db = new initDatabase();
   // db.initDatabase();

    String method = request.getParameter("method");
    userService service = new userService();
    JSONObject json = new JSONObject();
    JSONArray results = new JSONArray();
    JSONObject result;

    if(method.equals("logIn"))
    {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        int info = service.logIn(username, password);

        result = new JSONObject();
        result.put("userID", info);
        result.put("userName", username);
        result.put("password", password);

        results.put(result);
        json.put("Results", results);
        response.setContentType("application/json");
        response.getWriter().write(json.toString());


    }
    else if(method.equals("addUser"))
    {

        String [] column = {"firstName", "lastName", "email", "phone", "userName", "password"};
        String [] input = new String[column.length];
        result = new JSONObject();
        for(int i = 0; i < column.length; i++)
        {
            String info = request.getParameter(column[i]);
            if(info != null)
            {
                result.put(column[i], info);
                input[i] = info;
            }
            else
            {   result.put(column[i], info);
                input[i] = "NULL";
            }
        }
        int id = service.addUser(input);
        result.put("userID", id);
        results.put(result);
        json.put("Results", results);
        if(id > 0)
        {

            accountService account = new accountService();
            String query = "insert into account (userID, totalShares, balance) values(" + id + ", 0, 10000);";
            String results2 = account.executeInsert(query);
            if(results2.equalsIgnoreCase("{\"Result\":1}"))
            {
                %>
                    <script> alert("User and Account Created"); </script>
                     <h1 align="center"> Great Success!</h1>
                <%

            }
            else
            {
                %>
                    <script> alert("User and Account Created"); </script>
                    <h1 align="center">Y U No Work?!</h1>
                 <%


            }
        }
         else
         {

                 %>
                    <script> alert("Unable to Create User"); </script>

                    <%



          }

    }
    else if(method.equals("getUserInfo"))
    {
        String [] column = {"userID", "firstName", "lastName", "email", "phone", "userName", "password"};
        String id = request.getParameter("userID");
        String [] info = service.getUserInfo(id);

        result = new JSONObject();
        for(int i = 0; i < info.length; i++)
            result.put(column[i], info[i]);
        results.put(result);
        json.put("Results", results);
        response.setContentType("application/json");
        response.getWriter().write(json.toString());

    }
    else if(method.equals("forgotPassword"))
    {
        String [] column = {"userID", "firstName", "lastName", "email", "phone", "userName", "password"};
        String username = request.getParameter("userName");
        String eMail = request.getParameter("eMail");
        String phone = request.getParameter("phone");

        String [] info = service.forgotPassword(username, eMail, phone);

        result = new JSONObject();
        for(int i = 0; i < info.length; i++)
            result.put(column[i], info[i]);
        results.put(result);
        json.put("Results", results);
        response.setContentType("application/json");
        response.getWriter().write(json.toString());




    }

%>
