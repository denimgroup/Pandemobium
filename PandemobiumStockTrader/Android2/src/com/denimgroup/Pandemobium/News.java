package com.denimgroup.Pandemobium;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/25/13
 * Time: 10:30 AM
 * To change this template use File | Settings | File Templates.
 */
public class News extends Activity {
    @Override
    protected  void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.news);

        WebView webView = (WebView) findViewById(R.id.webView);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadUrl("http://www.google.com");

    }


}
