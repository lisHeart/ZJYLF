//
//  AFHttpEngine.h
//  AppFramework
//
//  Created by liubin on 13-1-10.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHttpOperation.h"
#import "AFNetworkManager.h"
typedef void(^onFinishedBlock) (NSData *data);
typedef void(^onErrorBlock) (NSError *error);
typedef void(^onCancelBlock) ();
typedef void(^onUploadProgressBlock) (float progress);
typedef void(^onDownloadProgressBlock) (float progress);
typedef void(^onDownloadPartBlock) (NSData *part);

@interface AFHttpEngine : NSObject<AFHttpOperationDelegate>
{
    AFHttpOperationType _engineType;
    AFHttpOperationMethod _method;
    NSString *_url;
    NSString *_contentType;
    NSMutableDictionary *_params;
    NSData *_uploadFile;

    // Callback blocks
    getDataEncodingBlock _getDataEncodingHandler;
    postDataEncodingBlock _postDataEncodingHandler;
    onFinishedBlock _onFinished;
    onErrorBlock _onError;
    onUploadProgressBlock _onUploadProgress;
    onDownloadProgressBlock _onDownloadProgress;
    onDownloadPartBlock _onDownloadPart;
}

@property (nonatomic, readonly) AFHttpOperationType engineType;
@property (nonatomic, assign) AFHttpOperationMethod method;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, copy) getDataEncodingBlock getDataEncodingHandler;
@property (nonatomic, copy) postDataEncodingBlock postDataEncodingHandler;
@property (nonatomic, copy) onFinishedBlock onFinished;
@property (nonatomic, copy) onErrorBlock onError;
@property (nonatomic, copy) onCancelBlock onCancel;
@property (nonatomic, copy) onUploadProgressBlock onUploadProgress;
@property (nonatomic, copy) onDownloadProgressBlock onDownloadProgress;
@property (nonatomic, copy) onDownloadPartBlock onDownloadPart;

- (id)initWithType:(AFHttpOperationType)type;

// methods
- (void)send;
- (void)cancel;
- (void)setFile:(NSData *)file fileName:(NSString *)fileName forKey:(NSString *)key;


@end
