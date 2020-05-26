//
//  NetWorkForCompanyGetlist.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"


@interface CompanyGetlistPagedata : IObjcJsonBase

@property (nonatomic, copy) NSString *companyname;
@property (nonatomic, copy) NSString *corporation;
@property (nonatomic, copy) NSString *linktel;
@property (nonatomic, copy) NSString *progressname;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *companyid;

@end
@interface CompanyGetlistData : IObjcJsonBase

@property (nonatomic, strong)  NSArray *pagedata;

@end
@interface CompanyGetlistRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)  CompanyGetlistData *data;

@end
@interface NetWorkForCompanyGetlist : WCServiceBase_Test

@end
