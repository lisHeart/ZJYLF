//
//  NetWorkForProgressApplySearch.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface ProgressApplySearchRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSNumber *data;


@end
@interface NetWorkForProgressApplySearch : WCServiceBase_Test
@property (nonatomic, copy) NSString *mobile;
@end
