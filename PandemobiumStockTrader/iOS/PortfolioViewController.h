//
//  PortfolioViewController.h
//  Pandemobium
//
//  Created by Thomas Salazar on 7/1/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"


@interface PortfolioViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *netWorth;
@property (strong, nonatomic) IBOutlet UILabel *numberShares;
@property (strong, nonatomic) IBOutlet UILabel *accountNumber;
@property (strong, nonatomic) IBOutlet UIImageView *accntImage;
@property (strong, nonatomic) IBOutlet UITableViewCell *barImage;
- (IBAction)revealMenu:(id)sender;
@end
