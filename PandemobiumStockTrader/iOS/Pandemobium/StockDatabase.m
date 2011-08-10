//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with 
// vulnerabilities included for security testing purposes.
// Copyright (c) 2011 Denim Group, Ltd. All rights reserved worldwide.
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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader.  If not, see
// <http://www.gnu.org/licenses/>.
//

#import "StockDatabase.h"


@implementation StockDatabase

-(sqlite3 *) openDatabase 
{
    NSString * docsDir;
    NSArray * dirPaths;
    NSString * databasePath;
    char * errMsg;
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"stocks.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &stockDB) == SQLITE_OK)
    {
        const char * sql_stmt = "CREATE TABLE IF NOT EXISTS trade (id INTEGER PRIMARY KEY AUTOINCREMENT, trade_time INT, trade_type TEXT, symbol TEXT, shares INTEGER, price REAL)";
        const char * sql_stmt2 = "CREATE TABLE IF NOT EXISTS tip (id INTEGER PRIMARY KEY AUTOINCREMENT, tip_creator TEXT, symbol TEXT, current_price REAL, target_price REAL, reason TEXT)";
        
        sqlite3_exec(stockDB, sql_stmt, NULL, NULL, &errMsg);
        sqlite3_exec(stockDB, sql_stmt2, NULL, NULL, &errMsg);
        
    }
    
    return stockDB;
    
}


@end
