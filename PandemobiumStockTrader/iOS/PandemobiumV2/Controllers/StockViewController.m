//
//  StockViewController.m
//  Pandemobium
//
//  Created by Adrian Salazar on 6/20/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "StockViewController.h"
#import "AppDelegate.h"
#import "QuotesViewController.h"
#import "TradeViewController.h"
#import "DBHelper.h"
#import "SVProgressHUD.h"

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
    [self.view becomeFirstResponder];
    
	// Do any additional setup after loading the view.
   
    [self initImage];
    [self fetchData];
    [self stockStatus:symbol];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initImage
{
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    [self.imageView setImage:image ];
   
}

-(void) fetchData
{
   
//    NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
//    
//    NSError *error;
//    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    
//    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
//    NSDictionary *query = [jsonData objectForKey:@"query"];
//    NSDictionary *results = [query objectForKey:@"results"];
//    stockInfo = [results objectForKey:@"quote"];
//    
    
    
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
    //NSLog(@"%@", url);
    NSError *error;
    //while(true)
    //{
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * jsonData = [[NSDictionary alloc]init];
    NSDictionary * query = [[NSDictionary alloc]init];
    NSDictionary * results = [[NSDictionary alloc]init];
    //NSDictionary * stockInfo = [[NSDictionary alloc]init];
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
    @finally {
    
    }
    
    
    
}

-(void)stockStatus:(NSString *)stockSymbol
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    DBHelper *helper = [[DBHelper alloc]init] ;
    
    
    
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
            //        [self.favoriteButton setTitle:@"Remove" forState:UIControlStateNormal];
            //[self.favoriteButton.title = @"Remove"];
            [self.favoriteButton setTitle:@"Remove"];
        }
        
    }
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

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
    
    if([cellTitle objectAtIndex:indexPath.row] == [NSNull null])
    {
        cell.textLabel.text = @"N/A";
        
        
    }
    else
    {
        cell.textLabel.text = [cellTitle objectAtIndex:indexPath.row];
    }
    
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


- (IBAction)backButtonClicked:(id)sender
{
    self.originateFrom = @"QuoteView";
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if(app.user.reloadData == [[NSNumber alloc]initWithInt:1] )
    {
        [SVProgressHUD show];
        DBHTTPClient *client = [DBHTTPClient sharedClient];
        client.delegate = self;
        [client getAllStockValue:app.user.accountID];
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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    DBHelper *helper = [[DBHelper alloc]init] ;
    DBHTTPClient *client = [DBHTTPClient sharedClient];
    client.delegate = self;
    UIAlertView *alert;
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *buttonTitle;
    
    if([appDelegate.user.loggedIn intValue] == 1)
    {
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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    DBHelper *helper = [[DBHelper alloc]init] ;
    DBHTTPClient *client = [DBHTTPClient sharedClient];
    client.delegate = self;
    

    UIAlertView *alert;
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *buttonTitle;
    
    if([appDelegate.user.loggedIn intValue] == 1)
    {
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

-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.user.favoriteStocks = results;
    appDelegate.user.oldFavorites = results;
    appDelegate.user.accountValue = totalValue;
    appDelegate.user.totalShares = totalShares;
    appDelegate.user.reloadData = [[NSNumber alloc] initWithInt:0];
    
    [self performSegueWithIdentifier:originateFrom sender:self];
    [SVProgressHUD dismiss];

}



@end
