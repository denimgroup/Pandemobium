//
//  TipsViewController.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

@synthesize webView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
     */
    
    /////////////////////webview container running, simple and not vulnerabilities implemented yet june 20th
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://money.cnn.com/magazines/moneymag/money101/lesson5/index.htm"];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestURL];
    
    /////////////////////
    
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

@end
