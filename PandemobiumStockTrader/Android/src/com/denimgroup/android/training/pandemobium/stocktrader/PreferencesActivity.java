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

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class PreferencesActivity extends Activity implements OnClickListener {
	
	private static String CREDENTIALS_FILE = "credentials.properties";
	public static String ACCOUNT_FILE = "account.txt";
	
	private Button btnRetrievePrefs;
	private EditText etUsername;
	private EditText etPassword;
	private TextView tvStatus;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.preferences);
        
        btnRetrievePrefs = (Button)findViewById(R.id.btn_retrieve_prefs);
        btnRetrievePrefs.setOnClickListener(this);
        
        etUsername = (EditText)findViewById(R.id.et_username);
        
        etPassword = (EditText)findViewById(R.id.et_password);
        
        tvStatus = (TextView)findViewById(R.id.tv_status);
    }
    
	@Override
	public void onClick(View button) {
		
		Log.i("PreferencesActivity", "Received onClick event for button: " + button);
		
		if(button == btnRetrievePrefs) { 
			doRetrievePreferences();
		} else {
			Log.w("PreferencesActivity", "Got an unresolvable onClick event for button: " + button);
		}
	}
	
	private void doRetrievePreferences()
	{
		String username = etUsername.getText().toString();
		String password = etPassword.getText().toString();
		
		StringBuilder sb = new StringBuilder();
		sb.append("Username=");
		sb.append(username);
		sb.append("\n");
		sb.append("Password=");
		sb.append(password);
		
		//	Save the credentials so we don't have to log in all the time
		//	but be sure to do it in a private file so they are "secure"
		try {
	
			Context context = getApplicationContext();
			
			FileOutputStream stream;
			stream = context.openFileOutput(CREDENTIALS_FILE, Context.MODE_PRIVATE);
			
			OutputStreamWriter bw = new OutputStreamWriter(stream);
			
			bw.write(sb.toString());
			bw.flush();
			bw.close();

		} catch (Exception e) {
			
		}
		
		//	Retrieve the account preferences from the web service
				
		try {
			String accountServiceUrl = getResources().getString(R.string.account_service);
			String actualUrl = accountServiceUrl + "?method=getAccountId&username=" + username + "&password=" + password;
			
			StringBuilder responseText = new StringBuilder();
			
			URL url = new URL(actualUrl);			
			
			URLConnection conn = url.openConnection ();
		
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = rd.readLine()) != null) {
				responseText.append(line);
			}
			rd.close();
			
			//	Check to see if login was successful
			Log.d("PreferencesActivity", "Raw result from account service: " + responseText.toString());
			String[] tokens = responseText.toString().split("=");
			String accountId = null;
			String errorMessage = null;
			if("account_id".equals(tokens[0])) {
				accountId = tokens[1];
			} else {
				errorMessage = tokens[1];
			}
			
			if(accountId != null) {
				Context context = getApplicationContext();
				FileOutputStream stream;
				stream = context.openFileOutput(ACCOUNT_FILE, Context.MODE_WORLD_READABLE | Context.MODE_WORLD_WRITEABLE);
				OutputStreamWriter bw = new OutputStreamWriter(stream);
				bw.write(accountId);
				bw.close();
				
				SharedPreferences settings = context.getSharedPreferences("CoolAppPreferences", Context.MODE_WORLD_READABLE | Context.MODE_WORLD_WRITEABLE );
				Editor editor = settings.edit();
				editor.putString("AccountId", accountId);
				boolean success = editor.commit();
				if(success) {
					Log.d("PreferencesActivity", "Preferences saved successfully");
				} else {
					Log.d("PreferencesActivity", "Preferences not saved for some reason");
				}
				
				tvStatus.setText("Login successful. Your account ID is: " + accountId);
				
			} else {
				tvStatus.setText(errorMessage);
			}
		} catch (Exception e) {
			Log.e("PreferencesActivity", "Exception " + e);
			tvStatus.setText(e.toString());
		}
	}
}
