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
#import "CorePlot-CocoaTouch.h"



@interface PortfolioViewController : UITableViewController <CPTPlotDataSource, CPTBarPlotDataSource, CPTBarPlotDelegate>
@property (strong, nonatomic) IBOutlet UILabel *netWorth;
@property (strong, nonatomic) IBOutlet UILabel *numberShares;
@property (strong, nonatomic) IBOutlet UILabel *accountNumber;
@property (strong, nonatomic) IBOutlet UIImageView *accntImage;
@property (strong, nonatomic) IBOutlet UITableViewCell *barImage;
@property (strong, nonatomic) IBOutlet UIImageView *barGraphImage;
@property (strong, nonatomic) NSArray * listOfStocks;
@property (strong, nonatomic) NSArray * stockValues;
@property (strong, nonatomic) NSDecimalNumber *portfolioSum;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTGraphHostingView *barHostView;
@property (nonatomic, strong) NSNumber *shares;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *stockAnnotation;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)revealMenu:(id)sender;
@end
