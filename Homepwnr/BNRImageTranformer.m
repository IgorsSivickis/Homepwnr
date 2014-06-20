//
//  BNRImageTranformer.m
//  Homepwnr
//
//  Created by Igors.Sivickis on 6/20/14.
//  Copyright (c) 2014 Accenture. All rights reserved.
//

#import "BNRImageTranformer.h"

@implementation BNRImageTranformer

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
