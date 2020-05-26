//
//  NetWorkForTaskSubmit.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/24.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface TaskSubmitPostmodel : IObjcJsonBase
//任务类型（1:物业保修，2建议，3投诉）
@property (nonatomic, copy) NSString *tasktypeid;
@property (nonatomic, copy) NSString *tasktitle;
@property (nonatomic, copy) NSString *taskcontent;
//相关联系人
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *linkphone;
@property (nonatomic, copy) NSString *submitor;
@property (nonatomic, copy) NSString *companyid;


@end
@interface TaskSubmitRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;


@end
@interface NetWorkForTaskSubmit : WCServiceBase_Test
@property (nonatomic, strong) TaskSubmitPostmodel *postModel;
@end
