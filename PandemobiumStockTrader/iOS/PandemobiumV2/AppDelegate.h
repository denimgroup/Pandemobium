//
//  AppDelegate.h
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/17/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeViewController.h"
#import "TipsViewController.h"
#import "ManageTipsViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) NSNumber *currentImageIndex;
@property (strong, nonatomic) User * user;


//@property (nonatomic, retain) TipsViewController *tips;
//@property (nonatomic, retain) TradeViewController *trade;

- (NSURL *) applicationDocumentsDirectory;

@end
