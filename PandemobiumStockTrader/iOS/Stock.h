//
//  Stock.h
//  Pandemobium
//
//  Created by Thomas Salazar on 6/25/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Stock : NSManagedObject

@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * share;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSSet *user;
@end

@interface Stock (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
