//
// Created by fengshuai on 14-2-7.
// Copyright (c) 2014 winchannel. All rights reserved.


#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"


@interface MKBreakpointDownloader : MKNetworkOperation

+ (MKBreakpointDownloader *) operationWithURLString:(NSString *) urlString
                                             params:(NSMutableDictionary *) body
                                         httpMethod:(NSString *)method
                                       tempFilePath:(NSString *)tempFilePath
                                   downloadFilePath:(NSString *)downloadFilePath
                                        rewriteFile:(BOOL)rewrite;

@end