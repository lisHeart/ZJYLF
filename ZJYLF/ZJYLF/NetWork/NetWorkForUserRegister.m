//
//  NetWorkForUserRegister.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForUserRegister.h"
@implementation UseroginDatamodel

@end
@implementation UseroginPostmodel

@end
@implementation UseroginRespone

@end
@implementation NetWorkForUserogin
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/user.login";
}

- (Class)responseType {
    return [UseroginRespone class];
}
@end
@implementation RegisterModel

@end
@implementation UserRegisterPostmodel

@end
@implementation UserRegisterRespone

@end
@implementation NetWorkForUserRegister
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/user.register";
}

- (Class)responseType {
    return [UserRegisterRespone class];
}
@end
