//
//  CS_JSONModel.h
//  CodeSpace_iOS_Frameworks
//
//  Created by CodeSpace.
//  Copyright © CodeSpace. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CSJSONModel : JSONModel

+ (id)objectFromJSON:(NSDictionary *)object;

+ (id)objectFromJSONString:(NSString *)string;

+ (id)objectFromData:(NSData *)data;

+ (BOOL)propertyIsOptional:(NSString*)propertyName;

@end
