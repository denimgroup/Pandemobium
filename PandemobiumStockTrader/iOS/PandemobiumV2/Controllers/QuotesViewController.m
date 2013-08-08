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
//



#import "QuotesViewController.h"

@interface QuotesViewController ()

@end

@implementation QuotesViewController;

//@synthesize managedObjectContext;
@synthesize favoriteStocks;
@synthesize activityIndicator;
@synthesize reload;
@synthesize appDelegate;

#pragma mark - Initial Page Setup Methods

//Initial function that gets called. Add anything that needs to be loaded when first loading page.
-(void)viewDidLoad
{
    [SVProgressHUD dismiss];
    appDelegate = [UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"outOfRange"
                                               object:nil];
    
    
    [super viewDidLoad];

    
    //Initialize the previous list of stocks. This allows
    //us to cutdown the number of times we load the data.
    if([self isLoggedIn] == FALSE)
    {
        [self setDefaultFavorites];
        [self loadDefaultFavoriteStocks];
    }
    else
    {
        favoriteStocks = appDelegate.user.oldFavorites;
       
        [self loadFavoriteStocks];
        
    }
    
    [self initImage];
    
}

// Loads the right view controller which is where a user can search through
//a list of stocks if they do not know the companies stock symbol.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[RightViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
    }
    if(self.slidingViewController == nil)
    {
        NSLog(@"NIL");
        
    }
    
    if(self.slidingViewController.panGesture == nil)
    {
        NSLog(@"pan gesture NIL");
        
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
 }

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}



#pragma mark - Load List of stocks

// Load a logged in users list of stocks
-(void) loadFavoriteStocks
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if(appDelegate.user.reloadData == [[NSNumber alloc]initWithInt:1] )
    {
        
        reload = [[NSNumber alloc]initWithInt:0];
        DBHTTPClient *client = [DBHTTPClient sharedClient];
        client.delegate = self;
        [client getAllStockValue:app.user.accountID];
    }
}

// If not logged in, load a default list of stocks. This list
// is stored locally.
-(void)loadDefaultFavoriteStocks
{

    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == %@", @"1"];
    [request setPredicate:predicate];
    
    favoriteStocks = [context executeFetchRequest:request error:&error];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    favoriteStocks = [favoriteStocks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
}

// Check to see if the USER is logged in.
-(BOOL)isLoggedIn
{
    if(appDelegate.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        return TRUE;
    }
    return FALSE;
    
}

// Always have Google, Microsoft, and Apple as favorite stocks.
// This allows for there to always be content displayed on the stock
// list as well as the graph plots.  
-(void)setDefaultFavorites
{
        [self addFavorite:@"GOOG"];
        [self addFavorite:@"MSFT"];
        [self addFavorite:@"AAPL"];
}

// Adds a stock "symbol" to the list of stocks that are "favorites" of the user.  
-(void)addFavorite:(NSString *)symbol
{
   // AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", symbol];
    [request setPredicate:predicate];
    
    Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
    stock.favorite = [[NSNumber alloc]initWithBool:YES];
    
    [context save:&error];
}





#pragma mark - Image handlers

// Initialize and set the image that is displayed at the top of the page
- (void) initImage
{

    NSString *key;
    if(appDelegate.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        key=@"SYMBOL";
        
    }
    else
    {
        key=@"symbol";
    }
    NSString *symbol = [[favoriteStocks objectAtIndex:appDelegate.currentImageIndex.intValue] valueForKey:key];
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    [self.topImage setImage:image ];
    
}

// There are two buttons that are overlayed on top of the image to indicate
// which direction to change the image. Left or Right

- (IBAction)leftButtonClicked:(id)sender {
   
    [self changeImage:@"left"];
    
}

- (IBAction)rightButtonclicked:(id)sender
{
        [self changeImage:@"right"];
}

// Change the image based on the direction of the image. 
-(void)changeImage:(NSString *)direction
{
    if([direction isEqualToString:@"left"])
    {
        //Wrap around to the left
        if(appDelegate.currentImageIndex.intValue == 0)
        {
            appDelegate.currentImageIndex = [[NSNumber alloc]initWithInt:[favoriteStocks count] - 1];
        }
        else
        {
            NSNumber *sum = [NSNumber numberWithInt:(appDelegate.currentImageIndex.intValue - 1)];
            appDelegate.currentImageIndex = sum;
        }
    }
    else
    {
        //Wrap around to the right
        if(appDelegate.currentImageIndex.intValue == [favoriteStocks count] - 1)
        {
            appDelegate.currentImageIndex = [[NSNumber alloc]initWithInt:0];
        }
        else
        {
            NSNumber *sum = [NSNumber numberWithInt:(appDelegate.currentImageIndex.intValue + 1)];
            appDelegate.currentImageIndex = sum;
        }
    }
    
    //Load the image
    [self initImage];
}

#pragma mark - Table View

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView {
    return 1;
}

// Return the number of rows in the section
- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section {
    
    if(favoriteStocks != NULL)
    {
    
        return [favoriteStocks count];
    }
    return 0;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)quoteTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StockCell";
    UITableViewCell *cell = [quoteTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Set the data for this cell:
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSString *symbol ;
    NSString *key;
    if(appDelegate.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        key=@"SYMBOL";
        
    }
    else
    {
        key=@"symbol";
    }
    
    //Set the title of the cell.
    symbol = [[favoriteStocks objectAtIndex:indexPath.row] valueForKey:key];
    
    if (![symbol isEqualToString:@""])
    {cell.textLabel.text = symbol;
    
    //Set the subtitle of the cell
    if([self isLoggedIn] && [favoriteStocks isEqualToArray:appDelegate.user.favoriteStocks])
    {
        //Retrieve it from the saved list
        cell.detailTextLabel.text = [[favoriteStocks objectAtIndex:indexPath.row]valueForKey:@"summary"];
    }
    else
    {
        //Fetch the local data. 
        if([favoriteStocks count] > 0 )
        {
            cell.detailTextLabel.text = [self fetchData:[[favoriteStocks objectAtIndex:indexPath.row] valueForKey:key] ];
        }
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

// Segue whenever a row is selected
- (void)tableView:(UITableView *)quoteTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [self performSegueWithIdentifier:@"StockView" sender:quoteTableView];
}


// Prepare for a segue by initializing the page that we will transition to
// 
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"StockView"])
    {
        StockViewController *stockViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.quoteTableView indexPathForSelectedRow];
        
        
        NSString *key;
        if(appDelegate.user.loggedIn == [[NSNumber alloc]initWithInt:1])
        {
            key=@"SYMBOL";
            
        }
        else
        {
            key=@"symbol";
        }
        NSString *symbol = [[favoriteStocks objectAtIndex:indexPath.row] valueForKey:key];
        NSString *destinationTitle = symbol;
        
        //Set what stock symbol we are going to view in the StockView controller
        stockViewController.symbol = destinationTitle;
        stockViewController.originateFrom = @"QuoteView";
        [stockViewController setTitle:destinationTitle];
    }
    
}


//fetch data from Yahoos database. Do some string processing and return a summary of what to display
//for the lists title. 
-(NSString *)fetchData:(NSString *)symbol
{
    
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
    NSError *error;
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * jsonData = [[NSDictionary alloc]init];
    NSDictionary * query = [[NSDictionary alloc]init];
    NSDictionary * results = [[NSDictionary alloc]init];
    NSDictionary * stockInfo = [[NSDictionary alloc]init];
    @try
    {
        id object = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if(error)
        {
            NSLog(@"Error parsing data");
            
        }
        if([object isKindOfClass:[NSDictionary class]]) //Parse through the various layers
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
                        //If made it here, then the object was successfully parsed and is of right type
                        
                        stockInfo = [results objectForKey:@"quote"]; 
                        
                        
                        //Ensure that there are no null objects, otherwise program can fail.
                        NSString *temp =@"";
                        if([stockInfo valueForKey:@"Change"] != [NSNull null])
                        {
                            temp = [[NSString alloc]initWithFormat:@"%@%@ Change, ", temp,[stockInfo valueForKey:@"Change"]];
                           
                        }
                        if([stockInfo valueForKey:@"DaysRange"] != [NSNull null])
                        {
                            temp = [[NSString alloc]initWithFormat:@"%@%@, ", temp,[stockInfo valueForKey:@"DaysRange"]];
                            
                        }
                        if([stockInfo valueForKey:@"Name"] != [NSNull null])
                        {
                            temp = [[NSString alloc]initWithFormat:@"%@%@", temp,[stockInfo valueForKey:@"Name"]];
                            
                        }
                        
                        //returns a short summary of the stock
                        return temp;
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"EXCEPTION CAUGHT %@", [exception description]);
    }
   
}


#pragma mark - On Exit

//When the view is going to dissapear, save the favorite stocks to reuse them the next time
//the page is loaded
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    appDelegate.user.oldFavorites = self.favoriteStocks;
    
}

#pragma mark - DBHTTPClient delegate
//Whenever the HTTP client is done fetching data, store the data locally
//and reload the page with the fresh data. Usefull whenever user is logged in
//or new changes are done to the remote database.
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares
{
    appDelegate.user.favoriteStocks = results;
    appDelegate.user.oldFavorites = results;
    appDelegate.user.accountValue = totalValue;
    appDelegate.user.totalShares = totalShares;
    appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:0];
    favoriteStocks = results;
    reload = [[NSNumber alloc]initWithInt:1];

    //[self viewDidLoad];
    [self initImage];
    [self.quoteTableView reloadData];
}

-(void)handleUpdatedData:(NSNotification *)notification {
  //  NSLog(@"recieved");
    [self viewDidLoad];
    [self.quoteTableView reloadData];
}

@end
