//
//  UIImageView+SD.m
//  ImageAction
//
//  Created by Stone on 15/8/11.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import "UIImageView+SD.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SD)

- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage
{
    if (urlStr == nil) return;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self sd_setImageWithURL:url placeholderImage:phImage];
}

- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock
{
    if (urlStr == nil) return;
    NSString *dealStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:dealStr];
    
    // 后者：下载失败重试，前者：低优先级,如果tableView在滚动，则暂停下载，这样可以避免列表滚动时的因为下载图片而产生的卡顿
    SDWebImageOptions options = SDWebImageAllowInvalidSSLCertificates;// | SDWebImageRetryFailed;
    
    [self sd_setImageWithURL:url placeholderImage:phImage options:SDWebImageAllowInvalidSSLCertificates progress:progressBlock completed:completedBlock];

}
@end
