//
//  NetWorkForCompanyGetlist.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForCompanyGetlist.h"
@implementation CompanyGetlistPagedata

@end
@implementation CompanyGetlistData
- (NSDictionary *)classNameForItemInArray {
    return @{@"pagedata":@"CompanyGetlistPagedata"};
}
@end
@implementation CompanyGetlistRespone

@end

@implementation NetWorkForCompanyGetlist
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/company.getlist";
}

- (Class)responseType {
    return [CompanyGetlistRespone class];
}
@end
