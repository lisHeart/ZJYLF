//
//  AFHttpMacros.h
//  AppFramework
//
//  Created by liubin on 13-1-9.
//  Copyright (c) 2013年 winChannel. All rights reserved.
//

#ifndef AppFramework_AFHttpMacros_h
#define AppFramework_AFHttpMacros_h

#define kAFHttpRequestTimeOut  30

#define WCH_RELEASE(_POINTER) { [_POINTER release]; _POINTER = nil; }

typedef enum
{
    AFHttpOperationTypeNormal = 0,
    AFHttpOperationTypeUpload,
	AFHttpOperationTypeDownload
} AFHttpOperationType;

typedef enum
{
    AFHttpOperationStateReady = 0,
    AFHttpOperationStateExecuting,
    AFHttpOperationStateFinish
} AFHttpOperationState;

#endif
