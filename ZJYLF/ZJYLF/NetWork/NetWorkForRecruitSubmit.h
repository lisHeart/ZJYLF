//
//  NetWorkForRecruitSubmit.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface RecruitSubmitPostmodel : IObjcJsonBase
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *recruitcontent;
@property (nonatomic, copy) NSString *submitor;


@end
@interface RecruitSubmitRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;


@end
@interface NetWorkForRecruitSubmit : WCServiceBase_Test
@property (nonatomic, strong) RecruitSubmitPostmodel *postModel;
@end
