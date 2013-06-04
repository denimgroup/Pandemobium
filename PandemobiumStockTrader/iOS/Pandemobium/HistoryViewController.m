//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with 
// vulnerabilities included for security testing purposes.
// Copyright (c) 2011 Denim Group, Ltd. All rights reserved worldwide.
//
// This file is part of Pandemobium Stock Trader.
//
// Pandemobium Stock Trader is free software: you can redistribute it 
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader.  If not, see
// <http://www.gnu.org/licenses/>.
//

#import "HistoryViewController.h"
#import "StockDatabase.h"
#import "sqlite3.h"


@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
   
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
-(NSString *) getTradeHistory
{
    sqlite3_stmt * stmt;
    
    StockDatabase * db = [[StockDatabase alloc] init];
    
    sqlite3 * stockDB = db.openDatabase;
    
    NSString *querySQL = @"SELECT trade_type, shares, symbol, price, trade_time FROM trade ORDER BY trade_time ASC";
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(stockDB, query_stmt, -1, &stmt, NULL);
    
    NSString * tradeHistoryString = [[NSString alloc] init];
    
    int counter = 0;
    
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        NSString *trade_type = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(stmt, 0)];
        
        NSString *shares = [[NSString alloc] initWithUTF8String:
                            (const char *) sqlite3_column_text(stmt, 1)];
        
        NSString *symbol = [[NSString alloc] initWithUTF8String:
                            (const char *) sqlite3_column_text(stmt, 2)];
        
        NSString *price = [[NSString alloc] initWithUTF8String:
                           (const char *) sqlite3_column_text(stmt, 3)];
        
        
        NSString *trade_time = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(stmt, 4)];
        
        NSString * lineString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@\n",trade_type, shares, symbol, price, trade_time];
        
        // Code to do something with extracted data here
        
        tradeHistoryString = [tradeHistoryString stringByAppendingString:lineString];
        
        counter++;
        
        [trade_type release];
        [shares release];
        [symbol release];
        [price release];
        [trade_time release];
    }
    sqlite3_finalize(stmt);
    sqlite3_close(stockDB);
    [db release];
    
    return tradeHistoryString;

}

-(NSString *) getTipsHistory
{
    sqlite3_stmt * stmt;
    
    StockDatabase * db = [[StockDatabase alloc] init];
    
    sqlite3 * stockDB = db.openDatabase;
    
    NSString *querySQL = @"SELECT symbol, target_price, reason FROM tip ORDER BY symbol ASC";
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(stockDB, query_stmt, -1, &stmt, NULL);
    
    NSString * tipHistoryString = [[NSString alloc] init];
    
    int counter = 0;
    
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        NSString *symbol = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(stmt, 0)];
        
        NSString *target_price = [[NSString alloc] initWithUTF8String:
                            (const char *) sqlite3_column_text(stmt, 1)];
        
        NSString *reason = [[NSString alloc] initWithUTF8String:
                            (const char *) sqlite3_column_text(stmt, 2)];
        
     
        
        NSString * lineString = [NSString stringWithFormat:@"%@ %@ %@\n",symbol, target_price, reason];
        
        // Code to do something with extracted data here
        
        tipHistoryString = [tipHistoryString stringByAppendingString:lineString];
        
        counter++;
        
        [symbol release];
        [target_price release];
        [reason release];
    }
    sqlite3_finalize(stmt);
    sqlite3_close(stockDB);
    [db release];
    
    return tipHistoryString;
    
}


-(void) update 
{
      
    tradeHistory.text = [self getTradeHistory];
    tipHistory.text = [self getTipsHistory];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
