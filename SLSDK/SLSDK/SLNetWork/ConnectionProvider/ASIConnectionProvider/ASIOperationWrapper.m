//
// Created by fengshuai on 13-12-4.
// Copyright (c) 2013 winchannel. All rights reserved.


#import "ASIOperationWrapper.h"
#import "ASIHTTPRequest.h"


@implementation ASIOperationWrapper

- (void)cancel
{
    [self.operation cancel];
}

@end