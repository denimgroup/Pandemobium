//
//  TipsViewController.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

@synthesize tips;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
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
        tips = [[NSArray alloc]initWithArray:[helper getTips]];
        NSLog(@"printed list of tips: %@", tips.debugDescription);
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    
    return [tips count];
    //return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tipsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Set the data for this cell:
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.text = [[tips objectAtIndex:indexPath.row] valueForKey:@"REASON"];
    cell.textLabel.text = [[tips objectAtIndex:indexPath.row] valueForKey:@"SYMBOL"];
    NSLog(@"tips stuff: %@", [tips objectAtIndex:indexPath.row]);
    
    // set the accessory view:
    //cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    [self performSegueWithIdentifier:@"StockView" sender:tableView];
//
//}


@end
