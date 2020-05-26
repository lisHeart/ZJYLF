//
// Created by fengshuai on 13-12-13.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <sys/proc.h>
#import "AFConnectionProvider.h"
#import "AFNetworkWrapper.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager+Download.h"

#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#define kDownloadTimeOut (60)
#define DESKEY @"d94e2c302409fe87ccf3dd0f32f5134a" 

@interface AFConnectionProvider()
@property(nonatomic, strong) NSMutableDictionary *resumeDataCache;
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, copy) NSString *downloadSessionIdntifier;
@property(nonatomic, weak) id<WCBackTransferTerminationReportDelegate> delegate;
@end

@implementation AFConnectionProvider

- (id)initWithBackTransferDelegate:(id <WCBackTransferTerminationReportDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        if ([UIDevice getCurrentSystemVersionNumber] >= 7)
        {
            self.delegate = delegate;
            self.resumeDataCache = [NSMutableDictionary dictionary];
            self.downloadSessionIdntifier = [NSString stringWithFormat:@"%@.downloadSession",[[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString *)kCFBundleNameKey]];
            self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:[WCBaseContext sharedInstance].configuration.naviURL]];
 
            __weak typeof(self) wself = self;
            [self.sessionManager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
                if ([WCBaseContext sharedInstance].backgroundSessionCompletionHandler)
                {
                    void (^completionHandler)() = [WCBaseContext sharedInstance].backgroundSessionCompletionHandler;
                    [WCBaseContext sharedInstance].backgroundSessionCompletionHandler = nil;
                    completionHandler();
                }
            }];

            [self.sessionManager setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
                if ([wself.delegate respondsToSelector:@selector(provideFileURLForCompleteTask:)])
                {
                    NSString *path= [wself.delegate provideFileURLForCompleteTask:downloadTask];
                    if ([path length])
                        return [NSURL fileURLWithPath:path];
                }
                return nil;
            }];

            [self.sessionManager setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
                if ([wself.delegate respondsToSelector:@selector(reportTaskStatus:error:)])
                    [wself.delegate reportTaskStatus:task error:error];
            }];

            [self performSelector:@selector(reportFinish) withObject:nil afterDelay:2];
        }
    }

    return self;
}

-(void)reportFinish
{
    if ([self.delegate respondsToSelector:@selector(reportCheckFinished)])
    {
        [self.delegate reportCheckFinished];
    }
}

- (id <WCNetworkOperation>)createGetRequest:(NSString *)url
                            progressBlock:(void (^)(float progress))progressBlock
                             successBlock:(void (^)(NSData *responseData))completeBlock
                              failedBlock:(void (^)(NSError *error))failedBlock
                              cancelBlock:(void (^)())cancelBlock timeout:(NSUInteger)timeout
{
    if (!self.sessionManager)
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:[WCBaseContext sharedInstance].configuration.naviURL]];
//    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//    if ([url rangeOfString:@"/common/commapi/com.region.tree"].location != NSNotFound) {
//        [self.sessionManager.requestSerializer setValue:@"bb5a74bad72b4507a83b45df17758be8" forHTTPHeaderField:@"Authorization"];
//    }
//    else if([url rangeOfString:@"passportapi"].location != NSNotFound ||
//            [url rangeOfString:@"uploadpicture"].location != NSNotFound
//            ){//url 中包含 passportapi 为用户相关接口 使用 bb5a74bad72b4507a83b45df17758be8
//        [self.sessionManager.requestSerializer setValue:@"bb5a74bad72b4507a83b45df17758be8" forHTTPHeaderField:@"Authorization"];
//    }
//    else{
//        [self.sessionManager.requestSerializer setValue:@"1b75c03cacd5418f9759f1e431c91a28" forHTTPHeaderField:@"Authorization"];
//    }
    
    //传递时间戳
    NSTimeInterval time     = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp     = [NSString stringWithFormat:@"%.0f", time];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *version;
    //根据url判断是否是线上/测试环境版本
    if ([[WCBaseContext sharedInstance].configuration.naviURL isEqualToString:@"http://test9.525j.com.cn"]) {
        version             = [prefs valueForKey:@"WJ_Build_Number"];
    }else{
        version             = [prefs valueForKey:@"WJ_Version_Number"];
    }
    
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                if (completeBlock) {
                                                        completeBlock(responseObject);
                                                }
                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            if (failedBlock) {
                                                    failedBlock(error);
                                            }
                                    }];
    
    AFNetworkWrapper *wrapper = [[AFNetworkWrapper alloc] init];
    wrapper.dataTask = dataTask;

    return wrapper;
}

/*
- (id <WCNetworkOperation>)createDownloadRequest:(NSString *)url
                                                targetPath:(NSString *)targetPath
                                             progressBlock:(void (^)(float progress))progressBlock
                                              successBlock:(void (^)(NSData *responseData))completeBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock
                                               cancelBlock:(void (^)())cancelBlock
                                            taskIdentifier:(NSString *)identifier
{
    AFNetworkWrapper *afNetworkWrapper= [[AFNetworkWrapper alloc] init];
    if ([WCBaseContext sharedInstance].configuration.supportBackgroundTransfer&& [identifier length]>0)
    {
        //利用URLSession以支持后台下载

        afNetworkWrapper.downloadTempPath= [targetPath stringByAppendingString:kTempDownloadSuffix];

        NSData *resumeData= [self.resumeDataCache objectForKey:identifier];
        if (!resumeData)//缓存里没有，从文件系统读取
        {
            if ([NSFileManager FileExist:afNetworkWrapper.downloadTempPath])
                resumeData= [NSData dataWithContentsOfFile:afNetworkWrapper.downloadTempPath];
        }
        if (resumeData)//恢复下载
        {
            NSURLSessionDownloadTask *task= [self.sessionManager downloadTaskWithResumeData:resumeData progressBlock:progressBlock destination:^NSURL *(NSURL *targetPath2, NSURLResponse *response)
            {
                if ([NSFileManager FileExist:targetPath])
                    [NSFileManager deleteFileByPath:targetPath];
                return [NSURL fileURLWithPath:targetPath];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
            {
                if(!error)
                {
                    if (completeBlock)
                        completeBlock(nil);
                }
                else
                {
                    if (failedBlock)
                        failedBlock(error);
                }
            }];
            afNetworkWrapper.downloadTask=task;
            [self.resumeDataCache removeObjectForKey:identifier];//移除缓存
            [task setTaskDescription:identifier];
            [task resume];
        }
        else//从头开始下载
        {
            NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kDownloadTimeOut];
            NSURLSessionDownloadTask *task= [self.sessionManager downloadTaskWithRequest:request progressBlock:progressBlock destination:^NSURL *(NSURL *targetPath2, NSURLResponse *response)
            {
                if ([NSFileManager FileExist:targetPath])
                    [NSFileManager deleteFileByPath:targetPath];
                return [NSURL fileURLWithPath:targetPath];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
            {
                if(!error)
                {
                    if (completeBlock)
                        completeBlock(nil);
                }
                else
                {
                    if (failedBlock)
                        failedBlock(error);
                }
            }];
            afNetworkWrapper.downloadTask=task;
            [task setTaskDescription:identifier];
            [task resume];
        }

        return afNetworkWrapper;
    }
    else
    {
        AFHTTPRequestOperation *requestOperation= [[AFHTTPRequestOperationManager manager] Download:url targetPath:targetPath
         success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            if (completeBlock)
                completeBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            if (failedBlock)
                failedBlock(error);
        }];
        if (progressBlock)
            [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead)
            {
                progressBlock(totalBytesRead/totalBytesExpectedToRead);
            }];

        AFNetworkWrapper *networkWrapper= [[AFNetworkWrapper alloc] init];
        networkWrapper.operation=requestOperation;
        return networkWrapper;
    }
}
*/

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
                                   timeout:(NSUInteger)timeout
{
    if (!self.sessionManager)
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:[WCBaseContext sharedInstance].configuration.naviURL]];
    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if([url rangeOfString:@"passportapi"].location != NSNotFound ||
       [url rangeOfString:@"uploadfiles"].location != NSNotFound ||
       [url rangeOfString:@"examapi"].location != NSNotFound     ||
       [url rangeOfString:@"dpapi"].location != NSNotFound) {
        //url 中包含 passportapi 为用户相关接口 使用 bb5a74bad72b4507a83b45df17758be8
        [self.sessionManager.requestSerializer setValue:@"bb5a74bad72b4507a83b45df17758be8" forHTTPHeaderField:@"Authorization"];
    }
    else {
        [self.sessionManager.requestSerializer setValue:@"1b75c03cacd5418f9759f1e431c91a28" forHTTPHeaderField:@"Authorization"];
    }
    
    if ([url containsString:@"com.appclient.analysis"]) {
        [self.sessionManager.requestSerializer setValue:@"bb5a74bad72b4507a83b45df17758be8" forHTTPHeaderField:@"Authorization"];
    }
    
    //传递时间戳
    NSTimeInterval time     = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp     = [NSString stringWithFormat:@"%.0f", time];
    NSUserDefaults *prefs   = [NSUserDefaults standardUserDefaults];
    NSString *version;
    //根据url判断是否是线上/测试环境版本
    if ([[WCBaseContext sharedInstance].configuration.naviURL isEqualToString:@"http://test9.525j.com.cn"]) {
        version             = [prefs valueForKey:@"WJ_Build_Number"];
    }else{
        version             = [prefs valueForKey:@"WJ_Version_Number"];
    }
    
    NSURLSessionDataTask *dataTask = nil;
    /*!
     * 上传单张图片
     */
    if (fileData && fileName.length > 0) {
        [self.sessionManager POST:url parameters:postParamsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:fileData name:@"image" fileName:fileName mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completeBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
        }];
    }
    
    /*!
     * 上传多张图片
     */
    if (uploadFilesDic.count > 0) {
        [self.sessionManager POST:url parameters:postParamsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSEnumerator *enumerator = [uploadFilesDic keyEnumerator];
            id paramKey = nil;
            while ((paramKey = [enumerator nextObject])) {
                NSString *fileName = [NSString stringWithFormat:@"%@",paramKey];
                NSData *imgData = [uploadFilesDic objectForKey:paramKey];
                [formData appendPartWithFileData:imgData name:@"image" fileName:fileName mimeType:@"image/png"];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completeBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
        }];
    }
    
    /*!
     * 一般的POST请求
     */
    if (postBodyDic) {
        [self.sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyDic options:NSJSONWritingPrettyPrinted error:error];
            NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog (@"postBody: %@", string);
            
            return string;
        }];
        
        dataTask = [self.sessionManager POST:url
                                  parameters:postBodyDic
                                    progress:nil
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         completeBlock(responseObject);
                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         failedBlock(error);
                                     }];
    } else if (postBodyArr) {
        [self.sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyArr options:NSJSONWritingPrettyPrinted error:error];
            NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return string;
        }];
        
        dataTask = [self.sessionManager POST:url
                                  parameters:postParamsDic
                                    progress:nil
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         completeBlock(responseObject);
                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         failedBlock(error);
                                     }];
    }
    
    AFNetworkWrapper *wrapper = [[AFNetworkWrapper alloc] init];
    wrapper.dataTask = dataTask;

    return wrapper;
}

#pragma mark - 3DES加密
-(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    NSData *data = [DESKEY dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //    NSString* encoded = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    //    char* a=[[GTMBase64 decodeData:data] bytes];
    NSData *decode = [GTMBase64 decodeData:data];
    
    
    //    Byte iv[] = [decode bytes];
    //    const void *vkey = (const void *)CFBridgingRetain([GTMBase64 decodeData:data]);
    const void *vkey = (const void *)[decode bytes];
    //    const void *vkey = (const void *)[encoded UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding]
        ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        //        NSString* decoded = [[NSString alloc] initWithData:[GTMBase64 decodeString:finalStr] encoding:NSUTF8StringEncoding];
        //        result = [[NSString alloc] initWithData:[GTMBase64 stringByEncodingData:myData] encoding:NSUTF8StringEncoding]
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

@end
