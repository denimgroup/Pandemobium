//
//  TradeViewController.h
//  Pandemobium
//
//  Created by Thomas Salazar on 6/27/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"

@interface TradeViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *amountofShares;
@property (strong, nonatomic) IBOutlet UITextField *companyCode;
@property (strong, nonatomic) IBOutlet UILabel *accountNumber;
@property (strong, nonatomic) IBOutlet UILabel *accountAmount;
@property (strong, nonatomic) IBOutlet UILabel *canInvest;

@property (strong, nonatomic) NSString *symbol;

- (IBAction)revealMenu:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
