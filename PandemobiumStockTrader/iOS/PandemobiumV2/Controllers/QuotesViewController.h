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
#import "StockViewController.h"
#import "SVProgressHUD.h"
#import "DBHTTPClient.h"

@interface QuotesViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, DBHTTPClientDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (strong, nonatomic) IBOutlet UITableView *quoteTableView;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSArray *favoriteStocks;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSNumber * reload;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;


- (void) initImage;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView;
- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)quoteTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//-(BOOL)isLoggedIn;

@end