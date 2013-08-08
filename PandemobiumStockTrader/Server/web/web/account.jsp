<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 7/3/13
  Time: 9:33 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page        language="java"
                contentType="text/html; charset=ISO-8859-1"
                pageEncoding="ISO-8859-1"%>

<%@ page import="services.accountService" %>
<%@ page import="JSON.JSONObject" %>
<%@ page import="JSON.JSONArray" %>
<%@ page import="java.net.URL" %>
<%@ page import="services.initDatabase" %>

<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevent caching at the proxy server
%>

<%


    accountService service = new accountService();
    JSONObject json = new JSONObject();

    String query = request.getParameter("query");
    query = query.replace("%20", " ");
    query = query.toUpperCase();

    //----
    //System.out.println( db.executeSelect("show tables;"));
  //  initDatabase db = new initDatabase();
  //  db.initDatabase();

    if(query.contains("INSERT INTO") || query.contains("UPDATE") || query.contains("DELETE") || query.contains("DROP"))
    {
        String results = service.executeInsert(query);
        json = new JSONObject(results);

    }
    else if(query.contains("SELECT"))
    {
        String results = service.executeSelect(query);
        json = new JSONObject(results);
    }
    else
    {
        json = new JSONObject("{\"Results\":\"Invalid Query\"}");

    }
    response.setContentType("application/json");
    response.getWriter().write(json.toString());

%>

