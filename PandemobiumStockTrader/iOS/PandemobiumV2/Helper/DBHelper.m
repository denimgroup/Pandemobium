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

#import "DBHelper.h"
#import "SVProgressHUD.h"
@implementation DBHelper



static NSString *baseURL = @"http://localhost:8080/web/";
static NSString *accountPage = @"account.jsp";
static NSString *historyPage = @"history.jsp";
static NSString *tipsPage = @"tips.jsp";
static NSString *userPage = @"user.jsp";


-(NSDictionary *) urlCall:(NSString *)query fromPage:(NSString *)page
{
    @try
    {
        NSError *error;
        NSString *url = [[NSString alloc]initWithFormat:@"%@%@?%@", baseURL, page, query];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
       
        id object = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if((!error) && ([object isKindOfClass:[NSDictionary class]]))
        {
                return object;
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to retrieve data from DB" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    @catch (NSException *e) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception Caugth"
                                                    message:[[NSString alloc]initWithFormat:@"%@", e]
                                                    delegate:nil cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [alert show];
    }
}


-(NSNumber *) getAccountID:(NSNumber *) userID
{
    NSString * query = [[NSString alloc]initWithFormat:@"Select accountID from account where userID=%i", [userID intValue]];
    NSDictionary *results = [self urlCall:query fromPage:accountPage];
    
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        NSArray *secondParse = [results objectForKey:@"Results"];
        if([[secondParse objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = [secondParse objectAtIndex:0];
            return [results valueForKey:@"accountID"];
        }
    }
    return NULL;
}

-(NSDictionary *) logIn:(NSString *)username forPassword:(NSString *)password;
{
  
    NSString *query = [[NSString alloc]initWithFormat:@"method=logIn&username=%@&password=%@", username, password];
    NSDictionary *results = [self urlCall:query fromPage:userPage];
   
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        NSArray *secondParse = [results objectForKey:@"Results"];
        if([[secondParse objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
           return [secondParse objectAtIndex:0];
            
        }
    }
    return NULL;

}

-(NSArray *) getFavoriteStocks:(NSNumber *)accountID
{

    NSString *query = [[NSString alloc]initWithFormat:
                       @"query=Select symbol from stock where favorite=1 AND accountID=%i;", [accountID intValue]];

    NSDictionary * results = [self urlCall:query fromPage:accountPage];
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        return [results objectForKey:@"Results"];
    }
    return NULL;
}

-(NSArray *) getPurchasedStocks:(NSNumber *)accountID
{
    NSString *query = [[NSString alloc]initWithFormat:@"query=Select * from stock where accountID=%i AND shares > 0;", [accountID intValue]];
    NSDictionary * results = [self urlCall:query fromPage:accountPage];

    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        return [results objectForKey:@"Results"];
    }
    return NULL;
    
}

-(NSArray *) getAllUserStocks:(NSNumber *)accountID
{
    NSString *query = [[NSString alloc]initWithFormat:@"query=Select * from stock where accountID=%i;", [accountID intValue]];
    NSDictionary * results = [self urlCall:query fromPage:accountPage];
    
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        return [results objectForKey:@"Results"];
    }
    return NULL;
}

-(NSDictionary *) getAccountInfo:(NSNumber *) accountID
{
    NSString *query = [[NSString alloc]initWithFormat:@"query=Select * from account where accountID=%i", [accountID intValue]];
    NSDictionary *results = [self urlCall:query fromPage:accountPage];
    
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        NSArray *secondParse = [results objectForKey:@"Results"];
        if([[secondParse objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            return [secondParse objectAtIndex:0];
            
        }
    }
    return NULL;
}

- (NSNumber *) getAccountValue:(NSNumber *) accountID
{
  
    NSArray * listStocks = [self getPurchasedStocks:accountID];
    NSNumber *balance = [[NSNumber alloc]initWithFloat:0.0];
    NSDictionary * stockInfo;
    
    for (int i = 0; i < [listStocks count]; i++)
    {
        stockInfo = [self fetchYahooData:[[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"]];
        NSNumber * listPrice = [[NSNumber alloc]initWithFloat:[[stockInfo valueForKey:@"LastTradePriceOnly"] floatValue]];
        NSNumber * shares = [[NSNumber alloc] initWithInt:[[[listStocks objectAtIndex:i ]valueForKey:@"SHARES"] intValue]];
        
        balance = [NSNumber numberWithDouble:([balance doubleValue] + ([listPrice doubleValue] * [shares intValue]))];
    }
    
    return balance;
    
    
}

- (NSArray *) getStockValue:(NSNumber *) accountID
{
    
    NSArray * listStocks = [self getPurchasedStocks:accountID];
    NSMutableArray * stockValue = [[NSMutableArray alloc]initWithCapacity:[listStocks count]];
    
    
    NSDictionary * stockInfo;
    
    for (int i = 0; i < [listStocks count]; i++)
    {
        stockInfo = [self fetchYahooData:[[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"]];
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
    }
    
    return [[NSArray alloc]initWithArray:stockValue];
}

- (NSArray *) getAllStockValue:(NSNumber *) accountID
{
    
    
    NSArray * listStocks = [self getAllUserStocks:accountID];
    NSMutableArray * stockValue = [[NSMutableArray alloc]initWithCapacity:[listStocks count]];
    
    
    NSDictionary * stockInfo;
    
    for (int i = 0; i < [listStocks count]; i++)
    {
        stockInfo = [self fetchYahooData:[[listStocks objectAtIndex:i]valueForKey:@"SYMBOL"]];
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
    }
    
    return [[NSArray alloc]initWithArray:stockValue];
}




-(NSDictionary *)fetchYahooData:(NSString *)symbol
{
    
    
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT%%20*%%20FROM%%20yahoo.finance.quote%%20WHERE%%20symbol%%3D%%27%@%%27&format=json&diagnostics=false&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", symbol];
    //NSLog(@"%@", url);
    NSError *error;
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * jsonData = [[NSDictionary alloc]init];
    NSDictionary * query = [[NSDictionary alloc]init];
    NSDictionary * results = [[NSDictionary alloc]init];
    NSDictionary * stockInfo = [[NSDictionary alloc]init];
    @try {
        id object = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if(error)
        {
            NSLog(@"Error parsing data");
            
        }
        if([object isKindOfClass:[NSDictionary class]])
        {
            jsonData = object;
            if([[ jsonData objectForKey:@"query" ] isKindOfClass:[NSDictionary class]])
            {
                query = [jsonData objectForKey:@"query"];
                
                if([[query objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                {
                    results = [query objectForKey:@"results"];
                    
                    if([[results objectForKey:@"quote"] isKindOfClass:[NSDictionary class]])
                    {
                        stockInfo = [results objectForKey:@"quote"]; //error
               
                        return stockInfo;
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"EXCEPTION CAUGHT : %@", [exception description]);
    }
    @finally {
        NSLog(@"Finally");
    }
    
    
}

-(NSDictionary *) buyStock:(NSNumber *)shares forSymbol:(NSString *)symbol fromAccountID:(NSNumber *)accountID
{
    NSArray * listOfStocks = [self getAllUserStocks:accountID];
    
    NSString *query;
    
    if([listOfStocks count] == 0) // Just insert stock
    {
        query = [[NSString alloc] initWithFormat:@"INSERT INTO stock (symbol, shares, accountID, favorite) values('%@', %i, %i, 1);", symbol, [shares intValue], [accountID intValue]];
            }
    else
    { // Check to see if stock is in favorites (watching or bought)
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SYMBOL = %@", symbol];
        NSArray * matched = [listOfStocks filteredArrayUsingPredicate:p];
        if([matched count] > 0)
        { //Stock Exists
            NSNumber *currentShares = [[NSNumber alloc]initWithInt:[[[matched objectAtIndex:0]objectForKey:@"SHARES"] intValue]];
            NSNumber *newShares = [[NSNumber alloc]initWithInt:([currentShares intValue] + [shares intValue])];
            query = [[NSString alloc] initWithFormat:
                     @"UPDATE stock SET shares = %i WHERE accountID = %i AND symbol = '%@';",
                     [newShares intValue], [accountID intValue], symbol ];
        }
        else
        { //Does not exist
            query = [[NSString alloc] initWithFormat:@"INSERT INTO stock (symbol, shares, accountID, favorite) values('%@', %i, %i, 1);", symbol, [shares intValue], [accountID intValue]];
        }
    }
    query=[[NSString alloc]initWithFormat:@"query=%@", query];
    return [self urlCall:query fromPage:accountPage];
    
}

-(NSDictionary *) sellStock:(NSNumber *)shares forSymbol:(NSString *)symbol fromAccountID:(NSNumber *)accountID
{
    NSDictionary * stock = [self getIndividualStock:accountID forStock:symbol];
    
    NSString *query;
    if([[stock objectForKey:@"SHARES"]intValue] >= [shares intValue])
    { //update the stock
        NSNumber * newShareTotal = [[NSNumber alloc]initWithInt:([[stock objectForKey:@"SHARES"]intValue] - [shares intValue])];
        query = [[NSString alloc]initWithFormat:@"update stock set shares=%i where accountID=%i AND symbol='%@';",
                 [newShareTotal intValue],[accountID intValue], symbol];
        
    }
    else if ([[stock objectForKey:@"SHARES"]intValue] == [shares intValue])
    {
        //delete stock
        query = [[NSString alloc] initWithFormat:@"delete from stock where symbol='%@' AND accountID=%i;", symbol, [accountID intValue]];
    }

    query=[[NSString alloc]initWithFormat:@"query=%@", query];
    return [self urlCall:query fromPage:accountPage];

    
}

-(NSDictionary *) updateAccountBalance:(NSNumber *) accountID newBalance:(NSNumber *)balance
{
    
    NSString *query = [[NSString alloc]initWithFormat:@"query=update account set balance = %.2f where accountID=%i;", [balance doubleValue], [accountID intValue]];
    return [self urlCall:query fromPage:accountPage];
    
}

-(NSNumber *) getShareTotal:(NSNumber *) accountID
{
    NSString *query = [[NSString alloc]initWithFormat:@"query=Select sum(shares) from stock where accountID=%i;", [accountID intValue]];
    NSDictionary *results = [self urlCall:query fromPage:accountPage];
    
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        NSArray *secondParse = [results objectForKey:@"Results"];
        if([[[secondParse objectAtIndex:0] objectForKey:@"SUM(SHARES" ]isKindOfClass:[NSNumber class]])
        {
             return [[secondParse objectAtIndex:0] objectForKey:@"SUM(SHARES)"];
            
        }
    }
    return NULL;
}


-(NSArray *) getHistory:(NSNumber *)userID
{
    NSString *query = [[NSString alloc]initWithFormat:@"query=Select * from history where userID=%i order by time desc;", [userID intValue]];
    NSDictionary *results = [self urlCall:query fromPage:historyPage];
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        return [results objectForKey:@"Results"];
    }
    return NULL;
}

-(NSArray *) getTips
{
    NSString *query = [[NSString alloc]initWithFormat:@"query=Select * from tips order by tipID desc;"];
    NSDictionary *results = [self urlCall:query fromPage:tipsPage];
    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        return [results objectForKey:@"Results"];
    }
    return NULL;
}

-(NSDictionary *) getIndividualStock:(NSNumber *) accountID forStock:(NSString *)symbol
{
    
    NSString *query = [[NSString alloc]initWithFormat:
                       @"query=Select * from stock where symbol='%@' AND accountID=%i;", symbol, [accountID intValue]];
    NSDictionary *results = [self urlCall:query fromPage:accountPage];

    if([[results objectForKey:@"Results"]isKindOfClass:[NSArray class]])
    {
        NSArray *secondParse = [results objectForKey:@"Results"];
        if([[secondParse objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            return [secondParse objectAtIndex:0];
            
        }
    }
    return NULL;
}


-(NSDictionary *) addFavoriteStock:(NSNumber *) accountID stockSymbol:(NSString *)symbol
{
    NSArray * listOfStocks = [self getAllUserStocks:accountID];
    NSString *query;
    
    if([listOfStocks count] == 0) // Just insert stock
    {
        query = [[NSString alloc] initWithFormat:
                 @"INSERT INTO stock (symbol, shares, accountID, favorite) values('%@', %i, %i, %i);", symbol, 0, [accountID intValue], 1];
    }
    else
    { // Check to see if stock is in favorites (watching or bought)
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SYMBOL = %@", symbol];
        NSArray * matched = [listOfStocks filteredArrayUsingPredicate:p];
        if([matched count] > 0)
        { //Stock Exists
            query = [[NSString alloc] initWithFormat:
                     @"UPDATE stock SET favorite = %i WHERE accountID = %i AND symbol = '%@';",
                     1, [accountID intValue], symbol ];
        }
        else
        { //Does not exist
            query = [[NSString alloc] initWithFormat:
                     @"INSERT INTO stock (symbol, shares, accountID, favorite) values('%@', %i, %i, %i);", symbol, 0, [accountID intValue], 1];
        }
    }
    query=[[NSString alloc]initWithFormat:@"query=%@", query];
    return [self urlCall:query fromPage:accountPage];
}

-(NSDictionary *) removeFavoriteStock:(NSNumber *) accountID stockSymbol:(NSString *)symbol
{    
    NSString *query;
    NSDictionary *stock = [self getIndividualStock:accountID forStock:symbol];
    if([[stock objectForKey:@"SHARES"]intValue] == 0)
    {
        query = [[NSString alloc] initWithFormat:
                 @"query=delete from stock where symbol='%@' AND accountID=%i;", symbol, [accountID intValue]];
        return [self urlCall:query fromPage:accountPage];
    }
    return NULL;

}


-(NSDictionary *) addHistory:(NSNumber *) userID forLog:(NSString *)log
{
    NSString *query = [[NSString alloc]initWithFormat:
                       @"query=insert into history(userID, log) values(%i, '%@');", [userID intValue], log];
    return [self urlCall:query fromPage:historyPage];
}

- (NSDictionary *) addTip:(NSNumber *)userID forSymbol:(NSString *)symbol forLog:(NSString *)log
{
    NSString *query = [[NSString alloc]initWithFormat:
                       @"query=insert into tips(userID, symbol, reason) values(%i,'%@','%@');", [userID intValue],symbol ,log];
    return [self urlCall:query fromPage:tipsPage];
}


@end
