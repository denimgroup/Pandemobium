//
//  ManageTipsViewController.h
//  Pandemobium
//
//  Created by Thomas Salazar on 7/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

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
