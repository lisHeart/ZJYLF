//
//  WCConfiguration.m
//  winCRM
//
//  Created by Cai Lei on 5/23/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WCOnbConfiguration.h"

@implementation WCOnbConfiguration

- (BOOL)isForAppStore
{
    return [self.src_name isEqualToString:@"AppStore"];
}


@end
