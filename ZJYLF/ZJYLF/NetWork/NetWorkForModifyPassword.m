//
//  NetWorkForModifyPassword.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForModifyPassword.h"
@implementation ModifyPasswordPostmodel

@end
@implementation ModifyPasswordRespone

@end
@implementation NetWorkForModifyPassword
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/user.modify.password";
}


- (Class)responseType {
    return [ModifyPasswordRespone class];
}
@end
