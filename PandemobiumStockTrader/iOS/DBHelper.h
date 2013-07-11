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
-(NSDictionary *) getAccountInfo:(NSNumber *) accountID;
-(NSArray *) getPurchasedStocks:(NSNumber *)accountID;
-(NSNumber *) getAccountValue:(NSNumber *) accountID;
-(NSDictionary *)fetchYahooData:(NSString *)symbol;
-(NSDictionary *) buyStock:(NSNumber *)shares forSymbol:(NSString *)symbol fromAccountID:(NSNumber *)accountID;
-(NSDictionary *) updateAccountBalance:(NSNumber *) accountID newBalance:(NSNumber *)balance;
-(NSNumber *) getShareTotal:(NSNumber *) accountID;
-(NSArray *) getTips;
-(NSArray *) getHistory:(NSNumber *)userID;
-(NSDictionary *) getIndividualStock:(NSNumber *) accountID forStock:(NSString *)symbol;
-(NSDictionary *) addFavoriteStock:(NSNumber *) accountID stockSymbol:(NSString *)symbol;
-(NSDictionary *) removeFavoriteStock:(NSNumber *) accountID stockSymbol:(NSString *)symbol;
-(NSArray *) getAllUserStocks:(NSNumber *)accountID;
-(NSDictionary *) sellStock:(NSNumber *)shares forSymbol:(NSString *)symbol fromAccountID:(NSNumber *)accountID;
-(NSArray *) getStockValue:(NSNumber *) accountID;


@end
