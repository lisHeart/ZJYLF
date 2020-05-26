//
// Created by fengshuai on 13-12-3.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>

#define kTempDownloadSuffix @"download.tmp"

@protocol WCNetworkOperation <NSObject>

-(void)cancel;

@optional
-(void)pause;
@end

@protocol WCBackTransferTerminationReportDelegate <NSObject>
@optional
-(void)reportTaskStatus:(NSURLSessionTask *)task error:(NSError *)error;
-(NSString *)provideFileURLForCompleteTask:(NSURLSessionTask *)task;
-(void)reportCheckFinished;
@end

@protocol WCNetworkOperationProvider <NSObject>
@required
-(id<WCNetworkOperation>)createGetRequest:(NSString *)url
       progressBlock:(void(^)(float progress))progressBlock
        successBlock:(void(^)(NSData *responseData))completeBlock
         failedBlock:(void(^)(NSError *error))failedBlock
         cancelBlock:(void(^)())cancelBlock
             timeout:(NSUInteger)timeout;

-(id<WCNetworkOperation>)createPostRequest:(NSString *)url
                                  fileData:(NSData *)fileData
                               postBodyDic:(NSMutableDictionary *)postBodyDic
                               postBodyArr:(NSMutableArray *)postBodyArr
                            postParamsDic:(NSMutableDictionary *)postParamsDic
                                  fileName:(NSString *)fileName
                               contentType:(NSString *)contentType
                            uploadFilesDic:(NSMutableDictionary*)uploadFilesDic
                             progressBlock:(void(^)(float progress))progressBlock
                              successBlock:(void(^)(NSData *responseData))completeBlock
                               failedBlock:(void(^)(NSError *error))failedBlock
                               cancelBlock:(void(^)())cancelBlock
                                    forKey:(NSString *)key
                                    timeout:(NSUInteger)timeout;

@end
