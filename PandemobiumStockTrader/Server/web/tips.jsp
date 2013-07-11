<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 7/3/13
  Time: 12:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page        language="java"
                contentType="text/html; charset=ISO-8859-1"
                pageEncoding="ISO-8859-1"%>

<%@ page import="JSON.ResultSetConverter" %>
<%@ page import="JSON.JSONObject" %>
<%@ page import="JSON.JSONArray" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.*" %>

<%
    JSONObject json = new JSONObject();
    JSONArray array;

    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection database = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");

    String query = request.getParameter("query");
    query = query.replace("%20", " ");
    ResultSet results;
    Statement statement = database.createStatement();
    if(statement.execute(query))
    {
        results = statement.getResultSet();
        ResultSetConverter converter = new ResultSetConverter();
        array = converter.convert(results);
        json.put("Results", array);

    }
    else {
        int i = statement.getUpdateCount();
        if(i < 0)
        {
            json = new JSONObject("{\"Results\":\"Invalid \"}");
        }
        else
        {
            json = new JSONObject("{\"Results\":\"Success\"}");
        }
    }

    database.close();

    response.setContentType("application/json");
    response.getWriter().write(json.toString());

%>

