//
//  NetWorkForTaskGet.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForTaskGet.h"
@implementation repliesModel

@end
@implementation TaskGetResponeModel
- (NSDictionary *)classNameForItemInArray {
    return @{@"replies" : @"repliesModel"};
}
@end
@implementation TaskGetRespone

@end
@implementation NetWorkForTaskGet
- (NSString *)getInterfaceUrl {
    
    return @"/task/task.get?taskid={taskid}";
    
}

- (Class)responseType {
    return [TaskGetRespone class];
}
@end
