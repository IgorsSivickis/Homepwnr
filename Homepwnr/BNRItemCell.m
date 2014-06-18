//
//  BNRItemCell.m
//  Homepwnr
//
//  Created by Igors.Sivickis on 6/18/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
