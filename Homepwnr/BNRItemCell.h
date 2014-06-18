//
//  BNRItemCell.h
//  Homepwnr
//
//  Created by Igors.Sivickis on 6/18/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;

@end
