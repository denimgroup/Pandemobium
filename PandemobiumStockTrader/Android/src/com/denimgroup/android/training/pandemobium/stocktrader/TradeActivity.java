/**
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
 */

package com.denimgroup.android.training.pandemobium.stocktrader;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import com.denimgroup.android.training.pandemobium.stocktrader.util.AccountUtils;

public class TradeActivity extends Activity implements OnClickListener {
	
	private static String BASE_URL = "http://query.yahooapis.com/";
	private static String SERVICE = "v1/public/yql";
	private static String BASE_QUERY = "select Ask from yahoo.finance.quotes where symbol = ";
	private static String STORE = "store://datatables.org/alltableswithkeys";
	
	private static String ORDER_STATUS = "orderStatus";
	private static String STATUS_PLACED = "placed";
	
	private Button btnGetQuote;
	private Button btnTrade;
	private EditText etShares;
	private EditText etSymbol;
	private TextView tvCurrentQuote;
	private TextView tvTradeResults;
	
	private double sharePrice;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.trade);
        
        btnGetQuote = (Button)findViewById(R.id.btn_get_quote);
        btnGetQuote.setOnClickListener(this);
        
        btnTrade = (Button)findViewById(R.id.btn_trade);
        btnTrade.setOnClickListener(this);
        
        etShares = (EditText)findViewById(R.id.et_shares);
        etSymbol = (EditText)findViewById(R.id.et_symbol);
        tvCurrentQuote = (TextView)findViewById(R.id.tv_current_quote);
        tvTradeResults = (TextView)findViewById(R.id.tv_trade_results);

        if (Intent.ACTION_MAIN.equals(getIntent().getAction())) {
        	Log.d("TradeActivity", "Action launched manually");
        } else {
        	Uri data = getIntent().getData();

        	if (data == null) {
        			Log.i("TradeActivity", "No data passed with intent");
        	} else {
        		Uri tradeUri = getIntent().getData();
        		Log.i("TradeActivity", "Intent launched with data: " + tradeUri.toString());
        		String shares = tradeUri.getQueryParameter("shares");
        		String symbol = tradeUri.getQueryParameter("symbol");
        		String price = tradeUri.getQueryParameter("price");
        		
        		etShares.setText(shares);
        		etSymbol.setText(symbol);
        		tvCurrentQuote.setText(price);
        		
        		this.sharePrice = Double.parseDouble(price);
        		
        		doTrade();
        	}
        }
    }
    
	@Override
	public void onClick(View button) {
		Log.i("TradeActivity", "Received onClick event for button: " + button);
		
		etSymbol.setText(etSymbol.getText().toString().toUpperCase());
		if(button == btnGetQuote) {
			doGetQuote();
		} else if(button == btnTrade) {
			doTrade();
		} else {
			Log.w("TradeActivity", "Got an unresolvable onClick event for button: " + button);
		}
	}
	
	private void doTrade()
	{
		//	Get the stuff we need from the UI
		String symbol = etSymbol.getText().toString();
		String quantity = etShares.getText().toString();
		String price = "" + this.sharePrice;
		String accountId = AccountUtils.retrieveAccountId(getApplicationContext());
	        
        String tradeServiceUrl = getResources().getString(R.string.trade_service);
        
        String actualUrl = tradeServiceUrl + "?method=executeBuy&id=" + accountId + "&symbol=" + symbol + "&quantity=" + quantity + "&price=" + price;
        
        try {
        	Log.d("TradeActivity", "URL for trade is: " + actualUrl);
        	
	        URL url = new URL(actualUrl);			
			URLConnection conn = url.openConnection ();
			StringBuilder responseText = new StringBuilder();
		
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = rd.readLine()) != null) {
				responseText.append(line);
			}
			rd.close();
			
			Log.d("TradeActivity", "Trade result: " + responseText.toString());
			tvTradeResults.setText(responseText.toString());
			
			//	TODO Make this only log if the trade was successful
			StockDatabase dbHelper = new StockDatabase(this.getApplicationContext());
			SQLiteDatabase db = dbHelper.openDatabase();
			SQLiteStatement stmt = db.compileStatement("INSERT INTO trade (trade_time, trade_type, symbol, shares, price) VALUES (?, ?, ?, ?, ?)");
			stmt.bindLong(1, System.currentTimeMillis());
			stmt.bindString(2, "BUY");
			stmt.bindString(3, symbol);
			stmt.bindString(4, quantity);
			stmt.bindDouble(5, Double.parseDouble(price));
			stmt.execute();
			
			db.close();
			
        } catch (MalformedURLException urle) {
        	Log.e("TradeActivity", "Bad URL for trading web services call: " + urle.toString());
        } catch (IOException ioe) {
        	Log.e("TradeActivity", "Communications problems when making web services call for trade: " + ioe.toString());
        }
	}
	
	private void doGetQuote()
	{
		String symbol = etSymbol.getText().toString();
		String quote = retrieveQuote(symbol);
		String labelText = "";
		if(quote ==  null){
			quote = "0";
			labelText = "Unexpected error!";
		}
		else{
			labelText = symbol + " is currently trading at " + quote;
		}
		
		tvCurrentQuote.setText(labelText);
		this.sharePrice = Double.parseDouble(quote);
	}
    
    private String retrieveQuote(String symbol)
    {
    	String retVal = null;
    	String query = BASE_QUERY + "\"" + symbol + "\"";
    	String fullUrl = BASE_URL + SERVICE + "?q=" + URLEncoder.encode(query) + "&env=" + STORE; 
    	
    	Log.d("TradeActivity", "URL to be retrieved is: " + fullUrl);
    	
    	try {
	    	URL url = new URL(fullUrl);
	    	
	    	XmlPullParserFactory parserCreator = XmlPullParserFactory.newInstance();
	    	XmlPullParser parser = parserCreator.newPullParser();
	    	
	    	// test ...
	    	URLConnection conn = url.openConnection();
	    	parser.setInput(conn.getInputStream(), null);
	    	
	    	//String test = conn.getInputStream().toString();
	    	
	    	//parser.setInput(url.openStream(), null);
	    	
	    	int parserEvent = parser.getEventType();
	    	parse:
	    	while(parserEvent != XmlPullParser.END_DOCUMENT) {
	    		switch(parserEvent) {
	    		case XmlPullParser.START_TAG:
	    			//test = parser.getName();
	    			Log.d("TradeActivity", "Found a " + parser.getName() + " tag");
	    			break;
	    		case XmlPullParser.TEXT:
	    			Log.d("TradeActivity", "Found a TEXT event");
	    			retVal = parser.getText();
	    			Log.d("TradeActivity", "Found Ask value of: " + retVal);
	    			break parse;
	    		}
	    		parserEvent = parser.next();
	    	}
	    	
    	} catch (MalformedURLException urle) {
    		Log.e("TradeActivity", urle.toString());
    	} catch (IOException ioe) {
    		Log.e("TradeActivity", ioe.toString());
    	} catch (XmlPullParserException xmle) {
    		Log.e("TradeActivity", xmle.toString());
		}
    	
    	Log.d("TradeActivity", "Content to be returned is: " + retVal);
    	
    	return(retVal);
    }
    
    // http://query.yahooapis.com/v1/public/yql?q=select%20Ask%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22AAPL%22%29&env=store://datatables.org/alltableswithkeys
    // http://query.yahooapis.com/v1/public/yql?q=SELECT+Ask+FROM+yahoo.finance.quote+WHERE+SYMBOL+%3D+YHOO&env=store://datatables.org/alltableswithkeys
}
