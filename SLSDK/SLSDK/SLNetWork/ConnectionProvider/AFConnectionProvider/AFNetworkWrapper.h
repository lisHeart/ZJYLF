//
// Created by fengshuai on 13-12-13.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>

@protocol WCNetworkOperation;
@interface AFNetworkWrapper : NSObject <WCNetworkOperation>

@property(nonatomic, strong) NSURLSessionDataTask *dataTask;
@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic, copy) NSString *downloadTempPath;

@end
