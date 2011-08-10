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

#import "TipViewController.h"
#import "StockDatabase.h"
#import "/usr/include/sqlite3.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@implementation TipViewController

@synthesize keyboardToolbar;

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
    priceField.text = @"";
    reasonField.text = @"";
    status.text = @"";
}

- (void)dealloc
{
    [super dealloc];
    [stockDB release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//If we begin editing on the text field we need to move it up to make sure we can still
	//see it when the keyboard is visible.
	//
	//I am adding an animation to make this look better
    
    [((UIScrollView *)self.view) setContentOffset:CGPointMake(0.0, textField.frame.origin.y-100) animated:YES];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView 
{
    [((UIScrollView *)self.view) setContentOffset:CGPointMake(0.0, textView.frame.origin.y-30) animated:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {	
    
    
    [((UIScrollView *)self.view)  setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [((UIScrollView *)self.view)  setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    symbolField.delegate = self;
    priceField.delegate = self;
    reasonField.delegate = self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];

    self.keyboardToolbar.hidden = FALSE;

	CGRect frame = self.keyboardToolbar.frame;
	frame.origin.y = self.view.frame.size.height - 110.0;
	self.keyboardToolbar.frame = frame;

 	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect frame = self.keyboardToolbar.frame;
	frame.origin.y = self.view.frame.size.height;
	self.keyboardToolbar.frame = frame;
	
	[UIView commitAnimations];
}

-(IBAction) hideKeyboard:(id)sender
{
    [reasonField resignFirstResponder];
}

-(NSString *) getTipsFromDatabase: (NSString *) symbol
{
    sqlite3_stmt * stmt;
    
    sqlite3 * db = stockDB.openDatabase;
    
    NSString *querySQL = @"SELECT symbol, target_price, reason FROM tip where symbol = ?";
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(db, query_stmt, -1, &stmt, NULL);
    
    sqlite3_bind_text(stmt,  1, [symbol UTF8String], -1, SQLITE_TRANSIENT);
    
    
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
        
        
        
        NSString * lineString = [NSString stringWithFormat:@"TIP%d:symbol=%@&target_price=%@&reason=@\n",counter,symbol, target_price, reason];
        
        // Code to do something with extracted data here
        
        tipHistoryString = [tipHistoryString stringByAppendingString:lineString];
        
        counter++;
        
        [symbol release];
        [target_price release];
        [reason release];
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    
    return tipHistoryString;
    
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


-(void) sendTips: (NSString *) symbol
{
    NSString * tipsToPost = [self getTipsFromDatabase:symbol];
    
    NSBundle * mainBundle;
    mainBundle = [NSBundle mainBundle];
    NSString * response;
    
    
    NSString * accountId = [self readAccountFile];
    NSString * myUrl = [mainBundle objectForInfoDictionaryKey:@"tip_service"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@?method=submitTips&id=%@&tip_creator=%@&symbol=%@&target_price=%@&reason=%@",
                            myUrl,accountId,@"dcornell",[symbolField text],
                            [priceField text], [reasonField text]];
    
    status.text = @"";
    
    if ([tipsToPost isEqualToString:@"" ])
    {
        status.text = @"No Tips to send.";
        
        return;
    }
        
    
    
    NSURL * url = [[NSURL alloc] initWithString: urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:tipsToPost forKey:@"tipData"];
    
    [request startSynchronous];
    
    NSError * error = [request error];
    if (!error) 
    {
        response = [request responseString];
        status.text = @"Tip sent!";
    }     
  
    
    
}

-(void) handleUrl: (NSURL *)url {
    // do stuff
    NSArray *parameters = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [parameters count]; i=i+2) {
        [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
    }
    
    NSString * symbol = [keyValueParm objectForKey:@"symbol"];
    
    [self sendTips:symbol];
}


-(IBAction) saveTip 
{
   
    
    sqlite3 * db = stockDB.openDatabase;
    sqlite3_stmt *compiled_statement;
    
    NSString * formatedSql = [NSString stringWithFormat:@"INSERT INTO tip (tip_creator, symbol, target_price, reason) VALUES (?, ?, ?, ?)"];
    const char * sql = [formatedSql UTF8String];
    
    sqlite3_prepare_v2(db, sql, -1, &compiled_statement, NULL);
    
    sqlite3_bind_text(compiled_statement, 1, "USERNAME", -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(compiled_statement,  2, [[symbolField text] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(compiled_statement, 3, [[priceField text] doubleValue]);
   sqlite3_bind_text(compiled_statement, 4, [[reasonField text] UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(compiled_statement);
    
    sqlite3_reset(compiled_statement);
    
    sqlite3_close(db);
    
    status.text = @"Tip saved!";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
