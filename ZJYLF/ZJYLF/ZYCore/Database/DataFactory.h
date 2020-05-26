//
//  DataFactory.h
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/17.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandboxFile.h"

#define DB      [DataFactory sharedFactory]

@interface DataFactory : NSObject

+ (DataFactory *)sharedFactory;
- (id)Factory:(Class)modelClass;
- (void)insertToDB:(id)model;
- (void)updateToDB:(id)model;
- (void)deleteToDB:(id)model;
- (void)isExistsModel:(id)model callback:(void (^)(BOOL))block;
- (void)clearTableData:(Class)modelClass;
- (void)deleteWhereData:(NSDictionary *)data Class:(Class)modelClass;
- (void)searchWhere:(NSDictionary *)where
            orderBy:(NSString *)columeName
             offset:(int)offset
              count:(int)count
              Class:(Class)modelClass
           callback:(void(^)(NSArray *))result;
- (void)searchBySQL:(NSString *)sql
              Class:(Class)modelClass
           callback:(void(^)(NSArray *))result;
- (void)search:(Class)modelClass
         where:(NSString *)key
         value:(NSString *)value
      callback:(void(^)(NSArray *))result;
- (void)search:(id)model
         class:(Class)modelClass
      callback:(void(^)(NSArray *))result;
@end
