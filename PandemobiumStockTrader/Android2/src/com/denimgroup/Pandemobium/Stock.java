package com.denimgroup.Pandemobium;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import org.json.*;


/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/29/13
 * Time: 4:00 PM
 * To change this template use File | Settings | File Templates.
 */
public class Stock extends Activity {
    String symbol;

    @Override
    protected  void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.quotes);


        DownloadStockInfo task = new DownloadStockInfo();


    }

    private class DownloadStockInfo extends AsyncTask<String, Void, String>
    {

        @Override
         protected String doInBackground(String... params)
         {
             symbol = "MSFT";
             String url = "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20yahoo.finance.quote%20WHERE%20symbol%3D%27"+ symbol +"%27&diagnostics=false&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

             JSONParser jParser = new JSONParser();
             JSONObject json = jParser.getJSONFromUrl(url);
             System.out.println(json);

            return "hello";

         }

    }

}
