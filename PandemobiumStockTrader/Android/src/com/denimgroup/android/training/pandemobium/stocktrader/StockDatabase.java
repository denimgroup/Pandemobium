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

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class StockDatabase {

	private static String DATABASE_NAME = "stocks.db";
	
	private static String[] CREATE_STATEMENTS = 
	{
		"CREATE TABLE trade (id INTEGER PRIMARY KEY AUTOINCREMENT, trade_time INT, trade_type TEXT, symbol TEXT, shares INTEGER, price REAL)",
		"CREATE TABLE tip (id INTEGER PRIMARY KEY AUTOINCREMENT, tip_creator TEXT, symbol TEXT, current_price REAL, target_price REAL, reason TEXT)"
		
	};
	
	private Context theContext;
	
	StockDatabase(Context context) {
		
		this.theContext = context;
		
		String fullDbPath = null;
		try {
			fullDbPath = context.getDatabasePath(DATABASE_NAME).getCanonicalPath();
		} catch (IOException ioe) {
			Log.e("StockDatabase", "Error when resolving database path name for database: " + DATABASE_NAME + ": " + ioe.toString());
		}
		Log.i("StockDatabase", "Database file path is: " + fullDbPath);
		boolean doesDbExist = checkDatabase(fullDbPath);
		if(!doesDbExist) {
			SQLiteDatabase db = context.openOrCreateDatabase(DATABASE_NAME, Context.MODE_WORLD_READABLE | Context.MODE_WORLD_WRITEABLE, null);
			createDatabase(db);
		}
	}
	
	public SQLiteDatabase openDatabase() {
		return(this.theContext.openOrCreateDatabase(DATABASE_NAME, Context.MODE_WORLD_READABLE | Context.MODE_WORLD_WRITEABLE, null));
	}
	
	private void createDatabase(SQLiteDatabase db) {
		Log.i("StockDatabase", "Creating database " + DATABASE_NAME);
		for (String currentSql : CREATE_STATEMENTS) {
			Log.d("StockDatabase", currentSql);
			db.execSQL(currentSql);
		}
	}
	
	private boolean checkDatabase(String fullPath) {
	    SQLiteDatabase checkDb = null;
	    try {
	        checkDb = SQLiteDatabase.openDatabase(fullPath, null, SQLiteDatabase.OPEN_READONLY);
	        checkDb.close();
	    } catch (SQLiteException e) {
	        // database doesn't exist yet.
	    }
	    return checkDb != null ? true : false;
	}
}
