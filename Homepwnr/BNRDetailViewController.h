//
//  BNRDetailViewController.h
//  Homepwnr
//
//  Created by Igors.Sivickis on 5/28/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController

-(instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;

@end
