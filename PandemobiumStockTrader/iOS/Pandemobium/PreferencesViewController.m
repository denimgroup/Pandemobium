//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with 
// vulnerabilities included for security testing purposes.
// Copyright (c) 2011 Denim Group, Ltd. All rights reserved worldwide.
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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader.  If not, see
// <http://www.gnu.org/licenses/>.
//

#import "PreferencesViewController.h"
#import "ASIHTTPRequest.h"


@implementation PreferencesViewController

@synthesize usernameField, passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) clear 
{
   
    usernameField.text = @"";
    passwordField.text = @"";
    statusLabel.text = @"";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//If we begin editing on the text field we need to move it up to make sure we can still
	//see it when the keyboard is visible.
	//
	//I am adding an animation to make this look better
    
    [((UIScrollView *)self.view) setContentOffset:CGPointMake(0.0, textField.frame.origin.y-100) animated:YES];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {	
    
    
    [((UIScrollView *)self.view)  setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
}

- (void)saveLoginData {
    NSString * username = [usernameField text];
    NSString * password = [passwordField text];
    

    if(![username isEqualToString:@""])
        
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    
    if(![password isEqualToString:@""])
        
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    
    
    
   
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) sendCredentials
{
    NSBundle * mainBundle;
    mainBundle = [NSBundle mainBundle];
    NSString * response;
    NSString * username = [usernameField text];
    NSString * password = [passwordField text];
    NSString * myUrl = [mainBundle objectForInfoDictionaryKey:@"account_service"];
    
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@?method=getAccountId&username=%@&password=%@",
                            myUrl,username, password ];
    
   
    
    
    NSURL * url = [[NSURL alloc] initWithString: urlString];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError * error = [request error];
    if (!error) 
    {
        response = [request responseString];
        NSArray *parameters = [response componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        NSString * accountId;
        NSString * value = [parameters objectAtIndex:0];
        
        if ([value isEqualToString:@"account_id"])
        {
            accountId = [parameters objectAtIndex:1];
            
            [self saveLoginData];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            //make a file name to write the data to using the documents directory:
            NSString *fileName = [NSString stringWithFormat:@"%@/account.txt", 
                                  documentsDirectory];
            //create content - four lines of text
            NSString *content = accountId;
            //save content to the documents directory
            [content writeToFile:fileName 
                      atomically:NO 
                        encoding:NSStringEncodingConversionAllowLossy 
                           error:nil];
             statusLabel.text = @"Login Successful!!";
        }
        else {
            statusLabel.text = [parameters objectAtIndex:1];
        }
        
       
    }
    else 
    {
        response = [error description];
        statusLabel.text = response;
    }
    
    // do something with results? 
    
}

-(IBAction) retreiveCredentials 
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [self sendCredentials];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    usernameField.delegate = self;
    passwordField.delegate = self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
