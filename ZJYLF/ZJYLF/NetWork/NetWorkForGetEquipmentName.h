//
//  NetWorkForGetEquipmentName.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface EquipmentNameModel : IObjcJsonBase

@property (nonatomic, copy) NSString *equipmentname;
@property (nonatomic, copy) NSString *equipmentid;


@end
@interface EquipmentNameRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)  NSArray*data;

@end
@interface NetWorkForGetEquipmentName : WCServiceBase_Test

@end
