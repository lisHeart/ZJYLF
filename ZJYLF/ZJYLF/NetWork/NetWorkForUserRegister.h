//
//  NetWorkForUserRegister.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface UseroginDatamodel : IObjcJsonBase

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *usertype;

@end

@interface UseroginPostmodel : IObjcJsonBase

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;

@end

@interface UseroginRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) UseroginDatamodel *data;


@end
//登录接口
@interface NetWorkForUserogin : WCServiceBase_Test
@property (nonatomic, strong) UseroginPostmodel *postModel;
@end

//注册页面UI数据 跟网络无关
@interface RegisterModel : IObjcJsonBase

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;


@end

@interface UserRegisterPostmodel : IObjcJsonBase

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *creatorid;


@end
@interface UserRegisterRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;


@end
@interface NetWorkForUserRegister : WCServiceBase_Test
@property (nonatomic, strong) UserRegisterPostmodel *postModel;
@end
