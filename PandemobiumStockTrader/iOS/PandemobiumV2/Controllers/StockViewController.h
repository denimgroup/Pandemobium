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

#import <UIKit/UIKit.h>
#import "DBHTTPClient.h"
#import "AppDelegate.h"
#import "QuotesViewController.h"
#import "TradeViewController.h"
#import "DBHelper.h"
#import "SVProgressHUD.h"

@interface StockViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DBHTTPClientDelegate>

@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *originateFrom;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tradingButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSDictionary *stockInfo;

@property(strong, nonatomic) NSArray *cellTitle; 
@property(strong, nonatomic) NSArray *cellSubtitle;
@property(strong, nonatomic) AppDelegate *appDelegate;
@property(strong, nonatomic) DBHelper *helper;


@end
