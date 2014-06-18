//
//  BNRItemStore.m
//  Homepwnr
//
//  Created by Igors.Sivickis on 5/27/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore()
@property (nonatomic)NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+(instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    if (!sharedStore){
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use+[BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

-(void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore]deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex){
        return;
    }
    BNRItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self){
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc]init];
        }
    }
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(BNRItem *)createItem
{
//    BNRItem *item = [BNRItem randomItem];
    BNRItem *item = [[BNRItem alloc]init];
    [self.privateItems addObject:item];
    return item;
}

@end
