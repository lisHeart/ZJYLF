//
//  NSString+Hash.h
//  winCRM
//
//  Created by Cai Lei on 12/26/12.
//  Copyright (c) 2012 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)

- (NSString *)MD5Hash;

@end

@interface NSString (UUID)

+(NSString *)UUIDString;


@end

@interface NSString(Ext)
+ (NSString *)stringWithObject:(id)obj;
+ (NSString *)string:(NSString *)str withStringEncoding:(NSStringEncoding)stringEncoding;

- (NSString *)stringWithTrimWhiteSpcace;

@end
