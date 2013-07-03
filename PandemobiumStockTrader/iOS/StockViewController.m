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

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface StockViewController ()

@end

@implementation StockViewController

@synthesize symbol;
@synthesize stockInfo;
@synthesize originateFrom;

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
   
    NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
    
    NSError *error;
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSDictionary *query = [jsonData objectForKey:@"query"];
    NSDictionary *results = [query objectForKey:@"results"];
    stockInfo = [results objectForKey:@"quote"];
    
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
    
    NSArray *title = [stockInfo allKeys];
    NSArray *subtitle = [stockInfo allValues];
    
    cell.textLabel.text = [title objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [subtitle objectAtIndex:indexPath.row];
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryNone;
    
    return cell;
}


- (IBAction)backButtonClicked:(id)sender
{
    
    [self performSegueWithIdentifier:originateFrom sender:sender];
}

- (IBAction)favoriteButtonClicked:(id)sender
{
    [self.favoriteButton titleTextAttributesForState:UIControlStateNormal];
//    if([self.favoriteButton.currentTitle isEqualToString:@"Favorite"])
    if([self.favoriteButton.title isEqualToString:@"Favorite"])
    {
        [self addFavorite:symbol];
//        [self.favoriteButton setTitle:@"Remove" forState:UIControlStateNormal];
        //[self.favoriteButton.title = @"Remove"];
        [self.favoriteButton setTitle:@"Remove"];
    }
    else
    {
        [self removeFavorite:symbol];
//        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
        //[self.favoriteButton.title = @"Favorite"];
        [self.favoriteButton setTitle:@"Favorite"];
    }
    
}
- (IBAction)tradingButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"Trading" sender:sender];
 
}


-(void)addFavorite:(NSString *)stockSymbol
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", stockSymbol];
    [request setPredicate:predicate];
    
    Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
    stock.favorite = [[NSNumber alloc]initWithBool:YES];
    
    [context save:&error];
    
}


-(void)removeFavorite:(NSString *)stockSymbol
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", stockSymbol];
    [request setPredicate:predicate];
    
    Stock *stock = [[context executeFetchRequest:request error:&error]objectAtIndex:0];
    stock.favorite = [[NSNumber alloc]initWithBool:NO];
    
    [context save:&error];
    
}
-(void)stockStatus:(NSString *)stockSymbol
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([[segue identifier]isEqualToString:@"Quoteview"])
//    {
//       // QuotesViewController *viewController = [segue destinationViewController];
//        
//    }
}



@end
