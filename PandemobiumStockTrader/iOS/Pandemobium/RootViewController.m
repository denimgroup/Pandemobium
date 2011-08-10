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

#import "RootViewController.h"
#import "BuyViewController.h"
#import "TipViewController.h"
#import "PreferencesViewController.h"
#import "HistoryViewController.h"
#import "ManageTipsViewController.h"

@implementation RootViewController

@synthesize buyViewController;
@synthesize tipViewController;
@synthesize prefViewController;
@synthesize historyViewController;
@synthesize manageTipsViewController;




-(IBAction) tradePressed:(id)sender 
{
    if (self.buyViewController == nil)
    {
        BuyViewController * buyView = [[BuyViewController alloc]
                                       initWithNibName:@"BuyView" bundle:[NSBundle mainBundle]];
        self.buyViewController = buyView;
        [buyView release];
    }
    
    [self.navigationController pushViewController:self.buyViewController animated:YES];
    [self.buyViewController clear];
}

-(IBAction) tipPressed:(id)sender 
{
    if (self.manageTipsViewController == nil)
    {
        ManageTipsViewController * tipView = [[ManageTipsViewController alloc]
                                       initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
        self.manageTipsViewController = tipView;
        [tipView release];
    }
    
    [self.navigationController pushViewController:self.manageTipsViewController animated:YES];
}

-(IBAction) prefPressed:(id)sender
{
    if (self.prefViewController == nil)
    {
        PreferencesViewController * prefView = [[PreferencesViewController alloc]
                                       initWithNibName:@"Preferences" bundle:[NSBundle mainBundle]];
        self.prefViewController = prefView;
        [prefView release];
    }
    
    [self.navigationController pushViewController:self.prefViewController animated:YES];
    [self.prefViewController clear];
}

-(IBAction) historyPressed:(id)sender
{
    if (self.historyViewController == nil)
    {
        HistoryViewController * historyView = [[HistoryViewController alloc]
                                                initWithNibName:@"HistoryView" bundle:[NSBundle mainBundle]];
        self.historyViewController = historyView;
        [historyView release];
    }
    

    [self.navigationController pushViewController:self.historyViewController animated:YES];
    [self.historyViewController update];

}

-(IBAction) managePressed:(id)sender
{
    if (self.tipViewController == nil)
    {
        TipViewController * manageView = [[TipViewController alloc]
                                               initWithNibName:@"TipView" bundle:[NSBundle mainBundle]];
        self.tipViewController = manageView;
        [manageView release];
    }
    
    [self.navigationController pushViewController:self.tipViewController animated:YES];
    [self.tipViewController clear];

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    if( [[url absoluteString] hasPrefix:@"trade"])
    {
        [self tradePressed:self];
        [self.buyViewController handleUrl: url];
    }
    else if( [[url absoluteString] hasPrefix:@"sendtips"])
    {
        [self managePressed:self];
        [self.tipViewController handleUrl: url];
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
