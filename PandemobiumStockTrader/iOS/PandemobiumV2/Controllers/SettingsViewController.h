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

@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)enableWalkthrough:(id)sender;
- (IBAction)aboutButton:(id)sender;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)revealMenu:(id)sender;
@end
