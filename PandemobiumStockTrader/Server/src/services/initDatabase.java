package services;

import JSON.JSONArray;
import JSON.JSONObject;
import JSON.ResultSetConverter;

import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/30/13
 * Time: 10:43 AM
 * To change this template use File | Settings | File Templates.
 */
public class initDatabase {

    //Tests to make sure that only one copy of the record gets inserted. This is done to prevent any duplicates.
    public void insertRecord(Connection conn, String testSql, String update)
    {
       try{
           Statement db = conn.createStatement();
           ResultSet result = db.executeQuery(testSql);
           if(result == null)
           {    //Table is empty
               db.execute(update);
           }
           else if (!result.next())
           {
               //No rows were returned
              db.execute(update);
           }

       } catch(Exception exc)
       {   exc.printStackTrace();

       }



    }


    public void initDatabase() {
        try
        {
            Class.forName("org.hsqldb.jdbc.JDBCDriver").newInstance();
            Connection database = DriverManager.getConnection("jdbc:hsqldb:mem:stocktrader", "SA", "");

            if(!database.isClosed())
            {
                System.out.println("Setting up Stocktrader DB");
                Statement query = database.createStatement();
                String statement = "CREATE TABLE IF NOT EXISTS users (\n" +
                        "        userID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,\n" +
                        "        firstName VARCHAR(20) NOT NULL,\n" +
                        "        lastName VARCHAR(20) NOT NULL,\n" +
                        "        email VARCHAR(30),\n" +
                        "        phone VARCHAR(12),\n" +
                        "        userName VARCHAR(20) NOT NULL,\n" +
                        "        password VARCHAR(20) NOT NULL\n" +
                        ");\n";
                query.execute(statement);

                statement = "CREATE TABLE IF NOT EXISTS account (\n" +
                        "        accountID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,\n" +
                        "        userID INT NOT NULL,\n" +
                        "        totalShares INT NOT NULL,\n" +
                        "        balance FLOAT NOT NULL,\n" +
                        "        FOREIGN KEY (userID) REFERENCES users(userID)\n" +
                        "        ON DELETE CASCADE\n" +
                        ") ;";
                query.execute(statement);

                statement = "CREATE TABLE IF NOT EXISTS tips (\n" +
                        "        tipID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,\n" +
                        "        userID INT NOT NULL,\n" +
                        "        symbol VARCHAR(10),\n" +
                        "        reason VARCHAR(512),\n" +
                        "        FOREIGN KEY (userID) REFERENCES users(userID)\n" +
                        "        ON DELETE CASCADE\n" +
                        ");";
                query.execute(statement);

                statement = "CREATE TABLE IF NOT EXISTS stock (\n" +
                        "        stockID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,\n" +
                        "        accountID INT NOT NULL,\n" +
                        "        symbol VARCHAR(10) NOT NULL,\n" +
                        "        shares int NOT NULL,\n" +
                        "        favorite boolean not null, \n" +
                        "        FOREIGN KEY(accountID) REFERENCES account(accountID)\n" +
                        "        ON DELETE CASCADE\n" +
                        ");";
                query.execute(statement);

                statement = "CREATE TABLE IF NOT EXISTS history (\n" +
                        "        historyID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,\n" +
                        "        userID INT NOT NULL,\n" +
                        "        log VARCHAR(512) NOT NULL,\n" +
                        "        time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n" +
                        "        FOREIGN KEY(userID) REFERENCES users(userID)\n" +
                        "        ON DELETE CASCADE\n" +
                        ") ;";
                query.execute(statement);




                //Table does not exist, insert default username and password
                statement =  "INSERT INTO users (firstName, lastName, email, phone, userName, password)\n" +
                        "        VALUES ('john', 'doe', NULL, NULL, 'jdoe', 'password');";

                insertRecord(database, "select userName from users where userName='jdoe';", statement);


                statement =  "INSERT INTO users (firstName, lastName, email, phone, userName, password)\n" +
                        "        VALUES ('adrian', 'salazar', NULL, NULL, 'asalazar', 'password');";
                insertRecord(database, "select userName from users where userName='asalazar';", statement);


                statement =  "INSERT INTO users (firstName, lastName, email, phone, userName, password)\n" +
                        "        VALUES ('thomas', 'salazar', NULL, NULL, 'tsalazar', 'password');";
                insertRecord(database, "select userName from users where userName='tsalazar';", statement);



                statement = "insert into account (userID, totalShares, balance) VALUES (0, 0, 10000);";
                insertRecord(database, "select userID from account where userID=0;", statement);

                statement = "insert into account (userID, totalShares, balance) VALUES (1, 0, 10000);";
                insertRecord(database, "select userID from account where userID=1;", statement);

                statement = "insert into account (userID, totalShares, balance) VALUES (2, 0, 10000);";
                insertRecord(database, "select userID from account where userID=2;", statement);


                statement = "insert into tips (userID, symbol, reason) values(0, 'GOOG', 'Use google for all your searches');";
                insertRecord(database, "select userID, symbol, reason from tips where userID=0 AND symbol='GOOG' AND reason='Use google for all your searches';", statement);




                System.out.println("Adding default stocks");

                for(int i = 0; i < 3; i++)
                {
                    statement = "insert into stock (accountID, symbol, shares, favorite) values(" + i +", 'GOOG', 0, 1);";
                    insertRecord(database, "select * from stock where accountID ="+i+" AND symbol='GOOG';", statement);
                    statement = "insert into stock (accountID, symbol, shares, favorite) values(" + i +", 'AAPL', 0, 1);";
                    insertRecord(database, "select * from stock where accountID ="+i+" AND symbol='AAPL';", statement);
                    statement = "insert into stock (accountID, symbol, shares, favorite) values(" + i +", 'MSFT', 0, 1);";
                    insertRecord(database, "select * from stock where accountID ="+i+" AND symbol='MSFT';", statement);

                }





               /*
                ResultSet response;
                JSONArray array ;
                ResultSetConverter converter = new ResultSetConverter();


                response = query.executeQuery("select * from users;");
                array = converter.convert(response);
                System.out.println(array);


                response = query.executeQuery("select * from account;");
                array = converter.convert(response);
                System.out.println(array);

                response = query.executeQuery("select * from tips;");
                array = converter.convert(response);
                System.out.println(array);

                response = query.executeQuery("select * from stock;");
                array = converter.convert(response);
                System.out.println(array);
                       */


                database.close();

                System.out.println("Finished setting up DB");



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

    }



}
