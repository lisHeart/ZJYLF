//
//  NetWorkForDownloadAdd.h
//  ZJYLF
//
//  Created by 刘高洋 on 2019/3/17.
//  Copyright © 2019年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface DownloadAddPostmodel : IObjcJsonBase
@property (nonatomic, copy) NSString *appversion;
@property (nonatomic, copy) NSString *deviceid;
@property (nonatomic, copy) NSString *platform;


@end
@interface DownloadAddRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;


@end

@interface NetWorkForDownloadAdd : WCServiceBase_Test
@property (nonatomic, strong) DownloadAddPostmodel *postModel;
@end

