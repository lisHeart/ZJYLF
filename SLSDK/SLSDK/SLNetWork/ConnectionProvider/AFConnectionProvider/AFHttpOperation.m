//
//  AFHttpOperation.m
//  AppFramework
//
//  Created by liubin on 13-1-9.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#import "AFHttpOperation.h"

@interface AFHttpOperation ()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) AFHttpOperationMethod method;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, assign) BOOL isCancelled;
@property (nonatomic, assign) CGFloat totalBytesExpectedToRead;
#if TARGET_OS_IPHONE
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
#endif

- (NSMutableURLRequest *)submit;
- (void)endBackgroundTask;

@end

@implementation AFHttpOperation

@synthesize flowSize = _flowSize;
@synthesize type = _type;
@synthesize state = _state;
@synthesize getDataEncodingHandler = _getDataEncodingHandler;
@synthesize postDataEncodingHandler = _postDataEncodingHandler;
@synthesize delegate = _delegate;

@synthesize url = _url;
@synthesize method = _method;
@synthesize contentType = _contentType;
@synthesize params = _params;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize isCancelled = _isCancelled;
@synthesize totalBytesExpectedToRead = _totalBytesExpectedToRead;
#if TARGET_OS_IPHONE
@synthesize backgroundTaskId = _backgroundTaskId;
#endif

- (id)initWithURL:(NSString *)url
           params:(NSDictionary *)params
             type:(AFHttpOperationType)type
           method:(AFHttpOperationMethod)method
      contentType:(NSString *)contentType
         delegate:(id<AFHttpOperationDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _flowSize = 0;
        _totalBytesExpectedToRead = 0;
        _isCancelled = NO;
        _type = type;
        _method = method;

        self.state = AFHttpOperationStateReady;
        self.url = url;
        self.contentType = contentType;
        NSDictionary *tmpParams = [[NSDictionary alloc] initWithDictionary:params copyItems:YES];
        self.params = tmpParams;
        [tmpParams release];
        self.delegate = delegate;
    }

    return self;
}

- (void)dealloc
{
    [_connection cancel];
    WCH_RELEASE(_connection);
    WCH_RELEASE(_getDataEncodingHandler);
    WCH_RELEASE(_postDataEncodingHandler);
    WCH_RELEASE(_url);
    WCH_RELEASE(_contentType);
    WCH_RELEASE(_params);
    WCH_RELEASE(_data);
    [super dealloc];
}

- (void)setState:(AFHttpOperationState)state
{
    switch (state)
    {
        case AFHttpOperationStateReady:
        {
            [self willChangeValueForKey:@"isReady"];
            break;
        }
        case AFHttpOperationStateExecuting:
        {
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
            break;
        }
        case AFHttpOperationStateFinish:
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            break;
        }            
        default:
            break;
    }

    _state = state;

    switch (state)
    {
        case AFHttpOperationStateReady:
        {
            [self didChangeValueForKey:@"isReady"];
            break;
        }
        case AFHttpOperationStateExecuting:
        {
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        }
        case AFHttpOperationStateFinish:
        {
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            break;
        }
        default:
            break;
    }
}

#pragma mark NSOperation methods
- (void)start
{
#if TARGET_OS_IPHONE
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];
#endif

    if (self.isReady)
    {
        NSMutableURLRequest *request = [self submit];
        if (request)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                              delegate:self
                                                                      startImmediately:NO];
                self.connection = connection;
                [connection release];
                [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                [self.connection start];
            });

            self.state = AFHttpOperationStateExecuting;
        }
        else
        {
            self.state = AFHttpOperationStateFinish;
            [self endBackgroundTask];
        }
    }
    else if (self.isCancelled)
    {
        self.state = AFHttpOperationStateFinish;
        [self endBackgroundTask];
    }
}

/**
 * Because NSOperation can't be reused in NSOperationQueue, this operation is invalid after cancel.
 */
- (void)cancel
{
    if (self.isFinished) return;
    
    @synchronized(self)
    {
        // Add @synchronized for thread safe when cancel method is called in multi-threads.
        // Do not release url, params and data to avoid bad pointer risk.
        self.isCancelled = YES;
        self.delegate = nil;
        [_connection cancel];
        WCH_RELEASE(_connection);
        if (self.state != AFHttpOperationStateFinish)
        {
            self.state = AFHttpOperationStateFinish;
        }
        [self endBackgroundTask];
    }
    
    [super cancel];
}

- (BOOL)isReady
{
    if (self.state == AFHttpOperationStateReady) return YES;
    return NO;
}

- (BOOL)isExecuting
{
    if (_state == AFHttpOperationStateExecuting) return YES;
    return NO;
}

- (BOOL)isFinished
{
    if (self.state == AFHttpOperationStateFinish) return YES;
    return NO;
}

- (BOOL)isConcurrent
{
    return YES;
}

#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    // Record upload progress
    if ([self.delegate respondsToSelector:@selector(AFHttpOperation:uploadProgress:)])
    {
        CGFloat written = (CGFloat)totalBytesWritten;
        CGFloat total = (CGFloat)totalBytesExpectedToWrite;
        if (total > 0)
        {
            CGFloat progress = (written / total) * 100;
            [self.delegate AFHttpOperation:self uploadProgress:progress];
        }
    }

    _flowSize += bytesWritten;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = nil;
    if (response)
    {
        NSInteger size = [response expectedContentLength] < 0 ? 0 : [response expectedContentLength];
        self.totalBytesExpectedToRead = size;
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:size];
        self.data = data;
        [data release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data)
    {
        if (!self.data)
        {
            NSMutableData *part = [[NSMutableData alloc] initWithData:nil];
            self.data = part;
            [part release];
        }

        [self.data appendData:data];

        // Record download progress
        if ([self.delegate respondsToSelector:@selector(AFHttpOperation:downloadProgress:)])
        {
            CGFloat read = (CGFloat)[self.data length];
            CGFloat total = (CGFloat)self.totalBytesExpectedToRead;
            if (total > 0)
            {
                CGFloat progress = (read / total) * 100;
                [self.delegate AFHttpOperation:self downloadProgress:progress];
            }
        }

        // part download
        if ([self.delegate respondsToSelector:@selector(AFHttpOperation:downloadPart:)])
        {
            [self.delegate AFHttpOperation:self downloadPart:data];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.isCancelled) return;
    
    self.state = AFHttpOperationStateFinish;
    _flowSize += [self.data length];
    if ([self.delegate respondsToSelector:@selector(AFHttpOperation:didFinished:)])
    {
        [self.delegate AFHttpOperation:self didFinished:self.data];
    }
    self.data = nil;
    [self endBackgroundTask];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.isCancelled) return;
    
    self.state = AFHttpOperationStateFinish;
    _flowSize += [self.data length];
    self.data = nil;
    if ([self.delegate respondsToSelector:@selector(AFHttpOperation:didError:)])
    {
        [self.delegate AFHttpOperation:self didError:error];
    }
    [self endBackgroundTask];
}

#pragma mark NSOperation private methods
- (NSMutableURLRequest *)submit
{
    NSMutableURLRequest *request = nil;

    if (self.method == AFHttpOperationMethodGET)
    {
        NSString *urlStr = nil;
        NSString *paramsString = self.getDataEncodingHandler(self.params);
        if (paramsString)
        {
            urlStr = [NSString stringWithFormat:@"%@?%@", self.url, paramsString];
        }
        else
        {
            urlStr = [NSString stringWithFormat:@"%@", self.url];
        }

        NSURL *url = [NSURL URLWithString:urlStr];
        request = [NSMutableURLRequest requestWithURL:url
                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                      timeoutInterval:kAFHttpRequestTimeOut];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:self.url];
        request = [NSMutableURLRequest requestWithURL:url
                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                      timeoutInterval:kAFHttpRequestTimeOut];
    }

    switch (self.method)
    {
        case AFHttpOperationMethodGET:
        {
            [request setHTTPMethod:@"GET"];
            break;
        }
        case AFHttpOperationMethodPOST:
        {
            [request setHTTPMethod:@"POST"];
            NSData *postData = self.postDataEncodingHandler(self.params);
            if (postData)
            {
                [request setHTTPBody:postData];
                [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
            }
            break;
        }
        case AFHttpOperationMethodPUT:
        {
            [request setHTTPMethod:@"PUT"];
            break;
        }
        default:
        {
            [request setHTTPMethod:@"POST"];
            break;
        }
    }
    if ([self.contentType length] > 0)
    {
        [request setValue:self.contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    return request;
}

- (void)endBackgroundTask
{
    if ([NSThread isMainThread])
    {
        if (self.backgroundTaskId != UIBackgroundTaskInvalid)
        {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backgroundTaskId != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
                self.backgroundTaskId = UIBackgroundTaskInvalid;
            }
        });
    }
}



@end
