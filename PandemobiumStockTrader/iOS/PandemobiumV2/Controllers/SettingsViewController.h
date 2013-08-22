//
//  SettingsViewController.h
//  Pandemobium
//
//  Created by Thomas Salazar on 6/26/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"


@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) NSString *baseURL;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)enableWalkthrough:(id)sender;
- (IBAction)aboutButton:(id)sender;
- (IBAction)revealMenu:(id)sender;
@end
