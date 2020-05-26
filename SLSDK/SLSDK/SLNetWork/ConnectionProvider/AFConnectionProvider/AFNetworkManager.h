//
//  AFNetworkManager.h
//  AppFramework
//
//  Created by liubin on 13-1-10.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AFHttpMacros.h"

@class AFHttpEngine;
@class AFHttpOperation;

@protocol AFNetworkManagerDelegate <NSObject>

- (void)reachabilityChanged:(NetworkStatus)status;

@end

@interface AFNetworkManager : NSObject
{
    unsigned long long _allFlowSize;
}

@property (nonatomic, readonly) unsigned long long allFlowSize;

// methods

+ (AFNetworkManager *)sharedInstance;

- (void)registerReachabilityNotification:(id<AFNetworkManagerDelegate>)observer;
- (void)removeReachabilityNotification:(id<AFNetworkManagerDelegate>)observer;
- (void)addHttpEngineObserver:(AFHttpEngine *)engine;
- (void)removeHttpEngineObserver:(AFHttpEngine *)engine flowSize:(size_t)size;
- (NetworkStatus)reachabilityStatus;
- (void)addHttpOperation:(AFHttpOperation *)operation;
- (void)cancelAll;

@end
