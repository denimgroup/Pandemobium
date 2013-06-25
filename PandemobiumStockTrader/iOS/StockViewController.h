//
//  StockViewController.h
//  Pandemobium
//
//  Created by Adrian Salazar on 6/20/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockViewController : UIViewController
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) IBOutlet UIButton *tradingButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@end
