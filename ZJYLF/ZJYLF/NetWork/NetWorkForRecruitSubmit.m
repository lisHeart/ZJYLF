//
//  NetWorkForRecruitSubmit.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForRecruitSubmit.h"
@implementation RecruitSubmitPostmodel

@end
@implementation RecruitSubmitRespone

@end
@implementation NetWorkForRecruitSubmit
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/recruit.submit";
}

- (Class)responseType {
    return [RecruitSubmitRespone class];
}
@end
