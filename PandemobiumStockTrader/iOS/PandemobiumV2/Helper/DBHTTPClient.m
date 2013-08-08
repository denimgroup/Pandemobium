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

#import "DBHTTPClient.h"
#import "SVProgressHUD.h"
#import "DBHelper.h"

@implementation DBHTTPClient

NSString *const BaseURLString = @"http://localhost:8080/web/";

+(DBHTTPClient *) sharedClient
{
    static dispatch_once_t pred;
    static DBHTTPClient *_sharedDBHTTPClient = nil;
    dispatch_once(&pred, ^{_sharedDBHTTPClient = [[self alloc]initWithBaseURL:[NSURL URLWithString:BaseURLString]]; });
    return _sharedDBHTTPClient;
}
-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
    
}

-(void)logIn:(NSString *)username forPassword:(NSString *)password
{
    /*
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"logIn" forKey:@"method"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    
    //[self setParameterEncoding:AFJSONParameterEncoding];
    */
   
    NSString *urlString = [[NSString alloc]initWithFormat:
                           @"%@user.jsp?method=logIn&username=%@&password=%@", BaseURLString, username, password];
    //NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
            {
                NSDictionary * firstParse = (NSDictionary *)JSON;
                NSArray *secondParse = [firstParse objectForKey:@"Results"];
                if([self.delegate respondsToSelector:@selector(DBHTTPClient:didUpdateWithLogIn:)])
                    [self.delegate DBHTTPClient:self didUpdateWithLogIn:[secondParse objectAtIndex:0]];
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                [SVProgressHUD dismiss];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User Information"
                                                             message:[NSString stringWithFormat:@"%@",error]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }];
    [operation start];
     
}

-(void) getAccountID:(NSNumber *) userID
{
    
    NSString *query = [[NSString alloc]initWithFormat:@"Select accountID from account where userID=%i", [userID intValue]];
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/web/account.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         NSDictionary * firstParse = (NSDictionary *)JSON;
         NSArray *secondParse = [firstParse objectForKey:@"Results"];
         NSDictionary *results = [secondParse objectAtIndex:0];
         
         if([self.delegate respondsToSelector:@selector(DBHTTPClient:didUpdateWithAccountID:)])
             [self.delegate DBHTTPClient:self didUpdateWithAccountID:[results valueForKey:@"ACCOUNTID"]];
         else if([self.delegate respondsToSelector:@selector(DBHTTPClient:didUpdateWithLogIn:)])
             [self.delegate DBHTTPClient:self didUpdateWithAccountID:[results valueForKey:@"ACCOUNTID"]];
     }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         [SVProgressHUD dismiss];
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Account Information"
                                                      message:[NSString stringWithFormat:@"%@",error]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [av show];
     }];
    [operation start];
}
-(void) addHistory:(NSNumber *) userID forLog:(NSString *)log
{
    
    NSString *query = [[NSString alloc]initWithFormat:@"insert into history(userID, log) values(%i, '%@');", [userID intValue], log];
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/web/history.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
    
     }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         [SVProgressHUD dismiss];
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Logging History"
                                                      message:[NSString stringWithFormat:@"%@",error]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [av show];
     }];
    [operation start];
}

- (void) getAllStockValue:(NSNumber *) accountID
{
    
    NSString *query = [[NSString alloc]initWithFormat:@"Select * from stock where accountID=%i;", [accountID intValue]];
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/web/account.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         DBHelper *helper = [[DBHelper alloc]init];
         NSDictionary * firstParse = (NSDictionary *)JSON;
         NSArray * listStocks = [firstParse objectForKey:@"Results"];
         
         NSMutableArray * stockValue = [[NSMutableArray alloc]initWithCapacity:[listStocks count]];
         
         NSDictionary * stockInfo;
         NSNumber *totalValue = [[NSNumber alloc]initWithDouble:0.0f];
         NSNumber *totalShares = [[NSNumber alloc]initWithInt:0];
         
         
         NSNumber *listPrice;
         NSNumber *shares;
         NSNumber *value;
         NSString *change;
         
         for (int i = 0; i < [listStocks count]; i++)
         {

             //Query yahoo's DB for stock info

             stockInfo = [helper fetchYahooData:[[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"]];
           
             if([stockInfo valueForKey:@"LastTradePriceOnly"] != [NSNull null])
             {
                 listPrice = [[NSNumber alloc]initWithFloat:[[stockInfo valueForKey:@"LastTradePriceOnly"] floatValue]];
             }
             else
             {
                 listPrice = [[NSNumber alloc]initWithFloat:0.0];
             }
             
             if(([[listStocks objectAtIndex:i] valueForKey:@"SHARES"] != [NSNull null]) &&
                ([[[listStocks objectAtIndex:i] valueForKey:@"SHARES"] intValue] > 0))
             {
                 shares = [[NSNumber alloc] initWithInt:[[[listStocks objectAtIndex:i ]valueForKey:@"SHARES"] intValue]];
                 
             }
             else
             {
                 shares = [[NSNumber alloc]initWithInt:0];
             }
             
             
            value = [[NSNumber alloc]initWithDouble:([listPrice doubleValue] * [shares intValue])];
             
             
             NSMutableDictionary * temp = [[NSMutableDictionary alloc] initWithCapacity:5];
             if([stockInfo valueForKey:@"Change"] != [NSNull null])
             {
                 change = [stockInfo valueForKey:@"Change"];
             }
             else
             {
                 change= @"N/A";
             }
             [temp setObject:change forKey:@"Change"];
             
             if([[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"] != [NSNull null])
             {
                 [temp setObject:[[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"] forKey:@"SYMBOL"];
             }
             else
             {
                 [temp setObject:@"N/A" forKey:@"SYMBOL"];
             }
             [temp setObject:value forKey:@"value"];
             [temp setObject:shares forKey:@"SHARES"];
             
             NSString *summary = [[NSString alloc] initWithFormat:@"%@ Change, %i Owned, $%0.2f Value",
                                  [stockInfo valueForKey:@"Change"],
                                  [shares intValue],
                                  [value doubleValue]];
             [temp setObject:summary forKey:@"summary"];
             
             [stockValue addObject:temp];
             
             
             totalValue = [[NSNumber alloc]initWithDouble:([totalValue doubleValue] + [value doubleValue])];
             totalShares = [[NSNumber alloc]initWithDouble:([totalShares intValue] + [shares intValue])];
             
         }

         // return [[NSArray alloc]initWithArray:stockValue];
         if([self.delegate respondsToSelector:@selector(DBHTTPClient:didUpdateWithAllStockValue:withTotalValue:withTotalShares:)])
             [self.delegate DBHTTPClient:self didUpdateWithAllStockValue:[[NSArray alloc]initWithArray:stockValue] withTotalValue:totalValue withTotalShares:totalShares];
     }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         [SVProgressHUD dismiss];
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Accessing Account/Stock DB"
                                                      message:[NSString stringWithFormat:@"%@",error]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [av show];
     }];
    [operation start];
}


-(void) addFavoriteStock:(NSNumber *) accountID stockSymbol:(NSString *)symbol
{
    
    
    NSString *query = [[NSString alloc]initWithFormat:@"Select * from stock where accountID=%i;", [accountID intValue]];
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/web/account.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         NSDictionary * firstParse = (NSDictionary *)JSON;
         NSArray * listOfStocks = [firstParse objectForKey:@"Results"];
         
         NSString *secondQuery; // = [[NSString alloc]initWithFormat:@"Select * from account where accountID=%i", [accountID intValue]];
         NSString *secondUrl; // = [[NSString alloc]initWithFormat:@"http://localhost:8080/web/account.jsp?query=%@", query];
         
         if([listOfStocks count] == 0) // Just insert stock
         {
             secondQuery = [[NSString alloc] initWithFormat:@"INSERT INTO stock (symbol, shares, accountID) values('%@', %i, %i);", symbol, 0, [accountID intValue]];
         }
         else
         { // Check to see if stock is in favorites (watching or bought)
             NSPredicate *p = [NSPredicate predicateWithFormat:@"SYMBOL = %@", symbol];
             NSArray * matched = [listOfStocks filteredArrayUsingPredicate:p];
             if([matched count] > 0)
             { //Stock Exists
                 secondQuery = [[NSString alloc] initWithFormat:
                                @"UPDATE stock SET favorite = %i WHERE accountID = %i AND symbol = '%@';",
                                1, [accountID intValue], symbol ];
             }
             else
             { //Does not exist
                 secondQuery = [[NSString alloc] initWithFormat:@"INSERT INTO stock (symbol, shares, accountID) values('%@', %i, %i);", symbol, 0, [accountID intValue]];
             }
         }
         secondUrl = [[NSString alloc]initWithFormat:@"http://localhost:8080/web/account.jsp?query=%@", secondQuery];
         secondUrl = [secondUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

         [self addStock:secondUrl];
                  
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
         [SVProgressHUD dismiss];
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Stock Information"
                                                      message:[NSString stringWithFormat:@"%@",error]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [av show];
     }];
    [operation start];

}

-(void) addStock:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // return [[NSArray alloc]initWithArray:stockValue];
        NSDictionary * thirdParse = (NSDictionary *)JSON;
        
        if([self.delegate respondsToSelector:@selector(DBHTTPClient:didUpdateWithLAddFavoriteStocks:)])
            [self.delegate DBHTTPClient:self didUpdateWithLAddFavoriteStocks:thirdParse];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD dismiss];
        UIAlertView *av2 = [[UIAlertView alloc] initWithTitle:@"Error Adding Favorite Stock"
                                                      message:[NSString stringWithFormat:@"%@",error]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av2 show];
        
    }];
    [operation start];
  
}




@end
