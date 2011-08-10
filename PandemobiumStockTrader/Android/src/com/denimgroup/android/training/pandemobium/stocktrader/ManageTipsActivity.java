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

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import com.denimgroup.android.training.pandemobium.stocktrader.util.AccountUtils;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

public class ManageTipsActivity extends Activity implements OnClickListener {
	
	private Button btnSaveTip;
	private EditText etSymbol;
	private EditText etTargetPrice;
	private EditText etReason;
	private TextView tvTipStatus;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.managetips);
        
        etSymbol = (EditText)findViewById(R.id.et_symbol);
        etTargetPrice = (EditText)findViewById(R.id.et_target_price);
        etReason = (EditText)findViewById(R.id.et_reason);
        
        btnSaveTip = (Button)findViewById(R.id.btn_save_tip);
        btnSaveTip.setOnClickListener(this);
        
        tvTipStatus = (TextView)findViewById(R.id.tv_tip_status);
        
        if (Intent.ACTION_MAIN.equals(getIntent().getAction())) {
        	Log.d("ManageTipsActivity", "Action launched manually");
        } else {
        	Uri data = getIntent().getData();

        	if (data == null) {
        			Log.i("ManageTipsActivity", "No data passed with intent");
        	} else {
        		Uri tradeUri = getIntent().getData();
        		Log.i("ManageTipsActivity", "Intent launched with data: " + tradeUri.toString());
        		String symbol = tradeUri.getQueryParameter("symbol").toUpperCase();
        		
        		// test ...
        		//String target_price = tradeUri.getQueryParameter("target_price");
        		
        		doSendTipData(symbol);
        		
        	}
        }
    }

	@Override
	public void onClick(View button) {
		
		Log.i("ManageTipsActivity", "Received onClick event for button: " + button);
		
		if(button == btnSaveTip) {
			etSymbol.setText(etSymbol.getText().toString().toUpperCase());
			doSaveTip();
		} else {
			Log.w("ManageTipsActivity", "Got an unresolvable onClick event for button: " + button);
		}
	}
	
	private void doSendTipData(String symbol) {
		StockDatabase dbHelper = new StockDatabase(this.getApplicationContext());
		SQLiteDatabase db = dbHelper.openDatabase();
		
		StringBuilder sb = new StringBuilder();
		
		String sql = "SELECT * FROM tip WHERE symbol = '" + symbol + "'";
		
		Log.d("ManageTipsActivity", "SQL to execute is: " + sql);
		
		Cursor tips = db.rawQuery(sql, null);
		
		//	Take all the data returned and package it up for sending
		int numTips = tips.getCount();
		Log.d("ManageTipsActivity", "Got " + numTips + " tips to send");
		tips.moveToFirst();
		for(int i = 0; i < numTips; i++) {
			sb.append("TIP");
			sb.append(i);
			sb.append(":");
			int columnCount = tips.getColumnCount();
			Log.d("ManageTipsActivity", "Tip " + i + " has " + columnCount + " columns");
			for(int j = 0; j < columnCount; j++) {
				if(j > 0) {
					sb.append("&");
				}
				sb.append(tips.getColumnName(j));
				sb.append("=");
				sb.append(tips.getString(j));
			}
			tips.moveToNext();
			sb.append("\n");
		}
		
		tips.close();
		db.close();
		
		Log.d("ManageTipsActivity", "Tip data to post is: " + sb.toString());
		
		String accountId = AccountUtils.retrieveAccountId(getApplicationContext());
		String tradeServiceUrl = getResources().getString(R.string.tip_service);
		
		String fullUrl = tradeServiceUrl + "?method=submitTips&id=" + accountId;
		
		Log.d("ManageTipsActivity", "Full URL for tip sending is: " + fullUrl);
		
		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(fullUrl);
		List<NameValuePair> pairs = new ArrayList<NameValuePair>();
		pairs.add(new BasicNameValuePair("tipData", sb.toString()));
		try {
			post.setEntity(new UrlEncodedFormEntity(pairs));
			HttpResponse response = client.execute(post);
			tvTipStatus.setText("Tip data for " + etSymbol.getText().toString() + " sent!");
			
		} catch (Exception e) {
			Log.e("ManageTipsActivity", "Error when encoding or sending tip data: " + e.toString());
			e.printStackTrace();
		}
	}
	
	private void doSaveTip() {
		String symbol = etSymbol.getText().toString();
		Double targetPrice = Double.parseDouble(etTargetPrice.getText().toString());
		String reason = etReason.getText().toString();
		
		//	TOFIX - Read the username from the credentials.properties file
		
		String sql = "INSERT INTO tip (tip_creator, symbol, target_price, reason) VALUES (?, ?, ?, ?)";
		
		StockDatabase dbHelper = new StockDatabase(this.getApplicationContext());
		SQLiteDatabase db = dbHelper.openDatabase();
		SQLiteStatement stmt = db.compileStatement(sql);
		stmt.bindString(1, "USERNAME");
		stmt.bindString(2, symbol);
		stmt.bindDouble(3, targetPrice);
		stmt.bindString(4, reason);
		stmt.execute();
		stmt.close();
		
		db.close();
		
		tvTipStatus.setText("Tip saved!");
	}
}
