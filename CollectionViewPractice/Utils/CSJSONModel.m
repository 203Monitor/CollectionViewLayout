//
//  CS_JSONModel.m
//  CodeSpace_iOS_Frameworks
//
//  Created by CodeSpace.
//  Copyright © CodeSpace. All rights reserved.
//

#import "CSJSONModel.h"

@implementation CSJSONModel

+ (id)objectFromJSON:(NSDictionary *)object {
    return [[self alloc] initWithDictionary:object error:nil];
}

+ (id)objectFromJSONString:(NSString *)string {
    return [[self alloc] initWithString:string error:nil];
}

+ (id)objectFromData:(NSData *)data {
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:nil];
    return [self objectFromJSON:obj];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
