//
//  ManageTipsViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 7/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "ManageTipsViewController.h"
@interface ManageTipsViewController () <UITextFieldDelegate>

@end

@implementation ManageTipsViewController

CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize reason;
@synthesize symbol;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //DBHelper * helper = [[DBHelper alloc]init];
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    UIAlertView * alert;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if([app.user.loggedIn intValue] != 1)
    {

        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Log-in to make Tips"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)submitReason:(id)sender
{
    //check if user is logged in otherwise dont do anything
    NSLog(@"submit reason is pressed");
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    UIAlertView *alert;
    
    
    if([app.user.loggedIn intValue] != 1)
    {
        NSLog(@"Log in before you can create a tip");
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Log-In to make Tips"
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:^(void){}];
    }
    else
    {
        if((![self.reason.text isEqual:@"Reason: "] && ![self.symbol.text isEqual:@""]) && (self.reason.text.length <= 512 && self.symbol.text.length <= 10))
        {
            //submit a tip
            alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                               message:@"Tip Sent Succesfully"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles: nil];
            app.user.reloadData = [[NSNumber alloc] initWithInt:1];
            DBHelper *client = [[DBHelper alloc]init];
        
            [client
                    addTip:app.user.userID
                forSymbol:[[NSString alloc] initWithFormat:@"%@",symbol.text]
                   forLog:[[NSString alloc] initWithFormat:@"%@",reason.text]
             ];
        
            [alert show];
            [self viewDidLoad];
            
            //set strings back to nothing
            self.symbol.text = @"";
            self.reason.text = @"Reason: ";
            
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"ALERT"
                                               message:@"Fill Out Form With:\nStock Symbol: <10char\nReason: <512char."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


- (IBAction)clearTextView:(id)sender
{
    NSLog(@"clear text button is pressed");
    self.symbol.text = @"";
    self.reason.text = @"Reason: ";
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}
@end
