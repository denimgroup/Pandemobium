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

#import "StockViewController.h"


#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface StockViewController ()

@end

@implementation StockViewController

@synthesize symbol;
@synthesize stockInfo;
@synthesize originateFrom;
@synthesize activityIndicator;
@synthesize cellSubtitle;
@synthesize cellTitle;
@synthesize appDelegate;
@synthesize helper;


#pragma mark - Initial setup
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Actions to perform when page is loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view becomeFirstResponder];
 
    //Initialize appDelegate and DB Helper
    appDelegate = [UIApplication sharedApplication].delegate;
    helper = [[DBHelper alloc]init] ;
    
    
    [self initImage];
    [self fetchData];
    [self stockStatus:symbol];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Load the graph from yahoos finance api
- (void) initImage
{
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    UIImage *image = [UIImage imageWithData:imageData];
    [self.imageView setImage:image ];
   
}
//fetch data from Yahoos database.
-(void) fetchData
{
   
   
    NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
    NSError *error;
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * jsonData = [[NSDictionary alloc]init];
    NSDictionary * query = [[NSDictionary alloc]init];
    NSDictionary * results = [[NSDictionary alloc]init];

    //Parse through the JSON object to extract an array
    @try {
        id object = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        //NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if(error)
        {
            NSLog(@"Error parsing data");
            
        }
        if([object isKindOfClass:[NSDictionary class]])
        {
            jsonData = object;
            if([[ jsonData objectForKey:@"query" ] isKindOfClass:[NSDictionary class]])
            {
                query = [jsonData objectForKey:@"query"];
                
                if([[query objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                {
                    results = [query objectForKey:@"results"];
                    
                    if([[results objectForKey:@"quote"] isKindOfClass:[NSDictionary class]])
                    {
                        //Extract the values and the key
                        stockInfo = [results objectForKey:@"quote"];
                        cellTitle = [[stockInfo allKeys] mutableCopy];
                        cellSubtitle = [[stockInfo allValues] mutableCopy];
                        
                    }
                    
                }
                
            }
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    
}

//Determine the stock tatus. That is, determine if the stock is listed as a
//'favorite' stock for the user. If it is, then set the appropriate button title.
//This is to allow the user to Add/Remove from favotires
-(void)stockStatus:(NSString *)stockSymbol
{
    if([appDelegate.user.loggedIn intValue] == 1)
    {
        NSArray *dbStockInfo = [helper getAllUserStocks:appDelegate.user.accountID];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SYMBOL = %@", stockSymbol];
        NSArray * matched = [dbStockInfo filteredArrayUsingPredicate:p];
        if([matched count] >= 1)
        {
            if([[[matched objectAtIndex:0] objectForKey:@"FAVORITE"]intValue] == 1)
            {
                [self.favoriteButton setTitle:@"Remove"];
            }
        }
        

    }
    else
    {
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
        
        NSError *error;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", stockSymbol];
        [request setPredicate:predicate];
        
        Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
        
        if([stock.favorite isEqualToNumber:[[NSNumber alloc]initWithBool:YES]])
        {
            [self.favoriteButton setTitle:@"Remove"];
        }
    }
}

#pragma mark - Table View
// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stockInfo count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"stockInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Set the data for this cell:
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //Ensure that the cell title label is not null
    if([cellTitle objectAtIndex:indexPath.row] == [NSNull null])
    {
        cell.textLabel.text = @"N/A";
    }
    else
    {
        cell.textLabel.text = [cellTitle objectAtIndex:indexPath.row];
    }
    
    //Ensure that the cell subtitle is not null
    if([cellSubtitle objectAtIndex:indexPath.row] == [NSNull null])
    {
        cell.detailTextLabel.text = @"N/A";
    }
    else
    {
        cell.detailTextLabel.text = [cellSubtitle objectAtIndex:indexPath.row];
    }
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Action Listeners
- (IBAction)backButtonClicked:(id)sender
{
    [SVProgressHUD show];
    self.originateFrom = @"QuoteView";
    
    if(appDelegate.user.reloadData == [[NSNumber alloc]initWithInt:1] )
    {
        [SVProgressHUD show];
        DBHTTPClient *client = [DBHTTPClient sharedClient];
        client.delegate = self;
        [client getAllStockValue:appDelegate.user.accountID];
    }
    else
    {
         [self performSegueWithIdentifier:originateFrom sender:sender];
    }

}

- (IBAction)favoriteButtonClicked:(id)sender
{

    [self.favoriteButton titleTextAttributesForState:UIControlStateNormal];
    if([self.favoriteButton.title isEqualToString:@"Favorite"])
    {
        [self addFavorite:symbol];
      
    }
    else
    {
        [self removeFavorite:symbol];
    }
    
}
- (IBAction)tradingButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"Trading" sender:sender];
 
}


-(void)addFavorite:(NSString *)stockSymbol
{

    DBHTTPClient *client = [DBHTTPClient sharedClient];
    client.delegate = self;
    UIAlertView *alert;
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *buttonTitle;
    
    if([appDelegate.user.loggedIn intValue] == 1)
    {
        //User is logged in
        NSDictionary *results = [helper addFavoriteStock:appDelegate.user.accountID stockSymbol:stockSymbol];
        if([[results objectForKey:@"Result"]intValue]==1)
        { //Great success
            appDelegate.user.reloadData = [[NSNumber alloc]initWithInt:1];
            alertTitle = @"Success";
            alertMessage=@"Added Stock to Favorites";
            buttonTitle=@"OK";
            [self.favoriteButton setTitle:@"Remove"];
            [client addHistory:appDelegate.user.userID forLog:[[NSString alloc]initWithFormat:@"Added %@ to Favorites in Account %i",
                                                               stockSymbol, [appDelegate.user.accountID intValue]]];
            
        }
        else
        { //DB Error
            alertTitle = @"ERROR";
            alertMessage=@"Could not add Stock to Favorites";
            buttonTitle=@"Try Again";
        }
        
    }
    else
    {
        //Local data, user is not logged in 
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
        
        NSError *error;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", stockSymbol];
        [request setPredicate:predicate];
        
        Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
        stock.favorite = [[NSNumber alloc]initWithBool:YES];
        
        [context save:&error];
        
        alertTitle = @"Success";
        alertMessage=@"Added Stock to Favorites. Please log-in to maintain favorites";
        buttonTitle=@"OK";

        
    }
    alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                       message:alertMessage
                                      delegate:nil
                             cancelButtonTitle:buttonTitle
                             otherButtonTitles: nil];
    [alert show];
   
}


-(void)removeFavorite:(NSString *)stockSymbol
{
    
    DBHTTPClient *client = [DBHTTPClient sharedClient];
    client.delegate = self;
    

    UIAlertView *alert;
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *buttonTitle;
    
    if([appDelegate.user.loggedIn intValue] == 1)
    {
        //User is logged in
        NSDictionary *results = [helper removeFavoriteStock:appDelegate.user.accountID stockSymbol:stockSymbol];
        if([[results objectForKey:@"Result"]intValue]==1)
        { //Great success
            alertTitle = @"Success";
            alertMessage=@"Removed Stock from Favorites";
            buttonTitle=@"OK";
            
            [client addHistory:appDelegate.user.userID forLog:[[NSString alloc]initWithFormat:@"Removed %@ from Favorites in Account %i",
                                                               stockSymbol, [appDelegate.user.accountID intValue]]];
            [self.favoriteButton setTitle:@"Favorite"];
            appDelegate.user.reloadData = [[NSNumber alloc]initWithInt:1];
            
        }
        else
        { //DB Error
            alertTitle = @"ERROR";
            alertMessage=@"Could not remove stock. Can only remove non-purchased stock.";
            buttonTitle=@"Try Again";
        }
        
    }
    else
    {
        //User is not logged in
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
        
        NSError *error;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", stockSymbol];
        [request setPredicate:predicate];
        
        Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
        stock.favorite = [[NSNumber alloc]initWithBool:NO];
        
        [context save:&error];
        alertTitle = @"Success";
        alertMessage=@"Removed Stock from Favorites. Please log-in to maintain favorites";
        buttonTitle=@"OK";
    }
    alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                       message:alertMessage
                                      delegate:nil
                             cancelButtonTitle:buttonTitle
                             otherButtonTitles: nil];
    [alert show];
    
    
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"Trading"])
    {
        TradeViewController *tradeViewController = [segue destinationViewController];
        tradeViewController.symbol = symbol;
    }
    
}

#pragma mark - DBHTTPClient Delegate
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares
{
    appDelegate.user.favoriteStocks = results;
    appDelegate.user.oldFavorites = results;
    appDelegate.user.accountValue = totalValue;
    appDelegate.user.totalShares = totalShares;
    appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:0];
    
    [self performSegueWithIdentifier:originateFrom sender:self];
    [SVProgressHUD dismiss];

}
@end
