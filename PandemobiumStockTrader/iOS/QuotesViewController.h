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

@interface QuotesViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (nonatomic, strong) IBOutlet UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, strong) IBOutlet UISwipeGestureRecognizer * swipeDown;
@property (strong, nonatomic) IBOutlet UITableView *quoteTableView;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;


- (void) initImage;
- (void)swipeTopImage:(UISwipeGestureRecognizer *)recognizer;
- (void) swipeRecognizer:(UISwipeGestureRecognizer *)recognizer;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView;
- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)quoteTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(BOOL)isLoggedIn;

@end