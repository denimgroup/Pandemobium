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

#import <UIKit/UIKit.h>


@class BuyViewController;
@class TipViewController;
@class PreferencesViewController;
@class HistoryViewController;
@class ManageTipsViewController;

@interface RootViewController : UIViewController {
    BuyViewController * buyViewController;
    TipViewController * tipViewController;
    PreferencesViewController * prefViewController;
    HistoryViewController * historyViewController;
    ManageTipsViewController * manageTipsViewController;

}

@property (nonatomic, retain) BuyViewController * buyViewController;
@property (nonatomic, retain) TipViewController * tipViewController;
@property (nonatomic, retain) PreferencesViewController * prefViewController;
@property (nonatomic, retain) HistoryViewController * historyViewController;
@property (nonatomic, retain) ManageTipsViewController * manageTipsViewController;

-(IBAction) tradePressed:(id) sender;
-(IBAction) tipPressed:(id) sender;
-(IBAction) prefPressed:(id) sender;
-(IBAction) historyPressed:(id) sender;
-(IBAction) managePressed:(id) sender;

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url ;

@end
