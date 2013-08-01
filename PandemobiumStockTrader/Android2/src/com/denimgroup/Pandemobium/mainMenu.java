package com.denimgroup.Pandemobium;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.content.Intent;
public class mainMenu extends Activity {
    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

    }
    public void signInPressed(View view)
    {
        System.out.println("sing in was pressed");
        Intent i = new Intent(mainMenu.this, SignIn.class);
        startActivity(i);

    }
    public void settingsPressed(View view)
    {
        System.out.println("settings was pressed");
        Intent i = new Intent(mainMenu.this, Settings.class);
        startActivity(i);

    }public void quotesPressed(View view)
    {
        System.out.println("quotes was pressed");
        Intent i = new Intent(mainMenu.this, Stock.class);
        startActivity(i);


    }public void searchPressed(View view)
    {
        System.out.println("search was pressed");
        Intent i = new Intent(mainMenu.this, Search.class);
        startActivity(i);

    }public void tradingPressed(View view)
    {
        System.out.println("trading was pressed");
        Intent i = new Intent(mainMenu.this, Trading.class);
        startActivity(i);

    }public void portfolioPressed(View view)
    {
        System.out.println("portfolio was pressed");
        Intent i = new Intent(mainMenu.this, Portfolio.class);
        startActivity(i);

    }public void tipsPressed(View view)
    {
        System.out.println("tips was pressed");
        Intent i = new Intent(mainMenu.this, Tips.class);
        startActivity(i);

    }public void historyPressed(View view)
    {
        System.out.println("history was pressed");
        Intent i = new Intent(mainMenu.this, History.class);
        startActivity(i);

    }public void manageTipsPressed(View view)
    {
        System.out.println("manage was pressed");
        Intent i = new Intent(mainMenu.this, TipManager.class);
        startActivity(i);

    }
    public void newsPressed(View view)
    {
        System.out.println("news was pressed");
        Intent i = new Intent(mainMenu.this, News.class);
        startActivity(i);

    }
}
