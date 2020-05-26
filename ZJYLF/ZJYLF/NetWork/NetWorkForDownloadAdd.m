//
//  NetWorkForDownloadAdd.m
//  ZJYLF
//
//  Created by 刘高洋 on 2019/3/17.
//  Copyright © 2019年 hymac. All rights reserved.
//

#import "NetWorkForDownloadAdd.h"
@implementation DownloadAddPostmodel

@end
@implementation DownloadAddRespone

@end
@implementation NetWorkForDownloadAdd
- (NSString*)getInterfaceUrl{
    return @"/yunlifang/app.download.record.add";
}


- (Class)responseType {
    return [DownloadAddRespone class];
}
@end
