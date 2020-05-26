//
//  WCConfiguration.h
//  winCRM
//
//  Created by Cai Lei on 5/23/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "IObjcJsonBase.h"

@interface WCBaseConfiguration : IObjcJsonBase

@property (nonatomic, copy) NSString *versionNumber;
@property (nonatomic, copy) NSString *buildNumber;
@property (nonatomic, copy) NSString *svnRevision;
@property (nonatomic, copy) NSString *buildType;
@property (nonatomic, copy) NSString *naviURL;
@property (nonatomic, copy) NSString *interfaceVersion;
@property (nonatomic, copy) NSString *app_name;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *platform_name;
@property (nonatomic, copy) NSString *src_name;
@property (nonatomic, copy) NSString *boxAddress; //box的域名或ip地址
@property (nonatomic, copy) NSString *macFromBox; //从box获得的本机mac地址
@property (nonatomic, copy) NSString *alipayCallbackUrl; //支付宝应用需要的服务端回调地址
@property (nonatomic, assign) BOOL supportBackgroundTransfer;
@property (nonatomic, strong) NSArray *ignoreTransType;
@property (nonatomic, assign) BOOL readlocality631;
@property (nonatomic, copy) NSString *baiduMapKey;

- (NSString *)rootNodeName ;

- (NSString *)version;
@end
