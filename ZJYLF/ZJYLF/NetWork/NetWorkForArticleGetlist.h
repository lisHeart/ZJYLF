//
//  NetWorkForArticleGetlist.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/25.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WCServiceBase_Test.h"
@interface PageDataModel : IObjcJsonBase

@property (nonatomic, copy) NSString *articletitle;
@property (nonatomic, copy) NSString *articlecontent;
@property (nonatomic, copy) NSString *articlepicture;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *createtime;

//文章类型 0，公告 1，互动 2，政策
@property (nonatomic, strong) NSNumber *typeid;
@property (nonatomic, strong) NSNumber *istop;
@property (nonatomic, strong) NSNumber *isdeleted;


@end
@interface ArticleGetlistResponeModel : IObjcJsonBase
@property (nonatomic, strong) NSNumber *currentpageindex;
@property (nonatomic, strong) NSNumber *pagesize;
@property (nonatomic, strong) NSNumber *totalitemcount;
@property (nonatomic, strong) NSNumber *totalpagecount;
@property (nonatomic, strong) NSNumber *hasnextpage;
@property (nonatomic, strong) NSNumber *haspreviouspage;
@property (nonatomic, strong) NSArray *pagedata;


@end
@interface ArticleGetlistRespone : IObjcJsonBase

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)ArticleGetlistResponeModel *data;

@end
@interface NetWorkForArticleGetlist : WCServiceBase_Test

@property (nonatomic, copy) NSString *Pageindex;
@property (nonatomic, copy) NSString *Pagesize;
@property (nonatomic, copy) NSString *Articletype;

@end
