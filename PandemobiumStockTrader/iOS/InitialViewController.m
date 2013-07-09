//
//  InitialViewController.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "InitialViewController.h"

@implementation InitialViewController
@synthesize activityIndicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator startAnimating];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    }
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Quotes"];
    [activityIndicator stopAnimating];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end