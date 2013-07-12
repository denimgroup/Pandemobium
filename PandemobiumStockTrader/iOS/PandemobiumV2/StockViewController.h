//
//  StockViewController.h
//  Pandemobium
//
//  Created by Adrian Salazar on 6/20/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

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
@end
