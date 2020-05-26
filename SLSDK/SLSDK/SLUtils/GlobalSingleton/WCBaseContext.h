//
// Created by fengshuai on 13-12-3.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>

@protocol WCNetworkOperationProvider;

/*
@class WCNaviServiceItemsManager;
@class WCSyncManager;
@class WCPolicyManager;
@class WCLogRecordHelper;
@class WCDownloaderManager;
@class WCMultimediaCenter;
@class WCLocationManager;
@class WCUserHelper;
@class WCTreeNodeHelper;
*/

@class WCBaseConfiguration;

typedef enum
{
    EASINetworkProvider,
    EMKNetworkProvider,
    EAFNetworkProvider
}ENetworkProviderType;


@interface WCBaseContext : NSObject
+ (WCBaseContext *)sharedInstance;
@property (nonatomic, strong) WCBaseConfiguration *configuration;

/*
@property (nonatomic, strong) WCNaviServiceItemsManager *naviServiceManager;
@property (nonatomic, strong) WCSyncManager *syncManager;
@property (nonatomic, strong) WCPolicyManager *policyManager;
@property (nonatomic, strong) WCLocationManager *locationManager;
@property (nonatomic, strong) WCDownloaderManager *downloaderManager;
@property (nonatomic, strong) WCUserHelper *userHelper;
@property (nonatomic, strong) WCTreeNodeHelper *treeNodeHelper;
@property (nonatomic, strong) WCMultimediaCenter *multimediaCenter;
*/

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong, setter=setDeviceToken:, getter=getDeviceToken) NSString *deviceToken;
//@property (nonatomic, strong) WCLogRecordHelper *logHelper;
@property (nonatomic, strong) NSMutableDictionary *deviceManagementData;
@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)();

@property(nonatomic, strong, readonly) id <WCNetworkOperationProvider> connectionProvider;

+ (double)randomDoubleStart:(double)a end:(double)b;

+ (NSString *)appVersion;

-(NSString *) cacheRootFolder;
-(NSString *) resourceFolder;
-(NSString *) multimediaFolder;
-(NSString *) webPageFolder;
-(NSString *) downloadFolder;
-(NSString *) logFolder;

- (NSString *)databasePath;

#pragma mark Startup

//-(void)startup;

//-(void)startupWithConfiguration:(WCBaseConfiguration *)configuration andDatabaseStorePath:(NSString *)dataBasePath;

-(void)startupWithConfiguration:(WCBaseConfiguration *)configuration;

//-(void)startupWithConnectionProvider:(id<WCNetworkOperationProvider>)provider andConfiguration:(WCBaseConfiguration *)configuration;
//
//-(void)startupWithCacheRootPath:(NSString *)cacheRootPath andConfiguration:(WCBaseConfiguration *)configuration;
//
//-(void)startupWithConnectionProviderType:(ENetworkProviderType)providerType
//                        andCacheRootPath:(NSString *)cacheRootPath
//                        andConfiguration:(WCBaseConfiguration *)configuration;
//
//-(void)startupWithConnectionProvider:(id<WCNetworkOperationProvider>)provider
//                    andCacheRootPath:(NSString *)cacheRootPath
//                    andConfiguration:(WCBaseConfiguration *)configuration
//                    andDatabaseStorePath:(NSString *)dataBasePath;
//
//
//#pragma mark synchornizeContactInfo
//
//-(void)synchornizeContactInfo;
//
@end