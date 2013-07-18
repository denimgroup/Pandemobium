//
//  User.h
//  Pandemobium
//
//  Created by Adrian Salazar on 7/5/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSObject 

@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSNumber * loggedIn;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSNumber * userID;
@property (nonatomic, strong) NSNumber * accountID;

@property (nonatomic, strong) NSArray *favoriteStocks;
@property (nonatomic, strong) NSArray *oldFavorites;
@property (nonatomic, strong) NSNumber *accountValue;
@property (nonatomic, strong) NSNumber *totalShares;
@property (nonatomic, strong) NSNumber *reloadData;

@end
