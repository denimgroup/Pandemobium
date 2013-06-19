//
//  QuotesViewController.h
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/17/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "RightViewController.h"
#import "sqlite3.h"
#import "Stock.h"

@interface QuotesViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;



- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;

@end