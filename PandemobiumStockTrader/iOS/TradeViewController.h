//
//  TradeViewController.h
//  PandemobiumV2
//
//  Created by Thomas Salazar on 6/18/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface TradeViewController : UIViewController<UITextFieldDelegate>
- (IBAction)revealMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *shares;
@property (strong, nonatomic) IBOutlet UITextField *symbol;
@property (strong, nonatomic) IBOutlet UIButton *tradebutton;

//managing text and keybaord behavior
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
