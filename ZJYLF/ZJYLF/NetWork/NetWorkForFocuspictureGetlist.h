//
//  NetWorkForFocuspictureGetlist.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pageDataModel : IObjcJsonBase

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *jumpurl;

@end
@interface dataModel : IObjcJsonBase
@property (nonatomic, strong) NSNumber *currentpageindex;
@property (nonatomic, strong) NSNumber *pagesize;
@property (nonatomic, strong) NSNumber *totalitemcount;
@property (nonatomic, strong) NSNumber *totalpagecount;
@property (nonatomic, strong) NSNumber *hasnextpage;
@property (nonatomic, strong) NSNumber *haspreviouspage;
@property (nonatomic, strong) NSArray *pagedata;


@end
@interface FocuspictureGetlistRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)  dataModel*data;

@end
@interface NetWorkForFocuspictureGetlist : WCServiceBase_Test

@end
