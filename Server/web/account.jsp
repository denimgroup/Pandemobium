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


<%
    accountService service = new accountService();
    JSONObject json = new JSONObject();

    String query = request.getParameter("query");
    query = query.replace("%20", " ");
    query = query.toUpperCase();

    if(query.contains("INSERT INTO") || query.contains("UPDATE") || query.contains("DELETE"))
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