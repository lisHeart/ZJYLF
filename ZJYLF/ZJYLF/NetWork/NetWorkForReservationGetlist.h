//
//  NetWorkForReservationGetlist.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/27.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface ReservationGetlistModel : IObjcJsonBase

@property (nonatomic, copy) NSString *equipmentname;
@property (nonatomic, copy) NSString *equipmentimage;
@property (nonatomic, copy) NSString *hirecompany;
@property (nonatomic, copy) NSString *usenumber;
@property (nonatomic, copy) NSString *hiretime;




@end
@interface ReservationGetlistResponeModel : IObjcJsonBase
@property (nonatomic, strong) NSNumber *currentpageindex;
@property (nonatomic, strong) NSNumber *pagesize;
@property (nonatomic, strong) NSNumber *totalitemcount;
@property (nonatomic, strong) NSNumber *totalpagecount;
@property (nonatomic, strong) NSNumber *hasnextpage;
@property (nonatomic, strong) NSNumber *haspreviouspage;
@property (nonatomic, strong) NSArray *pagedata;


@end
@interface ReservationGetlistRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)ReservationGetlistResponeModel *data;

@end
@interface NetWorkForReservationGetlist : WCServiceBase_Test
@property (nonatomic, copy) NSString * pageindex;
@property (nonatomic, copy) NSString * pagesize;

@end
