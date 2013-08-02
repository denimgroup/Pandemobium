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


#import "RightViewController.h"



@interface RightViewController()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@end

@implementation RightViewController

@synthesize peekLeftAmount;
@synthesize searchBar;
@synthesize filteredStockArray;
@synthesize stockArray;
@synthesize appDelegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peekLeftAmount = 40.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    //Load the stocks that we will be using
    appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    NSError *error;
    self.stockArray = [context executeFetchRequest:request error:&error];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    self.stockArray = [self.stockArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.filteredStockArray = [self.stockArray mutableCopy];
    
    //Allow searching
    [searchBar setShowsCancelButton:YES];
    [searchBar setShowsScopeBar:YES];
    [searchBar sizeToFit];
    
    //declare the delegate
    self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
    //Reload the data to display
    [[self tableView]reloadData];
    
}

#pragma mark - For the sliding view

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = 0.0f;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.height;
        } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.width;
        }
        self.view.frame = frame;
    } onComplete:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.slidingViewController anchorTopViewTo:ECLeft animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = self.peekLeftAmount;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.height - self.peekLeftAmount;
        } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.width - self.peekLeftAmount;
        }
        self.view.frame = frame;
    } onComplete:nil];
    [self.searchBar resignFirstResponder];
}


#pragma mark - Table View

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredStockArray count];
    }
    else
    {
        return [stockArray count];
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //set up the cell
    static NSString *CellIdentifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *name ;
    NSMutableArray *symbol;
    //Determine which array we are looking at, the one that is being serarche or the complete list of stocks.
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        name = [self.filteredStockArray valueForKey:@"name"];
        symbol = [self.filteredStockArray valueForKey:@"symbol"];
    }
    else
    {
        name = [self.stockArray valueForKey:@"name"];
        symbol = [self.stockArray valueForKey:@"symbol"];
    }
    
    //Set up the cells contents
    cell.textLabel.text = [symbol objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [name objectAtIndex:indexPath.row];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - TableView Delegate

//Segue with chosen stock
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"StockView" sender:tableView];
}


#pragma mark - Segue
//Segue by determinint which array we are using and then
//prepare stock view with the symbol of the stock that we clicked on. 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"StockView"])
    {
        StockViewController *stockViewController = [segue destinationViewController];
        
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.filteredStockArray objectAtIndex:[indexPath row]] valueForKey:@"symbol"];
            stockViewController.symbol = destinationTitle;
            [stockViewController setTitle:destinationTitle];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.stockArray objectAtIndex:[indexPath row]] valueForKey:@"symbol"];
            stockViewController.symbol = destinationTitle;
            [stockViewController setTitle:destinationTitle];
        }
        
        stockViewController.originateFrom = @"SearchView";
    }
}




#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredStockArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR symbol CONTAINS[cd] %@", searchText, searchText];
    NSArray *tempArray = [self.stockArray filteredArrayUsingPredicate:predicate];
    
    self.filteredStockArray = [NSMutableArray arrayWithArray:tempArray];

}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;}

@end
