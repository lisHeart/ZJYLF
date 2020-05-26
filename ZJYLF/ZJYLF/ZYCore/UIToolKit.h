//
//  UIToolKit.h
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/15.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//


#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>


extern NSString *ConfigPath(NSString *fileName);

extern BOOL RemoveFile(NSString *fileName);

extern NSString* ResourcePath(NSString* fileName);

extern void SaveFile(NSString* fileName, NSData* data);

//检查文件是否存在
extern BOOL ExistAtPath(NSString* fileFullPath);

//计算文字实际高度
extern float CalcTextHight(UIFont *font, NSString* text, CGFloat width);
extern float CalcTextWidth(UIFont *font, NSString* text, CGFloat hight);

//@{设置颜色
extern UIColor* ColorByHexString(NSString* colorKey);
extern UIColor* TEXTCOLOR(NSString* colorHex);
extern UIColor* BACKCOLOR(NSString* colorHex);
//@}

//@{设置字体大小
extern UIFont * FontOfSize(CGFloat fontSize);
extern UIFont * BoldFontOfSize(CGFloat fontSize);
//@}

//@{
extern UIImage * Image(NSString *name);

//}

//@{ 随机生成颜色
extern UIColor * randomColor();
//}

//@{通知管理
extern void NotificationPost(NSString* name, id object, NSDictionary* uInfo);
extern void NotificationAddObserver(id target, NSString* name, SEL selector);
extern void NotificationRemoveObserver(id target, NSString* name);
//@}

//@{客户信息房型等选择
extern NSString *housestype(NSString *housestypeid);
extern NSString *corpmode(NSString *corpmodeid);
extern NSString *reservationType(NSString *reservationtype);
extern NSString *escHousestype(NSString *housestypeid);
extern NSString *escCorpmode(NSString *corpmodeid);
//@}

typedef void (^ShowMessageBlock)(void);
extern void ShowMessage(NSString *message, ShowMessageBlock completion);
/**
 * @"top" @"center" @"bottom"
 */
extern void ShowMessageAt(NSString *message, NSString *position, ShowMessageBlock completion);
extern void TPLLog (NSString *format, ...);

//@{判断空字符串
extern BOOL isBlankString(NSString *string);
//@}
//@{不同类型返回的图片名字
extern NSString * image(NSString *string);
//@}

//@{ 返回阶段名称
extern NSString *getStageName(NSNumber *stageid);
//}

//@{ 时间转换
extern NSString *timestampVConversionStandardTimeAccorateToDay(NSString *timeStamp);
extern NSString *timestampVConversionStandardTimeAccorateToSec(NSString *timeStamp);
extern NSString *timestampVConversionStandardTimeAccorateToSecond(NSString *timeStamp);
extern NSString *timestampVConversionStandardTimeAccorateWithFormat(NSString *timeStamp, NSString *format);
extern NSString *timestampMonthAndDayFromData(NSString* time);
//去掉时间的秒
extern NSString *timesCutSecond(NSString* time);
//去掉时间的两边
extern NSString *timesCutBothSide(NSString  *time);
//}

//@{
//numberh转换成string
extern NSString  *numberBecomeStrng(id number);
//保留小数点后2位
extern NSString *decimalpPoint(id number);
//string转换成number
extern NSNumber *stringBecomeNumber(id string);
//数字转金额大写
extern NSString *conversionChineseDigital(NSString *amount);
//}
//@{ 返回阶段id
extern NSString *getStageid(NSString *stageName);
//}
//@{ 时间格式转换
extern NSDate *localDate();
extern NSDate *dateFromString(NSString *time);
extern NSDate *nextDateFromString(NSString *time);
extern NSString *stringFromDate(NSDate *date);
extern NSString *stringFromDateWithFormatter(NSDate *date, NSString *format);
extern NSString *intervalSineceNow(NSDate *date);
extern NSString *daysSinceNow(NSDate *date);
// 相差天数
extern NSString *dateBetween(NSDate *begin, NSDate *end);
// 相差小时
extern NSString *dateBetweenHour(NSDate *begin, NSDate *end);
// 相差分钟
extern NSString *dateBetweenMin(NSDate *being, NSDate *end);
//}

//@{
extern NSString *replaceString(NSString *string, NSInteger width);
//}
// 将时间格式转化为 精确到分钟
extern NSString *switchMinute(NSString *time);
// 将时间格式转化为 精确到天
extern NSString *switchDay(NSString *time);
//@{MD5 加密
extern NSString *md5(NSString *key);
//}

//@{ 机器信息

extern NSString *networktype();
extern NSString *getcarrierName();
//}

//@{
extern NSString * getUrlWithBaseUrlandDict(NSString *baseUrl,NSDictionary *dict);
//}
extern BOOL isMobileNumber(NSString *mobileNum);
//@{ button 左文字右图片
extern void mixButton(UIButton * button,CGFloat width);


