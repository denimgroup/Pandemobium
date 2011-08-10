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
<%@ page import="java.lang.Double, java.net.URL, java.net.URLConnection, java.io.InputStreamReader, java.io.BufferedReader, java.sql.Connection, java.sql.DriverManager, java.sql.SQLException, java.sql.Statement, java.sql.ResultSet" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	Class.forName("org.hsqldb.jdbcDriver").newInstance();
	Connection c = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "sa", "");
	Statement s = c.createStatement();
	ResultSet rs = null;
	String method = request.getParameter("method");
	String id = "", tip_creator = "", symbol = "", reason = "";
	double target_price = 0;
	if(method == null){
		System.out.println("No method provided");
	}
	else if(method.equals("submitTips")){
		tip_creator = request.getParameter("id");
		String query = "", line = "", tips = request.getParameter("tipData");
		String[] tokens, indcol, lines = tips.split("\n");
		for(int i = 0; i < lines.length; i++){
			line = lines[i].substring(line.indexOf(":")+1);
			tokens = line.split("&");
			for(int j=0; j<tokens.length; j++){
				indcol = tokens[j].split("=");
				if(indcol[0].equals("symbol"))
					symbol = indcol[1].toUpperCase();
				if(indcol[0].equals("target_price"))
					target_price = Double.parseDouble(indcol[1]);
				if(indcol[0].equals("reason"))
					reason = indcol[1];
			}
			if(symbol.equals(""))
				break;
			query = "INSERT INTO tips (tip_creator, symbol, target_price, reason) VALUES ('"
				+ tip_creator + "', '" + symbol + "', " + target_price + ", '" + reason + "')";
			System.out.println("QUERY IS: " + query);
			rs = s.executeQuery(query);
			System.out.println("Thanks");
		}
	}
	else{
		System.out.println("Unknown method " + method);
	}
%>