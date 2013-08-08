//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with
// vulnerabilities included for security testing purposes.
// Copyright (c) 2013 Denim Group, Ltd. All rights reserved worldwide.
//
// This file is part of Pandemobium Stock Trader.
//
// Pandemobium Stock Trader is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader. If not, see
// <http://www.gnu.org/licenses/>.

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize history;
@synthesize tips;
@synthesize activityIndicator;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"outOfRange"
                                               object:nil];

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

-(void)handleUpdatedData:(NSNotification *)notification {
    //  NSLog(@"recieved");
    [self viewDidLoad];
}

@end
