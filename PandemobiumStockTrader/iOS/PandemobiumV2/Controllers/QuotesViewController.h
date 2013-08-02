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
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "RightViewController.h"
#import "Stock.h"
#import "StockViewController.h"
#import "DBHTTPClient.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "SVProgressHUD.h"



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
@property (strong, nonatomic) AppDelegate *appDelegate;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;


- (void) initImage;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView;
- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)quoteTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//-(BOOL)isLoggedIn;

@end