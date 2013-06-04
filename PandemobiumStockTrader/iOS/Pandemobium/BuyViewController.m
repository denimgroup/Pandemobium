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

#import "BuyViewController.h"
#import "StockDatabase.h"
#import "sqlite3.h"


@implementation BuyViewController


@synthesize detailsLoader;
@synthesize detailKeys;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        stockDB = [[StockDatabase alloc] init];
    }
    return self;
}

-(void) clear
{
    symbolField.text = @"";
    sharesField.text = @"";
    buyStatus.text = @"";
    stockResults.text = @"";
}

-(IBAction) getQuote {
       
    [symbolField resignFirstResponder];
    
    [self.detailsLoader loadDetails:[symbolField text]];
}

-(void) handleUrl: (NSURL *)url {
    // do stuff
    
    NSArray *parameters = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [parameters count]; i=i+2) {
        [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
    }
    
    sharesField.text = [keyValueParm objectForKey:@"shares"];
    price = [[keyValueParm objectForKey:@"price"] doubleValue];
    symbolString = [keyValueParm objectForKey:@"symbol"];
    symbolField.text = symbolString;
    
    [self buyStocks];
    
}

-(NSString *) readAccountFile
{
    
    //get the documents directory:
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    //make a file name to write the data to using the documents directory:
    
    NSString *fileName = [NSString stringWithFormat:@"%@/account.txt", 
                          
                          documentsDirectory];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                         
                                                    usedEncoding:nil
                         
                                                           error:nil];
    
    //use simple alert from my library (see previous post for details)
    
    
    return content;
    
    
}


-(void) sendStockTransaction
{
    NSBundle * mainBundle;
    mainBundle = [NSBundle mainBundle];
    NSString * response;
    NSString * mySymbol = symbolString;
    NSString * myShares = [sharesField text];
    NSString * myUrl = [mainBundle objectForInfoDictionaryKey:@"trade_service"];
    
    NSString * accountId = [self readAccountFile];
    
    NSString * urlString = [NSString stringWithFormat:@"%@?method=executeBuy&id=%@&symbol=%@&quantity=%@&price=%lf",
                            myUrl,accountId,mySymbol,myShares,price ];
 
    
    NSURL * url = [[NSURL alloc] initWithString: urlString];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError * error = [request error];
    if (!error) 
    {
        response = [request responseString];
    }
    else 
    {
        response = [error description];
    }
    
    // do something with results? 
    
}

-(IBAction) buyStocks {
    
    [sharesField resignFirstResponder];
    
    [self sendStockTransaction];
    
    
    sqlite3 * db = stockDB.openDatabase;
    sqlite3_stmt *compiled_statement;

    NSString * mySymbol = [NSString stringWithString:  symbolString];
    
    
    NSString * formatedSql = [NSString  stringWithString:@"INSERT INTO trade (trade_time, trade_type, symbol, shares, price) VALUES (?, ?, ?, ?, ?)"];
    const char * sql = [formatedSql UTF8String];
    
    sqlite3_prepare_v2(db, sql, -1, &compiled_statement, NULL);
    
    sqlite3_bind_int64(compiled_statement, 1, [NSDate timeIntervalSinceReferenceDate]);
    sqlite3_bind_text(compiled_statement,  2, "Buy", -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(compiled_statement, 3, [mySymbol UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(compiled_statement, 4, [[sharesField text] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(compiled_statement, 5, price);
    
    int success = sqlite3_step(compiled_statement);
    
    sqlite3_reset(compiled_statement);
    
    sqlite3_close(db);
    
    buyStatus.text = @"Shares Purchased";
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//If we begin editing on the text field we need to move it up to make sure we can still
	//see it when the keyboard is visible.
	//
	//I am adding an animation to make this look better
    
    [((UIScrollView *)self.view)  setContentOffset:CGPointMake(0.0, textField.frame.origin.y-100) animated:YES];
    
	}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {	

    
    [((UIScrollView *)self.view)  setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

}

- (void)stockDetailsDidLoad:(YFStockDetailsLoader *)aDetailsLoader
{    
    self.detailKeys = [aDetailsLoader.stockDetails.detailsDictionary allKeys];
    // Do something with the data
    
    stockResults.text = [NSString stringWithFormat:@"Symbol:       %@\nLast Trade:  %@\nTrade Time:  %@\nChange:       %@", aDetailsLoader.stockDetails.symbol,aDetailsLoader.stockDetails.lastTradePriceOnly,aDetailsLoader.stockDetails.lastTradeTime, aDetailsLoader.stockDetails.change];
    
    symbolString = aDetailsLoader.stockDetails.symbol;
    price = [aDetailsLoader.stockDetails.lastTradePriceOnly doubleValue];
    [symbolString retain];
    
    
}

- (void)stockDetailsDidFail:(YFStockDetailsLoader *)aDetailsLoader
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Details failed" 
                                                    message:[aDetailsLoader.error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


- (void)dealloc
{
    [self.detailsLoader cancel];
    
    self.detailKeys = nil;
    self.detailsLoader = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    symbolField.delegate = self;
    sharesField.delegate = self;
    self.detailsLoader = [YFStockDetailsLoader loaderWithDelegate:self];

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
