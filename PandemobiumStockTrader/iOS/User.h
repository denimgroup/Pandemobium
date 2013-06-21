//
//  User.h
//  Pandemobium
//
//  Created by Adrian Salazar on 6/21/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stock;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *stocks;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStocksObject:(Stock *)value;
- (void)removeStocksObject:(Stock *)value;
- (void)addStocks:(NSSet *)values;
- (void)removeStocks:(NSSet *)values;

@end
