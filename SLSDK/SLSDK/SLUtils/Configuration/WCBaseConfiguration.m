//
//  WCConfiguration.m
//  winCRM
//
//  Created by Cai Lei on 5/23/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#define kMacAddressFromBox @"MacAddressFromBox"

#import "WCBaseConfiguration.h"

@implementation WCBaseConfiguration
{
    NSString *_macFromBox;
}

- (NSString *)rootNodeName
{
    return [@"root_" stringByAppendingString:self.group_name];
}

- (NSString *)version {
    NSString *verNum = self.versionNumber;
    NSString *buildNum = self.buildNumber;
    NSString *version = [NSString stringWithFormat:@"%@.%@",verNum,buildNum];
    return version;
}


- (NSString *)macFromBox
{
    if ([_macFromBox length]==0)
        _macFromBox= [[NSUserDefaults standardUserDefaults] objectForKey:kMacAddressFromBox];
    return _macFromBox;
}

- (void)setMacFromBox:(NSString *)macFromBox
{
    _macFromBox = [macFromBox copy];
    if ([macFromBox length])
    {
        [[NSUserDefaults standardUserDefaults] setObject:macFromBox forKey:kMacAddressFromBox];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
