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

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="java.sql.ResultSet, java.sql.Connection, java.sql.DriverManager, java.sql.SQLException, java.sql.Statement"%>
<%
      response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
      response.setHeader("Pragma","no-cache"); //HTTP 1.0
      response.setDateHeader ("Expires", 0); //prevent caching at the proxy server
%>
<%!
/**
*    Set up the database for use by the other pages.
*/
public void jspInit(){
	try{
	Class.forName("org.hsqldb.jdbcDriver").newInstance();
    Connection c = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "sa", "");
    Statement s = c.createStatement();
	System.out.println("About to set up database for exercises");
            
    executeQuery(s, "CREATE TABLE tips (id IDENTITY, tip_creator INT, symbol VARCHAR(64), target_price REAL, reason VARCHAR(64))");
            
    executeQuery(s, "CREATE TABLE trades (id IDENTITY, symbol VARCHAR(64), quantity INT, price_per REAL)");
    		
    executeQuery(s, "CREATE TABLE logins (id IDENTITY, username VARCHAR(32), password VARCHAR(32))");
    executeQuery(s, "INSERT INTO logins (username, password) VALUES ('dcornell', 'danpass')");
    executeQuery(s, "INSERT INTO logins (username, password) VALUES ('jdoe', 'janejohn')");
	}catch(Exception e){
		System.err.println(e);
	}
    System.out.println("Finished setting up database for exercises");
}

public void executeQuery(Statement s, String query) throws Exception {
      System.out.println("Query is: " + query);
      s.execute(query);
}
%>
<%
Class.forName("org.hsqldb.jdbcDriver").newInstance();
Connection c = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "sa", "");
Statement s = c.createStatement();
String method = request.getParameter("method");
if(method.equals("")){
	System.out.println("No method provided");
}
else if(method.equals("getAccountId")){
	ResultSet rs = null;
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String query;
	if(username != null && !username.equals("")) {
		//	Actually got a non-blank username so try to log in
		query = "SELECT * FROM logins WHERE username = '" + username + "' AND password = '" + password + "'";
		System.out.println("About to execute query: " + query);
		rs = s.executeQuery(query);
	}
	
	if(rs.next()){
		out.println("account_id="+rs.getString("id"));
	}else{
		out.println("error: unknown username or password");
	}
}else{
	out.println("Unknown method " + method);
}
%>