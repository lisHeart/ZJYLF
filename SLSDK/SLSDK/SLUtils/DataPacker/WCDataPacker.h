//
//  WCDataPacker.h
//  winCRM
//
//  Created by Cai Lei on 12/10/12.
//  Copyright (c) 2012 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSString *InitStreetCode;
extern const NSString *InitHttpCode;

@interface WCDataPacker : NSObject
@property (nonatomic,copy) NSString *salt;



- (NSData *)packDataWithZip:(NSData *)aData;
- (NSData *)packData:(NSData *)aData;

- (NSString *)packStringWithZip:(NSString *)aString;

- (NSData *)unpackDataWithUnzip:(NSData *)aData;
- (NSData *)unpackData:(NSData *)aData;

- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType;
- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType withFile:(NSData *)aFile;


- (NSData *)decrypt398File:(NSData *)aData withSalt:(NSString *)salt andLength:(NSUInteger)headerLen;


- (void)getResponseInfo:(NSData *)rawData
                   type:(UInt16 *)aType
              errorCode:(UInt32 *)aErrorCode
                content:(NSData **)aContent
                   file:(id*)aFile;



+ (int)checkCPULittleEndian;

void XORProcess(const char *src, char *dst,const char *key, int m,int n);


////transplant from the colorgenious add by jimmy lee

+ (WCDataPacker *)sharedInstance;

- (void)getResponseInfo:(const char *)aResponse
                   type:(UInt16 *)aType
              errorCode:(UInt32 *)aErrorCode
          contentLength:(UInt32 *)aContentLength
                content:(NSData **)aContent;

- (NSString *)packForURLParam:(NSString *)aURLParam;

- (NSData *)unpackForPostBody:(NSData *)aData;

- (NSData *)packForPostBody:(NSData *)aData;

- (NSData *)packForPostBodyNoZip:(NSData *)aData;

- (UInt16)getResponseErrorCodeTwoBytes:(const char *)aResponse offset:(NSInteger)aOffset;
////transplant from the colorgenious add by jimmy lee
@end
