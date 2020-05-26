//
// Created by fengshuai on 13-12-4.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"
#import "WCNetworkOperationProvider.h"

@class MKNetworkEngine;


@interface MKOperationWrapper : NSObject<WCNetworkOperation>
@property (nonatomic, strong) MKNetworkOperation *operation;
@end