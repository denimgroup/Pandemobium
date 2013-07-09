//
//  PortfolioViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 7/1/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "PortfolioViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"

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
    

    [self fetchData];
    
}


-(void)fetchData
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *results;
    DBHelper * helper = [[DBHelper alloc]init];
    NSNumber *networth ;
    UIAlertView *alert;
    if(appDelegate.user.loggedIn.intValue == 1)
    {
        accountNumber.text = [[NSString alloc] initWithFormat:@"%i", appDelegate.user.accountID.intValue];
        networth = [helper getAccountValue:appDelegate.user.accountID];
        results = [helper getAccountInfo:appDelegate.user.accountID];
        
        networth = [[NSNumber alloc]initWithDouble:([networth doubleValue] + [[results objectForKey:@"balance"]doubleValue])];
        netWorth.text = [[NSString alloc]initWithFormat:@"%.2f", [networth doubleValue] ];
        
        NSNumber *shares = [helper getShareTotal:appDelegate.user.accountID];
        numberShares.text = [[NSString alloc]initWithFormat:@"%i", [shares intValue]];
        
        
    }
    else
    {
        accountNumber.text = @"xxxx";
        numberShares.text = @"0";
        netWorth.text = @"$0.00";
        accntImage.image = [UIImage imageNamed:@"burg.jpg"];

        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:@"Please log-in to see your 'Portfolio.'"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
        [alert show];

    }
    
}

-(BOOL)isLoggedIn
{
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    if(app.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        return TRUE;
    }
    return FALSE;
    
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
