//
//  NetWorkForProgressApplySearch.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForProgressApplySearch.h"
@implementation ProgressApplySearchRespone

@end
@implementation NetWorkForProgressApplySearch
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/progress.apply.search?mobile={mobile}";
}


- (Class)responseType {
    return [ProgressApplySearchRespone class];
}
@end
