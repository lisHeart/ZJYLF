//
//  NetWorkForGetEquipmentName.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForGetEquipmentName.h"
@implementation EquipmentNameModel

@end
@implementation EquipmentNameRespone

- (NSDictionary *)classNameForItemInArray {
    return @{@"data":@"EquipmentNameModel"};
}
@end
@implementation NetWorkForGetEquipmentName
- (NSString*)getInterfaceUrl{
    return @"/equipment/equipment.reservation.getequipmentname";
}

- (Class)responseType {
    return [EquipmentNameRespone class];
}
@end
