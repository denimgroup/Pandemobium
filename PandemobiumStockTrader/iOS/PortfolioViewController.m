//
//  PortfolioViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 7/1/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "PortfolioViewController.h"

@interface PortfolioViewController ()

@end

@implementation PortfolioViewController

@synthesize accntImage;
@synthesize accountNumber;
@synthesize numberShares;
@synthesize netWorth;

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.accountNumber.text = @"xxxx";
    self.numberShares.text = @"xxx";
    self.netWorth.text = @"$153,310.00";
    self.accntImage.image = [UIImage imageNamed:@"burg.jpg"];
    
    NSLog(@"%@", self.accountNumber.text);
    NSLog(@"%@", self.numberShares.text);
    NSLog(@"%@", self.netWorth.text);
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
