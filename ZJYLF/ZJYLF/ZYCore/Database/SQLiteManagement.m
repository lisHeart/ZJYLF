//
//  SQLiteManagement.m
//  BlueMobiProject
//
//  Created by Stone on 15/9/15.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import "SQLiteManagement.h"

static SQLiteManagement *g_SQLiteInstance = nil;

@implementation SQLiteManagement

+ (SQLiteManagement *)instance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        g_SQLiteInstance = [[self alloc] init];
    });
    
    return g_SQLiteInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *path = ConfigPath(@"db.sqlite");
        TPLLOG (@"%@", path);
        if (!ExistAtPath(path))
        {
            NSString *contentFile = ResourcePath(@"db.sqlite");
            NSData *data = [NSData dataWithContentsOfFile:contentFile];
            SaveFile(path, data);
        }
    }
    
    return self;
}
@end
