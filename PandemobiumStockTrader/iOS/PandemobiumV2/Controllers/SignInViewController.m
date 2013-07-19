//
//  SignInViewController.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "SVProgressHUD.h"
#import "DBHTTPClient.h"


@interface SignInViewController () <UITextFieldDelegate>
@end

@implementation SignInViewController

CGFloat animatedDistance;

@synthesize usernameText;
@synthesize passwordText;
@synthesize signinButton;
@synthesize rememberloginSwitch;
@synthesize activityIndicator;

//for animating keyboard
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (NSString*) saveFilePath
{
    //NSString* path = [[NSBundle mainBundle] pathForResource:@"accounts" ofType:@"plist"];
    NSString* path = @"/Users/denimgroup/PandemobiumV2/PandemobiumStockTrader/iOS/PandemobiumV2/accounts.plist";
    return path;
}


- (IBAction)loginButtonPressed:(UIButton *)sender
{
    
    NSLog(@"login was pressed");
    
    DBHTTPClient *client = [DBHTTPClient sharedClient];
    client.delegate = self;
    [client logIn:usernameText.text forPassword:passwordText.text];
    [SVProgressHUD show];

}

-(BOOL)isLoggedIn
{
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    if(app.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        return TRUE;
    }
    return FALSE;
    
}


- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender
{
    NSLog(@"logout button was pressed");
    //do something to remvoe account information from app delegate
    if(![self isLoggedIn]){
        
        UIAlertView *alert;
        NSString *message = [[NSString alloc] initWithFormat:@"You are not logged in."];
        alert = [[UIAlertView alloc] initWithTitle:@"Just so you know..."
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //do stuff to log user off
        
        UIAlertView *alert;
        NSString *message = [[NSString alloc] initWithFormat:@"Come Again!"];
        alert = [[UIAlertView alloc] initWithTitle:@"Thank You"
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
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
//

#pragma mark - DBHTTPClientDelegate
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithLogIn:(NSDictionary *)results
{
    
    
    NSInteger userID = [[results valueForKey:@"userID"] intValue];
    
    if(userID >= 1)
    {
                
        AppDelegate * app = [UIApplication sharedApplication].delegate;
        app.user.password = [results objectForKey:@"password"];
        app.user.userID = [results objectForKey:@"userID"];
        app.user.userName = [results objectForKey:@"userName"];
        app.user.loggedIn = [[NSNumber alloc]initWithInt:1];
        
       [client getAccountID:[results objectForKey:@"userID"]];
        
        if(self.rememberloginSwitch.on)
        {
            NSLog(@"SET TO REMEMBER LOGIN");
            
            /*
             for writing to a local file using keychain, need to import .h+.m files in order to work
             KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
             */
            
            NSMutableArray* accountArray = [[NSMutableArray alloc]init];
            [accountArray addObject: usernameText.text];
            [accountArray addObject: passwordText.text];
            [accountArray writeToFile:[self saveFilePath] atomically:YES];
            NSLog(@"after saving account info data to the file");
            
            /*
             to get data back from file use
             NSMutableArray* myArray = [NSMutableArray arrayWithContentsOfFile:[self saveFilePath]retain];
             */
            
        }else
        {
            NSLog(@"not set to remmember your login");
        }
    }
    else
    {
        [SVProgressHUD dismiss];
        UIAlertView *alert;
        NSString *message = @"Invalid Username or Password";
        alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Try Again"
                                 otherButtonTitles:nil];
        [alert show];
        
        
    }
    usernameText.text = @"";
    passwordText.text = @"";
    
}

-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAccountID:(NSNumber *)results
{
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    app.user.accountID = results;
    app.user.reloadData = [[NSNumber alloc]initWithInt:1];
    
    
    [client addHistory:app.user.userID forLog:[[NSString alloc]initWithFormat:@"Logged in"]];
   
    [client getAllStockValue:app.user.accountID];
    
}

-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares
{
 
    
    AppDelegate * app = [UIApplication sharedApplication].delegate;

    UIAlertView *alert;
    NSString *message = [[NSString alloc] initWithFormat:@"Welcome back %@", app.user.userName];
    alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    
    [alert show];

    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.user.favoriteStocks = results;
    appDelegate.user.oldFavorites = results;
    appDelegate.user.accountValue = totalValue;
    appDelegate.user.totalShares = totalShares;
    appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:0];
    [SVProgressHUD dismiss];
    
    [self performSegueWithIdentifier:@"afterLogin" sender:self];
    
}


@end
