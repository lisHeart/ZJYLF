//
// Created by fengshuai on 13-12-13.
// Copyright (c) 2013 winchannel. All rights reserved.


#import "AFNetworkWrapper.h"

@implementation AFNetworkWrapper

- (void)cancel
{
    [self.dataTask cancel];
    [self.downloadTask cancel];
}

- (void)pause
{
    [self.dataTask cancel];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if ([fileManager fileExistsAtPath:self.downloadTempPath])
            [fileManager removeItemAtPath:self.downloadTempPath error:nil];
        [resumeData writeToFile:self.downloadTempPath atomically:NO];
    }];
}

@end
