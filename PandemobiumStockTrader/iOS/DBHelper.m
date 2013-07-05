//
//  DBHelper.m
//  Pandemobium
//
//  Created by Adrian Salazar on 7/5/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper


-(NSNumber *) getAccountID:(NSNumber *) userID
{
 
    NSError *error;
    NSString *query = [[NSString alloc]initWithFormat:@"Select accountID from account where userID=%i", [userID intValue]];
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/account.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * firstParse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *secondParse = [firstParse objectForKey:@"Results"];
    NSDictionary *results = [secondParse objectAtIndex:0];
    
    return [results valueForKey:@"accountID"];
}

-(NSDictionary *) logIn:(NSString *)username forPassword:(NSString *)password;
{
    NSError *error;
    NSLog(@"made it here");
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/user.jsp?method=logIn&username=%@&password=%@", username, password];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * firstParse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *secondParse = [firstParse objectForKey:@"Results"];
    return [secondParse objectAtIndex:0];

}

-(NSArray *) getFavoriteStocks:(NSNumber *)accountID
{
    NSError *error;
 //   NSString *query = [[NSString alloc]initWithFormat:@"Select symbol from stock where favorite=1 AND accountID=%i;", [accountID intValue]];
    NSString *query = [[NSString alloc]initWithFormat:@"Select symbol from stock where favorite=1 AND accountID=1;"];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/account.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary * firstParse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    return [firstParse objectForKey:@"Results"];
    
}


@end
