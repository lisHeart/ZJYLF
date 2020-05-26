//
//  WCServiceBase.h
//  SLSDK
//
//  Created by songlei on 15/5/15.
//  Copyright (c) 2015年 songlei. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IObjcJsonBase.h"
#import "JSONKit.h"

#define kServiceErrorCode (999)//断网

@class WCServiceBase;
@class WCDataPacker;

typedef enum
{
    ERequestTypeGet = 0,
    ERequestTypePost
} ERequstType;


@protocol WCServiceDelegate <NSObject>
@optional
- (void)service:(WCServiceBase *)service successed:(id)result;

- (void)service:(WCServiceBase *)service error:(NSError *)error;
@end

@interface WCServiceBase : IObjcJsonBase
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *grp;
@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *platform;
@property(nonatomic, copy) NSString *imei;
@property(nonatomic, copy) NSString *src;
@property(nonatomic, copy) NSString *lang;
@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, copy) NSString *uploadFileName;
@property(nonatomic, strong) NSData *uploadFileData;

@property(nonatomic, assign) BOOL useNaviSquare;//使用公共url作为请求

@property (nonatomic, assign)NSUInteger timeout;

@property(nonatomic, weak) id <WCServiceDelegate> delegate;

- (id)composeResult:(NSDictionary *)dictionary attachedFile:(id)file;

- (void)appendExtras:(NSDictionary *)extra;

- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock
            progressBlock:(void (^)(float progress))progressBlock;

- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock;

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock
             progressBlock:(void (^)(float progress))progressBlock;

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock;

- (void)stop;

//Methods for Overriden
- (NSString *)prepareRequestUrl:(ERequstType)requstType;

- (WCDataPacker *)prepareDataPacker;

//该方法一般不需要覆盖，但对401~410 除外
- (UInt16)serviceType;

- (Class)responseType;

- (NSMutableDictionary *)composeParams;

- (NSString *)getSrc;


@end
