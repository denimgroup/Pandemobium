//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with
// vulnerabilities included for security testing purposes.
// Copyright (c) 2013 Denim Group, Ltd. All rights reserved worldwide.
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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader. If not, see
// <http://www.gnu.org/licenses/>.


#import "TradeViewController.h"
#import "AppDelegate.h"


@interface TradeViewController () <UITextFieldDelegate>


@end

@implementation TradeViewController

//for querying data to send out a request to trade
@synthesize amountofShares;
@synthesize companyCode;

//for displaying data from account
@synthesize accountAmount;
@synthesize accountNumber;
@synthesize canInvest;
@synthesize symbol;
@synthesize shares;
//@synthesize appDelegate;

@synthesize activityIndicator;

AppDelegate *appDelegate;
BOOL *firstTime;
NSString *stockSymbol;

CGFloat animatedDistance;


// ------- Handle OpenURL ---------
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[url absoluteString] hasPrefix:@"trade"])
    {
      //  NSLog(@"Inside trade view controller");
        appDelegate = [UIApplication sharedApplication].delegate;
        
        
        NSArray *parameters = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < [parameters count]; i=i+2) {
            [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
        }
        
        shares = [[NSNumber alloc] initWithInt:[[keyValueParm objectForKey:@"shares"] intValue]];
        symbol = [[NSString alloc]initWithFormat:@"%@", [keyValueParm objectForKey:@"symbol"]];
        firstTime = (BOOL *)1;
        if([[url host] isEqualToString:@"buy"])
        {
        //    NSLog(@"will buy %i %@",[shares intValue], symbol);
            [self tradebuttonPressed:self];
            
            
        }
        else if ([[url host]isEqualToString:@"sell"])
        {
        //    NSLog(@"will sell %i %@",[shares intValue], symbol);
            [self sellButtonPressed:self];

        }
        return YES;
        
    }
    return NO;
}


- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6] ;
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

// ---------------------------------


//for animating keyboard
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

/////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"outOfRange"
                                               object:nil];

 
    appDelegate = [UIApplication sharedApplication].delegate;
    
    if(![symbol isEqual:NULL])
    {
        companyCode.text = symbol;
        
    }
    
    [self fetchData];
    //use accountAmount, accountNumber, and canInvest to display user data
    //query user database and yahoo to get info
    
}

-(void)fetchData
{
    NSDictionary *results;
    NSArray *stocks;
    DBHelper * helper = [[DBHelper alloc]init];
    
    if(appDelegate.user.loggedIn.intValue == 1)
    {
        accountNumber.text = [[NSString alloc] initWithFormat:@"%i", appDelegate.user.accountID.intValue];
        
        results = [helper getAccountInfo:appDelegate.user.accountID];
        canInvest.text = [[NSString alloc] initWithFormat:@"$%.2f", [[results objectForKey:@"BALANCE"] floatValue]];
        
        stocks = [helper getPurchasedStocks:appDelegate.user.accountID];

        if([stocks count] > 0)
        {
            
            NSNumber *balance = [helper getAccountValue:appDelegate.user.accountID];
            accountAmount.text = [[NSString alloc]initWithFormat:@"$%.2f", [balance doubleValue]];
        }
        else
        {
            accountAmount.text = [[NSString alloc]initWithFormat:@"$%.2f", 0.0];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)revealMenu:(id)sender
{
    [SVProgressHUD show];
    
    if(appDelegate.user.reloadData == [[NSNumber alloc]initWithInt:1] )
    {
        [SVProgressHUD show];
        // favoriteStocks = app.user.oldFavorites;
        DBHTTPClient *client = [DBHTTPClient sharedClient];
        client.delegate = self;
        [client getAllStockValue:appDelegate.user.accountID];
        //favoriteStocks = [helper getAllStockValue:app.user.accountID];
        //app.user.favoriteStocks = self.favoriteStocks;
    }
    else
    {
        [self performSegueWithIdentifier:@"notTrading" sender:sender];
    }
}



//for handling input text and keybaord behavior
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline= textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y -MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame= self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-  (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) stockExists:(NSString *)stockSymbol
{
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    NSError *error;
    NSArray *stockArray = [context executeFetchRequest:request error:&error];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    stockArray = [stockArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol CONTAINS[cd] %@", stockSymbol];
    NSArray *tempArray = [stockArray filteredArrayUsingPredicate:predicate];
    
    if([tempArray count] == 1)
    {
        return YES;
    }
    return NO;
    
}

-(BOOL) validateEntries
{
    UIAlertView * alert;
    NSString *message;
    
    if((companyCode.text == nil) && (firstTime == (BOOL *)1))
    {
        stockSymbol = symbol;
    }
    else
    {
        stockSymbol = companyCode.text;
    }
    if(firstTime == (BOOL *)1)
    {
        firstTime = (BOOL *)0;
    }
    else //  if(shares == nil)
    {
        shares = [[NSNumber alloc]initWithInt:[amountofShares.text intValue]];
        firstTime = (BOOL *)0;
    }
    
    
    if((![stockSymbol isEqualToString:@""]) && [shares intValue] > 0)
    {
        
        if([appDelegate.user.loggedIn intValue] == 1) //User logged in
        {
            if([self stockExists:stockSymbol] == YES)
            {
                
                return YES;
            }
            else
            {
                message = @"Stock symbol does not exist";
            }
        }
        else
        {
            message=@"Must be logged in to Buy/Sell";
        }
    }
    else
    {
        message=@"Shares or Company Symbol cannot be empty and must sell at least 1 share!";
    }
    
    
    alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"Try Again"
                             otherButtonTitles: nil];
    [alert show];
    
    
    return NO;
}

- (IBAction)tradebuttonPressed:(id)sender
{
    UIAlertView * alert;
    NSString *message;
    
    
    if([self validateEntries] == YES)
    {
        DBHelper *helper = [[DBHelper alloc]init];
        NSDictionary * yahooQuery = [helper fetchYahooData:stockSymbol];
        stockSymbol = [yahooQuery valueForKey:@"Symbol"]; //Uses Yahoos API for the proper naming convention. 
        
        NSNumber * cost = [[NSNumber alloc] initWithDouble:[[yahooQuery objectForKey:@"LastTradePriceOnly"] doubleValue ]];
        cost = [[NSNumber alloc] initWithDouble:([cost doubleValue] * [shares doubleValue])];
        
        NSDictionary * accountInfo = [helper getAccountInfo:appDelegate.user.accountID];
        NSNumber * newBalance = [[NSNumber alloc]initWithDouble:
                                 ([[accountInfo objectForKey:@"BALANCE"] doubleValue] - [cost doubleValue])];
        
        if([newBalance doubleValue] >= 0.0) // Has enough money to buy stocks
        {
            
            NSDictionary * balanceResults = [helper updateAccountBalance:appDelegate.user.accountID newBalance:newBalance];
            if([[balanceResults objectForKey:@"Result"]intValue] == 1)
            {
                
                NSDictionary * buyResults = [helper buyStock:shares forSymbol:stockSymbol fromAccountID:appDelegate.user.accountID];
                
                if([[buyResults objectForKey:@"Result"]intValue] == 1)
                {
                    alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                       message:@"Stock Purchase Succesfully"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
                    
                    appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:1];
                    DBHTTPClient *client = [DBHTTPClient sharedClient];
                    client.delegate = self;
                    
                    [client addHistory:appDelegate.user.userID forLog:
                     [[NSString alloc]initWithFormat:@"Purchased %i shares of %@ in Account %i",
                      [shares intValue], stockSymbol, [appDelegate.user.accountID intValue]]];
                    
                    [alert show];
                    companyCode.text = @"";
                    amountofShares.text =@"";

                    [self viewDidLoad];
                    return;
                    
                }
                else
                {
                    //Put the money back into the account
                    newBalance = [[NSNumber alloc]initWithDouble:[[accountInfo objectForKey:@"BALANCE"] doubleValue]];
                    balanceResults = [helper updateAccountBalance:appDelegate.user.accountID newBalance:newBalance];
                    message = @"Purchasing Stock";
                }
            }
            else
            {
                message = @"Updating Account Balance";
                
            }
        }
        else
        {
            message = @"Insufficient Funds";
            
        }
        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
        [alert show];
        
    }
    
}

- (IBAction)sellButtonPressed:(id)sender {
    
    UIAlertView * alert;
    NSString *message;
    
    if([self validateEntries] == YES)
    {
        DBHelper *helper = [[DBHelper alloc]init];
        NSDictionary * yahooQuery = [helper fetchYahooData:stockSymbol];
        stockSymbol = [yahooQuery valueForKey:@"Symbol"];
        
        NSNumber * cost = [[NSNumber alloc] initWithDouble:[[yahooQuery objectForKey:@"LastTradePriceOnly"] doubleValue ]];
        cost = [[NSNumber alloc] initWithDouble:([cost doubleValue] * [shares doubleValue])];
        
        NSDictionary * accountInfo = [helper getAccountInfo:appDelegate.user.accountID];
        NSNumber * newBalance = [[NSNumber alloc]initWithDouble:
                                 ([[accountInfo objectForKey:@"BALANCE"] doubleValue] + [cost doubleValue])];
        
        
        NSArray * listOfStocks = [helper getPurchasedStocks:appDelegate.user.accountID];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SYMBOL = %@", stockSymbol];
        NSArray * matched = [listOfStocks filteredArrayUsingPredicate:p];
        
        if([matched count] >= 1)
        { //Stock Exists
            
            if([[[matched objectAtIndex:0] valueForKey:@"SHARES"]intValue] >= [shares intValue])
            { //Has sufficient stock
                
                NSDictionary * balanceResults = [helper updateAccountBalance:appDelegate.user.accountID newBalance:newBalance];
                if([[balanceResults objectForKey:@"Result"]intValue] == 1)
                { //Updated Balance
                    
                    NSDictionary * sellResults = [helper sellStock:shares forSymbol:stockSymbol fromAccountID:appDelegate.user.accountID];
                    
                    
                    if([[sellResults objectForKey:@"Result"]intValue] == 1)
                    { //Sold the stock
                        appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:1];
                        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                           message:@"Stock Sold Succesfully"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
                        DBHTTPClient *client = [DBHTTPClient sharedClient];
                        client.delegate = self;
                        [client addHistory:appDelegate.user.userID forLog:
                         [[NSString alloc]initWithFormat:@"Sold %i shares of %@ in Account %i",
                          [shares intValue], stockSymbol, [appDelegate.user.accountID intValue]]];
                        
                        [alert show];
                        companyCode.text = @"";
                        amountofShares.text =@"";
                        [self viewDidLoad];
                        
                        return;
                    }
                    else
                    {
                        //put the money back
                        newBalance = [[NSNumber alloc]initWithDouble:[[accountInfo objectForKey:@"BALANCE"] doubleValue]];
                        [helper sellStock:shares forSymbol:stockSymbol fromAccountID:appDelegate.user.accountID];
                        
                        message = @"Selling stock";
                    }
                }
                else
                {
                    message =@"Updating Account Balance";
                }
            }
            else
            {
                message = @"Insufficient shares to sell";
            }
            
        }
        else
        {
            message = @"You do not own this stock";
        }
        
        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
        [alert show];
    }
}

-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares
{
    appDelegate.user.favoriteStocks = results;
    appDelegate.user.oldFavorites = results;
    appDelegate.user.accountValue = totalValue;
    appDelegate.user.totalShares = totalShares;
    appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:0];
    
    [self performSegueWithIdentifier:@"notTrading" sender:self];
    [SVProgressHUD dismiss];
    
}

-(void)handleUpdatedData:(NSNotification *)notification {
    //  NSLog(@"recieved");
    [self viewDidLoad];
}



@end
