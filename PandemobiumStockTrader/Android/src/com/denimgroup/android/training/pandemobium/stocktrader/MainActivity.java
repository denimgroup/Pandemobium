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

import com.denimgroup.android.training.pandemobium.stocktrader.R;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity implements OnClickListener {
	
	public static String APP_SETTINGS_FILE = "Settings";
	
	private Button btnTips;
	private Button btnTrade;
	private Button btnPreferences;
	private Button btnHistory;
	private Button btnManageTips;
	private Button btnAbout;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        btnTips = (Button)findViewById(R.id.btn_tips);
        btnTips.setOnClickListener(this);
        
        btnTrade = (Button)findViewById(R.id.btn_trade);
        btnTrade.setOnClickListener(this);
        
        btnPreferences = (Button)findViewById(R.id.btn_preferences);
        btnPreferences.setOnClickListener(this);
        
        btnHistory = (Button)findViewById(R.id.btn_history);
        btnHistory.setOnClickListener(this);
        
        btnManageTips = (Button)findViewById(R.id.btn_manage_tips);
        btnManageTips.setOnClickListener(this);
        
        btnAbout = (Button)findViewById(R.id.btn_about);
        btnAbout.setOnClickListener(this);
    }
    
	@Override
	public void onClick(View button) {
		
		Log.i("MainActivity", "Received onClick event for button: " + button);
		
		if(button == btnTips) {
			Intent i = new Intent(getApplicationContext(),TipsActivity.class);
			startActivity(i);
		} else if (button == btnTrade) {
			Intent i = new Intent(getApplicationContext(),TradeActivity.class);
			startActivity(i);
		} else if (button == btnPreferences) {
			Intent i = new Intent(getApplicationContext(),PreferencesActivity.class);
			startActivity(i);
		} else if (button == btnHistory) {
			Intent i = new Intent(getApplicationContext(),HistoryActivity.class);
			startActivity(i);
		} else if (button == btnManageTips) {
			Intent i = new Intent(getApplicationContext(),ManageTipsActivity.class);
			startActivity(i);
		} else if (button == btnAbout) {
			Intent i = new Intent(getApplicationContext(),AboutActivity.class);
			startActivity(i);
		} else {
			Log.w("MainActivity", "Got an unresolvable onClick event for button: " + button);
		}
	}
}