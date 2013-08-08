//
//  HistoryViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 8/8/13.
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
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    DBHelper * helper = [[DBHelper alloc]init];
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    UIAlertView * alert;
    
    history = [[NSArray alloc]init];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [history count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"historyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Set the data for this cell:
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.text = [[history objectAtIndex:indexPath.row] valueForKey:@"TIME"];
    cell.textLabel.text = [[history objectAtIndex:indexPath.row] valueForKey:@"LOG"];
    
    return cell;
}
@end
