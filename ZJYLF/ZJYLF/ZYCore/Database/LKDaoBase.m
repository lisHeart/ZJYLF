//
//
//  Created by y h on 12-10-9.
//  Copyright (c) 2012年 SKY. All rights reserved.
//

#import "LKDAOBase.h"
#import <objc/runtime.h>
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "SandboxFile.h"


@interface LKDAOBase ()
@property(retain,nonatomic)NSString* tableName;  //数据库表名称
@property(retain,nonatomic)NSString* primaryKey; //数据库表主键，多个主键中间用逗号分开。如 @"key1,key2"
@property(retain,nonatomic)Class modelClass;     //数据库表模型

@property(readonly,nonatomic)NSString* primaryKeyFormatString;
@end

@implementation LKDAOBase
@synthesize columeNames;
@synthesize columeTypes;
@synthesize bindingQueue;
@synthesize tableName;
@synthesize modelClass;
@synthesize primaryKey;



-(id)initWithDBQueue:(FMDatabaseQueue*)queue
           tableName:(NSString*)tablename
          primaryKey:(NSString*)pKey
          modelClass:(Class)className {
    if (self = [super init]) {
        self.bindingQueue = queue;
        
        self.columeNames = [NSMutableArray arrayWithCapacity:16];
        self.columeTypes = [NSMutableArray arrayWithCapacity:16];
        
        self.tableName = tablename;
        self.primaryKey = pKey;
        self.modelClass = className;
        
        //获取绑定的 Model 并 保存 Model 的属性信息
        NSDictionary* dic  = [self.modelClass getPropertys];
        NSArray* pronames = [dic objectForKey:@"name"];
        NSArray* protypes = [dic objectForKey:@"type"];
        self.propertys = [NSMutableDictionary dictionaryWithObjects:protypes forKeys:pronames];
        for (int i =0; i<pronames.count; i++) {
            [self addColume:[pronames objectAtIndex:i] type:[protypes objectAtIndex:i]];
        }
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            onceCreateTable = [[NSMutableDictionary  alloc]initWithCapacity:8];
        });
        NSString* className = NSStringFromClass([self.modelClass class]);
        NSNumber* onceToCreate = [onceCreateTable objectForKey:className];
        if(onceToCreate.boolValue == NO) {
            [self createTable];
            onceToCreate = [NSNumber numberWithBool:YES];
            [onceCreateTable setObject:onceToCreate forKey:className];
        }
    }
    return self;
}

-(void)dealloc {
    self.bindingQueue = nil;
    self.propertys = nil;
    self.columeNames = nil;
    self.columeTypes = nil;
    self.tableName = nil;
    self.primaryKey = nil;
    self.modelClass = nil;
    [super dealloc];
}
static NSMutableDictionary* onceCreateTable;
+(void)clearCreateHistory {
    [onceCreateTable removeAllObjects];
}
-(void)createTable {
    if([self.tableName isEmptyWithTrim]) {
        NSLog(@"LKTableName is None!");
        return;
    }
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSString* createTable = nil;
        if (self.primaryKey.length > 0) {
            createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@, PRIMARY KEY(%@))",
                           self.tableName, [self getParameterString], self.primaryKey];
        } else {
            createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",
                           self.tableName, [self getParameterString]];
        }
        [db executeUpdate:createTable];
     }];
}

- (NSString*) primaryKeyFormatString {
    NSArray* keys = [self.primaryKey componentsSeparatedByString:@","];
    NSString* results = nil;
    for (NSString* key in keys) {
        if (nil == results) {
            results = [NSString stringWithFormat:@"%@=?", key];
        } else {
            results = [NSString stringWithFormat:@"%@ and %@=?", results, key];
        }
    }
    return results;
}

- (NSArray*) primaryKeyModelValue:(NSObject<LKModelBaseInteface>*) model {
    NSArray* keys = [self.primaryKey componentsSeparatedByString:@","];
    NSMutableArray* results = [NSMutableArray array];
    for (NSString* key in keys) {
        id value = [model valueForKey:key];
        if (value) {
            [results addObject:value];
        } else {
            [results addObject:@""];
        }
    }
    return results;
}

-(void)addColume:(NSString *)name type:(NSString *)type {
    [columeNames addObject:name];
    [columeTypes addObject:[LKDAOBase toDBType:type]];
}
-(void)addColumePrimary:(NSString *)name type:(NSString *)type {
    [columeNames addObject:name];
    [columeTypes addObject:[NSString stringWithFormat:@"%@ primary key",[LKDAOBase toDBType:type]]];
}
-(NSString *)getParameterString {
    NSMutableString* pars = [NSMutableString string];
    for (int i=0; i<columeNames.count; i++) {
        [pars appendFormat:@"%@ %@",[columeNames objectAtIndex:i],[columeTypes objectAtIndex:i]];
        if(i+1 !=columeNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}

-(void)searchAll:(void(^)(NSArray*))callback{
    [self searchWhere:nil orderBy:nil offset:0 count:15 callback:callback];
}
-(void)searchWhere:(NSString*)where callback:(void(^)(NSArray*))block{
    [self searchWhere:where orderBy:nil offset:0 count:15 callback:block];
}
-(void)searchWhereDic:(NSDictionary*)where callback:(void(^)(NSArray*))block{
    [self searchWhereDic:where orderBy:nil offset:0 count:15 callback:block];
}
-(void)searchWhere:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block
{
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select rowid,* from %@ ",self.tableName];
         if(where != nil && ![where isEmptyWithTrim]) {
             [query appendFormat:@" where %@",where];
         }
         [self sqlString:query AddOder:orderBy offset:offset count:count];
         FMResultSet* set =[db executeQuery:query];
         [self executeResult:set block:block];
     }];
}

- (void)sqlSearch:(NSString *)sql callback:(void(^)(NSArray *))block {
    [bindingQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *query = [NSMutableString stringWithString:sql];
        [self sqlString:query AddOder:nil offset:-1 count:INT_MAX];
        FMResultSet *set = [db executeQuery:query];
        [self executeResult:set block:block];
    }];
}

-(void)searchWhereDic:(NSDictionary*)where orderBy:(NSString *)orderby offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block
{
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select rowid,* from %@ ",self.tableName];
         
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
         if(where !=nil&& where.count>0) {
             NSString* wherekey = [self dictionaryToSqlWhere:where andValues:values];
             [query appendFormat:@" where %@",wherekey];
         }
         [self sqlString:query AddOder:orderby offset:offset count:count];
         FMResultSet* set =[db executeQuery:query withArgumentsInArray:values];
         [self executeResult:set block:block];
     }];
}
-(void)sqlString:(NSMutableString*)sql AddOder:(NSString*)orderby offset:(int)offset count:(int)count {
    if(orderby != nil && ![orderby isEmptyWithTrim]) {
        [sql appendFormat:@" order by %@ desc",orderby];
    }
    [sql appendFormat:@" limit %d offset %d ",count,offset];
}

- (void)executeResult:(FMResultSet *)set block:(void (^)(NSArray *))block {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        NSObject<LKModelBaseInteface>* bindingModel = [[[self.modelClass alloc]init] autorelease];
        bindingModel.rowid = [set intForColumnIndex:0];
        for (int i=0; i<self.columeNames.count; i++) {
            NSString* columeName = [self.columeNames objectAtIndex:i];
            NSString* columeType = [self.propertys objectForKey:columeName];
            if([@"intfloatdoublelongcharshort" rangeOfString:columeType].location != NSNotFound) {
                [bindingModel setValue:[NSNumber numberWithDouble:[set doubleForColumn:columeName]] forKey:columeName];
            } else if([columeType isEqualToString:@"NSString"] ||
                    [columeType isEqualToString:@"NSMutableString"]) {
                [bindingModel setValue:[set stringForColumn:columeName] forKey:columeName];
            } else if([columeType isEqualToString:@"UIImage"]) {
                NSString* filename = [set stringForColumn:columeName];
                if([SandboxFile IsFileExists:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"]]) {
                    UIImage* img = [UIImage imageWithContentsOfFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"]];
                    [bindingModel setValue:img forKey:columeName];
                }
            } else if([columeType isEqualToString:@"NSDate"]) {
                NSString* datestr = [set stringForColumn:columeName];
                [bindingModel setValue:[LKDAOBase dateWithString:datestr] forKey:columeName];
            } else if([columeType isEqualToString:@"NSData"] ||
                      [columeType isEqualToString:@"NSMutableData"]) {
                NSData* value = [set dataForColumn:columeName];
                [bindingModel setValue:value forKey:columeName];
            } else if([columeType isEqualToString:@"NSArray"] ||
                      [columeType isEqualToString:@"NSMutableArray"] ||
                      [columeType isEqualToString:@"NSDictionary"] ||
                      [columeType isEqualToString:@"NSMutableDictionary"] ||
                      [columeType isEqualToString:@"NSSet"] ||
                      [columeType isEqualToString:@"NSMutableSet"] ||
                      [NSClassFromString(columeType) isSubclassOfClass:[LKModelBase class]]){
                NSData* value = [set dataForColumn:columeName];
                if (value && value.length>2) {
                    id array = [NSKeyedUnarchiver unarchiveObjectWithData:value];
                    [bindingModel setValue:array forKey:columeName];
                }
            }
            else if([columeType isEqualToString:@"NSNumber"]) {
                [bindingModel setValue:[NSNumber numberWithDouble:[set doubleForColumn:columeName]] forKey:columeName];
            } else if([columeType isEqualToString:@"NSDecimalNumber"]) {
                [bindingModel setValue:[NSDecimalNumber numberWithDouble:[set doubleForColumn:columeName]] forKey:columeName];
            }
        }
        [array addObject:bindingModel];
    }
    [set close];
    block(array);
}
-(void)insertToDB:(NSObject<LKModelBaseInteface> *)model callback:(void (^)(BOOL))block{
    
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSDate* date = [NSDate date];
         NSMutableString* insertKey = [NSMutableString stringWithCapacity:0];
         NSMutableString* insertValuesString = [NSMutableString stringWithCapacity:0];
         NSMutableArray* insertValues = [NSMutableArray arrayWithCapacity:self.columeNames.count];
         for (int i=0; i<self.columeNames.count; i++) {
             
             NSString* proname = [self.columeNames objectAtIndex:i];
             [insertKey appendFormat:@"%@,", proname];
             [insertValuesString appendString:@"?,"];
             id value =[self safetyGetModel:model valueKey:proname];
             if([value isKindOfClass:[UIImage class]]) {
                 NSString* filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
                 [UIImageJPEGRepresentation(value, 1) writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
                 value = filename;
             }
             else if([value isKindOfClass:[NSArray class]] ||
                     [value isKindOfClass:[NSDictionary class]] ||
                     [value isKindOfClass:[NSSet class]] ||
                     [value isKindOfClass:[LKModelBase class]]) {
                 value = [NSKeyedArchiver archivedDataWithRootObject:value];
             }
             else if([value isKindOfClass:[NSDate class]]) {
                 value = [LKDAOBase stringWithDate:value];
             }
             [insertValues addObject:value];
         }
         [insertKey deleteCharactersInRange:NSMakeRange(insertKey.length - 1, 1)];
         [insertValuesString deleteCharactersInRange:NSMakeRange(insertValuesString.length - 1, 1)];
         NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",self.tableName,insertKey,insertValuesString];
         BOOL execute = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
//         model.rowid = db.lastInsertRowId;
         if(block != nil){
             block(execute);
         }
         if(execute == NO) {
             NSLog(@"database insert fail %@",NSStringFromClass(model.class));
         }
     }];
}
-(void)updateToDB:(NSObject<LKModelBaseInteface> *)model callback:(void (^)(BOOL))block {
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSDate* date = [NSDate date];
         NSMutableString* updateKey = [NSMutableString stringWithCapacity:0];
         NSMutableArray* updateValues = [NSMutableArray arrayWithCapacity:self.columeNames.count];
         for (int i=0; i<self.columeNames.count; i++) {
             
             NSString* proname = [self.columeNames objectAtIndex:i];
             [updateKey appendFormat:@" %@=?,", proname];
             
             id value =[self safetyGetModel:model valueKey:proname];
             if([value isKindOfClass:[UIImage class]]) {
                 NSString* filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
                 [UIImageJPEGRepresentation(value, 1) writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
                 value = filename;
             }
             else if([value isKindOfClass:[NSArray class]] ||
                     [value isKindOfClass:[NSDictionary class]] ||
                     [value isKindOfClass:[NSSet class]] ||
                     [value isKindOfClass:[LKModelBase class]]) {
                 value = [NSKeyedArchiver archivedDataWithRootObject:value];
             }
             else if([value isKindOfClass:[NSDate class]]) {
                 value = [LKDAOBase stringWithDate:value];
             }
             [updateValues addObject:value];
         }
         [updateKey deleteCharactersInRange:NSMakeRange(updateKey.length - 1, 1)];
         NSString* updateSQL;
         if(model.rowid > 0) {
             updateSQL = [NSString stringWithFormat:@"update %@ set %@ where rowid=%d",
                          self.tableName,updateKey,model.rowid];
         }
         else {
             //如果不通过 rowid 来 更新数据  那 primarykey 一定要有值
             updateSQL = [NSString stringWithFormat:@"update %@ set %@ where %@",
                          self.tableName,updateKey,self.primaryKeyFormatString];
             [updateValues addObjectsFromArray:[self primaryKeyModelValue:model]];
         }
         BOOL execute = [db executeUpdate:updateSQL withArgumentsInArray:updateValues];
         if(block != nil) {
             block(execute);
         }
         if(execute == NO) {
             NSLog(@"database update fail %@   ----->rowid: %d",NSStringFromClass(model.class),model.rowid);
         }
     }];
}
-(void)deleteToDB:(NSObject<LKModelBaseInteface> *)model callback:(void (^)(BOOL))block{
    
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSString* delete;
         BOOL result;
         if(model.rowid > 0){
             delete = [NSString stringWithFormat:@"DELETE FROM %@ where rowid=%d",self.tableName,model.rowid];
             result = [db executeUpdate:delete];
         }
         else {
             delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@",self.tableName,self.primaryKeyFormatString];
             result = [db executeUpdate:delete withArgumentsInArray:[self primaryKeyModelValue:model]];
         }
         if(block != nil) {
             block(result);
         }
     }];
}
-(void)deleteToDBWithWhere:(NSString *)where callback:(void (^)(BOOL))block
{
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@",self.tableName,where];
         BOOL result = [db executeUpdate:delete];
         if(block != nil) {
             block(result);
         }
     }];
}
-(NSString*)dictionaryToSqlWhere:(NSDictionary*)dic andValues:(NSMutableArray*)values {
    NSMutableString* wherekey = [NSMutableString stringWithCapacity:0];
    if(dic != nil && dic.count >0 ) {
        NSArray* keys = dic.allKeys;
        for (int i=0; i< keys.count;i++) {
            NSString* key = [keys objectAtIndex:i];
            id va = [dic objectForKey:key];
            if([va isKindOfClass:[NSArray class]]) {
                NSArray* vlist = va;
                for (int j=0; j<vlist.count; j++) {
                    id subvalue = [vlist objectAtIndex:j];
                    if(wherekey.length > 0) {
                        if(j >0) {
                            [wherekey appendFormat:@" or %@ = ? ",key];
                        } else{
                            [wherekey appendFormat:@" and %@ = ? ",key];
                        }
                    } else {
                        [wherekey appendFormat:@" %@ = ? ",key];
                    }
                    [values addObject:subvalue];
                }
            } else {
                if(wherekey.length > 0){
                    [wherekey appendFormat:@" and %@ = ? ",key];
                } else{
                    [wherekey appendFormat:@" %@ = ? ",key];
                }
                [values addObject:va];
            }
            
        }
    }
    return wherekey;
}
-(void)deleteToDBWithWhereDic:(NSDictionary *)where callback:(void (^)(BOOL))block {
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:6];
         NSString* wherekey = [self dictionaryToSqlWhere:where andValues:values];
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@",self.tableName,wherekey];
         BOOL result = [db executeUpdate:delete withArgumentsInArray:values];
         if(block != nil) {
             block(result);
         }
     }];
}

-(void)clearTableData {
    [bindingQueue inDatabase:^(FMDatabase* db) {
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@",self.tableName];
         [db executeUpdate:delete];
     }];
}
-(void)isExistsModel:(NSObject<LKModelBaseInteface>*)model callback:(void(^)(BOOL))block{
    NSArray* keys = [self.primaryKey componentsSeparatedByString:@","];
    NSString* where = nil;
    for (NSString* key in keys) {
        id value = [model valueForKey:key];
        if (nil == value) {
            value = @"";
        }
        if (nil==where) {
            where = [NSString stringWithFormat:@"%@='%@'", key, value];
        } else {
            where = [where stringByAppendingFormat:@",%@='%@'", key, value];
        }
    }
    
    //如果有rowid 就肯定存在
    [self isExistsWithWhere:where callback:block];
}

-(void)isExistsWithWhere:(NSString *)where callback:(void (^)(BOOL))block {
    [bindingQueue inDatabase:^(FMDatabase* db) {
         //rowid 就不判断了
         NSString* rowCountSql = [NSString stringWithFormat:@"select count(rowid) from %@ where %@",self.tableName,where];
         FMResultSet* resultSet = [db executeQuery:rowCountSql];
         [resultSet next];
         int result =  [resultSet intForColumnIndex:0];
         [resultSet close];
         BOOL exists = (result != 0);
         if(block != nil) {
             block(exists);
         }
     }];
}
-(id)safetyGetModel:(NSObject<LKModelBaseInteface>*) model valueKey:(NSString*)valueKey {
    id value = [model valueForKey:valueKey];
    if(value == nil) {
        value = @"";
    }
    
    return value;
}
const static NSString* normaltypestring = @"floatdoublelongcharshort";
const static NSString* blobtypestring = @"NSDataUIImageNSArrayNSDictionaryNSSetNSMutableDataNSMutableDictionaryNSMutableArray";
+(NSString *)toDBType:(NSString *)type {
    if([type isEqualToString:@"int"]) {
        return LKSQLInt;
    } else if ([normaltypestring rangeOfString:type].location != NSNotFound) {
        return LKSQLDouble;
    } else if ([blobtypestring rangeOfString:type].location != NSNotFound ||
               [NSClassFromString(type) isSubclassOfClass:[LKModelBase class]]) {
        return LKSQLBlob;
    } else {
        return LKSQLText;
    }
}
#pragma mark-
+(NSDateFormatter*)getDateFormat {
    static  NSDateFormatter* formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return formatter;
}
//把Date 转换成String
+(NSString*)stringWithDate:(NSDate*)date {
    NSDateFormatter* formatter = [self getDateFormat];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}
+(NSDate *)dateWithString:(NSString *)str {
    NSDateFormatter* formatter = [self getDateFormat];
    NSDate* date = [formatter dateFromString:str];
    return date;
}
@end
@implementation NSObject(LKGetPropertys)
+(NSDictionary *)getPropertys {
    NSMutableArray* pronames = [NSMutableArray array];
    NSMutableArray* protypes = [NSMutableArray array];
    NSDictionary* props = [NSDictionary dictionaryWithObjectsAndKeys:pronames,@"name",protypes,@"type",nil];
    [self getSelfPropertys:pronames protypes:protypes isGetSuper:NO];
    return props;
}
+ (void)getSelfPropertys:(NSMutableArray *)pronames protypes:(NSMutableArray *)protypes isGetSuper:(BOOL)isGetSuper {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if([propertyName isEqualToString:@"primaryKey"]||[propertyName isEqualToString:@"rowid"]) {
            continue;
        }
        [pronames addObject:propertyName];
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char
         i int
         l long
         s short
         d double
         f float
         @ id //指针 对象
         ...  BOOL 获取到的表示 方式是 char
         .... ^i 表示  int*  一般都不会用到
         */
        
        if ([propertyType hasPrefix:@"T@"]) {
            [protypes addObject:[propertyType substringWithRange:
                                 NSMakeRange(3, [propertyType rangeOfString:@","].location-4)]];
        } else if ([propertyType hasPrefix:@"Ti"]){
            [protypes addObject:@"int"];
        } else if ([propertyType hasPrefix:@"Tf"]){
            [protypes addObject:@"float"];
        } else if([propertyType hasPrefix:@"Td"]) {
            [protypes addObject:@"double"];
        } else if([propertyType hasPrefix:@"Tl"]){
            [protypes addObject:@"long"];
        } else if ([propertyType hasPrefix:@"Tc"]) {
            [protypes addObject:@"char"];
        } else if([propertyType hasPrefix:@"Ts"]){
            [protypes addObject:@"short"];
        }
    }
    free(properties);
    if(isGetSuper && ([self superclass] != [NSObject class] && [self superclass] != [LKModelBase class])) {
        [[self superclass] getSelfPropertys:pronames protypes:protypes isGetSuper:isGetSuper];
    }
}
@end
@implementation LKModelBase
@synthesize rowid;
+(NSDictionary *)getPropertys {
    NSMutableArray* pronames = [NSMutableArray array];
    NSMutableArray* protypes = [NSMutableArray array];
    NSDictionary* props = [NSDictionary dictionaryWithObjectsAndKeys:pronames,@"name",protypes,@"type",nil];
    [self getSelfPropertys:pronames protypes:protypes isGetSuper:YES];
    return props;
}
-(NSString *)description {
    NSMutableString* sb = [NSMutableString stringWithCapacity:0];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (0 == i) {
            [sb appendFormat:@"%@:%@",propertyName,[self valueForKey:propertyName]];
        } else {
            [sb appendFormat:@"; %@:%@",propertyName,[self valueForKey:propertyName]];
        }
    }
    free(properties);
    return sb;
}

@end

@implementation NSString(LKisEmpty)
-(BOOL)isEmptyWithTrim {
    return [[self stringWithTrim] isEqualToString:@""];
}
-(NSString *)stringWithTrim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
