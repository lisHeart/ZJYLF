//
// Created by fengshuai on 13-12-4.
// Copyright (c) 2013 winchannel. All rights reserved.


@class ASIHTTPRequest;


@interface ASIOperationWrapper : NSObject <WCNetworkOperation>
    @property(nonatomic, strong) ASIHTTPRequest *operation;
@end