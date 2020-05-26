//
// Created by fengshuai on 14-2-24.
// Copyright (c) 2014 winchannel. All rights reserved.


#import "AFHTTPRequestOperationManager+Download.h"

@implementation AFHTTPRequestOperationManager (Download)

- (AFHTTPRequestOperation *)Download:(NSString *)URLString targetPath:(NSString *)targetPath success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 获得临时文件的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *newHeadersDict = [[NSMutableDictionary alloc] init];
    NSString *tempFilePath=[targetPath stringByAppendingString:kTempDownloadSuffix];

    NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                                           [[[NSBundle mainBundle] infoDictionary]
                                                                   objectForKey:(NSString *)kCFBundleNameKey],
                                                           [[[NSBundle mainBundle] infoDictionary]
                                                                   objectForKey:(NSString *)kCFBundleVersionKey]];
    [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];

    // 判断之前是否下载过 如果有下载重新构造Header
    if ([fileManager fileExistsAtPath:tempFilePath]) {
        NSError *error = nil;
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
                                                                     error:&error]
                fileSize];
        if (error) {
            NSLog(@"get %@ fileSize failed!\nError:%@", tempFilePath, error);
        }
        NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
        [newHeadersDict setObject:headerRange forKey:@"Range"];

    }

    // 初始化opertion

    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    [newHeadersDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    operation.outputStream= [NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *afhttpRequestOperation, id responseObject)
    {
        if ([NSFileManager FileExist:targetPath])
            [NSFileManager deleteFileByPath:targetPath];
        [[NSFileManager defaultManager] moveItemAtPath:tempFilePath toPath:targetPath error:nil];
        if (success)
            success(afhttpRequestOperation,responseObject);

    } failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;

}

@end