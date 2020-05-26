//
//  NetWorkForReservationSubmit.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForReservationSubmit.h"
@implementation ReservationSubmitPostmodel

@end
@implementation ReservationSubmitRespone

@end
@implementation NetWorkForReservationSubmit
- (NSString*)getInterfaceUrl{
    return @"/equipment/equipment.reservation.submit";
}

- (Class)responseType {
    return [ReservationSubmitRespone class];
}
@end
