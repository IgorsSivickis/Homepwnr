//
//  BNRItemStore.h
//  Homepwnr
//
//  Created by Igors.Sivickis on 5/27/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+(instancetype)sharedStore;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
-(BOOL)saveChanges;


@end
