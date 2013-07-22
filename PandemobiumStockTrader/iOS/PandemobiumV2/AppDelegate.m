//
//  AppDelegate.m
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/17/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "AppDelegate.h"
#import "Stock.h"
#import "QuotesViewController.h"
#import "iVersion.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    
    NSLog(@"Allowing non SSL certificates");
    return YES;
}

@end


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize user;

-(void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSLog(@"application did finish launching");
    
    
}




-(void)loadDataFromPropertyList
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"fullStockList" ofType:@"plist"]   ;
    NSArray *items = [NSArray arrayWithContentsOfFile:path];
    
    NSManagedObjectContext *ctx = self.managedObjectContext;
    for(NSDictionary *dict in items)
    {
        NSManagedObject *m = [NSEntityDescription insertNewObjectForEntityForName:@"Stock" inManagedObjectContext:ctx];
        [m setValuesForKeysWithDictionary:dict];
    }
    NSError *err = nil;
    [ctx save:&err];
    if(err != nil)
    {
        NSLog(@"Error savign manageed object context: %@", err);
    }
    
    
}

//-----------for launching with URL ---------
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    user = [[User alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"firstRun"])
    {
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self loadDataFromPropertyList];
        
    }
    
    self.currentImageIndex = [[NSNumber alloc]initWithInt:0];
    
    if(launchOptions != nil)
    {
        
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"handle Open URL");
    
    if([[url absoluteString] hasPrefix:@"trade"])
    {
        
        NSLog(@"something to do with trade");
        
        TradeViewController *trade = [[TradeViewController alloc]init];
        [trade application:application handleOpenURL:url];
        
        
    }
    else if([[url absoluteString] hasPrefix:@"tips"])
    {
        
        
        NSLog(@"something to do with tips");
        
    }
    
    
    return YES;
    
    
}

// ----------------------------------------------------


+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
  //  iVersion *version = [[iVersion alloc]init];
   // version.applicationBundleID = @"com.denimgroup.Pandemobium";
    //version.remoteVersionsPlistURL=@"http://localhost:8080/versions.plist";
   //[version checkForNewVersion];
    
    [iVersion sharedInstance].applicationBundleID = @"com.denimgroup.Pandemobium";
    [iVersion sharedInstance].displayAppUsingStorekitIfAvailable = NO;
    
    //configure iVersion. These paths are optional - if you don't set
    //them, iVersion will just get the release notes from iTunes directly (if your app is on the store)
    [iVersion sharedInstance].remoteVersionsPlistURL = @"http://localhost:8080/versions.plist";
    [iVersion sharedInstance].checkAtLaunch = YES;
    [iVersion sharedInstance].updateURL = [[NSURL alloc]initWithString:@"http://localhost:8080/download.html"];
    
    [[iVersion sharedInstance] checkForNewVersion];
   // iVersion.checkIfNewVersion();
    //[iVersion sharedInstance].localVersionsPlistPath = @"versions.plist";
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil] ;
    return _managedObjectModel;
    
    
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ClientStocks" withExtension:@"xcdatamodeld"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"defaultStockDB.sqlite"];
    NSLog(@"%@", storeURL);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
