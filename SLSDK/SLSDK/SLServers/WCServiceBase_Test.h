/*!
 @header   WCServiceBase_Test
 @abstract 网络请求基类
 @author   songlei
 @vwrsion  1.0  15/5/15 Creation
*/

#import <Foundation/Foundation.h>
#import "IObjcJsonBase.h"
#import "JSONKit.h"

#define kServiceErrorCode (999)//断网

@class WCServiceBase_Test;
@class WCDataPacker;

typedef enum
{
    ERequestTypeGet_Test = 0,
    ERequestTypePost_Test
} ERequstType_Test;


/*!
 @protocol   WCServiceTestDelegate的相关注释
 @abstract   WCServiceTestDelegate代理方法。
 @discussion startWithCursor 网络开始启动转圈等待。
             stopWatiCursor  网络结束关闭转圈等待。
             service:successed: 网络请求成功后实现代理。
             service:error:   网络请求失败。
 */
@protocol WCServiceTestDelegate <NSObject>
@optional

- (void)startWithCursor;
- (void)stopWatiCursor;
- (void)service:(WCServiceBase_Test *)service successed:(id)result;
- (void)service:(WCServiceBase_Test *)service error:(NSError *)error;

@end


@interface WCServiceBase_Test : IObjcJsonBase

@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *grp;
@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *platform;
@property(nonatomic, copy) NSString *imei;
@property(nonatomic, copy) NSString *src;
@property(nonatomic, copy) NSString *lang;
@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, copy,getter=getInterfaceUrl) NSString *interfaceUrl;
@property(nonatomic, copy,getter=getOtherBaseUrl) NSString *otherBaseUrl;
@property(nonatomic, copy) NSString *uploadFileName;
@property(nonatomic, strong) NSData *uploadFileData;
@property(nonatomic, strong) NSMutableDictionary *uploadFilesDic;

@property(nonatomic, strong) NSMutableDictionary *postBodyDic;
@property(nonatomic, strong) NSMutableDictionary *postParamsPDic;
@property(nonatomic, strong) NSMutableArray      *postBodyArr;


@property(nonatomic, assign) BOOL useNaviSquare;//使用公共url作为请求

@property (nonatomic, assign)NSUInteger timeout;

@property(nonatomic, weak) id <WCServiceTestDelegate> delegate;

- (id)composeResult:(NSDictionary *)dictionary attachedFile:(id)file;

- (void)appendExtras:(NSDictionary *)extra;

/*!
 @method     startGetRequest的相关注释。
 @abstract   Get请求
 @discussion 用此方法请求网络需要设置先delegate。
             请求开始时会自动调用WCServiceTestDelegate的startWithCursor方法，
             请求结束后自动调用stopWatiCursor。
             service:successed:，请求成功处理。
             service:error:，请求失败处理
 @return     result.code 值为200时为请求成功。
*/
- (void)startGetRequest;
/*!
 @method     startPostRequest的相关注释。
 @abstract   Post请求
 @discussion 用此方法请求网络需要设置先delegate。
             请求开始时会自动调用WCServiceTestDelegate的startWithCursor方法，
             请求结束后自动调用stopWatiCursor。
             service:successed:，请求成功处理。
             service:error:，请求失败处理
 @return     result.code 值为200时为请求成功。
 */
- (void)startPostRequest;

- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock
            progressBlock:(void (^)(float progress))progressBlock;

/*!
 @method     startGetWithBlock:的相关注释。
 @abstract   Get请求
 @discussion 用此方法请求网络无需设置delegate。
             请求开始时需要手动调用startWithCursor方法，开启转圈等待。
             请求结束后手动调用stopWatiCursor，关闭转圈等待。
             Block中处理请求结束后操作。
 @return     result.code 值为200时为请求成功。
 */
- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock;

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock
             progressBlock:(void (^)(float progress))progressBlock;

/*!
 @method     startPostWithBlock:的相关注释。
 @abstract   Get请求
 @discussion 用此方法请求网络无需设置delegate。
             请求开始时需要手动调用startWithCursor方法，开启转圈等待。
             请求结束后手动调用stopWatiCursor，关闭转圈等待。
             Block中处理请求结束后操作。
 @return     result.code 值为200时为请求成功。
 */
- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock;

/*!
 @method     stop的相关注释。
 @discussion 中断网络请求。
 */
- (void)stop;

/*!
 @method     网络请求
 @abstract   网络请求参数设置
 @discussion 子类需重写此方法，设定网络返回数据类型。
 @return     网络返回数据对象类型。
 */
- (Class)responseType;

- (NSMutableDictionary *)composeParams;

- (NSString *)getSrc;


@end
