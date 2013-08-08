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


#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "SVProgressHUD.h"
#import "DBHTTPClient.h"

@interface ManageTipsViewController : UIViewController <UITextFieldDelegate>
- (IBAction)revealMenu:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@property (strong, nonatomic) IBOutlet UITextView *reason;
@property (strong, nonatomic) IBOutlet UITextField *symbol;

@property(strong, nonatomic) NSString *reasonFromUrl;
@property(strong, nonatomic) NSString *symbolFromUrl;
- (IBAction)submitReason:(id)sender;
- (IBAction)clearTextView:(id)sender;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

@end
