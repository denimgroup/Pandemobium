//
//  RightViewController.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "RightViewController.h"
#import "Stock.h"
#import "StockViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface RightViewController()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@end

@implementation RightViewController

@synthesize peekLeftAmount;
@synthesize searchBar;

@synthesize filteredStockArray;
@synthesize stockArray;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peekLeftAmount = 40.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    NSError *error;
    self.stockArray = [context executeFetchRequest:request error:&error];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    self.stockArray = [self.stockArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                                        
    
    self.filteredStockArray = [self.stockArray mutableCopy];
    
    [searchBar setShowsCancelButton:YES];
    [searchBar setShowsScopeBar:YES];
    [searchBar sizeToFit];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView]reloadData];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Begin Editing Search\n");
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
    NSLog(@"End Editing Search\n");
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSLog(@"Number of Sections in Right View\n");
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    // If you're serving data from an array, return the length of the array:
    NSLog(@"Number of rows %d\n", [self.filteredStockArray count]);

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
    
    NSLog(@"Setting up cells in Right View\n");
    
    static NSString *CellIdentifier = @"searchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Set the data for this cell:
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *name = [[NSMutableArray alloc]init];
    NSMutableArray *symbol = [[NSMutableArray alloc]init];;
    
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
    
    
    cell.textLabel.text = [symbol objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [name objectAtIndex:indexPath.row];
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"Preparing to segue");
    [self performSegueWithIdentifier:@"StockView" sender:tableView];
    
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"StockView"])
    {
        StockViewController *stockViewController = [segue destinationViewController];
        
        //UIViewController *stockViewController = [segue destinationViewController];
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
    NSLog(@"filterContentForSearch %@\n", searchText);
    
    [self.filteredStockArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR symbol CONTAINS[cd] %@", searchText, searchText];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name contains[c] %@)", searchText];
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
