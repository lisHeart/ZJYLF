//
//  ZJTaskPursueViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJTaskPursueViewController.h"
#import "WorkerHomeFlowLayout.h"
#import "NetWorkForFocuspictureGetlist.h"
#import "HomeCollectionModel.h"
#import "HomeCollectionViewCell.h"
#import "AutoScrollView.h"
#import "PictureView.h"
#import "ZJRegisterViewController.h"
#import "ZJTaskViewController.h"
#import "ZJArticleViewController.h"
#import "ZJEquipmentHomeViewController.h"
#import "ZJTaskListViewController.h"
#import "ZJViewControllerApplyPrograss.h"
#import "ZJRecruitSubmitViewController.h"
#import "ZJPictuerDetailViewController.h"
#import "NetWorkForArticleGetlist.h"
#import "MarqueeView.h"
#import "AnotherMarquee.h"
#import "ZJArticleDetailViewController.h"
#import "ZJWebViewController.h"
#import "UIImageView+SD.h"
#import "UIImageView+WebCache.h"

@interface ZJTaskPursueViewController ()
<AutoScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>
{
     AutoScrollView *autoScrollView;          //轮播图片
    UICollectionView *HomeCollection;         //
}
@property (nonatomic, strong)NSMutableArray *collectionDataarr;
@property (nonatomic, strong)NSArray *picArr;
@property (nonatomic, strong)NSArray *articleArr;
@property (nonatomic, strong)NSArray *PolicyArr;
@property (nonatomic, strong)NSArray *allarticleArr;
@property (nonatomic, strong)NSArray *CompanyIArr;
@property (nonatomic, strong) NSArray *RecruitmentArr;
@property (nonatomic, strong)NSArray *allRecruitmentArr;
@property (nonatomic, strong)UIScrollView *scrollBackView;
@end

@implementation ZJTaskPursueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TopNavigationView.hidden = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeDataList.plist" ofType:nil];
           // 2.加载数组
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
    
    self.collectionDataarr = [NSMutableArray array];
    self.view.backgroundColor = WhiteBackColor;
    
    CGFloat height = 150;
    //轮播图
    autoScrollView = [[AutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    
    autoScrollView.delegate = self;

    [self getCollectionData];
    [self initCollection];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)initCollection {
    
    
    _scrollBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight - 44, SCREEN_WIDTH,SCREEN_HEIGHT- kNavBarHeight+44 -kTabBarHeight)];
    _scrollBackView.scrollEnabled = YES;
    [_scrollBackView addSubview:autoScrollView];
    [self.view addSubview:_scrollBackView];
    
    
}
-(void)initContentView{
    //上面四个按钮
    NSArray *titleArr = @[@"关于我们",@"入驻申请",@"员工注册",@"园区动态"];
    CGFloat buttonX = 0;
    for (NSString *name in titleArr) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX,autoScrollView.bottom + 10, SCREEN_WIDTH/4, 90);
        [button setImage:Image(name) forState:UIControlStateNormal];
        [button setTitle:name forState:UIControlStateNormal];
        button.titleLabel.font = FontOfSize(12);
        [button setTitleColor:ContentTextColor forState:UIControlStateNormal];
        [button addTarget: self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self initButton:button];
        [_scrollBackView addSubview:button];
        
        buttonX +=SCREEN_WIDTH/4;
    }
    //公告
    [UIView viewLinePoint:CGPointMake(0, autoScrollView.bottom + 110) inView:_scrollBackView length:SCREEN_WIDTH andAngle:0 lineColor:SepartorLineColor lineWidth:1.0];
    
    MarqueeView *artView =[[MarqueeView alloc]initWithFrame:CGRectMake(0, autoScrollView.bottom + 111, SCREEN_WIDTH,45) withTitle:self.articleArr];
    artView.titleColor = ContentTextColor;
    artView.titleFont = [UIFont systemFontOfSize:14];
    artView.backgroundColor =WhiteBackColor;
    __weak MarqueeView *marquee = artView;
    marquee.handlerTitleClickCallBack = ^(NSInteger index){
        PageDataModel *model = self.allarticleArr[index-1];
        ZJArticleDetailViewController *vc = [[ZJArticleDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    artView.moreClickCallBack = ^{
        ZJArticleViewController *vc = [[ZJArticleViewController alloc] init];
        vc.Articletype = @"Bulletin";
            [self.navigationController pushViewController:vc animated:YES];
    };
    [_scrollBackView addSubview:artView];
    
     [UIView viewLinePoint:CGPointMake(0, artView.bottom) inView:_scrollBackView length:SCREEN_WIDTH andAngle:0 lineColor:SepartorLineColor lineWidth:1.0];
    
    
    //政策资讯
    
    UIImageView *PolicylineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, artView.bottom +11, 3, 18)];
    PolicylineView.image = Image(@"蓝色竖线") ;
    [_scrollBackView addSubview:PolicylineView];
    
    UILabel *artLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, artView.bottom +10, 60, 20)];
    artLabel.text = @"政策资讯";
    artLabel.textColor = MainBackColor;
    artLabel.font = FontOfSize(14);
    [_scrollBackView addSubview:artLabel];
    
    UIButton *PolicymoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    PolicymoreButton.frame = CGRectMake(SCREEN_WIDTH - 55, artView.bottom + 3, 50, 35);
    [PolicymoreButton setImage:Image(@"蓝色竖线") forState:UIControlStateNormal];
    [PolicymoreButton setTitle:@"更多" forState:UIControlStateNormal];
    [PolicymoreButton addTarget:self action:@selector(PolicymoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [PolicymoreButton setTitleColor:MainBackColor forState:UIControlStateNormal];
    PolicymoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    PolicymoreButton.titleLabel.font = FontOfSize(12);
    [_scrollBackView addSubview:PolicymoreButton];
    
    for (int i = 0 ; i<3; i++) {
        PictureView *picView = [[PictureView alloc] init];
        PageDataModel *model = self.PolicyArr[i];
        CGFloat width = (SCREEN_WIDTH-60)/3;
        picView.layer.borderWidth = 1;
        picView.layer.cornerRadius = 8;
        picView.layer.borderColor = [UIColor clearColor].CGColor;
        picView.layer.masksToBounds = YES;
        picView.tag =100+i;
        picView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PolicyItemClick:)];
        [picView addGestureRecognizer:tap];
        picView.frame = CGRectMake(width*i+20+i*10, artLabel.bottom+20, width, 70);
        picView.url = model.articlepicture;
        [_scrollBackView addSubview:picView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*i+20+i*10, picView.bottom+10, width, 15)];
        label.text = model.articletitle;
        label.textColor = ContentTextColor;
        label.font = FontOfSize(14);
        [_scrollBackView addSubview:label];
    }
    //政策资讯
    
    UIImageView *companylineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, artLabel.bottom +136, 3, 18)];
    companylineView.image = Image(@"蓝色竖线") ;
    [_scrollBackView addSubview:companylineView];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, artLabel.bottom +135, 60, 20)];
    companyLabel.text = @"入驻企业";
    companyLabel.textColor = MainBackColor;
    companyLabel.font = FontOfSize(14);
    [_scrollBackView addSubview:companyLabel];
    
    UIButton *CompanymoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CompanymoreButton.frame = CGRectMake(SCREEN_WIDTH - 55,artLabel.bottom +128, 50, 35);
    [CompanymoreButton setImage:Image(@"蓝色竖线") forState:UIControlStateNormal];
    [CompanymoreButton setTitle:@"更多" forState:UIControlStateNormal];
    [CompanymoreButton addTarget:self action:@selector(CompanymoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [CompanymoreButton setTitleColor:MainBackColor forState:UIControlStateNormal];
    CompanymoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    CompanymoreButton.titleLabel.font = FontOfSize(12);
    [_scrollBackView addSubview:CompanymoreButton];
    for (int i = 0 ; i<3; i++) {
        PictureView *picView = [[PictureView alloc] init];
        PageDataModel *model = self.CompanyIArr[i];
        CGFloat width = (SCREEN_WIDTH-170)/3;
        picView.layer.borderWidth = 1;
        picView.layer.cornerRadius = 8;
        picView.layer.borderColor = [UIColor clearColor].CGColor;
        picView.layer.masksToBounds = YES;
        picView.tag =1000+i;
//        NSURL *url = [NSURL URLWithString:model.articlepicture];
       picView.url = model.articlepicture;
//        [picView sd_setImageWithURL:url];
    
        picView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyItemClick:)];
        [picView addGestureRecognizer:tap];
        picView.frame = CGRectMake(width*i+20+i*10, companyLabel.bottom+20, width, 60);
        
    
        [_scrollBackView addSubview:picView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*i+20+i*10, picView.bottom+10, width, 15)];
        label.text = model.articletitle;
        label.textColor = ContentTextColor;
        label.font = FontOfSize(14);
        [_scrollBackView addSubview:label];
    }
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(SCREEN_WIDTH - 120, companyLabel.bottom + 20, 100, 35);
    [foodButton setTitle:@"餐饮休闲" forState:UIControlStateNormal];
    foodButton.backgroundColor = MainBackColor;
    foodButton.layer.borderWidth = 1;
    foodButton.layer.cornerRadius = 5;
    [foodButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    foodButton.layer.borderColor = [UIColor clearColor].CGColor;
    foodButton.titleLabel.font = FontOfSize(14);
    [_scrollBackView addSubview:foodButton];
    
    UIButton *sportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sportButton.frame = CGRectMake(SCREEN_WIDTH - 120, foodButton.bottom + 10, 100, 35);
    [sportButton setTitle:@"健身中心" forState:UIControlStateNormal];
    sportButton.backgroundColor = MainBackColor;
    sportButton.layer.borderWidth = 1;
    [sportButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sportButton.layer.borderColor = [UIColor clearColor].CGColor;
    sportButton.layer.cornerRadius = 5;
    sportButton.titleLabel.font = FontOfSize(14);
    [_scrollBackView addSubview:sportButton];
    
    
    AnotherMarquee *RecruitmentView =[[AnotherMarquee alloc]initWithFrame:CGRectMake(0, sportButton.bottom + 20, SCREEN_WIDTH,45) withTitle:self.RecruitmentArr];
    RecruitmentView.titleColor = ContentTextColor;
    RecruitmentView.titleFont = [UIFont systemFontOfSize:14];
    RecruitmentView.backgroundColor =WhiteBackColor;
    __weak AnotherMarquee *Recruitment = RecruitmentView;
    Recruitment.handlerTitleClickCallBack = ^(NSInteger index){
        PageDataModel *model = self.allRecruitmentArr[index-1];
        ZJArticleDetailViewController *vc = [[ZJArticleDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
//        NSLog(@"%@----%zd",marquee.titleArr[index-1],index);
    };
    Recruitment.moreClickCallBack = ^{
        ZJArticleViewController *vc = [[ZJArticleViewController alloc] init];
        vc.Articletype = @"Recruitment";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [_scrollBackView addSubview:RecruitmentView];
    
    _scrollBackView.contentSize = CGSizeMake(0, RecruitmentView.bottom + 20);
    
    
    
}
-(void)ButtonClick:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"关于我们"]) {
        ZJWebViewController *vc = [[ZJWebViewController alloc] init];
        vc.titleS = button.titleLabel.text;
        vc.urlstr = @"http://182.131.3.110:8046/netetpsapp/www/index.html";
        [self.navigationController pushViewController:vc animated:YES];
    } else  if ([button.titleLabel.text isEqualToString:@"入驻申请"]) {
        ZJWebViewController *vc = [[ZJWebViewController alloc] init];
        vc.titleS = button.titleLabel.text;
        vc.urlstr = @"http://www.zjyunlifang.com/company/apply";
        [self.navigationController pushViewController:vc animated:YES];
    } else  if ([button.titleLabel.text isEqualToString:@"餐饮休闲"]) {
        ZJWebViewController *vc = [[ZJWebViewController alloc] init];
        vc.titleS = button.titleLabel.text;
        vc.urlstr = @"http://www.zjyunlifang.com/Introduce/Space?artid=32";
        [self.navigationController pushViewController:vc animated:YES];
    } else  if ([button.titleLabel.text isEqualToString:@"健身中心"]) {
        ZJWebViewController *vc = [[ZJWebViewController alloc] init];
        vc.titleS = button.titleLabel.text;
        vc.urlstr = @"http://www.zjyunlifang.com/Introduce/Space?artid=33";
        [self.navigationController pushViewController:vc animated:YES];
    }else  if ([button.titleLabel.text isEqualToString:@"员工注册"]) {
        ZJRegisterViewController *vc = [[ZJRegisterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        ZJArticleViewController *vc = [[ZJArticleViewController alloc] init];
        vc.Articletype = @"Bulletin";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)PolicyItemClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    PageDataModel *model = self.PolicyArr[index-100];
    ZJArticleDetailViewController *vc = [[ZJArticleDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)companyItemClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    PageDataModel *model = self.CompanyIArr[index-1000];
    ZJArticleDetailViewController *vc = [[ZJArticleDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) haha{
    
    UILabel *artLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, autoScrollView.bottom +110, 30, 25)];
    artLabel.text = @"公告";
    artLabel.textColor = MainBackColor;
    artLabel.font = FontOfSize(12);
    [_scrollBackView addSubview:artLabel];
    
    
    
    UILabel *symbol = [[UILabel alloc]initWithFrame:CGRectMake(artLabel.right +5, autoScrollView.bottom +116, 30, 12)];
    symbol.text = @"通知";
    symbol.backgroundColor = MainBackColor;
    symbol.textAlignment = NSTextAlignmentCenter;
    symbol.textColor = WhiteBackColor;
    symbol.font = FontOfSize(12);
    [_scrollBackView addSubview:symbol];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(symbol.right +10, autoScrollView.bottom +110, SCREEN_WIDTH - symbol.right -10 -55, 25)];
    content.text = @"通知通知通知通知通知通知通知通知通知通知";
    content.textColor = ContentTextColor;
    content.font = FontOfSize(10);
    [_scrollBackView addSubview:content];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(SCREEN_WIDTH - 55, autoScrollView.bottom+ 105, 50, 35);
    [moreButton setImage:Image(@"蓝色竖线") forState:UIControlStateNormal];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:MainBackColor forState:UIControlStateNormal];
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    moreButton.titleLabel.font = FontOfSize(12);
    [_scrollBackView addSubview:moreButton];
    
    
    [UIView viewLinePoint:CGPointMake(0, content.bottom + 10) inView:_scrollBackView length:SCREEN_WIDTH andAngle:0 lineColor:SepartorLineColor lineWidth:1.0];
}
-(void)initButton:(UIButton*)btn{
    //使图片和文字水平居中显示
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height + 20 ,-btn.imageView.frame.size.width, 0.0,0.0)];
    
    //图片距离右边框距离减少图片的宽度，其它不边
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0.0,10, -(btn.titleLabel.bounds.size.width)-13)];
}
//创造首页数据
- (void)getCollectionData {
    dispatch_group_t downloadGroup = dispatch_group_create();
    
    NetWorkForArticleGetlist *net = [NetWorkForArticleGetlist alloc];
     dispatch_group_enter(downloadGroup);
    net.Articletype = @"Bulletin";
    net.Pageindex = @"1";
    net.Pagesize = @"3";
    [net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            self.allarticleArr = [NSArray arrayWithArray:result.data.pagedata];
            NSMutableArray *arr = [NSMutableArray array];
            for (PageDataModel *model in result.data.pagedata) {
                [arr addObject:model.articletitle];
            }
            self.articleArr = [NSArray arrayWithArray:arr];
            dispatch_group_leave(downloadGroup);
        }
    }];
    
    dispatch_group_enter(downloadGroup);
    net.Articletype = @"Policy";
    net.Pageindex = @"1";
    net.Pagesize = @"3";
    [net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            self.PolicyArr = [NSArray arrayWithArray:result.data.pagedata];
            dispatch_group_leave(downloadGroup);
        }
    }];
    dispatch_group_enter(downloadGroup);
    net.Articletype = @"AppBanner";
    net.Pageindex = @"1";
    net.Pagesize = @"3";
    [net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            NSMutableArray *mul = [NSMutableArray array];
            for (PageDataModel *model in result.data.pagedata) {
                PictureView *picture = [[PictureView alloc] initWithFrame:autoScrollView.bounds];
                picture.isFromInternet = YES;
                picture.url = model.articlepicture;
                picture.userInteractionEnabled = YES;
                [mul addObject:picture];
            }
            
            autoScrollView.viewsArray = mul;
            _picArr = [NSArray arrayWithArray:result.data.pagedata];
            autoScrollView.autoScrollDelayTime = 5.0;
            [autoScrollView shouldAutoShow:YES];
            dispatch_group_leave(downloadGroup);
        }
    }];
    //入住企业列表
    dispatch_group_enter(downloadGroup);
    net.Articletype = @"CompanyIntroduction";
    net.Pageindex = @"1";
    net.Pagesize = @"3";
    [net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            self.CompanyIArr = [NSArray arrayWithArray:result.data.pagedata];
            dispatch_group_leave(downloadGroup);
        }
    }];
    
    dispatch_group_enter(downloadGroup);
    net.Articletype = @"Recruitment";
    net.Pageindex = @"1";
    net.Pagesize = @"3";
    [net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            self.allRecruitmentArr = [NSArray arrayWithArray:result.data.pagedata];
            NSMutableArray *arr = [NSMutableArray array];
            for (PageDataModel *model in result.data.pagedata) {
                [arr addObject:model.articletitle];
            }
            self.RecruitmentArr = [NSArray arrayWithArray:arr];
            dispatch_group_leave(downloadGroup);
        }
    }];
    [self startWithCursor];
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        [self stopWatiCursor];
        [self initContentView];
    });
//    NSArray *nameArr = @[@"物业报修",@"建议",@"设备场地预定",
//                         @"园区公告",@"园区招聘",
//                         @"投诉",@"任务查询",@"预定查询",@"车位申请",@"知识产权",@"税务服务",@"法律服务",@"品牌服务",@"退租申请"];
//    NSArray *detailArr = @[@"7x24小时",@"欢迎您的意见",@"申请租用最新设备",@"这里有最新的公共活动",@"发布您的招聘信息",@"有不满说出来",@"所有任务实时掌握",@"查询企业预定设备情况",@"办理车位登记",@"维护企业知识产权",@"税务有关的服务",@"法律相关的服务",@"树立企业品牌",@"办理退租业务"];
//    for (int i= 0; i<nameArr.count; i++) {
//        HomeCollectionModel *model = [[HomeCollectionModel alloc]init];
//        model.name  = nameArr[i];
//        model.detail = detailArr[i];
//        model.imageName = nameArr[i];
//
//
//        [_collectionDataarr addObject:model];
//    }
   
}

- (void)startAllRequest {

    
   
    
}

- (void)getAutoData {
    NetWorkForFocuspictureGetlist *netWorkForFocuspictureGetlist = [[NetWorkForFocuspictureGetlist alloc] init];
    [netWorkForFocuspictureGetlist startGetWithBlock:^(FocuspictureGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
             NSMutableArray *mul = [NSMutableArray array];
            for (pageDataModel *model in result.data.pagedata) {
                 PictureView *picture = [[PictureView alloc] initWithFrame:autoScrollView.bounds];
                picture.isFromInternet = YES;
                picture.url = model.imgurl;
                picture.userInteractionEnabled = YES;
                [mul addObject:picture];
            }
            
            autoScrollView.viewsArray = mul;
            _picArr = [NSArray arrayWithArray:result.data.pagedata];
            autoScrollView.autoScrollDelayTime = 5.0;
            [autoScrollView shouldAutoShow:YES];
        }
        
        
    }];
}
- (void) PolicymoreButtonClick {
    ZJArticleViewController *vc = [[ZJArticleViewController alloc] init];
    vc.Articletype = @"Policy";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) CompanymoreButtonClick{
    ZJArticleViewController *vc = [[ZJArticleViewController alloc] init];
    vc.Articletype = @"CompanyIntroduction";
    [self.navigationController pushViewController:vc animated:YES];
}
//#pragma mark - UICollectinoView dataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.collectionDataarr.count;
//}
////返回分区个数
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
////返回每个item
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    HomeCollectionModel *model = _collectionDataarr[indexPath.row];
//    HomeCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//    cell.nameLabel.text = model.name;
//    cell.detailLabel.text = model.detail;
//    cell.imageView.image = Image(model.imageName);
//    return cell;
//}
//
//#pragma mark -
//#pragma mark UICollectionView Delegate Method
//// 每一个cell大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//
//            CGFloat width = floorf(SCREEN_WIDTH / 2.0);
//            return CGSizeMake(width, 75);
//
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
//    [header addSubview:autoScrollView];
//
//    return header;
//}
//
//
//// 设置每组的cell的边界
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//// cell的最小行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0f;
//}
//
//// cell的最小列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0f;
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5) {
//        ZJTaskViewController *vc= [[ZJTaskViewController alloc] init];
//        vc.topTitle  = cell.nameLabel.text;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if(indexPath.row == 2){
//        ZJEquipmentHomeViewController *vc = [[ZJEquipmentHomeViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.row == 3){
//        ZJArticleViewController *vc = [[ZJArticleViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.row == 6){
//        ZJTaskListViewController *vc = [[ZJTaskListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.row == 7){
//        ZJViewControllerApplyPrograss *vc = [[ZJViewControllerApplyPrograss alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else {
//        ZJRecruitSubmitViewController *vc = [[ZJRecruitSubmitViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//
//
//}
//
- (void)didClickPage:(AutoScrollView *)view atIndex:(NSInteger)index{
    PageDataModel *mode = _picArr[index];
    ZJWebViewController *vc = [[ZJWebViewController alloc] init];
    vc.titleS = mode.articletitle;
    vc.urlstr = mode.articlecontent;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
