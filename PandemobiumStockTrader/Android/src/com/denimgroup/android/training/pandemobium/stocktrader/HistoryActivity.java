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

import java.util.Date;

import android.app.Activity;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.widget.TextView;

public class HistoryActivity extends Activity {
	
	private TextView tvTradeHistory;
	private TextView tvTipHistory;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.history);
        
        tvTradeHistory = (TextView)findViewById(R.id.tv_trade_history);
        tvTipHistory = (TextView)findViewById(R.id.tv_tip_history);
        
        StringBuilder sb;
        
		StockDatabase dbHelper = new StockDatabase(this.getApplicationContext());
		SQLiteDatabase db = dbHelper.openDatabase();
		
		Cursor trades = db.rawQuery("SELECT trade_type, shares, symbol, price, trade_time FROM trade ORDER BY trade_time ASC", null);
		int numTrades = trades.getCount();
		sb = new StringBuilder();
		sb.append("TRADE HISTORY:\n");
		if(numTrades == 0) {
			sb.append("No trades yet!\n");
		} else {
			trades.moveToFirst();
			for(int i = 0; i < numTrades; i++) {
				sb.append(trades.getString(0));
				sb.append(" ");
				sb.append(trades.getInt(1));
				sb.append(" shares of ");
				sb.append(trades.getString(2));
				sb.append(" for ");
				sb.append(trades.getDouble(3));
				sb.append(" on ");
				sb.append(new Date(trades.getLong(4)));
				sb.append("\n");
				trades.moveToNext();
			}
		}
		tvTradeHistory.setText(sb.toString());
		
		trades.close();
		
		Cursor tips = db.rawQuery("SELECT symbol, target_price, reason FROM tip ORDER BY symbol ASC", null);
		int numTips = tips.getCount();
		sb = new StringBuilder();
		sb.append("TIP HISTORY:\n");
		if(numTips == 0) {
			sb.append("No tips yet!\n");
		} else {
			tips.moveToFirst();
			for(int i = 0; i < numTips; i++) {
				sb.append(tips.getString(0));
				sb.append(" with a target price of ");
				sb.append(tips.getDouble(1));
				sb.append("\nREASON:");
				sb.append(tips.getString(2));
				sb.append("\n");
				tips.moveToNext();
			}
		}
		tvTipHistory.setText(sb.toString());
		
		tips.close();
		
		db.close();
    }

}
