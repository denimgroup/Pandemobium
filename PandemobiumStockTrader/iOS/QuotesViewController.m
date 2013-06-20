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
    
    [self loadSwipeGesture];
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


- (void) loadSwipeGesture
{
    
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    
    
    
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *) recognizer
{
    
    
    CGPoint point = [recognizer locationOfTouch:0 inView:self.view];
    
    // If the swipe occurs over the topImage then swipe the top image.
    if(point.x <= self.topImage.bounds.size.width + self.topImage.bounds.origin.x && point.y <= self.topImage.bounds.size.height + self.topImage.bounds.origin.y)
    {
        
        [self swipeTopImage:recognizer];
    }
    
    
}

- (void)swipeTopImage:(UISwipeGestureRecognizer *)recognizer
{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        
        NSURL *imageurl = [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=GOOG"];
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
        
        UIImage *image = [UIImage imageWithData:imageData];
        [self.topImage setImage:image ];
        
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSURL *imageurl = [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=AAPL"];
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
        
        UIImage *image = [UIImage imageWithData:imageData];
        [self.topImage setImage:image ];
        
    }
    
    
}
- (IBAction)leftButtonClicked:(id)sender
{
    
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
    
    NSManagedObject * firstObject = [objects objectAtIndex:0];
    NSString *symbol = [firstObject valueForKey:@"symbol"];
    
    NSLog(@"%@\n", symbol);
    
    NSString *path = [[NSString alloc]initWithFormat:@"http://chart.finance.yahoo.com/z?s=%@",symbol];
    
    // NSURL *imageurl = [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=GOOG"];
    NSURL *imageurl = [NSURL URLWithString:path];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageurl];
    
    UIImage *image = [UIImage imageWithData:imageData];
    // image.size = [CGSizeMake(self.topImage.bounds.size.width, self.topImage.bounds.size.height)];
    

    
    
    
    if([direction isEqualToString:@"left"])
    {
        
        
        
        
    }
    else
    {
        
    }
    
    
    
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
    static NSString *CellIdentifier = @"Cell";
    
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
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Stock"];
                            
}

/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    if([destination respondsToSelector:@selector(setDelegate:)])
    {
        [destination setValue:self forKey:@"delegate"];
    }
    if([destination respondsToSelector:@selector(setSelection:)])
    {
        NSIndexPath *indexPath = [self.quoteTableView indexPathForCell:sender];
        id object; // = [sender ]
        NSDictionary *selection = @{@"indexPath" : indexPath, @"object" :object};
        [destination setValue:selection forKey:@"selection"];
    }
       
    
}

 */

@end
