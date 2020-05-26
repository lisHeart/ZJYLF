//
//  JSObject.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/11/27.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectProtocol <JSExport>

- (void)goLogin;
@end
@interface JSObject : NSObject<JSObjectProtocol>


@end
