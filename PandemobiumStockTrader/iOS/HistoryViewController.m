//
//  HistoryViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 6/28/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()


@end

@implementation HistoryViewController
@synthesize history;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    history = [[NSMutableArray alloc] initWithObjects:@"history1",@"hisotry2", @"history3",@"history4", nil] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //Here you must return the number of sectiosn you want
    return 2;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    //Here, for each section, you must return the number of rows it will contain
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //For each section, you must return here it's label
    if(section == 0) return @"Trade History";
    else
        return @"Tips History";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"historyCell"];
    }
    cell.textLabel.text = [[history objectAtIndex:[indexPath row]] objectAtIndex:0];
    return cell;
}


@end
