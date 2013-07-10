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


@interface SignInViewController () <UITextFieldDelegate>
@end

@implementation SignInViewController

CGFloat animatedDistance;

@synthesize usernameText;
@synthesize passwordText;
@synthesize signinButton;
@synthesize rememberloginSwitch;

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

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    NSLog(@"loginwas pressed");
    
    DBHelper * dbhelper = [[DBHelper alloc] init];
    
    NSDictionary *results = [dbhelper logIn: usernameText.text forPassword: passwordText.text];
    NSInteger userID = [[results valueForKey:@"userID"] intValue];
    
    UIAlertView *alert;
    if(userID >= 1)
    {
        NSString *message = [[NSString alloc] initWithFormat:@"Welcome back %@", [results objectForKey:@"userName"]];
        alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                            message:message
                                            delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        
        AppDelegate * app = [UIApplication sharedApplication].delegate;
        app.user.password = [results objectForKey:@"password"];
        app.user.userID = [results objectForKey:@"userID"];
        app.user.userName = [results objectForKey:@"userName"];
        app.user.loggedIn = [[NSNumber alloc]initWithInt:1];
        app.user.accountID = [dbhelper getAccountID:[results objectForKey:@"userID"]];
        
        [self performSegueWithIdentifier:@"afterLogin" sender:sender];
        
        if(self.rememberloginSwitch.on)
        {
            //TO DO: Write to local file
            NSLog(@"SET TO REMEMBER LOGIN");
        }else
        {
            NSLog(@"not set to remmember your login");
        }
    }
    else
    {
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
    //To Do: Take to Quotes from here. 
    
    
    
}

//-(void) fetchData
//{
//    
//    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/user.jsp?method=logIn&username=user&password=password"];
//    
//    NSError *error;
//    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    
//    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
//    NSDictionary *query = [jsonData objectForKey:@"query"];
//    NSDictionary *results = [query objectForKey:@"results"];
//    stockInfo = [results objectForKey:@"quote"];
//    
//}

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


@end
