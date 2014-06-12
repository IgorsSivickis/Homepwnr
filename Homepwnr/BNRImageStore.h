//
//  BNRImageStore.h
//  Homepwnr
//
//  Created by Igors.Sivickis on 6/12/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject

+(instancetype)sharedStore;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;

@end
