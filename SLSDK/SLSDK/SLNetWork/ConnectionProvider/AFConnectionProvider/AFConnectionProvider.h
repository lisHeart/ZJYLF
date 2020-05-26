//
// Created by fengshuai on 13-12-13.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>


@interface AFConnectionProvider : NSObject<WCNetworkOperationProvider>

-(id)initWithBackTransferDelegate:(id<WCBackTransferTerminationReportDelegate>)delegate;

@end
