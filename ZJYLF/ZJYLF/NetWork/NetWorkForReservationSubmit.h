//
//  NetWorkForReservationSubmit.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface ReservationSubmitPostmodel : IObjcJsonBase
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *equipmentid;
@property (nonatomic, copy) NSString *staffnum;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *submitor;


@end
@interface ReservationSubmitRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;


@end
@interface NetWorkForReservationSubmit : WCServiceBase_Test
@property (nonatomic, strong) ReservationSubmitPostmodel *postModel;
@end
