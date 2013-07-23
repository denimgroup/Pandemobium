//
//  DBHTTPClient.h
//  Pandemobium
//
//  Created by Adrian Salazar on 7/16/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

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