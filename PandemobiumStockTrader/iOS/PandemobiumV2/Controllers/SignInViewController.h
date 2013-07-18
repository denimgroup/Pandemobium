//
//  SignInViewController.h
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "DBHTTPClient.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate, DBHTTPClientDelegate>

- (IBAction)revealMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UISwitch *rememberloginSwitch;
@property (strong, nonatomic) IBOutlet UIButton *signinButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

//managing text and keyboard behavior
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end