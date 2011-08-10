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

package com.denimgroup.android.training.pandemobium.stocktrader.util;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import android.content.Context;
import android.util.Log;

import com.denimgroup.android.training.pandemobium.stocktrader.PreferencesActivity;

public class AccountUtils {
	public static String retrieveAccountId(Context context) {
		
		String accountId = null;
		
		try {		
			FileInputStream stream;
			stream = context.openFileInput(PreferencesActivity.ACCOUNT_FILE);
			StringBuilder fileData = new StringBuilder();
	        BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
	        char[] buf = new char[1024];
	        int numRead=0;
	        while((numRead=reader.read(buf)) != -1){
	            String readData = String.valueOf(buf, 0, numRead);
	            fileData.append(readData);
	        }
	        reader.close();
	        accountId = fileData.toString();
	        
	        Log.d("AccountUtils", "Account ID is: " + accountId);
	        
		} catch (IOException ioe) {
			Log.e("AccountUtils", "Exception while trying to read account ID from file: " + ioe.toString());
		}
		
		
		
		
		return(accountId);
	}
}
