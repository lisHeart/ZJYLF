//
// Created by fengshuai on 13-12-4.
// Copyright (c) 2013 winchannel. All rights reserved.

#import "ASIConnectionProvider.h"
#import "ASIHTTPRequest.h"
#import "ASIOperationWrapper.h"
#import "ASIFormDataRequest.h"

#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
//#import "/Users/shizhexing/525j/525JMobile/525JMobile/WJCore/WJGlobalSingleton.m"

#define DESKEY @"d94e2c302409fe87ccf3dd0f32f5134a"      //DES秘钥

#pragma mark - 自定义ASI链接供应商 延展(内部)
@interface ASIConnectionProvider ()

- (BOOL)checkIsHttpsRequest:(ASIHTTPRequest *)request; //检查是否https请求

@end

#pragma mark - 自定义ASI链接供应商
@implementation ASIConnectionProvider

#pragma mark - 检查是否https请求
- (BOOL)checkIsHttpsRequest:(ASIHTTPRequest *)request
{
    if([request.url.absoluteString hasPrefix:@"https"] == YES || [request.url.absoluteString hasPrefix:@"HTTPS"] == YES)
        return YES;
    
    return NO;
}

- (id <WCNetworkOperation>)createGetRequest:(NSString *)url
                              progressBlock:(void (^)(float progress))progressBlock
                               successBlock:(void (^)(NSData *responseData))completeBlock
                                failedBlock:(void (^)(NSError *error))failedBlock
                                cancelBlock:(void(^)())cancelBlock
                                    timeout:(NSUInteger)timeout
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //将请求的网址进行url编码
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.haveBuiltRequestHeaders = YES;
    if (timeout > 0){
        [request setTimeOutSeconds:timeout];
    }
    if ([url rangeOfString:@"/common/commapi/com.region.tree"].location != NSNotFound) {
        [request addRequestHeader:@"Authorization" value:@"bb5a74bad72b4507a83b45df17758be8"];
    }
    else if([url rangeOfString:@"passportapi"].location != NSNotFound ||
       [url rangeOfString:@"uploadpicture"].location != NSNotFound
       ){//url 中包含 passportapi 为用户相关接口 使用 bb5a74bad72b4507a83b45df17758be8
        [request addRequestHeader:@"Authorization" value:@"bb5a74bad72b4507a83b45df17758be8"];
    }
    else{
        [request addRequestHeader:@"Authorization" value:@"1b75c03cacd5418f9759f1e431c91a28"];
    }
    
//    //传递时间戳
//    NSTimeInterval time     = [[NSDate date] timeIntervalSince1970];
//    NSString *timestamp     = [NSString stringWithFormat:@"%.0f", time];
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString *version;
//    //根据url判断是否是线上/测试环境版本
//    if ([[WCBaseContext sharedInstance].configuration.naviURL isEqualToString:@"http://test9.525j.com.cn"]) {
//        version             = [prefs valueForKey:@"WJ_Build_Number"];
//    }else{
//        version             = [prefs valueForKey:@"WJ_Version_Number"];
//    }
//    
//    [request addRequestHeader:@"encryptdata" value:[self TripleDES:[NSString stringWithFormat:@"{\"apptype\":\"enterprise\",\"currentversion\":%@,\"employeeid \":\"71E57E57-ED50-45A6-A9D6-E846FC6D53C1\",\"platform\":\"ios\",\"timestamp\":%@,\"username\":\"%@\",\"userpwd\":\"%@\"}",version,timestamp,[prefs valueForKey:@"WJ_ACCOUNT_LOGINNAME"],[prefs valueForKey:@"WJ_ACCOUNT_PASSWORD"]] encryptOrDecrypt:kCCEncrypt]];
    
    ASIOperationWrapper *operationWrapper = [[ASIOperationWrapper alloc] init];
    operationWrapper.operation = request;
    
    
    __weak ASIHTTPRequest *wRequest = request;
    [request setCompletionBlock:^{
        if(completeBlock)
            completeBlock([wRequest responseData]);
    }];

    [request setFailedBlock:^{
        if(failedBlock)
            failedBlock([wRequest error]);
    }];

    if (progressBlock)
    {
        __block unsigned long long received = 0;
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {

            received += size;
            float progress = (float)received / (float)total;
            progressBlock(progress);
        }];
    }

    if (cancelBlock) {
        [request clearDelegatesAndCancel];
    }
    
    if([self checkIsHttpsRequest:request] == YES){
        [request setValidatesSecureCertificate:NO];
    }

    [request startAsynchronous];

    return operationWrapper;
}

- (id <WCNetworkOperation>)createPostRequest:(NSString *)url
                                    fileData:(NSData *)fileData
                                     postBodyDic:(NSMutableDictionary *)postBodyDic
                                     postBodyArr:(NSMutableArray *)postBodyArr
                                     postParamsDic:(NSMutableDictionary *)postParamsDic
                                    fileName:(NSString *)fileName
                                 contentType:(NSString *)contentType
                             uploadFilesDic:(NSMutableDictionary*)uploadFilesDic
                               progressBlock:(void (^)(float progress))progressBlock
                                successBlock:(void (^)(NSData *responseData))completeBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock
                                 cancelBlock:(void(^)())cancelBlock
                                      forKey:(NSString *)key
                                    timeout:(NSUInteger)timeout
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //将请求的网址进行url编码
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    if (timeout > 0){
        [request setTimeOutSeconds:timeout];
    }
    request.haveBuiltRequestHeaders = YES;
    request.requestMethod = @"POST";
    if([url rangeOfString:@"passportapi"].location != NSNotFound ||
       [url rangeOfString:@"uploadfiles"].location != NSNotFound ||
       [url rangeOfString:@"examapi"].location != NSNotFound     ||
       [url rangeOfString:@"dpapi"].location != NSNotFound) {
        //url 中包含 passportapi 为用户相关接口 使用 bb5a74bad72b4507a83b45df17758be8
        [request addRequestHeader:@"Authorization" value:@"bb5a74bad72b4507a83b45df17758be8"];
    }
    else {
        [request addRequestHeader:@"Authorization" value:@"1b75c03cacd5418f9759f1e431c91a28"];
    }
    
    if ([url hasSuffix:@"com.appclient.analysis"]) {
        [request addRequestHeader:@"Authorization" value:@"bb5a74bad72b4507a83b45df17758be8"];
    }
//    //传递时间戳
//    NSTimeInterval time     = [[NSDate date] timeIntervalSince1970];
//    NSString *timestamp     = [NSString stringWithFormat:@"%.0f", time];
//    NSUserDefaults *prefs   = [NSUserDefaults standardUserDefaults];
//    NSString *version;
//    //根据url判断是否是线上/测试环境版本
//    if ([[WCBaseContext sharedInstance].configuration.naviURL isEqualToString:@"http://test9.525j.com.cn"]) {
//        version             = [prefs valueForKey:@"WJ_Build_Number"];
//    }else{
//        version             = [prefs valueForKey:@"WJ_Version_Number"];
//    }
//    [request addRequestHeader:@"encryptdata" value:[self TripleDES:[NSString stringWithFormat:@"{\"apptype\":\"enterprise\",\"currentversion\":%@,\"employeeid \":\"71E57E57-ED50-45A6-A9D6-E846FC6D53C1\",\"platform\":\"ios\",\"timestamp\":%@,\"username\":\"%@\",\"userpwd\":\"%@\"}",version,timestamp,[prefs valueForKey:@"WJ_ACCOUNT_LOGINNAME"],[prefs valueForKey:@"WJ_ACCOUNT_PASSWORD"]] encryptOrDecrypt:kCCEncrypt]];
    
    if (!fileData && uploadFilesDic.count == 0) { //没有图片上传
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
    }
    if (postBodyDic) {//PostBody 参数
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyDic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog (@"string %@", string);
        
        [request setPostBody:tempJsonData];
    }
    if (postBodyArr) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyArr options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog (@"string %@", string);
        
        [request setPostBody:tempJsonData];
    } else if(postParamsDic.count) { //POST 参数

        NSEnumerator *enumerator = [postParamsDic keyEnumerator];
        id paramKey = nil;
        while ((paramKey = [enumerator nextObject])) {
            [request setPostValue:[postParamsDic objectForKey:paramKey] forKey:paramKey];
        }
        
    }
    
    if (fileData && fileName.length > 0) { //上传单张图片
        [request setData:fileData withFileName:fileName andContentType:@"application/octet-stream" forKey:@"Content-Type"];
    }
    
    if (uploadFilesDic.count > 0) { //上传多张图片
        
        NSEnumerator *enumerator = [uploadFilesDic keyEnumerator];
        id paramKey = nil;
        while ((paramKey = [enumerator nextObject])) {
            NSString *fileName = [NSString stringWithFormat:@"%@",paramKey];
            NSData *imgData = [uploadFilesDic objectForKey:paramKey];
            [request addData:imgData withFileName:fileName andContentType:@"image/png" forKey:fileName];
        }
        
    }

    ASIOperationWrapper *operationWrapper = [[ASIOperationWrapper alloc] init];
    operationWrapper.operation=request;

    __weak ASIHTTPRequest *wRequest = request;
    [request setCompletionBlock:^{
        if(completeBlock)
            completeBlock([wRequest responseData]);
    }];

    [request setFailedBlock:^{
        if(failedBlock)
            failedBlock([wRequest error]);
    }];

    if (progressBlock)
    {
        __block unsigned long long received = 0;
        [request setBytesSentBlock:^(unsigned long long size, unsigned long long total){
            received += size;
            float progress = (float)received / (float)total;
            progressBlock(progress);
        }];
    }

    if (cancelBlock) {
        [request clearDelegatesAndCancel];
    }
    
    if([self checkIsHttpsRequest:request] == YES){
        [request setValidatesSecureCertificate:NO];
    }
    [request startAsynchronous];
    return operationWrapper;
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
//======================================================================================================================================================
