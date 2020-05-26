//
//  NetWorkForReservationGetlist.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/27.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForReservationGetlist.h"
@implementation ReservationGetlistModel

@end
@implementation ReservationGetlistResponeModel
- (NSDictionary *)classNameForItemInArray {
    return @{@"pagedata" : @"ReservationGetlistModel"};
}
@end
@implementation ReservationGetlistRespone

@end

@implementation NetWorkForReservationGetlist
- (NSString *)getInterfaceUrl {
    
    return @"/equipment/equipment.reservation.getlist?pagesize={pagesize}&&pageindex={pageindex}";
    
}

- (Class)responseType {
    return [ReservationGetlistRespone class];
}
@end
