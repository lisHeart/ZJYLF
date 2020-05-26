//
//  NetWorkForTaskGetlist.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface TaskGetlistModel : IObjcJsonBase

@property (nonatomic, copy) NSString *tasktypename;
@property (nonatomic, copy) NSString *tasktitle;
@property (nonatomic, copy) NSString *taskcontent;
@property (nonatomic, copy) NSString *statename;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *linkphone;
@property (nonatomic, strong) NSNumber *taskid;




@end
@interface TaskGetlistResponeModel : IObjcJsonBase
@property (nonatomic, strong) NSNumber *currentpageindex;
@property (nonatomic, strong) NSNumber *pagesize;
@property (nonatomic, strong) NSNumber *totalitemcount;
@property (nonatomic, strong) NSNumber *totalpagecount;
@property (nonatomic, strong) NSNumber *hasnextpage;
@property (nonatomic, strong) NSNumber *haspreviouspage;
@property (nonatomic, strong) NSArray *pagedata;


@end
@interface TaskGetlistRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)TaskGetlistResponeModel *data;

@end
@interface NetWorkForTaskGetlist : WCServiceBase_Test
@property (nonatomic, copy) NSString * pageindex;
@property (nonatomic, copy) NSString * pagesize;
@end
