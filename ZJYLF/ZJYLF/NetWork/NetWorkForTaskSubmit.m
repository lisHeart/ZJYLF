//
//  NetWorkForTaskSubmit.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/24.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForTaskSubmit.h"
@implementation TaskSubmitPostmodel

@end
@implementation TaskSubmitRespone

@end
@implementation NetWorkForTaskSubmit
- (NSString*)getInterfaceUrl{
    return @"/task/task.submit";
}

- (Class)responseType {
    return [TaskSubmitRespone class];
}
@end
