//
//  DBHelper.h
//  Pandemobium
//
//  Created by Adrian Salazar on 7/5/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBHelper : NSObject

-(NSNumber *) getAccountID:(NSNumber *) accountID;
-(NSDictionary *) logIn:(NSString *)username forPassword:(NSString *)password;
-(NSArray *) getFavoriteStocks:(NSNumber *)accountID;


@end
