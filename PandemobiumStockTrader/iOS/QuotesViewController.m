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

@interface QuotesViewController ()

@end

@implementation QuotesViewController;

@synthesize swipeUp;
@synthesize swipeDown;



//@synthesize managedObjectContext;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initImage];
  
    
    
    

    /*
    if(self.managedObjectContext == nil)
    {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
        NSLog(@"After _managedObjectContext: %@", self.managedObjectContext);
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects == nil)
    {
        NSLog(@"There was an error");
    }

    if(objects.count == 0)
    {
        NSLog(@"EmptyDB\n");
    }
    else{
        NSLog(@"Number of Items: %i\n", objects.count);
    }
*/
        //    UIApplication *app = [UIApplication sharedApplication];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
}





- (void)applicationWillResignActive:(NSNotification *)notification
{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSError *error;
//    for(int i = 0; i < 4; i++)
//    {
//        
//    }
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

- (void) initImage
{

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects == nil)
    {
        NSLog(@"There was an error");
    }
    
    appDelegate.currentImageIndex = appDelegate.currentImageIndex;
   // NSManagedObject * firstObject = [objects objectAtIndex:(NSUInteger)appDelegate.currentImageIndex];
    NSManagedObject * firstObject = [objects objectAtIndex:0];
    
    
    
    NSString *symbol = [firstObject valueForKey:@"symbol"];
    
    NSLog(@"%@\n", symbol);
    
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
   // NSURL *imageurl = [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=GOOG"];
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    // image.size = [CGSizeMake(self.topImage.bounds.size.width, self.topImage.bounds.size.height)];
 
   
    [self.topImage setImage:image ];
    //[self.topImage sizeThatFits:image.size];
    
}


- (IBAction)leftButtonClicked:(id)sender {
    NSLog(@"Left is clicked\n");
    [self changeImage:@"left"];
    
}
- (IBAction)rightButtonclicked:(id)sender
{
    [self changeImage:@"right"];
    
}

-(void)changeImage:(NSString *)direction
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects == nil)
    {
        NSLog(@"There was an error");
    }
    
    if([direction isEqualToString:@"left"])
    {
        if(appDelegate.currentImageIndex.intValue == 0)
        {
            appDelegate.currentImageIndex = [[NSNumber alloc]initWithInt:[objects count] - 1];
        }
        else
        {
            NSNumber *sum = [NSNumber numberWithInt:(appDelegate.currentImageIndex.intValue - 1)];
            appDelegate.currentImageIndex = sum;
        }
    }
    else
    {
        if(appDelegate.currentImageIndex.intValue == [objects count] - 1)
        {
            appDelegate.currentImageIndex = [[NSNumber alloc]initWithInt:0];
        }
        else
        {
            NSNumber *sum = [NSNumber numberWithInt:(appDelegate.currentImageIndex.intValue + 1)];
            appDelegate.currentImageIndex = sum;
        }
    }
    
    NSManagedObject * firstObject = [objects objectAtIndex:appDelegate.currentImageIndex.intValue ];
    NSString *symbol = [firstObject valueForKey:@"symbol"];
    
    NSLog(@"%@\n", symbol);
    
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
    // NSURL *imageurl = [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=GOOG"];
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    // image.size = [CGSizeMake(self.topImage.bounds.size.width, self.topImage.bounds.size.height)];
    
    [self.topImage setImage:image];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)quoteTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)quoteTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    
    return [objects count];
    //return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)quoteTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StockCell";
    
    UITableViewCell *cell = [quoteTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Set the data for this cell:
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    NSMutableArray *stockSymbols = [[NSMutableArray alloc]init];
    NSMutableArray *companyNames = [[NSMutableArray alloc]init];
    NSLog(@"Number of items %i\n", [objects count]);
    for(int i = 0; i < [objects count]; i++)
    {
        NSManagedObject *obj = [objects objectAtIndex:i];
        [stockSymbols addObject:[obj valueForKey:@"symbol"]];
        [companyNames addObject:[obj valueForKey:@"name"]];
    }
    
    cell.textLabel.text = [stockSymbols objectAtIndexedSubscript:indexPath.row];
    cell.detailTextLabel.text = [companyNames objectAtIndexedSubscript:indexPath.row];
    
     // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSMutableArray *stockSymbols = [[NSMutableArray alloc]init];
    NSMutableArray *companyNames = [[NSMutableArray alloc]init];
    NSLog(@"Number of items %i\n", [objects count]);
    for(int i = 0; i < [objects count]; i++)
    {
        NSManagedObject *obj = [objects objectAtIndex:i];
        [stockSymbols addObject:[obj valueForKey:@"symbol"]];
        [companyNames addObject:[obj valueForKey:@"name"]];
    }

    
    NSString *identifier = [NSString stringWithFormat:@"%@", [stockSymbols objectAtIndex:indexPath.row]];
    
    StockViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockView"];
    newTopViewController.symbol = identifier;
    NSLog(@"%@", [[NSString alloc]initWithString:newTopViewController.symbol]);

        
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"StockView"])
    {
        StockViewController *destination = [segue destinationViewController];
        NSLog(@"Everyday I'm segueing\n");
    }
    
}



@end
