//
//  Stock.h
//  PandemobiumV2
//
//  Created by Adrian Salazar on 6/19/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stock : NSManagedObject

@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * share;

@end
