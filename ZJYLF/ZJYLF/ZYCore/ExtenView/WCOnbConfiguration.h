#import <Foundation/Foundation.h>
#import "IObjcJsonBase.h"
#import "WCBaseConfiguration.h"
//===================================================================================================================================================

#pragma mark - 自定义配置文件管理器
@interface WCOnbConfiguration : WCBaseConfiguration

@property (nonatomic, assign) BOOL sendSMS;
@property (nonatomic, copy) NSString *naviTitleColor;
@property (nonatomic, copy) NSString *naviItemColor;
@property (nonatomic, copy) NSString *multiSubCellForeColor;
@property (nonatomic, copy) NSString *multiSubCellBackgroundColor;
@property (nonatomic, assign) BOOL showExchangeInInquire;
@property (nonatomic, assign) BOOL hideActivateItem;
@property (nonatomic, assign) BOOL smsRegister;
@property (nonatomic, assign) BOOL localShare;
@property (nonatomic, copy) NSString *signInTextColor;
@property (nonatomic, assign) BOOL hideNaviLeftTitle;
@property (nonatomic, copy) NSString *tabbarBackgroundImage;
@property (nonatomic, copy) NSString *tabItemColorNormal DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *tabItemColorHighlight DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *tabbarTextColor;
@property (nonatomic, copy) NSString *tabbarSelectedTextColor;
@property (nonatomic, assign) BOOL synchronizecat;                  //是否上传通讯录
@property (nonatomic, copy) NSString *smsNotiMsg;
@property (nonatomic, copy) NSString *drawerBGColor;
@property (nonatomic, assign) BOOL needrate;
@property (nonatomic, strong) NSString  *appstorepath;
@property (nonatomic, strong) NSString  *ratingmessage;
@property (nonatomic, assign) BOOL isVerticalTabbar;
@property (nonatomic, strong) NSString  *toptabColor;
@property (nonatomic, strong) NSString  *toptabSelectedColor;
@property (nonatomic, assign) BOOL hidePageIndicator;
@property (nonatomic, strong) NSString  *pageIndicatorTintColor;
@property (nonatomic, strong) NSString  *currentPageIndicatorTintColor;
@property (nonatomic, assign) BOOL allowArticleShare;               //文章是否支持分享
@property (nonatomic, strong) NSString *poitype;
@property (nonatomic, strong) NSString *poidispatch;
@property (nonatomic, strong) NSString *resourceBundleName;
@property (nonatomic, assign) BOOL beacon;
@property (nonatomic, strong) NSNumber *beaconCallType;
@property (nonatomic, strong) NSNumber *beaconRange;
@property (nonatomic, strong) NSArray *beaconRegions;
//@property (nonatomic, assign) CGFloat gridViewCellHeightWidthProportion;
//@property (nonatomic, assign) CGFloat gridViewCellMargin;
@property (nonatomic, strong) NSString *smsr;                       //预设手机号码
@property (nonatomic, assign) BOOL order387;                        //是否启动387排序
@property (nonatomic, assign) BOOL lightStatusBarContent;
@property (nonatomic, assign) BOOL needFTU;                         //是否需要引导视图
@property (nonatomic, strong) NSString *loginViewController;        //登录视图管理器名称
@property (nonatomic, strong) NSString *rootViewController;        //登录视图管理器名称


@property (nonatomic, assign) BOOL isStartShowLoginViewController;  //是否启动显示登录视图管理器标示
@property (nonatomic, strong) NSString *afterSalePhone;             //售后电话
@property (nonatomic, strong) NSString *startAppDelegate;           //启动appDelegate字段
@property (nonatomic, assign) BOOL isenablewhenmenushow;            //当菜单显示时，侧面的界面是否可用
@property (nonatomic, strong) NSString *LOGIN_MODE;                 //登录模式
@property (nonatomic, strong) NSString *SHOW_WELCOME_LETTER;        //显示欢迎信
@property (nonatomic, assign) BOOL fullscreenafterfirst;            //第一次后侧滑屏幕全屏
@property (nonatomic, assign) BOOL leftMenuAlwaysFullscreen;        //侧滑屏幕一直全屏
@property (nonatomic, copy) NSString *leftMenuItemSelectBackGroundColor;        //侧滑菜单高亮色
@property (nonatomic, strong) NSString *cityCodeTxt;                //城市编码对应的txt文件
@property (nonatomic, assign) BOOL isattachuseridwithurl;           //是否在url后面尾随userid
@property (nonatomic, retain) NSString *mapBtnTitleColorNormal;
@property (nonatomic, retain) NSString *mapBtnTitleColorSelect;
@property (nonatomic, retain) NSMutableDictionary *shareconfig;   //全局share配置
@property (nonatomic, retain) NSString *app_share_url; //分享url配置
@property (nonatomic, assign) BOOL needSV; //是否需要开场video
@property (nonatomic,assign) BOOL FireBeacon; //是否是在第一次启动时触发空beacon
@property (nonatomic, assign) BOOL bloodSugarManualInput;
@property (nonatomic, copy) NSString *agreementURLString;



-(BOOL)isForAppStore; //是否是AppStore项目

@property(nonatomic, assign) BOOL miniPublisherComplexStyle;//聊天发布栏样式,默认为false;
@property(nonatomic, assign) BOOL miniPublisherDisableEmotion;//聊天发布栏表情按钮是否禁用,默认为false;

@property(nonatomic, assign) BOOL hideBoxToast;//是否隐藏box提示
@property(nonatomic, assign) BOOL needAdvertisementView;//是否显示启动广告
@property(nonatomic, assign) BOOL httpWebViewHideShowToolBar;

@end
//===================================================================================================================================================
