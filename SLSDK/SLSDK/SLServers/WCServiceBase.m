//
//  WCServiceBase.m
//  SLSDK
//
//  Created by songlei on 15/5/15.
//  Copyright (c) 2015年 songlei. All rights reserved.
//

#import "WCBaseConfiguration.h"
#import "WCServiceBase.h"
//#import "WCNaviServiceItemsManager.h"
#import "WCDataPacker.h"
#import "Reachability.h"

@interface WCServiceBase()
@property(nonatomic, strong) id <WCNetworkOperation> operation;
@end

@implementation WCServiceBase

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
        //self.urlString= [WCBaseContext sharedInstance].naviServiceManager.rootItem.query;
        self.timeout=60;
        
        self.urlString = @"http://139.219.136.240:8087/plugin.servlet"; //导航地址返回的请求基地址
        self.timeout=60;
        
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

- (NSString *)prepareRequestUrl:(ERequstType)requstType{ //如果导航地址没有请求到，下一次啊有网络请求，重新获取导航地址
    NSString *url= nil;
    
    self.urlString = @"http://babycare.wincrm.net:9015/plugin.servlet";

    
    switch (requstType)
    {
        case ERequestTypeGet:
            url=self.urlString;
//            if ([url length]==0)
//                url= [[WCBaseContext sharedInstance].naviServiceManager.rootItem.query stringWithTrimWhiteSpcace];
//            if(_useNaviSquare&&[[WCBaseContext sharedInstance].naviServiceManager.rootItem.navSquare length])
//                url=[WCBaseContext sharedInstance].naviServiceManager.rootItem.navSquare;
            break;
        case ERequestTypePost:
            url=self.urlString;
//            if ([url length]==0)
//                url= [[WCBaseContext sharedInstance].naviServiceManager.rootItem.upload stringWithTrimWhiteSpcace];
//            if(_useNaviSquare&&[[WCBaseContext sharedInstance].naviServiceManager.rootItem.navSquare length])
//                url=[WCBaseContext sharedInstance].naviServiceManager.rootItem.navSquare;
            break;
        default:
            break;
    }
    return url;
}

- (WCDataPacker *)prepareDataPacker
{
    WCDataPacker * packer =[[WCDataPacker alloc] init];
    //packer.salt = [WCBaseContext sharedInstance].naviServiceManager.rootItem.salt;
    
    packer.salt = @"7238799724734f41992b3890d575bb1d";

    return packer;
}


- (UInt16)serviceType
{
    NSString *serviceTypeName= NSStringFromClass([self class]);
    // "WCxxxService" 截取中间的type
    UInt32 typeLength= (UInt32)([serviceTypeName length] - 9);//"WC"+"Service"=9个字符
    NSString *serviceTypeNum= [serviceTypeName substringWithRange:NSMakeRange(2, typeLength)];

    int serviceType=[serviceTypeNum intValue];
    if(serviceType)
        return (UInt16)serviceType;
    else
        @throw [NSException exceptionWithName:@"Invalid Service Type" reason:@"Invalid Service Type" userInfo:nil];
}

- (Class)responseType
{
    //override me!!!
    return [IObjcJsonBase class];
}


- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock
            progressBlock:(void (^)(float progress))progressBlock
{
    
    self.urlString= [self prepareRequestUrl:ERequestTypeGet];
    
     WCDataPacker *packer = [self prepareDataPacker]; //
    
    

    
    
    NSDictionary *jsonDict = [self composeParams];
    NSString *json= [jsonDict JSONString];
    
    
    NSLog(@"json = %@",json);
    
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@?type=%d&info=%@",
                           self.urlString,
                           [self serviceType],
                           [packer packStringWithZip:json]];
    
    NSLog(@"urlString = %@",urlString);
    
    UInt16 serviceType= [self serviceType];
    
    if(![[Reachability reachabilityForInternetConnection] isReachable])
    {
//        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, NSLocalizedString(@"common_string_remind_network_error", nil));
//        WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, @"断网");
        
        NSLog(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode);
        
        NSError *error0=[NSError errorWithDomain:@"WinCRM" code:kServiceErrorCode userInfo:[NSDictionary dictionaryWithObject:@"无法访问网络" forKey:NSLocalizedDescriptionKey]];
        if (finishBlock)
            finishBlock(nil,error0);
        if([self.delegate respondsToSelector:@selector(service:error:)])
            [self.delegate service:self error:error0];
        return;
    }
    
    id<WCNetworkOperationProvider> connectionProvider= [[WCBaseContext sharedInstance] connectionProvider];
    
    NSLog(@"-------------");
    
    self.operation=[connectionProvider createGetRequest:urlString
                                          progressBlock:progressBlock
                                           successBlock:^(NSData *responseData){
                                               dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                   UInt16 type = 0;
                                                   UInt32 errorCode = 0;
                                                   NSData *contentData = nil;
                                                   id file= nil;
                                                   
                                                   [packer getResponseInfo:responseData type:&type errorCode:&errorCode content:&contentData file:&file];
                                                   if (type == serviceType && (errorCode == 0 || errorCode  == serviceType*1000 ) && contentData)
                                                   {
                                                       NSData *parsedData = [packer unpackDataWithUnzip:contentData];
                                                       NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
                                                       NSLog(@"Service %d Response: %@", serviceType, responseString);
                                                       id result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           if (finishBlock)
                                                               finishBlock(result, nil);
                                                           if([self.delegate respondsToSelector:@selector(service:successed:)])
                                                               [self.delegate service:self successed:result];
                                                       });
                                                   }
                                                   else
                                                   {
                                                       NSDictionary *userInfo= nil;
                                                       if(contentData)
                                                       {
                                                           NSData *parsedData = [packer unpackDataWithUnzip:contentData];
                                                           NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
                                                           NSLog(@"Service %d with error Response: %@", serviceType, responseString);
                                                           userInfo= [responseString objectFromJSONString];
                                                       }
                                                       if (!userInfo)
                                                           userInfo = [NSDictionary dictionary];
                                                       
                                                       NSError *error2=[NSError errorWithDomain:@"WCService" code:errorCode userInfo:userInfo];
                                                       
                                                       NSLog(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
                                                       
//                                                       WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           if (finishBlock)
                                                               finishBlock(nil, error2);
                                                           if([self.delegate respondsToSelector:@selector(service:error:)])
                                                               [self.delegate service:self error:error2];
                                                       });
                                                   }
                                                   self.operation= nil;
                                               });
                                           }
                                            failedBlock:^(NSError *error0){
                                                NSLog(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error0.code, [error0 localizedDescription]);
//                                                WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error0.code, [error0 localizedDescription]);
                                                if (finishBlock)
                                                    finishBlock(nil, error0);
                                                if([self.delegate respondsToSelector:@selector(service:error:)])
                                                    [self.delegate service:self error:error0];
                                                self.operation= nil;
                                            } cancelBlock:nil
                                                timeout:self.timeout];
    
    
    
    
    
    
    /*
    self.urlString= [self prepareRequestUrl:ERequestTypeGet];
    
    WCDataPacker *packer = [self prepareDataPacker];

    NSDictionary *jsonDict = [self composeParams];
    NSString *json= [jsonDict JSONString];

    DDLogVerbose(@"Service %i Request:%@", [self serviceType], json);

    NSString *urlString = [NSString stringWithFormat:@"%@?type=%d&info=%@",
                                                     self.urlString,
                                                     [self serviceType],
                                                     [packer packStringWithZip:json]];
    UInt16 serviceType= [self serviceType];

    if(![[Reachability reachabilityForInternetConnection] isReachable])
    {
        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, NSLocalizedString(@"common_string_remind_network_error", nil));
        WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, @"断网");
        NSError *error0=[NSError errorWithDomain:@"WinCRM" code:kServiceErrorCode userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"common_string_remind_network_error", nil) forKey:NSLocalizedDescriptionKey]];
        if (finishBlock)
            finishBlock(nil,error0);
        if([self.delegate respondsToSelector:@selector(service:error:)])
            [self.delegate service:self error:error0];
        return;
    }

    id<WCNetworkOperationProvider> connectionProvider= [[WCBaseContext sharedInstance] connectionProvider];
    self.operation=[connectionProvider createGetRequest:urlString
                        progressBlock:progressBlock
                         successBlock:^(NSData *responseData){
                             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                 UInt16 type = 0;
                                 UInt32 errorCode = 0;
                                 NSData *contentData = nil;
                                 id file= nil;
                                 
                                 [packer getResponseInfo:responseData type:&type errorCode:&errorCode content:&contentData file:&file];
                                 if (type == serviceType && (errorCode == 0 || errorCode  == serviceType*1000 ) && contentData)
                                 {
                                     NSData *parsedData = [packer unpackDataWithUnzip:contentData];
                                     NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
                                     DDLogVerbose(@"Service %d Response: %@", serviceType, responseString);
                                     id result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];

                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (finishBlock)
                                             finishBlock(result, nil);
                                         if([self.delegate respondsToSelector:@selector(service:successed:)])
                                             [self.delegate service:self successed:result];
                                     });
                                 }
                                 else
                                 {
                                     NSDictionary *userInfo= nil;
                                     if(contentData)
                                     {
                                         NSData *parsedData = [packer unpackDataWithUnzip:contentData];
                                         NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
                                         DDLogVerbose(@"Service %d with error Response: %@", serviceType, responseString);
                                         userInfo= [responseString objectFromJSONString];
                                     }
                                     if (!userInfo)
                                         userInfo = [NSDictionary dictionary];

                                     NSError *error2=[NSError errorWithDomain:@"WCService" code:errorCode userInfo:userInfo];
                                     
                                     DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
                                     WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                            if (finishBlock)
                                                finishBlock(nil, error2);
                                            if([self.delegate respondsToSelector:@selector(service:error:)])
                                                [self.delegate service:self error:error2];
                                     });
                                 }
                                 self.operation= nil;
                             });
                         }
                          failedBlock:^(NSError *error0){
                              DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error0.code, [error0 localizedDescription]);
                              WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error0.code, [error0 localizedDescription]);
                              if (finishBlock)
                                  finishBlock(nil, error0);
                              if([self.delegate respondsToSelector:@selector(service:error:)])
                                  [self.delegate service:self error:error0];
                              self.operation= nil;
                          } cancelBlock:nil
                              timeout:self.timeout];
   */
    
    
    
    
    
    
    
}

- (NSMutableDictionary *)composeParams
{
    return [self generateJsonDict];
}

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock
    progressBlock:(void (^)(float progress))progressBlock
{

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    self.urlString= [self prepareRequestUrl:ERequestTypePost];

    WCDataPacker *packer = [self prepareDataPacker];
    NSDictionary *jsonDict = [self composeParams];

    DDLogVerbose(@"Service %i Post:%@", [self serviceType], [jsonDict JSONString]);

    NSData *jsonData = [jsonDict JSONData];

    UInt16 serviceType=[self serviceType];

    if(![[Reachability reachabilityForInternetConnection] isReachable])
    {
        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, @"断网");
        WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, @"断网");
        NSError *error0=[NSError errorWithDomain:@"WinCRM" code:kServiceErrorCode userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"common_string_remind_network_error", nil) forKey:NSLocalizedDescriptionKey]];
        if (finishBlock)
            finishBlock(nil,error0);
        if([self.delegate respondsToSelector:@selector(service:error:)])
            [self.delegate service:self error:error0];
        return;
    }

    id<WCNetworkOperationProvider> connectionProvider= [[WCBaseContext sharedInstance] connectionProvider];
    NSData *parckedData= nil;
    if (self.uploadFileData)
        parckedData=[packer generatePost:[packer packDataWithZip:jsonData] forType:[self serviceType]
                                withFile:[packer packData:self.uploadFileData]];
    else
        parckedData=[packer generatePost:[packer packDataWithZip:jsonData] forType:[self serviceType]];
    self.operation=[connectionProvider createPostRequest:self.urlString fileData:parckedData
                              fileName:([self.uploadFileName length]?self.uploadFileName:@"file")
                           contentType:@"application/octet-stream"
                         progressBlock:progressBlock
                          successBlock:^(NSData *responseData){
                              dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                  UInt16 type = 0;
                                  UInt32 errorCode = 0;
                                  NSData *contentData = nil;
                                  id file= nil;
                                  [packer getResponseInfo:responseData type:&type errorCode:&errorCode content:&contentData file:&file];
                                  if (type == serviceType &&  (errorCode == 0 || errorCode  == serviceType*1000 ) && contentData)
                                  {
                                      NSData *parsedData = [packer unpackDataWithUnzip:contentData];
                                      NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
                                      DDLogVerbose(@"%d Service Response: %@", serviceType, responseString);
                                      id result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];

                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (finishBlock)
                                              finishBlock(result, nil);

                                          if([self.delegate respondsToSelector:@selector(service:successed:)])
                                              [self.delegate service:self successed:result];
                                      });
                                  }
                                  else
                                  {
                                      NSDictionary *userInfo= nil;
                                      if(contentData)
                                      {
                                          NSData *parsedData = [packer unpackDataWithUnzip:contentData];
                                          NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
                                          DDLogVerbose(@"Service %d with error Response: %@", serviceType, responseString);
                                          userInfo= [responseString objectFromJSONString];
                                      }
                                      if (!userInfo)
                                          userInfo = [NSDictionary dictionary];

                                      NSError *error2=[NSError errorWithDomain:@"WCService" code:errorCode userInfo:userInfo];
                                      DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
                                      WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);

                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (finishBlock)
                                            finishBlock(nil, error2);
                                          if([self.delegate respondsToSelector:@selector(service:error:)])
                                            [self.delegate service:self error:error2];
                                      });
                                  }
                                  self.operation= nil;
                              });
                          }
                           failedBlock:^(NSError *error0){
                               
                               DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error0.code, [error0 localizedDescription]);
                               WCLOG432ERROR(serviceType,@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error0.code, [error0 localizedDescription]);
                               if (finishBlock)
                                   finishBlock(nil, error0);
                               if([self.delegate respondsToSelector:@selector(service:error:)])
                                   [self.delegate service:self error:error0];
                               self.operation= nil;
                           
                           }
                           cancelBlock:nil
                           forKey:@"upload"];
    */
    
    
    
    
    
    

}

- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock
{
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
        result=dictionary;
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

- (void)dealloc
{
    NSLog(@"Finalize Service:%@", [self debugDescription]);
    [self stop];
}


@end
