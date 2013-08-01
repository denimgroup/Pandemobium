package services;/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/3/13
 * Time: 9:32 AM
 * To change this template use File | Settings | File Templates.
 */

import java.sql.*;
import java.lang.*;
import java.net.*;
import JSON.JSONObject;
import java.util.*;
import JSON.ResultSetConverter;
import JSON.JSONArray;
import services.initDatabase;

public class accountService {

      public String executeSelect(String query) {
          try
          {

              //Class.forName("com.mysql.jdbc.Driver").newInstance();
              //Connection database = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");

              Class.forName("org.hsqldb.jdbc.JDBCDriver").newInstance();
              Connection database = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "SA", "");



              if(!database.isClosed())
              {
                  ResultSet response;
                  Statement statement = database.createStatement();
                  System.out.println(query);
                  response = statement.executeQuery(query);

                  JSONObject object = new JSONObject();
                  JSONArray array ;
                  ResultSetConverter converter = new ResultSetConverter();
                  array = converter.convert(response);
                 // System.out.println(array);
                  object.put("Results", array);
                  database.close();
                  return object.toString();

              }
          } catch (SQLException ex)
          {
              ex.printStackTrace();


          } catch(ClassNotFoundException e)
          {
              e.printStackTrace();

          } catch (InstantiationException e)
          {   e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.


          } catch (IllegalAccessException e) {
              e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.

          }
          return "result";
      }

    public String executeInsert(String query) {
        try
        {
            //Class.forName("com.mysql.jdbc.Driver").newInstance();
            //Connection database = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");

            Class.forName("org.hsqldb.jdbc.JDBCDriver").newInstance();
            Connection database = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "SA", "");


            if(!database.isClosed())
            {
                ResultSet response;
                Statement statement = database.createStatement();
                System.out.println(query);
                int results  = statement.executeUpdate(query);

                JSONObject objects = new JSONObject();
                JSONObject object = new JSONObject();
                JSONArray array = new JSONArray();
                //ResultSetConverter converter = new ResultSetConverter();
                //array = converter.convert(response);
                object.put("Result", results);
                array.put(object);
                objects.put("Results", array);

                database.close();
                return object.toString();

            }
        } catch (SQLException ex)
        {
            ex.printStackTrace();


        } catch(ClassNotFoundException e)
        {
            e.printStackTrace();

        } catch (InstantiationException e)
        {   e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.


        } catch (IllegalAccessException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.

        }
        return "result";
    }

}
