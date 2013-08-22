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
#import <CoreLocation/CoreLocation.h>
#import "iVersion.h"
#import "SettingsViewController.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate, DBHTTPClientDelegate, CLLocationManagerDelegate>

- (IBAction)revealMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UIButton *signinButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UISwitch *rememberloginSwitch;
@property (strong, nonatomic) IBOutlet UIButton *accountButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *originalLocation;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *baseURL;
-(IBAction) toggleButtonPressed;
//managing text and keyboard behavior
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end