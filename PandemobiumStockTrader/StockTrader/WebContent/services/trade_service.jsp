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
<%
String method = request.getParameter("method");
String id = "", symbol = "", quantity = "", price = "";
String orderStatus = "begin ...";

if(method.equals("")){
	System.out.println("No method provided");
}
else if(method.equals("executeBuy")){
	id = request.getParameter("id");
	symbol = request.getParameter("symbol");
	quantity = request.getParameter("quantity");
	price = request.getParameter("price");
	if(id.equals("") && symbol.equals("") && quantity.equals("") && price.equals("")){
		orderStatus = "error-missing-data";
	}
	else{
		System.out.println("id: " + id + "\nsymbol: " + symbol + "\nquantity" + quantity.toString() + "\nprice: " + price.toString());
		try{
			//Class.forName("org.hsqldb.jdbcDriver").newInstance();
	        Connection c = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "sa", "");	        
	        Statement s = c.createStatement();
	        String query = "INSERT INTO trades (symbol, quantity, price_per) VALUES ('"+symbol+"', "+quantity+", "+price+") ";
	        System.out.println("\nQuery is: " + query);
	        int res = s.executeUpdate(query);	
	        System.out.println("insert rows: " + res);
	        if(res == 1){
	        	orderStatus = "placed";
	        }
	        else{
	        	orderStatus = "not placed";
	        }
	        
	        ResultSet rs_test = s.executeQuery("select * from trades ");
	        while(rs_test.next()){
	        	String test_str = rs_test.getString("symbol");
	        	System.out.println("\n"+test_str+"\n");
	        }
	        c.close();
		} catch (Exception e) {
			orderStatus = "Unexpected error";
		    out.println(e);
		}
	}
	
	
	/*/ Fake execute transaction
	if(id.equals("") && symbol.equals("") && quantity.equals("") && price.equals("")){
		orderStatus = "error-missing-data";
	}	
	else{
		orderStatus = "placed";		
	}*/
	out.println("orderStatus=" + orderStatus);
}
else{
	out.println("Unknown method " + method);
}
%>