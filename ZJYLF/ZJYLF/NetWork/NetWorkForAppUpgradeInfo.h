//
//  NetWorkForAppUpgradeInfo.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/12/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface AppUpgradeInDataModel : IObjcJsonBase

@property (nonatomic, copy) NSString *vername;
@property (nonatomic, copy) NSString *verno;
@property (nonatomic, strong) NSNumber *forced;
@property (nonatomic, copy)NSString *download;
@property (nonatomic, copy) NSString *descriptions;


@end
@interface AppUpgradeInRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) AppUpgradeInDataModel *data;


@end
@interface NetWorkForAppUpgradeInfo : WCServiceBase_Test
@property (nonatomic, copy) NSString *appname;
@property (nonatomic, copy) NSString *platform;
@end
