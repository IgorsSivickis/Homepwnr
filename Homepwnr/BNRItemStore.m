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
@import CoreData;

@interface BNRItemStore()
@property (nonatomic)NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

-(void)loadAllItems
{
    if (!self.privateItems){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];

        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem"
                                             inManagedObjectContext:self.context];
        request.entity = e;

        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        request.sortDescriptors = @[sd];

        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch Failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

-(void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore]deleteImageForKey:key];

    [self.context deleteObject:item];
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

    double lowerBound = 0.0;
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)]orderingValue];
    }else{
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }

    double upperBound = 0.0;

    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    }else{
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    double newOrderValue = (lowerBound + upperBound)/2.0;

    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self){
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];

        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];

        NSError *error = nil;

        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;

        [self loadAllItems];
    }
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(BNRItem *)createItem
{
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    }else{
        order = [[self.privateItems lastObject] orderingValue]+1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count],order);

    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                                  inManagedObjectContext:self.context];
    [self.privateItems addObject:item];
    return item;
}

@end
