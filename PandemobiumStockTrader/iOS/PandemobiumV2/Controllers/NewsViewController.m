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


#import "NewsViewController.h"
#import "SVProgressHUD.h"

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize webView;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;

    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://www.finance.yahoo.com"];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestURL];

    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma WebViewStuff

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"Loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

@end
