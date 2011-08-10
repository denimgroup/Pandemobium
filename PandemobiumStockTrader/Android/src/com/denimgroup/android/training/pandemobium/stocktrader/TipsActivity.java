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
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;

public class TipsActivity extends Activity {
	
	private WebView wvTips;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	Log.i("TipsActivity", " Loading up browser page to display stock tips");
    	
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tips);
        
        wvTips = (WebView)findViewById(R.id.wv_tips);
        //	TOFIX - Pull this from preferences rather than hardcoding
        wvTips.loadUrl(getString(R.string.tip_list));
        //wvTips.loadUrl("http://10.0.2.2:8080/StockTrader/web/tips.jsp");
        // wvTips.loadUrl("file:///android_asset/tips/tips.html");
    }
}
