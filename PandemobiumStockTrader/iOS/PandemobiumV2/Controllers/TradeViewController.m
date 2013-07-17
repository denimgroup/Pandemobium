//
//  TradeViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 6/27/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "TradeViewController.h"

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

@synthesize activityIndicator;

CGFloat animatedDistance;

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *results;
    NSArray *stocks;
    DBHelper * helper = [[DBHelper alloc]init];
    
    if(appDelegate.user.loggedIn.intValue == 1)
    {
        accountNumber.text = [[NSString alloc] initWithFormat:@"%i", appDelegate.user.accountID.intValue];
        
        results = [helper getAccountInfo:appDelegate.user.accountID];
        canInvest.text = [[NSString alloc] initWithFormat:@"$%.2f", [[results objectForKey:@"balance"] floatValue]];
        
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
    NSLog(@"Reveal Menu Button has been pressed");

    //[self.slidingViewController anchorTopViewTo:ECRight];

    [self performSegueWithIdentifier:@"notTrading" sender:sender];
    
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

- (IBAction)tradebuttonPressed:(id)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIAlertView * alert;
    
    NSString * stockSymbol = companyCode.text;
    NSNumber * shares = [[NSNumber alloc]initWithInt:[amountofShares.text intValue]];
    NSDictionary * yahooQuery;

    if((![stockSymbol isEqualToString:@""]) && [shares intValue] > 0)
    {
    
        if([appDelegate.user.loggedIn intValue] == 1) //User logged in
        {
            DBHelper *helper = [[DBHelper alloc]init];
            yahooQuery = [helper fetchYahooData:stockSymbol];
            if(![[yahooQuery objectForKey:@"Symbol"] isEqual:nil]) //Stock Exists
            {
                NSNumber * cost = [[NSNumber alloc] initWithDouble:[[yahooQuery objectForKey:@"LastTradePriceOnly"] doubleValue ]];
                cost = [[NSNumber alloc] initWithDouble:([cost doubleValue] * [shares doubleValue])];
                
                NSDictionary * accountInfo = [helper getAccountInfo:appDelegate.user.accountID];
                NSNumber * newBalance = [[NSNumber alloc]initWithDouble:
                                         ([[accountInfo objectForKey:@"balance"] doubleValue] - [cost doubleValue])];
                
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
                            [helper addHistory:appDelegate.user.userID forLog:
                                [[NSString alloc]initWithFormat:@"Purchased %i shares of %@ in Account %i",
                                 [shares intValue], stockSymbol, [appDelegate.user.accountID intValue]]];
                            
                            [alert show];
                            [self viewDidLoad];
                            
                        }
                        else
                        {
                            alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                               message:@"Something went wrong with Purchasing stock."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Try Again"
                                                     otherButtonTitles: nil];
                            [alert show];
                            

                            
                        }
                    }
                    else
                    {
                        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                           message:@"Something went wrong with Account Balance."
                                                          delegate:nil
                                                 cancelButtonTitle:@"Try Again"
                                                 otherButtonTitles: nil];
                        [alert show];
                        
                        
                        
                    }

                }
                else
                {
                    alert = [[UIAlertView alloc] initWithTitle:@"Insufficient Funds"
                                                       message:@"Not enough funds in you account"
                                                      delegate:nil
                                             cancelButtonTitle:@"Try Again"
                                             otherButtonTitles: nil];
                    [alert show];
                    
                    
                }
                
            }
            else
            {
                alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stock"
                                                   message:@"Stock does not exist"
                                                  delegate:nil
                                         cancelButtonTitle:@"Try Again"
                                         otherButtonTitles: nil];
                [alert show];

                
            }
            
        }
        else
        {
            //User is not logged in, show an alert
            alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                               message:@"Must be logged in to 'Trade'"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        
        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                           message:@"Shares or Company Symbol cannot be empty and must buy at least 1 share!"
                                          delegate:nil
                                 cancelButtonTitle:@"Try Again"
                                 otherButtonTitles: nil];
        [alert show];
     }
    
    
}

- (IBAction)sellButtonPressed:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIAlertView * alert;
    
    NSString * stockSymbol = companyCode.text;
    NSNumber * shares = [[NSNumber alloc]initWithInt:[amountofShares.text intValue]];
    NSDictionary * yahooQuery;
    
    if((![stockSymbol isEqualToString:@""]) && [shares intValue] > 0)
    {
        
        if([appDelegate.user.loggedIn intValue] == 1) //User logged in
        {
            DBHelper *helper = [[DBHelper alloc]init];
            yahooQuery = [helper fetchYahooData:stockSymbol];
            if(![[yahooQuery objectForKey:@"Symbol"] isEqual:nil]) //Stock Exists
            {
                NSNumber * cost = [[NSNumber alloc] initWithDouble:[[yahooQuery objectForKey:@"LastTradePriceOnly"] doubleValue ]];
                cost = [[NSNumber alloc] initWithDouble:([cost doubleValue] * [shares doubleValue])];
                
                NSDictionary * accountInfo = [helper getAccountInfo:appDelegate.user.accountID];
                NSNumber * newBalance = [[NSNumber alloc]initWithDouble:
                                         ([[accountInfo objectForKey:@"balance"] doubleValue] + [cost doubleValue])];
                
                
                NSArray * listOfStocks = [helper getPurchasedStocks:appDelegate.user.accountID];
                NSPredicate *p = [NSPredicate predicateWithFormat:@"symbol = %@", stockSymbol];
                NSArray * matched = [listOfStocks filteredArrayUsingPredicate:p];
                
                if([matched count] >= 1)
                { //Stock Exists
                    
                    if([[[matched objectAtIndex:0] valueForKey:@"shares"]intValue] <= [shares intValue])
                    { //Has sufficient stock
                        
                        NSDictionary * balanceResults = [helper updateAccountBalance:appDelegate.user.accountID newBalance:newBalance];
                        if([[balanceResults objectForKey:@"Result"]intValue] == 1)
                        { //Updated Balance
                            
                            NSDictionary * sellResults = [helper sellStock:shares forSymbol:stockSymbol fromAccountID:appDelegate.user.accountID];
                            
                            
                            if([[sellResults objectForKey:@"Result"]intValue] == 1)
                            { //Sold the stock
                                alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                   message:@"Stock Sold Succesfully"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                                
                                [helper addHistory:appDelegate.user.userID forLog:
                                 [[NSString alloc]initWithFormat:@"Sold %i shares of %@ in Account %i",
                                  [shares intValue], stockSymbol, [appDelegate.user.accountID intValue]]];
                                [alert show];
                                companyCode.text = @"";
                                amountofShares.text =@"";
                                
                                [self viewDidLoad];
                                
                            }
                            else
                            {
                                alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                   message:@"Something went wrong with Selling Stock."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Try Again"
                                                         otherButtonTitles: nil];
                                [alert show];
                                
                                
                                
                            }
                        }
                        else
                        {
                            alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                               message:@"Something went wrong with updating Account Balance"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Try Again"
                                                     otherButtonTitles: nil];
                            [alert show];
                            
                            
                            
                        }
                        
                        
                    }
                    else
                    {
                        //Insufficient shares of the stock
                        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                           message:@"Shares cannot exceed what you own"
                                                          delegate:nil
                                                 cancelButtonTitle:@"Try Again"
                                                 otherButtonTitles: nil];
                        [alert show];
                        
                    }
                    
                    
                }
                else
                {
                    //stock does not exist
                    alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                       message:@"You do not own this stock."
                                                      delegate:nil
                                             cancelButtonTitle:@"Try Again"
                                             otherButtonTitles: nil];
                    [alert show];
                    
                    
                }
                    
           }
            else
            {
                alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stock"
                                                   message:@"Stock does not exist"
                                                  delegate:nil
                                         cancelButtonTitle:@"Try Again"
                                         otherButtonTitles: nil];
                [alert show];
                
                
            }
            
        }
        else
        {
            //User is not logged in, show an alert
            alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                               message:@"Must be logged in to 'Trade'"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        
        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                           message:@"Shares or Company Symbol cannot be empty and must sell at least 1 share!"
                                          delegate:nil
                                 cancelButtonTitle:@"Try Again"
                                 otherButtonTitles: nil];
        [alert show];
        
        
        
    }
    
}


@end
