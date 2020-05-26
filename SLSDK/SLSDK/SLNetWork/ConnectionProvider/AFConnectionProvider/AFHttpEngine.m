//
//  AFHttpEngine.m
//  AppFramework
//
//  Created by liubin on 13-1-10.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#import "AFHttpEngine.h"

#define kHttpParamsCapacityNumber 10

#define kFormBoundary @"0xKhTmLbOuNdArY"

@interface AFHttpEngine ()

@property (nonatomic, retain) AFHttpOperation *operation;

@property (nonatomic, retain) NSData *uploadFile;

@end

@implementation AFHttpEngine

@synthesize engineType = _engineType;
@synthesize method = _method;
@synthesize url = _url;
@synthesize contentType = _contentType;
@synthesize uploadFile = _uploadFile;
@synthesize params = _params;
@synthesize getDataEncodingHandler = _getDataEncodingHandler;
@synthesize postDataEncodingHandler = _postDataEncodingHandler;
@synthesize onFinished = _onFinished;
@synthesize onError = _onError;
@synthesize onUploadProgress = _onUploadProgress;
@synthesize onDownloadProgress = _onDownloadProgress;
@synthesize onDownloadPart = _onDownloadPart;
@synthesize operation = _operation;

- (id)initWithType:(AFHttpOperationType)type
{
    self = [super init];
    if (self)
    {
        _engineType = type;
        if (type == AFHttpOperationTypeDownload)
        {
            _method = AFHttpOperationMethodGET;
        }
        else
        {
            _method = AFHttpOperationMethodPOST;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:kHttpParamsCapacityNumber];
        self.params = params;
    }

    return self;
}

+ (NSString *)defaultQueryStringFromDictionary:(NSDictionary *)dictionary
{
    if ([dictionary count] <= 0) return @"";

    NSMutableString *postStr = [NSMutableString string];
    NSArray *allKeys = [dictionary allKeys];
    for (id key in allKeys)
    {
        NSString *keyName = [NSString stringWithObject:key];
        NSString *valName = [NSString stringWithObject:[dictionary objectForKey:key]];
        [postStr appendFormat:@"&%@=%@&", keyName, valName];
    }
    [postStr substringFromIndex:1];

    return [NSString stringWithString:postStr];
}

- (void)dealloc
{
    [_operation cancel];
}

- (void)setOperation:(AFHttpOperation *)operation
{
    AFNetworkManager *networkManager = [AFNetworkManager sharedInstance];
    @synchronized(_operation)
    {
        if (_operation)
        {
            [networkManager removeHttpEngineObserver:self flowSize:_operation.flowSize];
            [_operation cancel];
        }
        if (_operation)
        {
            [networkManager addHttpEngineObserver:self];
        }
    }
}

- (void)setFile:(NSData *)file fileName:(NSString *)fileName forKey:(NSString *)key
{
    if (!file) return;

    NSString *beginBoundary = [NSString stringWithFormat:@"--%@\r\n", kFormBoundary];
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n%@--", kFormBoundary];
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--\r\n", kFormBoundary];

    NSMutableString *bodyHeader = [NSMutableString string];
    [bodyHeader appendString:beginBoundary];
    [bodyHeader appendFormat:[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"@%\"; filename=\"%@\"\r\n",key,fileName]];
    [bodyHeader appendFormat:@"Content-Type:application/octet-stream\r\n\r\n"];

    NSMutableData *body = [NSMutableData data];
    [body appendData:[bodyHeader dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:file];
    [body appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    self.uploadFile=body;

}

#pragma mark AFHttpEngine methods
- (void)send
{
    AFNetworkManager *networkManager =[AFNetworkManager sharedInstance];
    if ([networkManager reachabilityStatus] == NotReachable)
    {
        if ([NSThread isMainThread])
        {
            NSError *err = [[NSError alloc] initWithDomain:@"NSURLErrorDomain"
                                                      code:kCFURLErrorNetworkConnectionLost
                                                  userInfo:nil];
            if (self.onError)
            {
                self.onError(err);
            }
            [err release];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err = [[NSError alloc] initWithDomain:@"NSURLErrorDomain"
                                                          code:kCFURLErrorNetworkConnectionLost
                                                      userInfo:nil];
                if (self.onError)
                {
                    self.onError(err);
                }
                [err release];
            });
        }
        return;
    }

    AFHttpOperation *operation = [[AFHttpOperation alloc] initWithURL:self.url
                                                               params:self.params
                                                                 type:self.engineType
                                                               method:self.method
                                                          contentType:self.contentType
                                                             delegate:self];
    [networkManager addHttpOperation:operation];
    if (self.getDataEncodingHandler)
    {
        operation.getDataEncodingHandler = self.getDataEncodingHandler;
        [self.getDataEncodingHandler release];
        self.getDataEncodingHandler = nil;
    }
    else
    {
        operation.getDataEncodingHandler = ^NSString *(NSDictionary *dictionary){
            return [AFHttpEngine defaultQueryStringFromDictionary:dictionary];
        };
    }
    if (self.postDataEncodingHandler)
    {
        operation.postDataEncodingHandler = self.postDataEncodingHandler;
        [self.postDataEncodingHandler release];
        self.postDataEncodingHandler = nil;
    }
    else
    {
        operation.postDataEncodingHandler = ^NSData *(NSDictionary *dictionary){
            return self.uploadFile;
        };
    }
    self.operation = operation;
    [operation release];
}

- (void)cancel
{
    if (self.onCancel)
        self.onCancel();

    self.getDataEncodingHandler = nil;
    self.postDataEncodingHandler = nil;
    self.onFinished = nil;
    self.onError = nil;
    self.onCancel= nil;
    self.onUploadProgress = nil;
    self.onDownloadProgress = nil;
    self.onDownloadPart = nil;
    self.operation = nil;
}

#pragma mark AFHttpOperationDelegate methods
- (void)AFHttpOperation:(id)operation didFinished:(NSData *)data
{
    if (self.operation == operation)
    {
        if (self.onFinished)
        {
            self.onFinished(data);
        }
        self.operation = nil;
    }
}

- (void)AFHttpOperation:(id)operation didError:(NSError *)error
{
    if (self.operation == operation)
    {
        if (self.onError)
        {
            self.onError(error);
        }
        self.operation = nil;
    }
}

- (void)AFHttpOperation:(id)operation uploadProgress:(CGFloat)progress
{
    if (self.operation == operation)
    {
        if (self.onUploadProgress)
        {
            self.onUploadProgress(progress);
        }
    }
}

- (void)AFHttpOperation:(id)operation downloadProgress:(CGFloat)progress
{
    if (self.operation == operation)
    {
        if (self.onDownloadProgress)
        {
            self.onDownloadProgress(progress);
        }
    }
}

- (void)AFHttpOperation:(id)operation downloadPart:(NSData *)data
{
    if (self.operation == operation)
    {
        if (self.onDownloadPart)
        {
            self.onDownloadPart(data);
        }
    }
}

@end
