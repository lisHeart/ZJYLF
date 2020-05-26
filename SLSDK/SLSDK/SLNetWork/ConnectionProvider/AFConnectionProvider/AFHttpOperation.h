//
//  AFHttpOperation.h
//  AppFramework
//
//  Created by liubin on 13-1-9.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHttpMacros.h"

typedef NSString *(^getDataEncodingBlock) (NSDictionary *dictionary);
typedef NSData *(^postDataEncodingBlock) (NSDictionary *dictionary);

@class AFHttpOperation;

@protocol AFHttpOperationDelegate <NSObject>

- (void)AFHttpOperation:(id)operation didFinished:(NSData *)data;
- (void)AFHttpOperation:(id)operation didError:(NSError *)error;
- (void)AFHttpOperation:(id)operation uploadProgress:(CGFloat)progress;
- (void)AFHttpOperation:(id)operation downloadProgress:(CGFloat)progress;
- (void)AFHttpOperation:(id)operation downloadPart:(NSData *)data;

@end

typedef enum
{
    AFHttpOperationMethodGET = 0,
    AFHttpOperationMethodPOST,
    AFHttpOperationMethodPUT
} AFHttpOperationMethod;

@interface AFHttpOperation : NSOperation<NSURLConnectionDataDelegate>
{
    size_t _flowSize;
    AFHttpOperationType _type;
    AFHttpOperationState _state;
    getDataEncodingBlock _getDataEncodingHandler;
    postDataEncodingBlock _postDataEncodingHandler;
    id<AFHttpOperationDelegate> _delegate;
}

@property (nonatomic, readonly) size_t flowSize;
@property (nonatomic, readonly) AFHttpOperationType type;
@property (nonatomic, assign) AFHttpOperationState state;
@property (nonatomic, copy) getDataEncodingBlock getDataEncodingHandler;
@property (nonatomic, copy) postDataEncodingBlock postDataEncodingHandler;
@property (nonatomic, assign) id<AFHttpOperationDelegate> delegate;

- (id)initWithURL:(NSString *)url
           params:(NSDictionary *)params
             type:(AFHttpOperationType)type
           method:(AFHttpOperationMethod)method
      contentType:(NSString *)contentType
         delegate:(id<AFHttpOperationDelegate>)delegate;

@end
