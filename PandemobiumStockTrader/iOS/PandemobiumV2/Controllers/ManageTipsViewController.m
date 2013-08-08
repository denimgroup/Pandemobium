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
@synthesize reasonFromUrl;
@synthesize symbolFromUrl;
@synthesize clearButton;
@synthesize submitButton;




// ------- Handle OpenURL ---------
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[url absoluteString] hasPrefix:@"tips"])
    {
        NSLog(@"Inside trade view controller");
        
        
        NSArray *parameters = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < [parameters count]; i=i+2) {
            [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
        }
        
        reasonFromUrl = [[NSString alloc]initWithFormat:@"%@", [keyValueParm objectForKey:@"reason"]];
        symbolFromUrl = [[NSString alloc]initWithFormat:@"%@", [keyValueParm objectForKey:@"symbol"]];
        
        if([[url host] isEqualToString:@"share"])
        {
            [self submitReason:self];
            return YES;
        }
        
        
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
    [self setupButtonLayer:submitButton];
    [self setupButtonLayer:clearButton];
	// Do any additional setup after loading the view.
    //DBHelper * helper = [[DBHelper alloc]init];
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    UIAlertView * alert;
    
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


-(void)setupButtonLayer:(UIButton*)button
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = button.layer.bounds;
    
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                       (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                       nil];
    
    gradient.locations =[NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:0.0f],
                         [NSNumber numberWithFloat:1.0f],
                         nil];
    
    gradient.cornerRadius = button.layer.cornerRadius;
    
    [button.layer setCornerRadius:9.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer addSublayer:gradient];
    
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
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    UIAlertView *alert;
    if([app.user.loggedIn intValue] != 1)
    {
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
        if((![self.reason.text isEqual:@"Reason: "] && ![self.symbol.text isEqual:@""]) && (self.reason.text.length <= 512 && self.symbol.text.length <= 10)){
        //submit a tip
            alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                               message:@"Tip Sent Succesfully"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles: nil];
            app.user.reloadData = [[NSNumber alloc] initWithInt:1];
            DBHelper *client = [[DBHelper alloc]init];
        
            if((reasonFromUrl != NULL) && (symbolFromUrl != NULL))
            {
                [client
                 addTip:app.user.userID
                 forSymbol:[[NSString alloc] initWithFormat:@"%@",symbolFromUrl]
                 forLog:[[NSString alloc] initWithFormat:@"%@",reasonFromUrl]
                 ];

                
            }
            else
            {
                [client
                    addTip:app.user.userID
                    forSymbol:[[NSString alloc] initWithFormat:@"%@",symbol.text]
                    forLog:[[NSString alloc] initWithFormat:@"%@",reason.text]
                 ];
            }
            [alert show];
            [self viewDidLoad];
        
        //set strings back to nothing
            self.symbol.text = @"";
            self.reason.text = @"Reason: ";
            
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                               message:@"Fill Out Form With:\nStock Symbol: less than 10 chars\nA Reason: less than 512 chars."
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
