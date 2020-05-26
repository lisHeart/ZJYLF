//
//  PictureListController.m
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "ShowPictureController.h"
#import "PictureListView.h"
#import "IgnoreController.h"
#import "PictureView.h"

#define SCREENSIZE    [[UIScreen mainScreen] bounds].size


@interface PictureListView ()
<UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ShowPictureControllerDelegate>

@property (nonatomic, assign) CGRect viewFrame;

@end

@implementation PictureListView
{
    UIScrollView *_scrollView;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.imagesArray = [NSMutableArray array];
        [self addObserver:self forKeyPath:@"maxCount" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"currentCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setContrllerFrame:(CGRect)frame
{
    _viewFrame = frame;
    self.frame = _viewFrame;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"maxCount"];
    [self removeObserver:self forKeyPath:@"currentCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"maxCount"]) {
        [self resetImages];
    }
    
    if ([keyPath isEqualToString:@"currentCount"]) {
        [self initUI];
    }
}

- (void)initUI
{
    [_scrollView removeFromSuperview];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    _scrollView.contentSize = CGSizeMake(90*_maxCount, _viewFrame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    _finalImages = [NSMutableArray array];
    
    [_imagesArray removeAllObjects];
    for (int i = 0; i < 9; i++)
    {
        PictureView *itemView = [[PictureView alloc] initWithFrame:CGRectMake(i*90, 0, 80, _scrollView.frame.size.height)];
        itemView.hasImage = NO;
        itemView.index = i;
        itemView.url = @"";
        itemView.isFromInternet = NO;
        
        itemView.backgroundColor = [UIColor redColor];
            
        itemView.userInteractionEnabled = YES;
        [_scrollView addSubview:itemView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [itemView addGestureRecognizer:tap];
        
        [_imagesArray addObject:itemView];
    }
}

- (void)resetImages
{
    _maxCount = _maxCount < kMaxImageCount ? _maxCount : kMaxImageCount;
    _scrollView.frame = CGRectMake(0, 0, _viewFrame.size.width, _viewFrame.size.height);
    if (self.type == List) {
        for (int i = 0; i < 9; i++)
        {
            PictureView *item = _imagesArray[i];
            if (i >= _maxCount) {
                item.url = @"";
                item.isFromInternet = NO;
                item.hidden = YES;
            } else {
                item.hidden = NO;
                item.isFromInternet = YES;
                if (![item.url isEqualToString:_picts[i]]) {
                    item.url = _picts[i];
                } else {
            
                }
            }
        }
        
        _scrollView.contentSize = CGSizeMake(90*_maxCount, _viewFrame.size.height);
        
    } else {
        NSInteger imageCount = _picts.count < 9 ? _picts.count : 9;
        for (int i = 0; i < imageCount; i++) {
            PictureView *item = _imagesArray[i];
            if (![item.url isEqualToString:_picts[i]]) {
                item.isFromInternet = YES;
                item.url = _picts[i];
                item.hidden = NO;
            }
        }
        
        [self resetScrollView];
    }
    
}

- (void)handleTap:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapPicture)])
    {
        [_delegate tapPicture];
    }
    
    UIGestureRecognizer *tap = (UIGestureRecognizer *)sender;
    PictureView *imageView = (PictureView *)tap.view;

    if (imageView.isFromInternet) {
        
        ShowPictureController *show = [[ShowPictureController alloc] init];
        show.delegate = self;
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < _maxCount; i++)
        {
            PictureView *view = _imagesArray[i];
            [array addObject:view];
        }
        
        if (self.type == List)
            [show show:show type:Show isInternet:YES index:imageView.index photoViews:array];
        else if (self.type == Add || self.type == Edit)
            [show show:show type:Delete isInternet:YES index:imageView.index photoViews:array];
            
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
        
    } else {
        
        if (!imageView.hasImage) {
            UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"拍照", @"从相册中选择", nil];
            [aSheet showInView:((UIViewController *)self.modalController).view];
        } else {
            
            ShowPictureController *show = [[ShowPictureController alloc] init];
            show.delegate = self;
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < _maxCount; i++)
            {
                PictureView *view = _imagesArray[i];
                if (view.hasImage) [array addObject:view];
            }
            [show show:show type:Delete isInternet:NO index:imageView.index photoViews:array];
            
            [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
        }
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                // 此处设置只能使用相机，禁止使用视频功能
                picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
                picker.allowsEditing = YES;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:picker animated:YES completion:nil];
            }
            break;
        case 1: // From album
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = NO;
                picker.delegate = self;
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:picker animated:YES completion:nil];
                
            }
            break;
        case 2:
            
            break ;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        //获取照片的原图
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //获取图片的路径
        NSURL* filePath = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        for (int i = 0; i < _maxCount; i++)
        {
            PictureView *view = _imagesArray[i];
            
            if (!view.hasImage) {
                view.image = original;
                view.originalImage = original;
                view.hasImage = YES;
                [picker dismissViewControllerAnimated:YES completion:nil];
                break ;
            }
        }
        
        [self resetScrollView];
    }
}

#pragma mark - ShowPictureController Delegate Method

- (void)finishWithImages:(NSArray *)images
{
    int count = 0;
    for (PictureView *view in _imagesArray)
    {
        if (view.isFromInternet) count ++;
    }
    if (count != images.count) self.isEidt = YES;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _maxCount; i++)
    {
        PictureView *itemView = [[PictureView alloc] initWithFrame:CGRectMake(i*90, 0, 80, _scrollView.frame.size.height)];
        itemView.hasImage = NO;
        itemView.index = i;
        itemView.isFromInternet = NO;
        itemView.url = @"";
        itemView.originalImage = [UIImage imageNamed:@"resource.Bundle/Images/grayPlus.png"];
        itemView.image = [UIImage imageNamed:@"resource.Bundle/Images/grayPlus.png"];
        
        itemView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [itemView addGestureRecognizer:tap];
        
        [array addObject:itemView];
    }
    
    [_finalImages removeAllObjects];
    for (int i = 0; i < images.count; i++)
    {
        PictureView *view = images[i];
        view.index = i;
        view.frame = CGRectMake(i*90, 0, 80, _scrollView.frame.size.height);
        [array replaceObjectAtIndex:i withObject:view];
        
        [_finalImages addObject:view.url];
    }
    
    [_imagesArray removeAllObjects];
    [_imagesArray addObjectsFromArray:array];
    
    for (PictureView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    for (PictureView *view in array)
    {
        [_scrollView addSubview:view];
    }
    
    [self resetScrollView];
}

- (void)resetScrollView
{
    int count = 0;
    for (PictureView *view in _imagesArray)
    {
        if (view.hasImage || view.isFromInternet) count ++;
        view.hidden = NO;
    }
    
    if (count < _maxCount) {
        for (int i = count + 1; i < _maxCount; i++) {
            PictureView *view = _imagesArray[i];
            view.hidden = YES;
        }
        
        [_scrollView setContentSize:CGSizeMake(90*(count+1), _viewFrame.size.height)];
    }
    
    if (self.type == Edit) {
        CGFloat offset = _scrollView.contentSize.width - _scrollView.frame.size.width;
        offset = offset > 0 ? offset : 0;
        [_scrollView setContentOffset:CGPointMake(offset, 0)];
    }
}
@end
















































