//
//  ShowPictureController.m
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import "ShowPictureController.h"
#import "ImageScrollView.h"
#import "PhotoItemView.h"
#import "PictureView.h"

@interface ShowPictureController ()
<UIScrollViewDelegate,
UIActionSheetDelegate,
PhotoItemViewDelegate>
{
    UILabel *pageLabel;
}
@property (nonatomic, strong) NSMutableArray *photoModels;

@property (nonatomic, strong) ImageScrollView *scrollView;

@property (nonatomic, assign) BOOL isNetWork;

@property (nonatomic, assign) ShowType type;
/** 总页码 */
@property (nonatomic, assign) NSUInteger pageCount;
/** 当前页 */
@property (nonatomic, assign) NSUInteger page;
/** 初始显示的index */
@property (nonatomic,assign) NSUInteger index;
/** 上一个页码 */
@property (nonatomic, assign) NSUInteger lastPage;
/** 现在显示页面 */
@property (nonatomic,assign) NSUInteger currentIndex;
/** 可重用集合 */
@property (nonatomic,strong) NSMutableSet *reusablePhotoItemViewSetM;
/** 显示中视图字典 */
@property (nonatomic,strong) NSMutableDictionary *visiblePhotoItemViewDictM;
/** 要显示的下一页 */
@property (nonatomic,assign) NSUInteger nextPage;

/** drag时的page */
@property (nonatomic,assign) NSUInteger dragPage;


@end

@implementation ShowPictureController

- (void)show:(UIViewController *)handleVC type:(ShowType)type isInternet:(BOOL)flag index:(NSUInteger)index photoViews:(NSArray *)photos
{
    self.photoModels = [NSMutableArray arrayWithArray:photos];
    
    if (_photoModels == nil || _photoModels.count == 0) return ;
    
    if (index >= _photoModels.count)
        return ;
    
    self.index = index;
    self.currentIndex = index;
    
    self.type = type;
    self.isNetWork = flag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self vcPrepare];
//    [self topBarView];
    [self bottomView];
    
    self.dragPage = -1;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)vcPrepare
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.scrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width+20, size.height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self pagesPrepare];
}

- (void)pagesPrepare
{
    __block CGRect frame = [UIScreen mainScreen].bounds;
    
    CGFloat widthEachPage = frame.size.width + 20;
    
    [self showWithPage:self.index];
    
    self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);
    
    self.scrollView.index = _index;
}

- (void)topBarView
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, size.width, 64)];
    topBar.barStyle = UIBarStyleBlackTranslucent;
    topBar.alpha = 0.5f;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"resource.Bundle/Images/back_arrow.png"];
    left.frame = CGRectMake(10, 64-40, 50, 35);
    left.imageEdgeInsets = UIEdgeInsetsMake((30-image.size.height)*.5, 2, (30-image.size.height)*.5, 50-image.size.width-2);
    [left setImage:image forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:left];
    
    if (self.type == Delete) {
        
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleBtn.frame = CGRectMake(size.width-50, 24, 40, 30);
        [deleBtn addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:deleBtn];
    }
    
    [self.view addSubview:topBar];
}

- (void)bottomView
{
    UIToolbar *bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    bottomBar.barStyle = UIBarStyleBlackTranslucent;
    bottomBar.alpha = 0.3f;
    [self.view addSubview:bottomBar];
    
    pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120)*.5, 10, 120, 20)];
    pageLabel.backgroundColor = [UIColor clearColor];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.font = FontOfSize(FontLargeSize);
    pageLabel.textColor = TEXTCOLOR(@"ffffff");
    [bottomBar addSubview:pageLabel];
}

- (void)showWithPage:(NSUInteger)page
{
    // 如果对应页码对应的视图正在显示中，就不用再显示了
    if ([self.visiblePhotoItemViewDictM objectForKey:@(page)] != nil) return ;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    // 取出重用photoItemView
    PhotoItemView *photoItemView = [self dequeReusablePhotoItemView];
    
    if (photoItemView == nil) {
        
        photoItemView = [[PhotoItemView alloc] initWithFrame:CGRectMake((size.width + 20) * page, 0, size.width, size.height)];
        photoItemView.delegate = self;
        
    } else {
        
        photoItemView.frame = CGRectMake((size.width + 20) * page, 0, size.width, size.height);
        
    }
    
    // 到这里，photoItemView一定有值，而且一定显示为当前页
    // 加入到当前显示中的字典
    [self.visiblePhotoItemViewDictM setObject:photoItemView forKey:@(page)];

    photoItemView.pageIndex = page;
    photoItemView.type = self.type;
    
    if (self.photoModels && self.photoModels.count > 0)
    {
        PhotoModel *model = _photoModels[page];
        if (model.image_HD) {
            photoItemView.url = model.image_HD;
        }
        else
            photoItemView.photoImageView.image = model.fullScreenImage;
        
        photoItemView.photoModel = model;
    }

    [self.scrollView addSubview:photoItemView];
}

#pragma mark -
#pragma mark PhotoItemView Delegate Method
- (void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteEvent
{
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗？"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"删除", nil];;
    [aSheet showInView:[[UIApplication sharedApplication].delegate window].rootViewController.view];

}

#pragma mark - UIActionSheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            CGRect frame = [UIScreen mainScreen].bounds;
            
            CGFloat widthEachPage = frame.size.width + 20;
            
            [self.photoModels removeObjectAtIndex:self.currentIndex];
            
            for (PhotoItemView *item in self.scrollView.subviews)
            {
                [item removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeAllObjects];
            }
            
            if (self.currentIndex > 0) {
                
                self.currentIndex -= 1;
                
                self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);
                self.scrollView.contentOffset = CGPointMake(widthEachPage * self.currentIndex, 0);
                
                self.pageCount = self.photoModels.count;
                [self showWithPage:self.currentIndex];
                
            } else if (self.currentIndex == 0) {
                
                if (self.photoModels.count > 0) {
                    
                    self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);
                    
                    self.pageCount = self.photoModels.count;
                    
                    [self showWithPage:self.currentIndex];
                }
                
            }
            
            if (self.photoModels.count == 0)
                [self performSelector:@selector(disMiss) withObject:nil afterDelay:0.1];
        }
            break;
            
        default:
            break;
    }
}

- (void)back
{
    if (_delegate && [_delegate respondsToSelector:@selector(finishWithImages:)] && self.type == Delete)
    {
        [_delegate finishWithImages:_photoModels];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)disMiss
{
    if (_delegate && [_delegate respondsToSelector:@selector(finishWithImages:)] && self.type == Delete)
    {
        [_delegate finishWithImages:_photoModels];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PhotoItemView *)dequeReusablePhotoItemView
{
    PhotoItemView *photoItemView = [self.reusablePhotoItemViewSetM anyObject];
    
    if (photoItemView != nil)
    {
        [self.reusablePhotoItemViewSetM removeObject:photoItemView];
        
        [photoItemView removeFromSuperview];
        
        [photoItemView reset];
    }
    
    return photoItemView;
}

- (NSMutableSet *)reusablePhotoItemViewSetM
{
    if (_reusablePhotoItemViewSetM == nil)
        _reusablePhotoItemViewSetM = [NSMutableSet set];
    
    return _reusablePhotoItemViewSetM;
}

- (NSMutableDictionary *)visiblePhotoItemViewDictM
{
    if (_visiblePhotoItemViewDictM == nil)
    {
        _visiblePhotoItemViewDictM = [NSMutableDictionary dictionary];
    }
    
    return _visiblePhotoItemViewDictM;
}

#pragma mark - UIScrollView Delegate Method

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = [self pageCalWithScrollView:scrollView];
    
    // self.drapPage 开始移动页面
    if (self.dragPage == -1) self.dragPage = page;
    
    // self.page 移动到当前页面位置
    self.page = page;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat pageOffsetX = self.dragPage * scrollView.bounds.size.width;
    
    if (offsetX > pageOffsetX) { // 正在向左滑动，展示右边的页面
        
        if (page >= self.pageCount - 1) return ;
        
        self.nextPage = page + 1;
        
    } else if (offsetX < pageOffsetX) { // 正在向右滑动，展示左边的页面
        
        if (page == 0)  return ;
        
        self.nextPage = page - 1;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 重围
    self.dragPage = -1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = [self pageCalWithScrollView:scrollView];
    self.currentIndex = page;
    
    pageLabel.text = [NSString stringWithFormat:@"%lu/%lu", self.currentIndex+1, (unsigned long)self.pageCount];
    
    [self reuserAndVisibleHandle:page];
}

- (void)setNextPage:(NSUInteger)nextPage
{
    _nextPage = nextPage;
    [self showWithPage:_nextPage];
}

- (NSUInteger)pageCalWithScrollView:(UIScrollView *)scrollView
{
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + .5;
    
    return page;
}

-(void)reuserAndVisibleHandle:(NSUInteger)page {
    
    // 遍历可视视图字典，除了page之外的所有视图全部移除，并加入重用集合
    [self.visiblePhotoItemViewDictM enumerateKeysAndObjectsUsingBlock:^(NSValue *key, PhotoItemView *photoItemView, BOOL *stop) {
        
        if (page == 0) {
            
            if ([key isEqualToValue:@(page)]) {
                
            } else if ([key isEqualToValue:@(page+1)] && ((page+1) < self.pageCount)) {
                
                photoItemView.zoomScale = 1.0;
                
            } else {
                
                photoItemView.zoomScale = 1.0;
                
                [self.reusablePhotoItemViewSetM addObject:photoItemView];
                
                [photoItemView removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeObjectForKey:key];
                
            }
            
        } else if (page == self.pageCount - 1) {
            
            if ([key isEqualToValue:@(page)]) {
                
            } else if ([key isEqualToValue:@(page-1)]) {
                
                photoItemView.zoomScale = 1.0;
                
            } else {
                
                photoItemView.zoomScale = 1.0;
                
                [self.reusablePhotoItemViewSetM addObject:photoItemView];
                
                [photoItemView removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeObjectForKey:key];
                
            }
            
        } else {
            
            if ([key isEqualToValue:@(page)]) {
                
            } else if ([key isEqualToValue:@(page+1)] || [key isEqualToValue:@(page-1)]) {
                
                photoItemView.zoomScale = 1.0;
                
            } else {
                
                photoItemView.zoomScale = 1.0;
                
                [self.reusablePhotoItemViewSetM addObject:photoItemView];
                
                [photoItemView removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeObjectForKey:key];
                
            }
            
        }
        
    }];
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
}

- (void)setPhotoModels:(NSMutableArray *)photoModels
{
    if (photoModels == nil || photoModels.count == 0) return ;
    
    _photoModels = (NSMutableArray *)photoModels;
    
    self.pageCount = photoModels.count;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //初始化页码信息
        self.page = _index;
        pageLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)_index+1, (unsigned long)self.pageCount];
    });
}
@end
