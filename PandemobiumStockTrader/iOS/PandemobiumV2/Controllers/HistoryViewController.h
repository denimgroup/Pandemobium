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
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface HistoryViewController : UITableViewController < UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *history;
@property (strong, nonatomic) NSArray *tips;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)revealMenu:(id)sender;
@end
