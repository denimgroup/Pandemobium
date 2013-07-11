//
//  CoreDataInterface.m
//  FightCardMobile
//
//  Created by Alex Pepper on 2/18/13.
//  Copyright (c) 2013 Zuffa. All rights reserved.
//


#import "CoreDataInterface.h"


@implementation CoreDataInterface

- (void)undo {
    
    [self.managedObjectContext.undoManager undo];
}


- (void)beginUndoGrouping {
    
    [self.managedObjectContext.undoManager beginUndoGrouping];
}


- (void)endUndoGrouping {
    
    [self.managedObjectContext.undoManager endUndoGrouping];
}


- (void)rollback {
    
    [self.managedObjectContext rollback];
}



- (id)insertEntity:(NSString *)entityName {
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:entityName
            inManagedObjectContext:self.managedObjectContext];
}


- (void)deleteEntity:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}



- (id)objectWithID:(NSManagedObjectID *)objectID {
    
    return [self.managedObjectContext objectWithID:objectID];
}


- (id)objectIDWithURL:(NSString *)url {
    
    return [self.persistentStoreCoordinator
            managedObjectIDForURIRepresentation:
            [NSURL URLWithString:url]];
}


- (id)objectWithURL:(NSURL *)url {
    
    NSManagedObjectID *objectID = [self.persistentStoreCoordinator
                                   managedObjectIDForURIRepresentation:url];
    
    return objectID ? [self objectWithID:objectID] : nil;
}


- (id)executeFetchRequest:(NSFetchRequest *)fetchRequest {
    
    NSError *error = nil;
    
    id result = [[self.managedObjectContext
                  executeFetchRequest:fetchRequest
                  error:&error] copy];
    
    return result;
}


- (void)save {
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            
            abort();
        }
    }
}


- (NSEntityDescription *)entityForName:(NSString *)entityName {
    
    return [NSEntityDescription entityForName:entityName
                       inManagedObjectContext:self.managedObjectContext];
}


- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
    	[_managedObjectContext setUndoManager:undoManager];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ClientStocks" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:[self coreDataStoreURL]
                                                    options:nil
                                                      error:&error];

    return _persistentStoreCoordinator;
}


- (NSURL *)coreDataStoreURL {

    NSURL *directory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [directory URLByAppendingPathComponent:@"defaultStockDB.sqlite"];
    
}

- (void)tearDownCoreDataStack {
    
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    NSError *error;
    NSURL *storeURL = store.URL;
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentStoreCoordinator;
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:nil
                                                               error:&error]) {
        abort();
    }
    
    
}


- (void)saveDataInContext:(void(^)(NSManagedObjectContext *context))saveBlock {
    
    CoreDataInterface *coreDataInterface = [[CoreDataInterface alloc] init];
    
    NSManagedObjectContext *context = coreDataInterface.managedObjectContext;
    
    [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    [self.managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    
    [self observeContext:context];
    
    saveBlock(context);
    
    if ([context hasChanges]) [context save:nil];
    
    [self unobserveContext:context];
    
    coreDataInterface = nil;
}


- (void)saveDataInBackgroundWithContext:(void(^)(NSManagedObjectContext *context))saveBlock
                             completion:(void(^)(void))completion {
    
    __weak id weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [weakSelf saveDataInContext:saveBlock];
        
        dispatch_sync(dispatch_get_main_queue(), ^{ completion(); });
    });
}


- (void)observeContext:(NSManagedObjectContext *)context {
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(mergeChangesFromNotification:)
     name:NSManagedObjectContextDidSaveNotification
     object:context];
}


- (void)unobserveContext:(NSManagedObjectContext *)context {
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:NSManagedObjectContextDidSaveNotification
     object:context];
}


- (void) mergeChangesFromNotification:(NSNotification *)notification {
    
    [self.managedObjectContext
     performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
     withObject:notification
     waitUntilDone:NO];
}

@end