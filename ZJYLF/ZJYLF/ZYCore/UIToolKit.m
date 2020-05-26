//
//  UIToolKit.m
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/15.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

//config目录：用来存放时间戳有效期内的景区下载文件:返回全路径
NSString* ConfigPath(NSString* fileName) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"dataCaches"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]){
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            //TPLLOG(@"create filepath fail:%@", path);
            return nil;
        }
    }

    if (nil != [fileName lastPathComponent]) {
        return [path stringByAppendingFormat:@"/%@", [fileName lastPathComponent]];
    } else {
        return [path stringByAppendingString:@"/"];
    }
    
    return nil;
}

//获取资源全路径
NSString* ResourcePath(NSString* fileName) {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@", fileName];
}

//删除文件
BOOL RemoveFile(NSString* fileName) {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError* error = nil;
    return [manager removeItemAtPath:fileName error:&error];
}

//存储文件
void SaveFile(NSString* fileName, NSData* data) {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager createFileAtPath:fileName contents:data attributes:nil];
}

BOOL ExistAtPath(NSString* fileFullPath) {
    return [[fileFullPath pathExtension] length] > 0 &&
    [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
}

UIImage * Image(NSString *name) {
    return [UIImage imageNamed:name];
}

NSString * numberBecomeStrng(id number){
    NSString *string = [[NSString alloc]init];
    if ([number isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
        string = [numberFormatter stringFromNumber:number];
    }else if ([number isKindOfClass:[NSString class]]){
        string = number;
    }
    return string;
}



float CalcTextHight(UIFont *font, NSString* text, CGFloat width){
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(width, 2000)
                                        options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize.height;
}

float CalcTextWidth(UIFont *font, NSString* text, CGFloat hight){
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(2000, hight)
                                        options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize.width;
}
NSString *getStageid(NSString *stageName){
    if ([stageName isEqualToString:@"施工开始"]) {
        return @"1";
    }
    if ([stageName isEqualToString:@"水电"]) {
        return @"2";
    }
    if ([stageName isEqualToString:@"泥木"]) {
        return @"3";
    }
    if ([stageName isEqualToString:@"油漆"]) {
        return @"4";
    }
    if ([stageName isEqualToString:@"成品安装"]) {
        return @"5";
    }
    return @"6";
}

NSString *getUrlWithBaseUrlandDict(NSString *baseUrl,NSDictionary *dict){
    NSMutableString *returnStr = [NSMutableString string];
    [returnStr appendString:baseUrl];
    NSArray * allkeys = [dict allKeys];
    for (int i=0; i<allkeys.count; i++) {
        NSString * key = [allkeys objectAtIndex:i];
        
        //
        NSString * value  = [dict objectForKey:key];
        //拼接url
        if (!isBlankString(value)) {
            [returnStr appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        }
    }
    //返回的url
    return returnStr;
}
UIColor* ColorByHexString(NSString* colorKey) {
    NSString *cString = [colorKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    //如果是0x_开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0x_"]) {
        cString = [cString substringFromIndex:3];
    }
    
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    // r
    NSString *rString = [cString substringWithRange:range];
    // g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    // b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0];
}

UIColor* TEXTCOLOR(NSString *colorHex) {
    return ColorByHexString(colorHex);
}

UIColor* BACKCOLOR(NSString *colorHex) {
    return ColorByHexString(colorHex);
}

UIFont * FontOfSize(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
    //    return [UIFont fontWithName:@"NSimSun" size:fontSize];
}

UIFont * BoldFontOfSize(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
    //    return [UIFont fontWithName:@"NSimSun" size:fontSize];
}
NSString *housestype(NSString *housestypeid)
{
    if ([housestypeid isEqualToString:@"1"]) {
        return @"公寓房";
    }
    if ([housestypeid isEqualToString:@"2"]) {
        return @"复式房";
    }
    if ([housestypeid isEqualToString:@"3"]) {
        return @"别墅房";
    }
    if ([housestypeid isEqualToString:@"4"]) {
        return @"商业店铺";
    }
    if ([housestypeid isEqualToString:@"5"]) {
        return @"办公空间";
    }
    return @"";
    
}
NSString *corpmode(NSString *corpmodeid)
{
    if ([corpmodeid isEqualToString:@"1"]) {
        return @"全包";
    }
    if ([corpmodeid isEqualToString:@"2"]) {
        return @"半包";
    }
    if ([corpmodeid isEqualToString:@"3"]) {
        return @"清包";
    }
    return @"";

}
NSString *escHousestype(NSString *housestypeid)
{
    if ([housestypeid isEqualToString:@"公寓房"]) {
        return @"1";
    }
    if ([housestypeid isEqualToString:@"复式房"]) {
        return @"2";
    }
    if ([housestypeid isEqualToString:@"别墅房"]) {
        return @"3";
    }
    if ([housestypeid isEqualToString:@"商业店铺"]) {
        return @"4";
    }
    if ([housestypeid isEqualToString:@"办公空间"]) {
        return @"5";
    }
    return @"";
    
}
NSString *escCorpmode(NSString *corpmodeid)
{
    if ([corpmodeid isEqualToString:@"全包"]) {
        return @"1";
    }
    if ([corpmodeid isEqualToString:@"半包"]) {
        return @"2";
    }
    if ([corpmodeid isEqualToString:@"清包"]) {
        return @"3";
    }
    return @"";
    
}
NSString *reservationType(NSString *reservationtype)
{
    if ([reservationtype isEqualToString:@"0"]) {
        return @"";
    }
    if ([reservationtype isEqualToString:@"1"]) {
        return @"上门洽谈";
    }
    if ([reservationtype isEqualToString:@"2"]) {
        return @"预约量房";
    }
   return @"已预约";
    
}

void NotificationPost(NSString* name, id object, NSDictionary* uInfo) {
    NSLog(@"ming zi : %@",name);
    NSLog(@"object : %@",object);
    NSLog(@"uinfo : %@",uInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:uInfo];
}

void NotificationAddObserver(id target, NSString* name, SEL selector) {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:name object:nil];
}

void NotificationRemoveObserver(id target, NSString* name) {
    [[NSNotificationCenter defaultCenter] removeObserver:target name:name object:nil];
}

void ShowMessage(NSString *message, ShowMessageBlock completion) {
    if (![message isKindOfClass:[NSString class]] || message.length <= 0) {
        return ;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (nil == completion) {
        [delegate.window makeToast:message duration:2.0 position:@"bottom"];
    } else {
        [delegate.window makeToast:message duration:2.0 position:@"bottom" completion:completion];
    }
}

void ShowMessageAt(NSString *message, NSString *position, ShowMessageBlock completion) {
    if (![message isKindOfClass:[NSString class]] || message.length <= 0) {
        return ;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (nil == completion) {
        [delegate.window makeToast:message duration:2.0 position:position];
    } else {
        [delegate.window makeToast:message duration:2.0 position:position completion:completion];
    }
}

void TPLLog(NSString *format, ...) {
    
}

//预算换算
NSString *BudgetFrom(NSString *budget)
{
    if ([budget isEqualToString:@"1"]) {
        return @"三万以下";
    }
    if ([budget isEqualToString:@"2"]) {
        return @"3-5万";
    }
    if ([budget isEqualToString:@"3"]) {
        return @"5-6万";
    }
    if ([budget isEqualToString:@"12"]) {
        return @"6-7万";
    }
    if ([budget isEqualToString:@"13"]) {
        return @"7-8万";
    }
    if ([budget isEqualToString:@"4"]) {
        return @"8-10万";
    }
    if ([budget isEqualToString:@"14"]) {
        return @"10-12万";
    }
    if ([budget isEqualToString:@"15"]) {
        return @"12-15万";
    }
    if ([budget isEqualToString:@"5"]) {
        return @"15-30万";
    }
    if ([budget isEqualToString:@"6"]) {
        return @"30万以上";
    }
    if ([budget isEqualToString:@"三万以下"]) {
        return @"1";
    }if ([budget isEqualToString:@"3-5万"]) {
        return @"2";
    }if ([budget isEqualToString:@"5-6万"]) {
        return @"3";
    }
    if ([budget isEqualToString:@"6-7万"]) {
        return @"12";
    }
    if ([budget isEqualToString:@"7-8万"]) {
        return @"13";
    }
    if ([budget isEqualToString:@"8-10万"]) {
        return @"4";
    }
    if ([budget isEqualToString:@"10-12万"]) {
        return @"14";
    }
    if ([budget isEqualToString:@"12-15万"]) {
        return @"15";
    }
    if ([budget isEqualToString:@"15-30万"]) {
        return @"4";
    }
    if ([budget isEqualToString:@"30万以上"]) {
        return @"6";
    }
    return @"";
}
NSString *getStageName(NSNumber *stageid)
{
    if ([stageid isEqualToNumber:@1]) {
        return @"开工阶段";
    }
    if ([stageid isEqualToNumber:@2]) {
        return @"水电阶段";
    }
    if ([stageid isEqualToNumber:@3]) {
        return @"泥木阶段";
    }
    if ([stageid isEqualToNumber:@4]) {
        return @"油漆阶段";
    }
    if ([stageid isEqualToNumber:@5]) {
        return @"成品安装";
    }
   
    return @"竣工验收";
   
    
}

NSString * image(NSString *string){
    if ([string isEqualToString:@"0"]) {
        return @"未开始";
    }
    if ([string isEqualToString:@"1"]) {
        return @"开工";
    }
    if ([string isEqualToString:@"2"]) {
        return @"水电";
    }
    if ([string isEqualToString:@"3"]) {
        return @"泥木";
    }
    if ([string isEqualToString:@"4"]) {
        return @"油漆";
    }
    if ([string isEqualToString:@"5"]) {
        return @"成品安装";
    }
    return @"竣工验收";
}

BOOL isBlankString(NSString *string) {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

//时间戳转化成标准时间  精确到日
NSString *timestampVConversionStandardTimeAccorateToDay(NSString *timeStamp)
{
    NSString *timeString = [[[[timeStamp componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@"+"] objectAtIndex:0];
    NSTimeInterval _interval=[timeString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate: date];
}
#pragma mark--判断手机号码
 BOOL isMobileNumber(NSString *mobileNum)
{
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //     NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CM = @" ^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    //     NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CU =  @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    //     NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * CT = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//时间戳转化成标准时间  精确到分
NSString *timestampVConversionStandardTimeAccorateToSec(NSString *timeStamp)
{
    NSString *timeString = [[[[timeStamp componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@"+"] objectAtIndex:0];
    NSTimeInterval _interval=[timeString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [objDateformat stringFromDate: date];
}

//时间戳转化成标准时间  精确到秒
NSString *timestampVConversionStandardTimeAccorateToSecond(NSString *timeStamp)
{
    NSString *timeString = [[[[timeStamp componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@"+"] objectAtIndex:0];
    NSTimeInterval _interval=[timeString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

NSString *timestampVConversionStandardTimeAccorateWithFormat(NSString *timeStamp, NSString *format) {
    NSString *timeString = [[[[timeStamp componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@"+"] objectAtIndex:0];
    NSTimeInterval _interval=[timeString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    return [objDateformat stringFromDate: date];

}
//截取时间只剩月和日
NSString *timestampMonthAndDayFromData(NSString* time)
{
    NSArray *arr=[time componentsSeparatedByString:@" "];
    NSString *str=[arr[0] substringFromIndex:5];
    return str;
}
NSString *timesCutSecond(NSString* time){
    NSString *str=[time substringToIndex:time.length-3];
    return str;
}

NSString *timesCutBothSide(NSString *time){
    NSString *str=[time substringToIndex:time.length-3];
    NSString *str1=[str substringFromIndex:5];
    return str1;
}

//保留小数点后2位
NSString *decimalpPoint(id number)
{
    NSString *numb = [[NSString alloc]init];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#####0.00;"];
    if ([number isKindOfClass:[NSNumber class]]) {
        numb = [numberFormatter stringFromNumber:number];
    }else if ([number isKindOfClass:[NSString class]]){
//        numb = [numberFormatter stringForObjectValue:stringBecomeNumber(number)];
        numb = [numberFormatter stringFromNumber:stringBecomeNumber(number)];
    }
    return numb;
}

NSNumber *stringBecomeNumber(id string) {
    id result;
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    if ([format numberFromString:string]) {
        result = [NSNumber numberWithFloat:[string floatValue]];
    } else {
        result = string;
    }
    
    return result;
}

NSString *conversionChineseDigital(NSString *amountStr) {
    NSArray *unitAr = @[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿"];
    NSArray *numAr = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    //整理字符串，长度
    amountStr = [NSString stringWithFormat:@"%.2f",[amountStr doubleValue]];
    amountStr = [amountStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSInteger length = amountStr.length;
    
    NSMutableString *tempStr = [NSMutableString new];
    BOOL zero = NO;
    
    for (int i = 0; i < length; i++) {
        
        NSString *tempNum = [amountStr substringWithRange:NSMakeRange(i ,1)];
        
        //判断“零”串
        if ([tempNum intValue] == 0){
            zero = YES;
            
            //出“零”，单位“分“，不显示
            if ( i == length - 2 ) {
                zero = NO;
                continue;
            }
            
            //出“零”，补“元”，去“零”
            if ( i == length - 3 ) {
                
                //出“零”，单位“元”，不显示
                if ( i == 0 ) {
                    zero = NO;
                    continue;
                }
                
                [tempStr appendString:@"元"];
                zero = NO;
                continue;
            }
            
            //补“万”，倒数第7个
            if ( i == length - 7 ) {
                [tempStr appendString:@"万"];
                continue;
            }
            
            continue;
            
        }else{
            
            //非“零”，且之前出现“零”，补“零”
            if (zero == YES) {
                [tempStr appendString:@"零"];
                zero = NO;
            }
        }
        
        //改"拾"，首位为“壹”，且位置为“拾”位
        if ( i == 0 && (length == 4 || length == 8) && [tempNum intValue] == 1) {
            [tempStr appendString:@"拾"];
            
            continue;
        }
        
        [tempStr appendString:[numAr objectAtIndex:[tempNum intValue]]];
        
        //补“元”，倒数第3个
        if ( i == length - 3 ) {
            
            [tempStr appendString:@"元"];
            continue;
        }
        
        //补“万”，倒数第7个
        if ( i == length - 7 ) {
            [tempStr appendString:@"万"];
            continue;
        }
        
        [tempStr appendString:[unitAr objectAtIndex:(length - i - 1)]];
        
    }
    
    //补“整”，如无“角”，“分”补“整”
    if ([tempStr hasSuffix:@"元"]) {
        [tempStr appendString:@"整"];
    }
    
    NSLog(@">>%@ %@",tempStr,amountStr);
    
    if (isBlankString(tempStr)) return @"零";
    
    return tempStr;
}

NSDate *localDate() {
    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

NSDate *dateFromString(NSString *time) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *destDate;

    NSString *string1 = @"", *string2 = @"";
    NSArray *array = [time componentsSeparatedByString:@" "];
    string1 = array[0];
    if (array.count > 1) {
        string2 = array[1];
    }
    NSMutableString *formatter = [[NSMutableString alloc] initWithCapacity:10];
    if ([string1 containsString:@"-"]) {
        [formatter appendString:@"yyyy-MM-dd"];
    } else {
        [formatter appendString:@"yyyy/MM/dd"];
    }
    
    if (string2.length > 0) {
        [formatter appendString:@" "];
        
        if (string2.length > 6)
            [formatter appendString:@"HH:mm:ss"];
        else
            [formatter appendString:@"HH:mm"];
    }
    [dateFormatter setDateFormat:formatter];
    destDate = [dateFormatter dateFromString:time];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:destDate];
    NSDate *localeData = [destDate dateByAddingTimeInterval:interval];
    return localeData;
}

NSDate *nextDateFromString(NSString *time) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    NSDate *date = dateFromString(time);
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setDay:1];

    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    
    return newdate;
}

NSString *stringFromDate(NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

NSString *stringFromDateWithFormatter(NSDate *date, NSString *format) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString *intervalSineceNow(NSDate *date)
{
    NSTimeInterval late = [date timeIntervalSince1970] * 1;
    
    NSDate *dat = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dat];
    dat = [dat dateByAddingTimeInterval:interval];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = late - now;
    
    if (cha <=0 ) return @"";
    
    if (cha > 0 && cha / 3600 < 1) {
        timeString = [NSString stringWithFormat:@"还剩%ld分钟自动确认", (NSInteger)cha/60];
    } else if (cha / 3600 > 1 &&  cha / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"还剩%@小时自动确认", timeString];
    } else if (cha/86400 > 1) {
        NSString *day, *hour;
        day = [NSString stringWithFormat:@"%f", cha/86400];
        day = [day substringToIndex:day.length-7];
        hour = [NSString stringWithFormat:@"%f", (cha-[day intValue]*24*60*60)/3600];
        hour = [hour substringToIndex:hour.length-7];
        timeString = [NSString stringWithFormat:@"还剩%@天%@小时自动确认", day, hour];
    }
    
    return timeString;
}
NSString *daysSinceNow(NSDate *date)
{
    NSTimeInterval late = [date timeIntervalSince1970] * 1;
    
    NSDate *dat = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dat];
    dat = [dat dateByAddingTimeInterval:interval];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = late - now;
    
    if (cha/86400 > 1) {
        NSString *day, *hour;
        day = [NSString stringWithFormat:@"%f", cha/86400];
        day = [day substringToIndex:day.length-7];
        hour = [NSString stringWithFormat:@"%f", (cha-[day intValue]*24*60*60)/3600];
        hour = [hour substringToIndex:hour.length-7];
        timeString = [NSString stringWithFormat:@"%@", day];
    }else{
         timeString =@"1";
    }
    
    return timeString;

}

NSString *dateBetween(NSDate *begin, NSDate *end) {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlag = NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlag fromDate:begin toDate:end options:0];
    NSInteger days = [components day];
    return [NSString stringWithFormat:@"%ld", (long)days];
}

NSString *dateBetweenHour(NSDate *begin, NSDate *end) {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlag = kCFCalendarUnitHour;
    NSDateComponents *components = [calendar components:unitFlag fromDate:begin toDate:end options:0];
    NSInteger hours = [components hour];
    return [NSString stringWithFormat:@"%ld", (long)hours];
}

NSString *dateBetweenMin(NSDate *being, NSDate *end) {
    NSTimeInterval first   = [being timeIntervalSince1970] * 1.0;
    NSTimeInterval sectond = [end timeIntervalSince1970] * 1.0;
    
    NSString *timeString = @"";
    
    NSTimeInterval cha = fabs(first - sectond);
    
    if (cha < 60) {
        timeString = [NSString stringWithFormat:@"%d秒", (int)cha];
    }
    if (cha/3600 < 1 && cha/60 >= 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟", timeString];
    }
    if (cha/3600 > 1 && cha/86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时", timeString];
    }
    if (cha/86400 > 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天", timeString];
        
    }
    
    return timeString;
}

NSString *replaceString(NSString *string, NSInteger width)
{
   
    NSMutableString *muString = [NSMutableString string];
    NSRange range1 = [string rangeOfString:@"_"];
    [muString appendString:[string substringToIndex:range1.location+1]];
    NSString *string1 = [string substringFromIndex:range1.location+1];
    NSRange range2 = [string1 rangeOfString:@"_"];
    NSString *string2 = [string1 substringFromIndex:range2.location];
    [muString appendString:[NSString stringWithFormat:@"%ld", (long)width]];
    [muString appendString:string2];
    
    return muString;
}

NSString * switchMinute (NSString *time) {
    NSString *timeStr;
    NSDate *date = dateFromString(time);
    timeStr =  stringFromDateWithFormatter(date, @"yyyy-MM-dd HH:mm");
    return timeStr;
    
}

NSString * switchDay (NSString *time) {
    NSString *timeStr;
    NSDate *date = dateFromString(time);
    timeStr =  stringFromDateWithFormatter(date, @"yyyy-MM-dd");
    return timeStr;
    
}

NSString *md5(NSString *key) {
    const char *cStr = [key UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X", result[i]];
    }
    return [ret lowercaseString];
}

NSString *networktype() {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            return @"无服务";
            break;
            
        case 1:
            NSLog(@"2G");
            return @"2G";
            break;
            
        case 2:
            NSLog(@"3G");
            return @"3G";
            break;
            
        case 3:
            NSLog(@"4G");
            return @"4G";
            break;
            
        case 4:
            NSLog(@"LTE");
            return @"LTE";
            break;
            
        case 5:
            NSLog(@"Wifi");
            return @"Wifi";
            break;
            
            
        default:
            break;
    }
    return @"";
}

NSString *getcarrierName() {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}
void mixButton(UIButton *button,CGFloat width) {
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-width, 0, width)];
    CGFloat labelWidth =[button.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0] }].width+5;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth)];
    
}




