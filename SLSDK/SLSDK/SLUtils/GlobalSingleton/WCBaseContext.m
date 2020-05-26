//#import "DDASLLogger.h"
//#import "DDTTYLogger.h"
//#import "WCLogFormatter.h"
#import "WCPlistHelper.h"
//#import "WCLocationManager.h"
//#import "UncaughtExceptionHandler.h"
//#import "WCRandomStatistic.h"
//#import "DDFileLogger.h"
#import "ASIConnectionProvider.h"
//#import "MKConnectionProvider.h"
#import "AFConnectionProvider.h"
//#import "WCTreeNodeHelper.h"
//#import "WCContactService.h"
//#import "WC11301Service.h"
//#import "WCBoxMate.h"

#import "WCBaseContext.h"
#import "WCBaseConfiguration.h"

#define ARC4RANDOM_MAX      0x100000000

static WCBaseContext *sharedInstance;
static BOOL _hasSetup;

@implementation WCBaseContext
{
    id <WCNetworkOperationProvider> _connectionProvider;
    NSString *_cacheRootPath;
    NSString *_dataBasePath;
}

+ (void)initialize
{
    NSAssert([WCBaseContext class] == self, @"Incorrect use of singleton : %@, %@", [WCBaseContext class], [self class]);
    _hasSetup = NO;
    sharedInstance = [[WCBaseContext alloc] init];
}

+ (WCBaseContext *)sharedInstance
{
    return sharedInstance;
}


/*

- (void)setupCore
{
    [self checkCacheFolder:[self cacheRootFolder]];
    [self checkCacheFolder:[self resourceFolder]];
    [self checkCacheFolder:[self multimediaFolder]];
    [self checkCacheFolder:[self webPageFolder]];
    [self checkCacheFolder:[self downloadFolder]];
    [self checkCacheFolder:[self logFolder]];

    [self setupLogger];

    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSURL fileURLWithPath:[self databasePath]]];
}

- (NSString *)databasePath
{
    return _dataBasePath;
}

- (void)setupLogger
{
    WCLogFormatter *formatter = [[WCLogFormatter alloc] init];

    DDLogFileManagerDefault *fm = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[self logFolder]];
    DDFileLogger *fl = [[DDFileLogger alloc] initWithLogFileManager:fm];

    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    UIColor *pink = [UIColor colorWithRed:(255 / 255.0) green:(58 / 255.0) blue:(159 / 255.0) alpha:1.0];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor yellowColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];

    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:fl];
}
 
 */

-(void)setDeviceToken:(NSString *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"DeviceToken"];
}

-(NSString *)getDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
}

- (NSString *)userToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
}

- (void)setUserToken:(NSString *)userToken
{
    if (userToken)
        [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"UserToken"];
}

+ (double)randomDoubleStart:(double)a end:(double)b
{
    double random = ((double) arc4random()) / (double) ARC4RANDOM_MAX;
    double diff = b - a;
    double r = random * diff;
    return a + r;
}

+ (NSString *)appVersion
{
    NSString *verNum = [WCBaseContext sharedInstance].configuration.versionNumber;
    NSString *buildNum = [WCBaseContext sharedInstance].configuration.buildNumber;
    NSString *version = [NSString stringWithFormat:@"%@.%@", verNum, buildNum];
    return version;
}


- (WCBaseConfiguration *)configuration
{
    if (_configuration == nil)
    {
        WCPlistHelper *plistHelper = [[WCPlistHelper alloc] initWithPlistNamed:@"onbConfiguration"];
        _configuration = [[WCBaseConfiguration alloc] initWithDictionary:plistHelper.allProperties];
    }
    return _configuration;
}

/*

- (WCNaviServiceItemsManager *)naviServiceManager
{
    if (_naviServiceManager == nil)
        _naviServiceManager = [[WCNaviServiceItemsManager alloc] init];

    return _naviServiceManager;
}

- (WCLogRecordHelper *)logHelper
{
    if (_logHelper == nil)
        _logHelper = [[WCLogRecordHelper alloc] init];
    

    return _logHelper;
}

- (NSMutableDictionary *)deviceManagementData
{
    if (_deviceManagementData == nil)
    {
        _deviceManagementData = [NSMutableDictionary dictionaryWithCapacity:10];
        NSMutableArray *warningAppList = [NSMutableArray arrayWithCapacity:5];
        [_deviceManagementData setObject:warningAppList forKey:@"warningAppList"];
    }
    return _deviceManagementData;
}

- (WCSyncManager *)syncManager
{
    if (_syncManager == nil)
        _syncManager = [[WCSyncManager alloc] init];
    
    return _syncManager;
}

- (WCPolicyManager *)policyManager
{
    if (_policyManager == nil)
        _policyManager = [[WCPolicyManager alloc] init];
    
    return _policyManager;
}

- (WCLocationManager *)locationManager
{
    if (_locationManager == nil)
        _locationManager = [[WCLocationManager alloc] init];

    return _locationManager;
}

- (WCDownloaderManager *)downloaderManager
{
    if (_downloaderManager == nil)
        _downloaderManager = [[WCDownloaderManager alloc] init];
    
    return _downloaderManager;
}

- (WCUserHelper *)userHelper
{
    if (_userHelper == nil)
        _userHelper = [[WCUserHelper alloc] init];
    
    return _userHelper;
}

-(WCTreeNodeHelper *)treeNodeHelper
{
    if (_treeNodeHelper == nil)
        _treeNodeHelper= [[WCTreeNodeHelper alloc] init];
    
    return _treeNodeHelper;
}

- (WCMultimediaCenter *)multimediaCenter
{
    if (_multimediaCenter == nil)
        _multimediaCenter = [[WCMultimediaCenter alloc] init];
    
    return _multimediaCenter;
}

*/



- (id <WCNetworkOperationProvider>)connectionProvider
{
    return _connectionProvider;
}

- (id <WCNetworkOperationProvider>)loadDefaultConnectionProvider
{
    if ([UIDevice getCurrentSystemVersionNumber] < 8)
        return [[ASIConnectionProvider alloc] init];
    else
        return [[AFConnectionProvider alloc] init];
}

- (void)startup
{
    if ([UIDevice getCurrentSystemVersionNumber] < 8)
        [self startupWithConnectionProviderType:EASINetworkProvider andCacheRootPath:nil andConfiguration:nil];
    else
        [self startupWithConnectionProviderType:EAFNetworkProvider andCacheRootPath:nil andConfiguration:nil];
}

- (void)startupWithConfiguration:(WCBaseConfiguration *)configuration andDatabaseStorePath:(NSString *)dataBasePath
{
    [self startupWithConnectionProvider:nil andCacheRootPath:nil andConfiguration:nil andDatabaseStorePath:dataBasePath];
}

- (void)startupWithConfiguration:(WCBaseConfiguration *)configuration
{
    if ([UIDevice getCurrentSystemVersionNumber] < 8)
        [self startupWithConnectionProviderType:EASINetworkProvider andCacheRootPath:nil andConfiguration:configuration];
    else
        [self startupWithConnectionProviderType:EAFNetworkProvider andCacheRootPath:nil andConfiguration:configuration];
}

- (void)startupWithConnectionProvider:(id <WCNetworkOperationProvider>)provider andConfiguration:(WCBaseConfiguration *)configuration
{
    [self startupWithConnectionProvider:provider andCacheRootPath:nil andConfiguration:configuration andDatabaseStorePath:nil];
}

- (void)startupWithCacheRootPath:(NSString *)cacheRootPath andConfiguration:(WCBaseConfiguration *)configuration
{
    if ([UIDevice getCurrentSystemVersionNumber] < 8)
        [self startupWithConnectionProviderType:EASINetworkProvider andCacheRootPath:cacheRootPath andConfiguration:configuration];
    else
        [self startupWithConnectionProviderType:EAFNetworkProvider andCacheRootPath:cacheRootPath andConfiguration:configuration];
}

- (void)startupWithConnectionProviderType:(ENetworkProviderType)providerType andCacheRootPath:(NSString *)cacheRootPath
                         andConfiguration:(WCBaseConfiguration *)configuration
{
    switch (providerType)
    {
        case EASINetworkProvider:
            [self startupWithConnectionProvider:[[ASIConnectionProvider alloc] init] andCacheRootPath:cacheRootPath andConfiguration:configuration andDatabaseStorePath:nil];
            break;
//        case EMKNetworkProvider:
//            [self startupWithConnectionProvider:[[MKConnectionProvider alloc]init] andCacheRootPath:cacheRootPath andConfiguration:configuration andDatabaseStorePath:nil];
//            break;
        case EAFNetworkProvider:
            [self startupWithConnectionProvider:[[AFConnectionProvider alloc] init] andCacheRootPath:cacheRootPath andConfiguration:configuration andDatabaseStorePath:nil];
            break;
        default:
            break;
    }
}

- (void)startupWithConnectionProvider:(id <WCNetworkOperationProvider>)provider andCacheRootPath:(NSString *)cacheRootPath
                     andConfiguration:(WCBaseConfiguration *)configuration andDatabaseStorePath:(NSString *)dataBasePath
{
    if (_hasSetup == YES)
        return;
    
    _hasSetup = YES;

    /*
    if ([[cacheRootPath stringWithTrimWhiteSpcace] length])
        _cacheRootPath = cacheRootPath;
    else
        _cacheRootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    */
    
    _cacheRootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];


    _dataBasePath = dataBasePath;
    if (_dataBasePath == nil)
    {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths lastObject];
        _dataBasePath = [documentPath stringByAppendingPathComponent:@"WCS.sqlite"];
    }

    //[self setupCore];

    if (configuration)
        _configuration = configuration;

    if ([UIDevice getCurrentSystemVersionNumber] < 7)
        self.configuration.supportBackgroundTransfer= NO;

//    if (self.configuration.supportBackgroundTransfer && ![_connectionProvider isKindOfClass:[AFConnectionProvider class]])
//        _connectionProvider = [[AFConnectionProvider alloc] initWithBackTransferDelegate:self.downloaderManager];//目前仅AFNetworking支持后台传输

    if (!_connectionProvider)
        _connectionProvider = provider;
    if (!_connectionProvider)
        _connectionProvider = [self loadDefaultConnectionProvider];

    //InstallUncaughtExceptionHandler();

//    if ([self.configuration.boxAddress length])
//        [[WCBoxMate sharedInstance] startup:!self.configuration.hideBoxToast];
}

/*

- (void)synchornizeContactInfo
{
    [[WCContactService shareInstance] synchornizeContactInfo];
}

- (NSString *)cacheRootFolder
{
    return [_cacheRootPath stringByAppendingPathComponent:CACHE_ROOT_FOLDER];
}

- (NSString *)resourceFolder
{
    return [[self cacheRootFolder] stringByAppendingPathComponent:CACHE_RESOURCE_FOLDER];
}

- (NSString *)multimediaFolder
{
    return [[self cacheRootFolder] stringByAppendingPathComponent:CACHE_MULTIMEDIA_FOLDER];
}

- (NSString *)webPageFolder
{
    return [[self multimediaFolder] stringByAppendingPathComponent:CACHE_MULTIMEDIA_WEBPAGE_FOLDER];
}

- (NSString *)downloadFolder
{
    return [[self cacheRootFolder] stringByAppendingPathComponent:CACHE_DOWNLOAD_TMP_FOLDER];
}

- (NSString *)logFolder
{
    return [[self cacheRootFolder] stringByAppendingPathComponent:CACHE_LOG_FOLDER];
}

*/



- (void)checkCacheFolder:(NSString *)folderPath
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if (!(isDir && existed))
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
