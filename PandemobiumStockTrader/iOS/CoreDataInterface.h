//
// CoreDataInterface.h
// FightCardMobile
//
// Created by Alex Pepper on 2/18/13.
// Copyright (c) 2013 Zuffa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataInterface : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)save;
- (void)rollback;
- (void)undo;
- (void)beginUndoGrouping;
- (void)endUndoGrouping;
- (id)insertEntity:(NSString *)entityName;
- (void)deleteEntity:(NSManagedObject *)object;
- (id)objectWithID:(NSManagedObjectID *)objectID;
- (id)objectIDWithURL:(NSString *)url;
- (id)objectWithURL:(NSURL *)url;
- (id)executeFetchRequest:(NSFetchRequest *)fetchRequest;
- (void)tearDownCoreDataStack;
- (void)saveDataInBackgroundWithContext:(void(^)(NSManagedObjectContext *context))saveBlock
                             completion:(void(^)(void))completion;
- (NSEntityDescription *)entityForName:(NSString *)entityName;
@end