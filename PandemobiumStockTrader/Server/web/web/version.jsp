<%--
  Created by IntelliJ IDEA.
  User: denimgroup
  Date: 8/5/13
  Time: 3:36 PM
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
<%@ page import="services.initDatabase" %>



<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevent caching at the proxy server

    initDatabase db = new initDatabase();
    db.initDatabase();

    JSONObject json = new JSONObject();
    JSONArray array;

    Class.forName("org.hsqldb.jdbc.JDBCDriver").newInstance();
    Connection database = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "SA", "");

    ResultSet rs;
    Statement statement = database.createStatement();
    String query="select * from version;";
    rs = statement.executeQuery(query);

    out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    out.println("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n");
    out.println("<plist version=\"1.0\">\n");
    out.print("<dict>");


    while(rs.next())
    {
        out.println("<key>"+rs.getInt("version") + ".0</key>");
        out.println("<array>");
        out.println("<string>"+ rs.getString("log")+"</string>");
        out.println("</array>");

    }
    out.println("</dict>");
    out.println("</plist>");




%>






