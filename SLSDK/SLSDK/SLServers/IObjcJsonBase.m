//
//  IObjcJsonBase.m
//  SLSDK
//
//  Created by songlei on 15/5/15.
//  Copyright (c) 2015年 songlei. All rights reserved.
//

#import "IObjcJsonBase.h"
#import <objc/runtime.h>

@interface IObjcJsonBase()

@property (nonatomic, strong) NSDictionary *propertyMappingObjcJsonDict;
@property (nonatomic, strong) NSDictionary *classNameForItemInArrayDict;
@property (nonatomic, strong) NSMutableArray *propertiesNeedToJsonArray;
@end

@implementation IObjcJsonBase

- (id)init {
    return [self initWithDictionary:nil];
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        [self preparePropertiesToJson];
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

-(void)preparePropertiesToJson
{
    self.propertyMappingObjcJsonDict = [self propertyMappingObjcJson];
    self.classNameForItemInArrayDict = [self classNameForItemInArray];
    self.propertiesNeedToJsonArray = [NSMutableArray arrayWithArray:[self propertiesNeedToJson]];

    if (![self propertiesNeedToJson]) {
        self.propertiesNeedToJsonArray = [NSMutableArray arrayWithArray:[self allPropertiesOriginName]];
    }

    NSMutableArray *omitProperties = [NSMutableArray array];
    [self omitPropertiesNeedToJson:omitProperties];
    for (NSString *omitStr in omitProperties)
    {
        NSArray *copy= [self.propertiesNeedToJsonArray copy];
        uint count = (uint)([copy count]);
        for (int i=0;i< count;i++)
            if ([[copy objectAtIndex:i] isEqualToString:omitStr])
            {
                [self.propertiesNeedToJsonArray removeObject:[copy objectAtIndex:i]];
                break;
            }
    }
}

- (NSMutableDictionary *)generateJsonDict {

    [self preparePropertiesToJson];
    NSMutableDictionary *retDict = [[NSMutableDictionary alloc] init];

    for (NSString *key in self.propertiesNeedToJsonArray) {
        
        NSString *realKey = [self.propertyMappingObjcJsonDict valueForKey:key];

        if (!realKey)
            realKey = key;

        Class objectClass = [self classForKey:realKey];

        objc_property_t theProperty =
                class_getProperty([self class], [realKey UTF8String]);
        const char * thePropertyName = property_getName(theProperty);
        id v = [self valueForKey:[NSString stringWithUTF8String:thePropertyName]];
        if (!v) {
            continue;
        }

        // 1, array
        if ([objectClass isSubclassOfClass:[NSArray class]]) {
            NSMutableArray *retArray = [[NSMutableArray alloc] init];
            for (id item in v) {
                if ([item isKindOfClass:[IObjcJsonBase class]]) {
                    NSDictionary *itemJsonDict = [item generateJsonDict];
                    if (itemJsonDict)
                        [retArray addObject:itemJsonDict];
                } else {
                    [retArray addObject:item];
                }
            }
            [retDict setObject:retArray forKey:key];
        }
                // 2, IObjcJsonBase
        else if ([objectClass isSubclassOfClass:[IObjcJsonBase class]]) {
            NSDictionary *itemJsonDict = [v generateJsonDict];
            if (itemJsonDict)
                [retDict setObject:itemJsonDict forKey:key];
        }
                // 3, string, number, dictionary, etc
        else {
            if (v && key) {
                [retDict setObject:v forKey:key];
            }
        }
    }

    return retDict;
}

-(NSString *)generateJsonStringForProperties
{
    return [[self generateJsonDict] JSONString];
}

// 返回数据新名称
- (NSDictionary *)propertyMappingObjcJson {
    /*/ //<key>     : real key value in Json string
        //<value>   : property name in Objc class
    return @{@"id" : @"sessionID"
             @"items" : @"itemArray"
     };
    //*/
    return nil;
}

// 数组数据类型
- (NSDictionary *)classNameForItemInArray {
    /*/ //<key>     : property name of NSArray
        //<value>   : class name of item in NSArray
    return @{@"itemArray" : @"WCItem"};
    //*/
    return nil;
}

- (NSArray *)propertiesNeedToJson {
    /*/ // real key values (who has property mapping) that need to be generated into Json string
    return @[@"id", @"items"];
    //*/
    return nil;
}

// 不需要上传的数据
- (void)omitPropertiesNeedToJson:(NSMutableArray *)propertiesToOmit
{
    //Override me!!!
    //子类不要删除父类已有的项

    [propertiesToOmit addObject:@"attachedFile"];
}

#pragma mark - private API
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSString *realKey = [self.propertyMappingObjcJsonDict valueForKey:key];

    if (!realKey)
        realKey = key;
    // 1, array
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *arrayValue = value;

        NSString *className = [self.classNameForItemInArrayDict objectForKey:realKey];
        Class itemClass = NSClassFromString(className);
        if (itemClass) {
            NSMutableArray *retArray = [[NSMutableArray alloc] init];

            for (id arrayEntry in arrayValue)
            {
                if ([itemClass instancesRespondToSelector:@selector(initWithDictionary:)])
                {
                    id entry = [[itemClass alloc] initWithDictionary:arrayEntry];
                    [retArray addObject:entry];
                }
                else
                    [retArray addObject:arrayEntry];
            }

            [super setValue:retArray forKey:realKey];
        } else {
            [super setValue:value forKey:realKey];
        }
    }
            // 2, dictionary
    else if ([value isKindOfClass:[NSDictionary class]]) {
        Class objectClass = [self classForKey:realKey];
        BOOL bIsObject = [objectClass instancesRespondToSelector:@selector(classForKey:)];
        if (bIsObject) {
            id modelObject = [[objectClass alloc] initWithDictionary:value];
            [super setValue:modelObject forKey:realKey];
        } else {
            [super setValue:value forKey:realKey];
        }
    }
            // 3, string, number, etc ,必须是非Obj类型
    else if([self.classNameForItemInArrayDict objectForKey:realKey]==nil){
        [super setValue:value forKey:realKey];
    }
}

- (Class) classForKey:(NSString*) key
{
    Class objectClass = [self class];
    NSString * accessorKey = key;

    objc_property_t theProperty =
            class_getProperty(objectClass, [accessorKey UTF8String]);

    if(!theProperty)
        return nil;

    const char * propertyAttrs = property_getAttributes(theProperty);
    NSString *propertyString = [NSString stringWithUTF8String:propertyAttrs];


    NSString *startingString = @"T@\"";
    NSString *endingString = @"\",";

    NSInteger startingIndex = [propertyString rangeOfString:startingString].location +startingString.length;

    if (startingIndex < 0)  //非NSObject类型
        return nil;

    NSString *propType = [propertyString substringFromIndex:startingIndex];

    NSInteger endingIndex = [propType rangeOfString:endingString].location;

    propType = [propType substringToIndex:endingIndex];

    Class propClass = NSClassFromString(propType);

    return propClass;
}

- (NSArray *)allPropertiesOriginName {
    NSMutableArray *retArray = [[NSMutableArray alloc] init];

    NSMutableDictionary *propertyToRealKeyMappingDict = [[NSMutableDictionary alloc] initWithCapacity:[self.propertyMappingObjcJsonDict count]];
    NSArray *keys = [self.propertyMappingObjcJsonDict allKeys];
    for (NSString *key in keys) {
        NSString *value = [self.propertyMappingObjcJsonDict objectForKey:key];
        [propertyToRealKeyMappingDict setObject:key forKey:value];
    }

    NSMutableArray *classArray = [[NSMutableArray alloc] init];
    Class curClass = [self class];
    NSString *curClassName = NSStringFromClass(curClass);

    while (![curClassName isEqualToString:@"IObjcJsonBase"]) {
        [classArray addObject:curClass];
        curClass = [curClass superclass];
        curClassName = NSStringFromClass(curClass);
    }

    for (Class classItem in classArray) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(classItem, &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName) {
                NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
                NSString *orgKey = [propertyToRealKeyMappingDict objectForKey:propertyName];
                if (!orgKey) {
                    orgKey = propertyName;
                }
                if([orgKey isEqualToString:@"hash"]||[orgKey isEqualToString:@"superclass"]||[orgKey isEqualToString:@"description"]||[orgKey isEqualToString:@"debugDescription"])
                    continue;
                [retArray addObject:orgKey];
            }
        }
        free(properties);
    }

    return retArray;
}

+(NSDictionary *)propertiesWithEncodedTypes
{

    // DO NOT use a static variable to cache this, it will cause problem with subclasses of classes that are subclasses of SQLitePersistentObject

    // Recurse up the classes, but stop at NSObject. Each class only reports its own properties, not those inherited from its superclass
    NSMutableDictionary *theProps;

    if ([self superclass] != [NSObject class])
        theProps = (NSMutableDictionary *)[[self superclass] propertiesWithEncodedTypes];
    else
        theProps = [NSMutableDictionary dictionary];

    unsigned int outCount;


    objc_property_t *propList = class_copyPropertyList([self class], &outCount);
    int i;

    // Loop through properties and add declarations for the create
    for (i=0; i < outCount; i++)
    {
        objc_property_t * oneProp = propList + i;
        NSString *propName = [NSString stringWithUTF8String:property_getName(*oneProp)];
        NSString *attrs = [NSString stringWithUTF8String: property_getAttributes(*oneProp)];
        NSArray *attrParts = [attrs componentsSeparatedByString:@","];
        if (attrParts != nil)
        {
            if ([attrParts count] > 0)
            {
                NSString *propType = [[attrParts objectAtIndex:0] substringFromIndex:1];
                [theProps setObject:propType forKey:propName];
            }
        }
    }

    free(propList);

    return theProps;
}
@end
