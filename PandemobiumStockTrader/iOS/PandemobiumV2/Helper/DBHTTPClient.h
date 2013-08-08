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

#import "AFHTTPClient.h"
#import "AFNetworking.h"

@protocol DBHTTPClientDelegate;

@interface DBHTTPClient : AFHTTPClient

@property(weak) id<DBHTTPClientDelegate> delegate;
+(DBHTTPClient *) sharedClient;
-(id)initWithBaseURL:(NSURL *)url;
-(void)logIn:(NSString *)username forPassword:(NSString *)password;
-(void) getAccountID:(NSNumber *) userID;
-(void) addHistory:(NSNumber *) userID forLog:(NSString *)log;
-(void) getAllStockValue:(NSNumber *) accountID;
-(void) addFavoriteStock:(NSNumber *) accountID stockSymbol:(NSString *)symbol;
//needs to be added to .m -(void) addTips:(NSNumber *) userID forlog:(NSString *)log;

@end


@protocol DBHTTPClientDelegate <NSObject>

@optional
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithLogIn:(NSDictionary *)results;
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAccountID:(NSNumber *)results;
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithAllStockValue:(NSArray *)results withTotalValue:(NSNumber *)totalValue withTotalShares:(NSNumber *)totalShares;
-(void)DBHTTPClient:(DBHTTPClient *)client didUpdateWithLAddFavoriteStocks:(NSDictionary *)results;

-(void)DBHTTPClient:(DBHTTPClient *)client didFailWithError:(NSError *)error;

@end