package com.denimgroup.Pandemobium;

import android.app.ListActivity;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.XmlResourceParser;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.*;
import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.text.Editable;
import android.text.TextWatcher;

/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/25/13
 * Time: 10:28 AM
 * To change this template use File | Settings | File Templates.
 */
//public class Search extends ListActivity {
 public class Search extends Activity {

    ListView listView;
    SimpleAdapter adapter;
    EditText inputSearch;
    List<HashMap<String, String>> stockList;

    @Override
    protected  void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        PListParser parser = new PListParser(getApplicationContext());
        stockList = parser.getPlistValues();
         String from[] = {"symbol", "name"};
      //  int[] to = { android.R.id.text1, android.R.id.text2 };
        int[] to = { android.R.id.text1, android.R.id.text2 };


        // setListAdapter(new SimpleAdapter(this, stockList, android.R.layout.simple_list_item_2, from, to));
  //     setListAdapter(new SimpleAdapter(this, stockList, R.layout.search, from, to));
 //       ListView listView = getListView();
   //     listView.setTextFilterEnabled(true);

        setContentView(R.layout.search);

        listView = (ListView) findViewById(R.id.list_view);
        listView.setTextFilterEnabled(true);
        //listView.onSele

        inputSearch = (EditText) findViewById(R.id.inputSearch);


        adapter = new SimpleAdapter(this, stockList, R.layout.list_item, from, to) ;
        listView.setAdapter(adapter);


        inputSearch.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence cs, int arg1, int arg2, int arg3) {
                // When user changed the Text
                Search.this.adapter.getFilter().filter(cs);
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2,
                                          int arg3) {
                // TODO Auto-generated method stub

            }

            @Override
            public void afterTextChanged(Editable arg0) {
                // TODO Auto-generated method stub
            }
        });

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                // When clicked, show a toast with the TextView text
                Toast.makeText(getApplicationContext(),
                        stockList.get(position).values().toString(), Toast.LENGTH_SHORT).show();
                Intent i = new Intent(Search.this, Quotes.class);
                startActivity(i);
            }
        });



    }

    public class PListParser {
        Context context;

        // constructor for  to get the context object from where you are using this plist parsing
        public PListParser(Context ctx) {

            context = ctx;
        }

        public List<HashMap<String, String>> getPlistValues() {

            //http://solutionforandroid.blogspot.com/2013/05/how-to-parse-plist-in-android-and-how.html


            // specifying the  your plist file.And Xml ResourceParser is an event type parser for more details Read android source
            XmlResourceParser parser = context.getResources()
                    .getXml(R.xml.full_stock_list);



            // flag points to find key and value tags .
            boolean keytag = false;
            boolean valuetag = false;
            String keyStaring = null;
            String stringvalue = null;


            HashMap<String, String> hashmap = new HashMap<String, String>();
            List<HashMap<String, String>> listResult = new ArrayList<HashMap<String, String>>();
            int event;
            try {
                event = parser.getEventType();

                // repeting the loop at the end of the doccument

                while (event != parser.END_DOCUMENT) {

                    switch (event) {
                        //use switch case than the if ,else statements
                        case 0:
                            // start doccumnt nothing to do
                            // System.out.println("\n" + parser.START_DOCUMENT
                            // + "strat doccument");
                            // System.out.println(parser.getName());
                            break;
                        case 1:
                            // end doccument
                            // System.out
                            // .println("\n" + parser.END_DOCUMENT + "end doccument");
                            // System.out.println(parser.getName());
                            break;
                        case 2:

                            if (parser.getName().equals("key")) {
                                keytag = true;
                                valuetag = false;
                            }
                            if (parser.getName().equals("string")) {
                                valuetag = true;
                            }

                            break;
                        case 3:
                            if (parser.getName().equals("dict")) {
                                System.out.println("end tag");
                                listResult.add(hashmap);
                                //System.out.println(hashmap);
                                System.out.println(listResult.size() + "size");
                                hashmap = null;
                                hashmap = new HashMap<String, String>();
                            }
                            break;
                        case 4:
                            if (keytag) {
                                if (valuetag == false) {
                                    // hashmap.put("value", parser.getText());
                                    // System.out.println(parser.getText());
                                    // starttag = false;
                                    keyStaring = parser.getText();
                                }
                            }
                            if (valuetag && keytag) {
                                stringvalue = parser.getText();

                                hashmap.put(keyStaring, stringvalue);
                                // System.out.println(keyStaring);
                                // System.out.println(stringvalue);
                                valuetag = false;
                                keytag = false;
                                // System.out.println("this is hash map"
                                // + hashmap.get(keyStaring));
                                // Toast.makeText(getApplication(), keyStaring,
                                // Toast.LENGTH_SHORT).show();

                            }
                            break;
                        default:
                            break;
                    }
                    event = parser.next();
                }
            } catch (XmlPullParserException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            //here you get the plistValues.
            return listResult;
        }
    }



}
