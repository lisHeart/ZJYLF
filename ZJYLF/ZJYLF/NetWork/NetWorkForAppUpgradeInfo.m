//
//  NetWorkForAppUpgradeInfo.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/12/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForAppUpgradeInfo.h"
@implementation AppUpgradeInDataModel

@end
@implementation AppUpgradeInRespone

@end
@implementation NetWorkForAppUpgradeInfo
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/app.upgrade.info/{appname}/{platform}";
}


- (Class)responseType {
    return [AppUpgradeInRespone class];
}
@end
