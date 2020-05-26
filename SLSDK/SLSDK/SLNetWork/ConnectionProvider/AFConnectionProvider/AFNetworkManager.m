//
//  AFNetworkManager.m
//  AppFramework
//
//  Created by liubin on 13-1-10.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#import "AFNetworkManager.h"
#import "AFHttpOperation.h"
#import "AFHttpEngine.h"


@interface AFNetworkManager ()

@property (nonatomic, retain) NSMutableArray *notifications;
@property (nonatomic, retain) NSMutableArray *engines;
@property (nonatomic, retain) NSOperationQueue *operationsQueue;
@property (nonatomic, retain) Reachability *cellReach;
@property (nonatomic, retain) Reachability *wifiReach;

@end

@implementation AFNetworkManager

@synthesize allFlowSize = _allFlowSize;
@synthesize notifications = _notifications;
@synthesize engines = _engines;
@synthesize operationsQueue = _operationsQueue;
@synthesize cellReach = _cellReach;
@synthesize wifiReach = _wifiReach;

- (id)init
{
    self = [super init];
    if (self)
    {
        _allFlowSize = 0;

        NSMutableArray *notifications = [[NSMutableArray alloc] init];
        self.notifications = notifications;

        NSMutableArray *engines = [[NSMutableArray alloc] initWithCapacity:10];
        self.engines = engines;

        NSOperationQueue *operationsQueue = [[NSOperationQueue alloc] init];
        // There are only 3 operations running at the same time (normal, upload and download).
        [operationsQueue setMaxConcurrentOperationCount:3];
        self.operationsQueue = operationsQueue;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        self.cellReach = [Reachability reachabilityForInternetConnection];
        [self.cellReach startNotifier];
        self.wifiReach = [Reachability reachabilityForLocalWiFi];
        [self.wifiReach startNotifier];
    }

    return self;
}

+ (AFNetworkManager *)sharedInstance
{
    static AFNetworkManager *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_operationsQueue cancelAllOperations];
}

#pragma mark AFHttpManager methods
- (void)registerReachabilityNotification:(id<AFNetworkManagerDelegate>)observer
{
    @synchronized(self.notifications)
    {
        if (![self.notifications containsObject:observer])
        {
            [self.notifications addObject:observer];
        }
    }
}

- (void)removeReachabilityNotification:(id<AFNetworkManagerDelegate>)observer
{
    @synchronized(self.notifications)
    {
        if ([self.notifications containsObject:observer])
        {
            [self.notifications removeObject:observer];
        }
    }
}

- (void)addHttpEngineObserver:(AFHttpEngine *)engine
{
    if (!engine) return;

    @synchronized(self.engines)
    {
        if (![self.engines containsObject:engine])
        {
            [self.engines addObject:engine];
        }
    }
}

- (void)removeHttpEngineObserver:(AFHttpEngine *)engine flowSize:(size_t)size
{
    _allFlowSize += size;

    if (!engine) return;

    @synchronized(self.engines)
    {
        if ([self.engines containsObject:engine])
        {
            [[engine retain] autorelease];
            [self.engines removeObject:engine];
        }
    }
}

- (NetworkStatus)reachabilityStatus
{
    NetworkStatus status = NotReachable;
    if ([self.cellReach currentReachabilityStatus] == ReachableViaWWAN)
    {
        status = ReachableViaWWAN;
    }
    if ([self.wifiReach currentReachabilityStatus] == ReachableViaWiFi)
    {
        status = ReachableViaWiFi;
    }
    return status;
}

- (void)addHttpOperation:(AFHttpOperation *)operation
{
    @synchronized(self.operationsQueue)
    {
        // Only one kind of operation is running at the same time.
        NSArray *queue = [self.operationsQueue operations];
        int count = [queue count];
        for (int i = count - 1; i >= 0; i--)
        {
            AFHttpOperation *one = [queue objectAtIndex:i];
            if (one.type == operation.type)
            {
                [operation addDependency:one];
                break;
            }
        }
        
        [self.operationsQueue addOperation:operation];
    }
}

- (void)cancelAll
{
    @synchronized(self.operationsQueue)
    {
        [self.operationsQueue cancelAllOperations];
    }
    @synchronized(self.engines)
    {
        [self.engines removeAllObjects];
    }
}

#pragma mark Reachability callback methods
-(void)reachabilityChanged:(NSNotification *)notification
{
    NetworkStatus status = [self reachabilityStatus];
    @synchronized(self.notifications)
    {
        for (id<AFNetworkManagerDelegate> observer in self.notifications)
        {
            if ([observer respondsToSelector:@selector(reachabilityChanged:)])
            {
                [observer reachabilityChanged:status];
            }
        }
    }
}

@end
