//
//  NetWorkForArticleGetlist.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/25.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "NetWorkForArticleGetlist.h"

@implementation PageDataModel

@end
@implementation ArticleGetlistResponeModel
- (NSDictionary *)classNameForItemInArray {
    return @{@"pagedata" : @"PageDataModel"};
}
@end
@implementation ArticleGetlistRespone

@end
@implementation NetWorkForArticleGetlist
- (NSString *)getInterfaceUrl {

    return @"/article/article.getlist?articletype={Articletype}&pageindex={Pageindex}&pagesize={Pagesize}";
    
}

- (Class)responseType {
    return [ArticleGetlistRespone class];
}
@end
