//
//  NetWorkForTaskGet.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface repliesModel : IObjcJsonBase
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *replycontent;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *taskid;
@property (nonatomic, strong) NSNumber *parentid;


@end
@interface TaskGetResponeModel : IObjcJsonBase
@property (nonatomic, copy) NSString *tasktypename;
@property (nonatomic, copy) NSString *tasktitle;
@property (nonatomic, copy) NSString *taskcontent;
@property (nonatomic, copy) NSString *statename;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *linkphone;
@property (nonatomic, copy) NSString *companyname;
@property (nonatomic, strong) NSArray *replies;
@property (nonatomic, strong) NSNumber *taskid;


@end
@interface TaskGetRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)TaskGetResponeModel *data;

@end
@interface NetWorkForTaskGet : WCServiceBase_Test
@property (nonatomic, copy) NSString * taskid;
@end
