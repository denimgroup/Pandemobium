package services;/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/1/13
 * Time: 2:18 PM
 * To change this template use File | Settings | File Templates.
 */
import java.sql.*;
import java.lang.*;
import java.net.*;
import JSON.JSONObject;
import java.util.*;



public class accountService {

    private static final int SQLConnection = -10;
    private static final int SQLException = -11;
    private static final int ClassNotFound = -12;
    private static final int InstantiationFail = -13;
    private static final int IllegalAccess = -14;
    private static final int SomethingHorrible = -20;

    private static final int NoUserFound = -1;
    private static final int IncorrectPassword = -2;

    private static final int SUCCESS = 1;

    public Integer logIn(String username, String password)
    {
        try
        {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection database = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");

            if(!database.isClosed())
            {
                ResultSet response;
                Statement statement = database.createStatement();
                String query = "SELECT userID from users where userName= '" + username + "' AND password='" + password + "';";
                System.out.println(query);
                response = statement.executeQuery(query);
                int userID = 0;
                if(response.next())
                {
                    userID = response.getInt("userID");
                }
                else
                {
                    userID = NoUserFound;
                }

                database.close();
                return userID;

            } else {
                return SQLConnection;
            }
        } catch (SQLException ex)
        {
            ex.printStackTrace();
            return SQLException;

        } catch(ClassNotFoundException e)
        {
            e.printStackTrace();
            return ClassNotFound;
        } catch (InstantiationException e)
        {   e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            return InstantiationFail;

        } catch (IllegalAccessException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.

        }
        return SomethingHorrible;
    }

  public Integer addUser(String [] input)
  {
      try
      {
          Class.forName("com.mysql.jdbc.Driver").newInstance();
          Connection database = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");

          if(!database.isClosed())
          {
              ResultSet response;
              Statement statement = database.createStatement();
              String query = "INSERT INTO users (firstName, lastName, email, phone, userName, password)" +
                      " VALUES(";

              for(int i = 0; i <input.length; i++)
              {
                  query = query +" '" + input[i] + "'";
                  if(i != input.length - 1)
                  {
                      query = query + ",";
                  }
              }
              query = query + ");";
              System.out.println(query);
              int result = statement.executeUpdate(query);


              if(result == SUCCESS)
              {   query = "SELECT userID from users where userName = '" + input[4] +"';";
                  response = statement.executeQuery(query);
                  response.next();
                  return response.getInt("userID");
              }

              database.close();
              return result;

          } else {
              return SQLConnection;
          }
      } catch (SQLException ex)
      {
          ex.printStackTrace();
          return SQLException;

      } catch(ClassNotFoundException e)
      {
          e.printStackTrace();
          return ClassNotFound;
      } catch (InstantiationException e)
      {   e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
          return InstantiationFail;

      } catch (IllegalAccessException e) {
          e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.

      }
      return SomethingHorrible;
  }

    public String [] getUserInfo(String id)
    {
        try
        {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection database = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");

            if(!database.isClosed())
            {
                ResultSet response;
                Statement statement = database.createStatement();
                String query = "SELECT * from users where userID =" + id +";";
                System.out.println(query);
                response = statement.executeQuery(query);
                String [] column = {"userID", "firstName", "lastName", "email", "phone", "userName", "password"};
                String [] results = new String[column.length];
                if(response.next())
                {
                    for(int i = 0; i < column.length; i++)
                    {
                        if(response.getString(column[i]) == null)
                            results[i]="NULL";
                        else
                            results[i]=response.getString(column[i]);
                    }
                }
                database.close();
                return results;

            } else {
                //return "SQLConnection";
            }
        } catch (SQLException ex)
        {
            ex.printStackTrace();
            //return "SQLException";

        } catch(ClassNotFoundException e)
        {
            e.printStackTrace();
            //return "ClassNotFound";
        } catch (InstantiationException e)
        {   e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            //return "InstantiationFail";

        } catch (IllegalAccessException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.

        }
        //return "SomethingHorrible";
        return new String[0];
    }
}

