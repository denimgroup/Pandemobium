//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with
// vulnerabilities included for security testing purposes.
// Copyright (c) 2013 Denim Group, Ltd. All rights reserved worldwide.
//
// This file is part of Pandemobium Stock Trader.
//
// Pandemobium Stock Trader is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader. If not, see
// <http://www.gnu.org/licenses/>.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"

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
-(NSArray *) getAllStockValue:(NSNumber *) accountID;
-(NSDictionary *) addHistory:(NSNumber *) userID forLog:(NSString *)log;
-(NSDictionary *) addTip:(NSNumber *)userID forSymbol:(NSString *)symbol forLog:(NSString *)log;


@end
