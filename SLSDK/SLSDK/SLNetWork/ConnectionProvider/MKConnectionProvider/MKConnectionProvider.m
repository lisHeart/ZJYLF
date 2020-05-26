//
// Created by fengshuai on 13-12-4.
// Copyright (c) 2013 winchannel. All rights reserved.


#import "MKConnectionProvider.h"
#import "MKNetworkEngine.h"
#import "MKOperationWrapper.h"
#import "MKBreakpointDownloader.h"

@interface MKConnectionProvider ()
@property(nonatomic, strong) MKNetworkEngine *engine;
@end

@implementation MKConnectionProvider

- (id)init
{
    self = [super init];
    if (self)
    {
        self.engine= [[MKNetworkEngine alloc] init];
    }

    return self;
}


- (id <WCNetworkOperation>)createGetRequest:(NSString *)url
                            progressBlock:(void (^)(float progress))progressBlock
                             successBlock:(void (^)(NSData *responseData))completeBlock
                              failedBlock:(void (^)(NSError *error))failedBlock
                              cancelBlock:(void(^)())cancelBlock
        timeout:(NSUInteger)timeout
{
    MKNetworkOperation *mkNetworkOperation= [self.engine operationWithURLString:url params:nil httpMethod:@"GET"];
    if (timeout>0)
        [mkNetworkOperation setTimeout:timeout];
    [mkNetworkOperation addCompletionHandler:^(MKNetworkOperation* completedOperation){
        if(completeBlock)
            completeBlock([completedOperation responseData]);
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        if(failedBlock)
            failedBlock(error);
    }];
    if (progressBlock)
        [mkNetworkOperation onDownloadProgressChanged:progressBlock];
    if (cancelBlock)
        [mkNetworkOperation addCancelHandler:cancelBlock];

    MKOperationWrapper *operationWrapper= [[MKOperationWrapper alloc] init];
    operationWrapper.operation=mkNetworkOperation;

    [self.engine enqueueOperation:mkNetworkOperation];
    return operationWrapper;
}

- (id <WCNetworkOperation>)createDownloadRequest:(NSString *)url
                                    targetPath:(NSString *)targetPath
                                 progressBlock:(void (^)(float progress))progressBlock
                                  successBlock:(void (^)(NSData *responseData))completeBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock
                                    cancelBlock:(void(^)())cancelBlock taskIdentifier:(NSString *)identifier
{
    MKBreakpointDownloader *mkNetworkOperation= [MKBreakpointDownloader operationWithURLString:url
                                                                                        params:nil
                                                                                    httpMethod:@"GET"
                                                                                  tempFilePath:[targetPath stringByAppendingString:@"download.tmp"]
                                                                              downloadFilePath:targetPath
                                                                                   rewriteFile:NO];
    [mkNetworkOperation addCompletionHandler:^(MKNetworkOperation* completedOperation){
        if(completeBlock)
            completeBlock([completedOperation responseData]);
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        if(failedBlock)
            failedBlock(error);
    }];
    if (progressBlock)
        [mkNetworkOperation onDownloadProgressChanged:progressBlock];
    if (cancelBlock)
        [mkNetworkOperation addCancelHandler:cancelBlock];
    MKOperationWrapper *operationWrapper= [[MKOperationWrapper alloc] init];
    operationWrapper.operation=mkNetworkOperation;
    [self.engine enqueueOperation:mkNetworkOperation];
    return operationWrapper;
}

- (id <WCNetworkOperation>)createPostRequest:(NSString *)url
                                  fileData:(NSData *)fileData
                                  fileName:(NSString *)fileName
                               contentType:(NSString *)contentType
                             progressBlock:(void (^)(float progress))progressBlock
                              successBlock:(void (^)(NSData *responseData))completeBlock
                               failedBlock:(void (^)(NSError *error))failedBlock
                               cancelBlock:(void(^)())cancelBlock
                                    forKey:(NSString *)key
{
    MKNetworkOperation *mkNetworkOperation = [self.engine operationWithURLString:url params:nil httpMethod:@"POST"];

    [mkNetworkOperation addData:fileData forKey:key mimeType:contentType fileName:fileName];

    [mkNetworkOperation addCompletionHandler:^(MKNetworkOperation* completedOperation){
        if(completeBlock)
            completeBlock([completedOperation responseData]);
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        if(failedBlock)
            failedBlock(error);
    }];
    if (progressBlock)
        [mkNetworkOperation onUploadProgressChanged:progressBlock];
    if (cancelBlock)
        [mkNetworkOperation addCancelHandler:cancelBlock];
    MKOperationWrapper *operationWrapper= [[MKOperationWrapper alloc] init];
    operationWrapper.operation=mkNetworkOperation;
    [self.engine enqueueOperation:mkNetworkOperation];
    return operationWrapper;
}

@end