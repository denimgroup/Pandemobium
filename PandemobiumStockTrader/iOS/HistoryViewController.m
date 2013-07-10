//
//  HistoryViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 6/28/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"

@interface HistoryViewController ()


@end

@implementation HistoryViewController
@synthesize history;
@synthesize tips;

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
    DBHelper * helper = [[DBHelper alloc]init];
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    UIAlertView * alert;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if([app.user.loggedIn intValue] == 1)
    {
        history = [[NSArray alloc]initWithArray:[helper getHistory:app.user.userID]];
        tips = [[NSArray alloc]initWithArray:[helper getTips]];
        
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Log-in to view History / Tips"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    
    
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
    
    NSLog(@"trying to set up history view");
    if (cell == nil) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"historyCell"];
    }
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell.textLabel.text = [[history objectAtIndex:indexPath.row] valueForKey:@"time"];
        cell.detailTextLabel.text = [[history objectAtIndex:indexPath.row]valueForKey:@"log"];
        
    }
    else
    {
        cell.textLabel.text = [[tips objectAtIndex:indexPath.row] valueForKey:@"symbol"];
        cell.detailTextLabel.text = [[tips objectAtIndex:indexPath.row]valueForKey:@"reason"];
        
    }
    
    return cell;
}


@end
