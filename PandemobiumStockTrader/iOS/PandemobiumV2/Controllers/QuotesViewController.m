//
//  QuotesViewController.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/17/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "QuotesViewController.h"
#import "Stock.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "SVProgressHUD.h"
#import "DBHTTPClient.h"

@interface QuotesViewController ()

@end

@implementation QuotesViewController;

//@synthesize managedObjectContext;
@synthesize favoriteStocks;
@synthesize activityIndicator;
@synthesize reload;

-(void)viewDidLoad
{
    [SVProgressHUD dismiss];
    [super viewDidLoad];
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    
    favoriteStocks = app.user.oldFavorites;
    
    
    if([self isLoggedIn] == FALSE)
    {
        [self setDefaultFavorites];
        [self loadDefaultFavoriteStocks];
    }
    else
    {
        [self loadFavoriteStocks];
        
    }
    
    [self initImage];
    
    
}



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

-(void)loadDefaultFavoriteStocks
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == %@", @"1"];
    [request setPredicate:predicate];
    
    favoriteStocks = [context executeFetchRequest:request error:&error];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    favoriteStocks = [favoriteStocks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
}
-(void) loadFavoriteStocks
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if(app.user.reloadData == [[NSNumber alloc]initWithInt:1] )
    {
    
        reload = [[NSNumber alloc]initWithInt:0];
        DBHTTPClient *client = [DBHTTPClient sharedClient];
        client.delegate = self;
        [client getAllStockValue:app.user.accountID];
    }
    
    
    
}
-(void)setDefaultFavorites
{
        [self addFavorite:@"GOOG"];
        [self addFavorite:@"MSFT"];
        [self addFavorite:@"AAPL"];
}

-(void)addFavorite:(NSString *)symbol
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", symbol];
    [request setPredicate:predicate];
    
    Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
    stock.favorite = [[NSNumber alloc]initWithBool:YES];
    
    [context save:&error];
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



- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (void) initImage
{

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  
    NSString *key;
    if(appDelegate.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        key=@"SYMBOL";
        
    }
    else
    {
        key=@"symbol";
    }
    NSString *symbol ;
   
        symbol = [[favoriteStocks objectAtIndex:appDelegate.currentImageIndex.intValue] valueForKey:key];
        
        
   
        
        // NSLog(@"%@", symbol);
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    [self.topImage setImage:image ];
    
}


- (IBAction)leftButtonClicked:(id)sender {
   
    [self changeImage:@"left"];
    
}

- (IBAction)rightButtonclicked:(id)sender
{
        [self changeImage:@"right"];
}

-(void)changeImage:(NSString *)direction
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if([direction isEqualToString:@"left"])
    {
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
    
    NSString *key;
    if(appDelegate.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        key=@"SYMBOL";
        
    }
    else
    {
        key=@"symbol";
    }
    
    NSString *symbol ;
        symbol = [[favoriteStocks objectAtIndex:appDelegate.currentImageIndex.intValue] valueForKey:key];
        
        
    
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
    // NSURL *imageurl = [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=GOOG"];
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    // image.size = [CGSizeMake(self.topImage.bounds.size.width, self.topImage.bounds.size.height)];
    
    [self.topImage setImage:image];
}

-(NSString *)fetchData:(NSString *)symbol
{
    

        NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
    //NSLog(@"%@", url);
        NSError *error;
    //while(true)
    //{
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * jsonData = [[NSDictionary alloc]init];
    NSDictionary * query = [[NSDictionary alloc]init];
    NSDictionary * results = [[NSDictionary alloc]init];
    NSDictionary * stockInfo = [[NSDictionary alloc]init];
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
                        stockInfo = [results objectForKey:@"quote"]; //error
                        
                        
                        NSString *temp = [[NSString alloc] initWithFormat:@"%@ Change, %@, %@",
                                          [stockInfo valueForKey:@"Change"],
                                          [stockInfo valueForKey:@"DaysRange"],
                                          [stockInfo valueForKey:@"Name"]];
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
    @finally {
        //NSString *temp = @"Unable to retrieve stock information\n";
       // return temp;

    }
    //}
    
   // NSLog(@"I will fail");
        
            
    
    
   
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    
    return [favoriteStocks count];
    //return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)quoteTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StockCell";
  
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
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
    
    symbol = [[favoriteStocks objectAtIndex:indexPath.row] valueForKey:key];
        
    
    
    cell.textLabel.text = symbol;
    
    if([self isLoggedIn] && [favoriteStocks isEqualToArray:appDelegate.user.favoriteStocks])
    {
        cell.detailTextLabel.text = [[favoriteStocks objectAtIndex:indexPath.row]valueForKey:@"summary"];
    }
    else
    {
        if([favoriteStocks count] > 0 )
        {
            cell.detailTextLabel.text = [self fetchData:[[favoriteStocks objectAtIndex:indexPath.row] valueForKey:key] ];
        }
         // set the accessory view:
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
- (void)tableView:(UITableView *)quoteTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

   // [self performSegueWithIdentifier:@"StockView" sender:tableView];
    [self performSegueWithIdentifier:@"StockView" sender:quoteTableView];
    
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"StockView"])
    {
        StockViewController *stockViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.quoteTableView indexPathForSelectedRow];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

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
        symbol = [[favoriteStocks objectAtIndex:indexPath.row] valueForKey:key];
        
        NSString *destinationTitle = symbol;
        
        stockViewController.symbol = destinationTitle;
        stockViewController.originateFrom = @"QuoteView";
        [stockViewController setTitle:destinationTitle];
               
        //StockViewController *destination = [segue destinationViewController];
        //NSLog(@"Everyday I'm segueing\n");
    }
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.user.oldFavorites = self.favoriteStocks;
    
}

-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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


@end
