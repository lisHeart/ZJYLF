//
//  IObjcJsonBase.h
//  SLSDK
//
//  Created by songlei on 15/5/15.
//  Copyright (c) 2015年 songlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IObjcJsonBase : NSObject

@property(nonatomic, strong) id attachedFile;//NSData or NSString

- (NSDictionary *)propertyMappingObjcJson;
- (NSDictionary *)classNameForItemInArray;
// return nil array to use all the properties for json
- (NSArray *)propertiesNeedToJson;

//Override 请将需要忽略的字段添加到 propertiesToOmit
- (void)omitPropertiesNeedToJson:(NSMutableArray *)propertiesToOmit;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSMutableDictionary *)generateJsonDict;
-(NSString *)generateJsonStringForProperties;
@end
