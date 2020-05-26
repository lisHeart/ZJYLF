//
//  DataFactory.m
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/17.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import "DataFactory.h"
#import "FMDatabaseQueue.h"

@interface DataFactory ()
@property (nonatomic, strong) LKDAOBase *classValue;
@property (nonatomic, strong) NSMutableDictionary *dbDatDic;
@end

@implementation DataFactory
@synthesize classValue = _classValue;
@synthesize dbDatDic = _dbDatDic;

#define GetDBPath(name) [SandboxFile GetPathForDocuments:name inDir:nil]

+ (DataFactory *)sharedFactory
{
    static id SharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [[self alloc] init];
    });
    return SharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        self.dbDatDic = [NSMutableDictionary dictionary];
        NSString *dbPath = [SandboxFile GetPathForResource:@"DBConfig.plist"];
        NSDictionary *dbConfig = [NSDictionary dictionaryWithContentsOfFile:dbPath];
        for (NSString *dbName in [dbConfig allKeys])
        {
            NSArray *dbItem = dbConfig[dbName];
            FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:GetDBPath(dbName)];
            for (NSDictionary *item in dbItem)
            {
                if ([item[@"tableName"] length] <= 0 || [item[@"modelName"] length] <=0){
                    continue;
                }
                NSMutableDictionary *temp = [NSMutableDictionary dictionary];
                [temp setObject:item[@"tableName"] forKey:@"tableName"];
                [temp setObject:queue forKey:@"queue"];
                if (item[@"primaryKey"]) {
                    [temp setObject:item[@"primaryKey"] forKey:@"primaryKey"];
                }
                [self.dbDatDic setObject:temp forKey:item[@"modelName"]];
            }
        }
    }
    return self;
}

- (id)Factory:(Class)modelClass
{
    NSDictionary *item = self.dbDatDic[NSStringFromClass(((NSObject *)modelClass).class)];
    
    LKDAOBase *dataBase = [[LKDAOBase alloc] initWithDBQueue:item[@"queue"]
                                                   tableName:item[@"tableName"]
                                                  primaryKey:item[@"primaryKey"]
                                                  modelClass:((NSObject *)modelClass).class];
    
    return dataBase;
}

- (void)insertToDB:(id)model
{
    
    self.classValue = [self Factory:model];
    [self.classValue insertToDB:model callback:^(BOOL Values) {

    }];
}

- (void)updateToDB:(id)model
{
    self.classValue = [self Factory:model];
    [self.classValue updateToDB:model callback:^(BOOL Values) {
#ifdef FMDB_LOG
        TPLLOG (@"修改%d", Values);
#endif
    }];
}

- (void)deleteToDB:(id)model
{
    self.classValue = [self Factory:model];
    [self.classValue deleteToDB:model callback:^(BOOL Values) {
#ifdef FMDB_LOG
        TPLLOG (@"删除%d", Values);
#endif
    }];
}

- (void)isExistsModel:(id)model callback:(void (^)(BOOL))block{
    self.classValue = [self Factory:model];
    [self.classValue isExistsModel:model callback:^(BOOL Values) {
        TPLLOG (@"%d", Values);
        block(Values);
    }];
}

- (void)clearTableData:(Class)modelClass
{
    self.classValue = [self Factory:modelClass];
    [self.classValue clearTableData];
#ifdef FMDB_LOG
    TPLLOG (@"删除全部数据");
#endif
}

- (void)deleteWhereData:(NSDictionary *)data Class:(Class)modelClass
{
    self.classValue = [self Factory:modelClass];
    [self.classValue deleteToDBWithWhereDic:data callback:^(BOOL Values) {
#ifdef FMDB_LOG
        TPLLOG (@"删除成功");
#endif
    }];
}

- (void)search:(Class)modelClass
         where:(NSString *)key
         value:(NSString *)value
      callback:(void(^)(NSArray *))result
{
    self.classValue = [self Factory:modelClass];
    if (key == nil || value == nil) {
        [self.classValue searchWhere:nil
                             orderBy:nil
                              offset:-1
                               count:15
                            callback:^(NSArray *array) {
                                result(array);
        }];
    } else {
        [self.classValue searchWhereDic:@{key:value}
                                orderBy:key
                                 offset:-1
                                  count:15
                               callback:^(NSArray *array) {
                                   result(array);
                               }];
    }
}

- (void)searchWhere:(NSDictionary *)where
            orderBy:(NSString *)columeName
             offset:(int)offset
              count:(int)count
              Class:(Class)modelClass
           callback:(void (^)(NSArray *))result
{
    self.classValue = [self Factory:modelClass];
    [self.classValue searchWhereDic:where
                            orderBy:columeName
                             offset:offset
                              count:count
                           callback:^(NSArray *array) {
                               result(array);
    }];
}

- (void)searchBySQL:(NSString *)sql
              Class:(Class)modelClass
           callback:(void(^)(NSArray *))result {
    self.classValue = [self Factory:modelClass];
    [self.classValue sqlSearch:sql callback:^(NSArray *array) {
        result(array);
    }];
}


@end
