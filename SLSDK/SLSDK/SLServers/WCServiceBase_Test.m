//
//  WCServiceBase.m
//  SLSDK
//
//  Created by songlei on 15/5/15.
//  Copyright (c) 2015年 songlei. All rights reserved.
//

#import "WCBaseConfiguration.h"
#import "WCServiceBase_Test.h"
#import "WCDataPacker.h"
#import "Reachability.h"
#import <objc/runtime.h>

@interface WCServiceBase_Test()
@property(nonatomic, strong) id <WCNetworkOperation> operation;
@end

@implementation WCServiceBase_Test

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.token = [WCBaseContext sharedInstance].userToken;
        self.grp = [WCBaseContext sharedInstance].configuration.group_name;
        self.ver = [WCBaseContext appVersion];
        self.platform = [WCBaseContext sharedInstance].configuration.platform_name;
        self.imei = [[UIDevice currentDevice] uniqueID];
        self.src = [self getSrc];
        self.lang = [[NSLocale preferredLanguages] objectAtIndex:0];
        self.timeout = 60;
    }
    return self;
}

- (NSString *)getSrc {
    NSString *retSrc = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPSRC"];
    if([retSrc length])
        return retSrc;
    else
    {
        retSrc = [WCBaseContext sharedInstance].configuration.src_name;
        [[NSUserDefaults standardUserDefaults] setObject:retSrc forKey:@"APPSRC"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return retSrc;
    }
}

- (void)omitPropertiesNeedToJson:(NSMutableArray *)propertiesToOmit
{
    [super omitPropertiesNeedToJson:propertiesToOmit];
    [propertiesToOmit addObject:@"uploadFileData"];
    [propertiesToOmit addObject:@"delegate"];
    [propertiesToOmit addObject:@"timeout"];

}

- (NSString *)prepareRequestUrl:(ERequstType_Test)requstType{
    /*
     替换版本请求参数，无需再接口类中定义
     */
    
    NSString *urlStr = self.interfaceUrl;
    NSString *interfaceVersion = [WCBaseContext sharedInstance].configuration.interfaceVersion;
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{VERSION}" withString:interfaceVersion];

    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    if(requstType == ERequestTypePost_Test){
        
        if(!self.postParamsPDic){
            self.postParamsPDic = [[NSMutableDictionary alloc] init];
        }
        
        for(int i = 0; i < count; i++){
            objc_property_t property = properties[i];
            
            const char * attributes = property_getAttributes(property);
            NSString *propertyString = [NSString stringWithUTF8String:attributes];
            NSString *startingString = @"T@\"";
            NSString *endingString = @"\",";
            NSInteger startingIndex = [propertyString rangeOfString:startingString].location +startingString.length;
            if (startingIndex < 0)  //非NSObject类型
                return nil;
            
            NSString *propType = [propertyString substringFromIndex:startingIndex];
            NSInteger endingIndex = [propType rangeOfString:endingString].location;
            
            NSString *propertName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            propType = [propType substringToIndex:endingIndex];
            id v = [self valueForKey:propertName];
            
            NSLog(@"name:%@",propertName);   //属性名称
            NSLog(@"propType:%@",propType);  //属性类型
            NSLog(@"v:%@",v);                //属性值
            
            /*
             如果是POST 处理body请求参数 self.postDic
             */
            Class propClass = NSClassFromString(propType);
            if([propClass isSubclassOfClass:[IObjcJsonBase class]]){
               NSMutableDictionary *vDic = [(IObjcJsonBase*)v generateJsonDict];
                NSLog(@"vDic:%@",vDic);
                self.postBodyDic = vDic;
            } else if ([propClass isSubclassOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray array];
                for (id obj in v) {
                    NSMutableDictionary *vDic = [(IObjcJsonBase*)obj generateJsonDict];
                    [array addObject:vDic];
                }
                self.postBodyArr = array;
            }
            else if ([propClass isSubclassOfClass:[NSMutableDictionary class]] && [propertName isEqualToString:@"filesDic"]){
                
                self.uploadFilesDic = v;
                
                continue;
            }
            else{
                [self.postParamsPDic setValue:v forKey:propertName];
            }
            
            /*
             替换参数
             */
            NSString *oldStr = [NSString stringWithFormat:@"{%@}",propertName];
            NSString *newStr = v;
            urlStr = [urlStr stringByReplacingOccurrencesOfString:oldStr withString:newStr];
        }
    }
    else{
        for(int i = 0; i < count; i++){
            objc_property_t property = properties[i];
            NSString *propertName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id v = [self valueForKey:propertName];
            
            NSLog(@"name:%@",propertName);
            NSLog(@"v:%@",v);
            
            NSString *oldStr = [NSString stringWithFormat:@"{%@}",propertName];
            NSString *newStr = v;
            if (!newStr) newStr = @"";
            urlStr = [urlStr stringByReplacingOccurrencesOfString:oldStr withString:newStr];
        }
    }
    
    free (properties);
    
    if (self.otherBaseUrl.length > 0) {
        urlStr = [NSString stringWithFormat:@"%@%@",self.otherBaseUrl,urlStr];
    }
    else {
        urlStr = [NSString stringWithFormat:@"%@%@",[WCBaseContext sharedInstance].configuration.naviURL,urlStr];
    }
    return urlStr;
}

- (Class)responseType{
    //override me!!!
    return [IObjcJsonBase class];
}


- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock
            progressBlock:(void (^)(float progress))progressBlock{
    
    NSString *requestUrlString = [self prepareRequestUrl:ERequestTypeGet_Test];
    
    if ([self.delegate respondsToSelector:@selector(startWithCursor)]) {
        [self.delegate startWithCursor];
    }
    
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        NSError *error0=[NSError errorWithDomain:@"525j" code:kServiceErrorCode userInfo:[NSDictionary dictionaryWithObject:@"没有网络" forKey:NSLocalizedDescriptionKey]];
        
        if (finishBlock)
            finishBlock(nil,error0);
        if ([self.delegate respondsToSelector:@selector(service:error:)]){
            [self.delegate service:self error:error0];
        }
        if ([self.delegate respondsToSelector:@selector(stopWatiCursor)]){
            [self.delegate stopWatiCursor];
        }
        
        [self showError:error0];
        
        return;
    }
    
    
    NSString *className = NSStringFromClass([self class]);
    if (![className isEqualToString:@"WENetWorkPwd"]) {
        [self checkPwd];
    }
    
    
    id<WCNetworkOperationProvider> connectionProvider = [[WCBaseContext sharedInstance] connectionProvider];
    NSLog(@"%@",connectionProvider);
    self.operation = [connectionProvider createGetRequest:requestUrlString
                                            progressBlock:^(float progress) {
                                              if (progressBlock)
                                                  progressBlock(progress);
                                            }
                                             successBlock:^(id responseData){
                                                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                   id file = nil;
                                                   id result = nil;
                                                   if ([responseData isKindOfClass:[NSData class]]) {
                                                       NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                       
                                                       NSLog(@"\r\n\r\n 接口请求类 [%@] \r\n请求类型GET \r\n 请求url = %@ \r\n   返回数据 = \r\n\r\n%@ \r\n\r\n",NSStringFromClass([self class]),requestUrlString,responseString);
                                                       
                                                       result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];
                                                   } else if ([responseData isKindOfClass:[NSDictionary class]]) {
                                                       
                                                       NSLog(@"\r\n\r\n 接口请求类 [%@] \r\n请求类型GET \r\n 请求url = %@ \r\n   返回数据 = \r\n\r\n%@ \r\n\r\n",NSStringFromClass([self class]),requestUrlString,responseData);
                                                       
                                                       result = [self composeResult:responseData attachedFile:file];
                                                   }

                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       if([self.delegate respondsToSelector:@selector(stopWatiCursor)]){
                                                           [self.delegate stopWatiCursor];
                                                       }
                                                       if (finishBlock)
                                                           finishBlock(result, nil);
                                                       if([self.delegate respondsToSelector:@selector(service:successed:)]){
                                                           [self.delegate service:self successed:result];
                                                       }
                                                   });
                                                   self.operation= nil;
                                               });
                                           }
                                            failedBlock:^(NSError *error0){
                                                NSLog(@"%@ Service Error. ErrorCode: %i. Error Description:%@", NSStringFromClass([self class]),(int)error0.code, [error0 localizedDescription]);
                                                if (finishBlock)
                                                    finishBlock(nil, error0);
                                                if([self.delegate respondsToSelector:@selector(service:error:)])
                                                    [self.delegate service:self error:error0];
                                                if([self.delegate respondsToSelector:@selector(stopWatiCursor)]){
                                                    [self.delegate stopWatiCursor];
                                                }
                                                self.operation= nil;
                                            } cancelBlock:nil
                                                timeout:self.timeout];
}


- (NSMutableDictionary *)composeParams
{
    return [self generateJsonDict];
}

- (void) startPostWithBlock:(void (^)(id result, NSError *error))finishBlock
    progressBlock:(void (^)(float progress))progressBlock
{
    
    NSString *requestUrlString = [self prepareRequestUrl:ERequestTypePost_Test];
    
    if ([self.delegate respondsToSelector:@selector(startWithCursor)]) {
        [self.delegate startWithCursor];
    }
    
    if(![[Reachability reachabilityForInternetConnection] isReachable])
    {
        NSError *error0 = [NSError errorWithDomain:@"525j" code:kServiceErrorCode userInfo:[NSDictionary dictionaryWithObject:@"没有网络" forKey:NSLocalizedDescriptionKey]];
        if (finishBlock)
            finishBlock(nil,error0);
        
        if([self.delegate respondsToSelector:@selector(service:error:)]){
            [self.delegate service:self error:error0];
        }
        if([self.delegate respondsToSelector:@selector(stopWatiCursor)]){
            [self.delegate stopWatiCursor];
        }
        
        [self showError:error0];
        
        return;
    }
    
    
    NSString *className = NSStringFromClass([self class]);
    if (![className isEqualToString:@"WENetWorkPwd"]) {
        [self checkPwd];
    }
    
    
    id<WCNetworkOperationProvider> connectionProvider = [[WCBaseContext sharedInstance] connectionProvider];

    self.operation=[connectionProvider createPostRequest:requestUrlString
                                                fileData:self.uploadFileData
                                             postBodyDic:self.postBodyDic
                                             postBodyArr:self.postBodyArr
                                           postParamsDic:self.postParamsPDic
                                                fileName:([self.uploadFileName length]?self.uploadFileName:@"file")
                                             contentType:@"application/octet-stream"
                                         uploadFilesDic:self.uploadFilesDic
                                           progressBlock:^(float progress) {
                                               if (progressBlock)
                                                   progressBlock(progress);
                                           }
                                            successBlock:^(NSData *responseData){
                                                
                                                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                    id file = nil;
                                                    id result = nil;
                                                    if ([responseData isKindOfClass:[NSData class]]) {
                                                        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                     
                                                        NSLog(@"\r\n\r\n 接口请求类 [%@] \r\n请求类型GET \r\n 请求url = %@ \r\n   返回数据 = \r\n\r\n%@ \r\n\r\n",NSStringFromClass([self class]),requestUrlString,responseString);
                                                        
                                                        result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];
                                                    } else if ([responseData isKindOfClass:[NSDictionary class]]) {
                                                        NSLog(@"\r\n\r\n 接口请求类 [%@] \r\n请求类型GET \r\n 请求url = %@ \r\n   返回数据 = \r\n\r\n%@ \r\n\r\n",NSStringFromClass([self class]),requestUrlString,responseData);
                                                        
                                                        result = [self composeResult:responseData attachedFile:file];
                                                    }
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if([self.delegate respondsToSelector:@selector(stopWatiCursor)]){
                                                            [self.delegate stopWatiCursor];
                                                        }
                                                        if (finishBlock)
                                                            finishBlock(result, nil);
                                                        if([self.delegate respondsToSelector:@selector(service:successed:)]){
                                                            [self.delegate service:self successed:result];
                                                        }
                                                    });
                                                    self.operation = nil;
                                                });
                                                
                                            }
                                             failedBlock:^(NSError *error0){
                                                
                                                 NSLog(@"%@ Service Error. ErrorCode: %i. Error Description:%@", NSStringFromClass([self class]),(int)error0.code, [error0 localizedDescription]);
                                                 
                                                 if (error0.code == 12) {
                                                     if ([self respondsToSelector:@selector(updateVersion)]) {
                                                         [self updateVersion];
                                                     }
                                                 } else if (error0.code == 3) {
                                                     if ([self respondsToSelector:@selector(authenticationError)]) {
                                                         [self authenticationError];
                                                     }
                                                 } else {
                                                     if (finishBlock)
                                                         finishBlock(nil, error0);
                                                     if([self.delegate respondsToSelector:@selector(service:error:)])
                                                         [self.delegate service:self error:error0];
                                                     if([self.delegate respondsToSelector:@selector(stopWatiCursor)]){
                                                         [self.delegate stopWatiCursor];
                                                     }
                                                 }
                                                 self.operation = nil;
                                             }
                                             cancelBlock:nil
                                                  forKey:@"upload"
                                                 timeout:self.timeout];

}

- (void)startGetRequest{
    
    [self startGetWithBlock:nil progressBlock:nil];
    
}

- (void)startPostRequest{
    [self startPostWithBlock:nil progressBlock:nil];
}


- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock {
    [self startGetWithBlock:finishBlock progressBlock:nil];
}

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock
{
    [self startPostWithBlock:finishBlock progressBlock:nil];
}


- (id)composeResult:(NSDictionary *)dictionary attachedFile:(id)file
{
    id result=nil;
    if([[self responseType] isSubclassOfClass:[IObjcJsonBase class]])
    {
        result= [[[self responseType] alloc] initWithDictionary:dictionary];
        ((IObjcJsonBase *)result).attachedFile=file;
    }
    else
    {
        result = dictionary;
    }
    return result;
}

- (void)appendExtras:(NSDictionary *)extra
{
    if ([extra count])
        for (NSString *key in [extra allKeys])
            [self setValue:[extra objectForKey:key] forKey:key];
}

- (void)stop
{
    [self.operation cancel];
}

/**
 * WJServiceBase 实现错误消息处理
 */
- (void)showError:(NSError *)error {
    
}

/**
 ＊ WJServiceBase 处理
 * 网络请求前，进行密码验证
 */
- (void)checkPwd {
    
}


/**
 * 版本号错误，进行版本升级
 */
- (void)updateVersion {

}

/**
 * 用户名或密码错误，重新登录
 */
- (void)authenticationError {
    
}

- (void)dealloc
{
    NSLog(@"Finalize Service:%@", [self debugDescription]);
    [self stop];
}

@end
