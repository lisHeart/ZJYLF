//
//  NetWorkForFocuspictureGetlist.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForFocuspictureGetlist.h"
@implementation pageDataModel

@end
@implementation dataModel
- (NSDictionary *)classNameForItemInArray {
    return @{@"pagedata":@"pageDataModel"};
}
@end
@implementation FocuspictureGetlistRespone

@end
@implementation NetWorkForFocuspictureGetlist
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/focuspicture.getlist";
}

- (Class)responseType {
    return [FocuspictureGetlistRespone class];
}
@end
