//
//  DBHTTPClient.m
//  Pandemobium
//
//  Created by Adrian Salazar on 7/16/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "DBHTTPClient.h"
#import "SVProgressHUD.h"
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
         NSDictionary * firstParse = (NSDictionary *)JSON;
         NSArray * listStocks = [firstParse objectForKey:@"Results"];
         
         NSMutableArray * stockValue = [[NSMutableArray alloc]initWithCapacity:[listStocks count]];
         
         NSDictionary * stockInfo;
         NSNumber *totalValue = [[NSNumber alloc]initWithDouble:0.0f];
         NSNumber *totalShares = [[NSNumber alloc]initWithInt:0];
         
         for (int i = 0; i < [listStocks count]; i++)
         {

             //Query yahoo's DB for stock info
             NSString *yahooURL = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", [[listStocks objectAtIndex:i] valueForKey:@"SYMBOL"]];
                                   
             
             NSError *error;
             NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:yahooURL]];
             
             NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
             NSDictionary *query = [jsonData objectForKey:@"query"];
             NSDictionary *results = [query objectForKey:@"results"];
             stockInfo =  [results objectForKey:@"quote"];
             //End Yahoo's query. For improvements make this run in the background.
             
                          
             NSNumber * listPrice = [[NSNumber alloc]initWithFloat:[[stockInfo valueForKey:@"LastTradePriceOnly"] floatValue]];
             NSNumber * shares = [[NSNumber alloc] initWithInt:[[[listStocks objectAtIndex:i ]valueForKey:@"SHARES"] intValue]];
             NSNumber * value = [[NSNumber alloc]initWithDouble:([listPrice doubleValue] * [shares intValue])];
             
             
             NSMutableDictionary * temp = [[NSMutableDictionary alloc] initWithCapacity:5];
             [temp setObject:[stockInfo valueForKey:@"Change"] forKey:@"Change"];
             [temp setObject:[[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"] forKey:@"SYMBOL"];
             [temp setObject:value forKey:@"value"];
             [temp setObject:[[listStocks objectAtIndex:i]valueForKey:@"SHARES"] forKey:@"SHARES"];
             
             NSString *summary = [[NSString alloc] initWithFormat:@"%@ Change, %i Owned, $%0.2f Value",
                                  [stockInfo valueForKey:@"Change"],
                                  [[[listStocks objectAtIndex:i] valueForKey:@"SHARES"]intValue],
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
