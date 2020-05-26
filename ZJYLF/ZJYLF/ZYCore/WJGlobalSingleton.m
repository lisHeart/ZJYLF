//
//  WJGlobalSingleton.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "WJGlobalSingleton.h"
static WJGlobalSingleton *sharedInstance;

@implementation WJGlobalSingleton

+ (WJGlobalSingleton *)sharedInstance{
    static WJGlobalSingleton *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (WCOnbConfiguration *)gWCOnbConfiguration
{
    if (!_gWCOnbConfiguration)
    {
        WCPlistHelper *plistHelper = [[WCPlistHelper alloc] initWithPlistNamed:@"onbConfiguration"];
        _gWCOnbConfiguration = [[WCOnbConfiguration alloc] initWithDictionary:plistHelper.allProperties];
    }
    
    return _gWCOnbConfiguration;
}
- (BOOL)hasLogin {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:WJ_ACCOUNT_USER_HASLOGIN];
}
- (void)setHasLogin:(BOOL)hasLogin {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:hasLogin forKey:WJ_ACCOUNT_USER_HASLOGIN];
    [prefs synchronize];
}
- (NSString*)username {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:WJ_ACCOUNT_USER_USERNAME];
}
- (void)setUsername :(NSString *)username {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:username forKey:WJ_ACCOUNT_USER_USERNAME];
    [prefs synchronize];
}

- (NSString*)mobile {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:WJ_ACCOUNT_USER_MOBILE];
}
- (void)setMobile:(NSString *)mobile{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:mobile forKey:WJ_ACCOUNT_USER_MOBILE];
    [prefs synchronize];
}

- (NSString*)password {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:WJ_ACCOUNT_USER_PASSWORD];
}
- (void)setPassword:(NSString *)password {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:password forKey:WJ_ACCOUNT_USER_PASSWORD];
    [prefs synchronize];
}

- (NSString *)companyid {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:WJ_ACCOUNT_USER_COMPANYID];
}

- (void)setCompanyid:(NSString *)companyid {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:companyid forKey:WJ_ACCOUNT_USER_COMPANYID];
    [prefs synchronize];
}
- (NSString *)userid {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:WJ_ACCOUNT_USER_ID];
}

- (void)setUserid:(NSString *)userid {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:userid forKey:WJ_ACCOUNT_USER_ID];
    [prefs synchronize];
}
-(NSString *)firstEnterApp{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:WJ_ACCOUNT_FIRST_ENTER];
}
- (void)firstEnterApp:(NSString *)firstEnterApp {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:firstEnterApp forKey:WJ_ACCOUNT_FIRST_ENTER];
    [prefs synchronize];
}
@end
