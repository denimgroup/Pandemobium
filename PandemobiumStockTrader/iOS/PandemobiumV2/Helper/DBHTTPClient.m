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

NSString *const BaseURLString = @"http://localhost:8080/";

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
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/account.jsp?query=%@", query];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         NSDictionary * firstParse = (NSDictionary *)JSON;
         NSArray *secondParse = [firstParse objectForKey:@"Results"];
         NSDictionary *results = [secondParse objectAtIndex:0];
         
         if([self.delegate respondsToSelector:@selector(DBHTTPClient:didUpdateWithLogIn:)])
             [self.delegate DBHTTPClient:self didUpdateWithAccountID:[results valueForKey:@"accountID"]];
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
    
    NSString *query = [[NSString alloc]initWithFormat:@"insert into history(userID, log) values(%i, \"%@\");", [userID intValue], log];
    NSString *url = [[NSString alloc]initWithFormat:@"http://localhost:8080/history.jsp?query=%@", query];
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




@end
