//
//  NetWorkForTaskGetlist.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForTaskGetlist.h"
@implementation TaskGetlistModel

@end
@implementation TaskGetlistResponeModel
- (NSDictionary *)classNameForItemInArray {
    return @{@"pagedata" : @"TaskGetlistModel"};
}
@end
@implementation TaskGetlistRespone

@end
@implementation NetWorkForTaskGetlist
- (NSString *)getInterfaceUrl {
    
    return @"/task/task.getlist?pagesize={pagesize}&&pageindex={pageindex}";
    
}

- (Class)responseType {
    return [TaskGetlistRespone class];
}
@end
