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



public class accountService {
    public String sayHelloWorldFrom(String from) {
        String result = "test";
        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost/stocktrader", "root", "");
            if(!c.isClosed())
            {
                result = "connection successful";
                c.close();
            } else {
                result ="connection not found";
            }


        } catch (SQLException ex)
        {
            ex.printStackTrace();

        } catch(ClassNotFoundException e)
        {
            e.printStackTrace();
        }
        System.out.println(result);
        return result;
    }
}
