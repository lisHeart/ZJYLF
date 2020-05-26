//
//  NetWorkForModifyPassword.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface ModifyPasswordPostmodel : IObjcJsonBase
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *usertype;
@property (nonatomic, copy) NSString *oldpassword;
@property (nonatomic, copy) NSString *newpassword;
@property (nonatomic, copy) NSString *verifycode;


@end
@interface ModifyPasswordRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;


@end
@interface NetWorkForModifyPassword : WCServiceBase_Test
@property (nonatomic, strong) ModifyPasswordPostmodel *postModel;
@end
