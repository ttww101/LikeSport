//
//  AppDelegate.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/3/28.
//  Copyright © 2016年 likesport. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "Definition.h"

#import "RAYNewFunctionGuideVC.h"

#import "LiveViewController.h"
#import "KSNavigationController.h"
#import "PlayingController.h"
#import "ResultController.h"
//#import "UMessage.h"
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
//#import <UserNotifications/UserNotifications.h>
//#endif
#import <AVOSCloud/AVOSCloud.h>
#import "AdViewController.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "GameViewController.h"

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark 收到推送时做的处理
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
//    [UMessage didReceiveRemoteNotification:userInfo];

    //推送反馈(app运行时)

//    NSString *  pushName = [userInfo objectForKey:@"action"];
//    NSLog(@"pushName%@",pushName);
    
    if (userInfo) {
        
        self.pushInfo = userInfo;
    }
    
    // 消除红点
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

//    UIUserNotificationSettings *settings = [UIUserNotificationSettings            settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //回调版本示例
    /*
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //完成之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
     */
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
    
}

// 告诉代理进程启动但还没进入状态保存
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
        self.pushInfo = userInfo;//[userInfo copy]
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _searchResult = [[NSMutableArray alloc] init];
    _filterList = [[NSMutableArray alloc] init];
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"b21f1d19809fd0835329f9e9"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    [JPUSHService setDebugMode];

    
    self.window.bounds = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    
    KSTabBarController *tabVc = [[KSTabBarController alloc] init];
    
  
    self.window.rootViewController =tabVc;
    self.tabBarController = tabVc;
    [self.window makeKeyAndVisible];
    
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
//    vc.titles = @[NSLocalizedStringFromTable(@"Enter the analysis of the event data", @"InfoPlist",nil),NSLocalizedStringFromTable(@"Expand Quick View Score Details", @"InfoPlist",nil),NSLocalizedStringFromTable(@"Go to view team information", @"InfoPlist",nil),NSLocalizedStringFromTable(@"Pay attention to all the races in the league, get the latest score in real time", @"InfoPlist",nil),NSLocalizedStringFromTable(@"Quickly search for more events", @"InfoPlist",nil),];
    vc.titles = @[NSLocalizedStringFromTable(@"Match analysis ,line-up and  statistics", @"InfoPlist",nil),NSLocalizedStringFromTable(@"Match details available", @"InfoPlist",nil),NSLocalizedStringFromTable(@"Get the score by searching the team or tournament", @"InfoPlist",nil),];

    NSString* frame0=[NSString stringWithFormat:@"{{%f,124},{%f,80}}",5.0f,[UIScreen mainScreen].bounds.size.width-100.0f];
    NSString* frame1=[NSString stringWithFormat:@"{{%f,124},{100,80}}",[UIScreen mainScreen].bounds.size.width-100];
    NSString* frame2=[NSString stringWithFormat:@"{{%f,40.0},{100,80}}",60.0f];
    NSString* frame3=[NSString stringWithFormat:@"{{%f,0.0},{100,80}}",[UIScreen mainScreen].bounds.size.width-100];
    NSString* frame4=[NSString stringWithFormat:@"{{%f,5.0},{100,80}}",[UIScreen mainScreen].bounds.size.width-100];
   // vc.frames=@[frame0,frame1,frame2,frame3,frame4];
    vc.frames=@[frame0,frame1,frame4];
    vc.nextaction=^(int index){
        
                if (index==0) {
                    //NSLog(@"live:%@",livevc);
                    [self.tabBarController setSelectedIndex:index];
                    KSNavigationController* navvc=(KSNavigationController*)self.tabBarController.viewControllers[index];
                    LiveViewController* livevc=navvc.viewControllers[0];
        
//                    [livevc.segmentView selectTabWithIndex:2 animate:NO];
                }
        
//                if (index==2) {
//                    [self.tabBarController setSelectedIndex:0];
//                    KSNavigationController* navvc=(KSNavigationController*)self.tabBarController.viewControllers[0];
//                    LiveViewController* livevc=navvc.viewControllers[0];
//                    livevc.resultController.selectedaction();
//        
//                }
//                if (index==4) {
//        
//                   KSNavigationController* navvc=(KSNavigationController*)self.tabBarController.viewControllers[0];
//                    [navvc popToViewController:navvc.viewControllers[0] animated:NO];
//                    
//                }

            
    };
   // [self.tabBarController presentViewController:vc animated:NO completion:^{
     //         }];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    NSLog(@"version:%@--cuuurent version:%f",version,((NSString*)[TimeOfBootCount valueForKey:@"currentversion"]).floatValue);
    CGFloat currentversion=((NSString*)[TimeOfBootCount valueForKey:@"currentversion"]).floatValue;
    
    if ((![TimeOfBootCount valueForKey:@"currentversion"])||currentversion!=version.floatValue) {
        [TimeOfBootCount setValue:version forKey:@"currentversion"];
        [TimeOfBootCount setValue:@"1" forKey:@"time"];
        [self.tabBarController presentViewController:vc animated:NO completion:^{
            
        }];

   }
    /**
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    
    if (![TimeOfBootCount valueForKey:@"time"]) {
        
        [TimeOfBootCount setValue:@"1" forKey:@"time"];
        
        [self.tabBarController presentViewController:vc animated:NO completion:^{
            
        }];

        NSLog(@"第一次启动");
        
    }else{
        
        [vc.timer invalidate];
        vc.timer=nil;
        vc=nil;
        
        NSLog(@"不是第一次启动");
    }
**/
    
    // 消除红点
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;


    //设置 shortcutItems   需要注意的是shortcutItems数组最多只能加入四个item，超过四个只会显示前面的四个
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
#pragma mark -- 3D touch
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"football"];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"item1" localizedTitle:NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil) localizedSubtitle:nil icon:icon1 userInfo:nil];
        
        //栏目2
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"basketball"];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"item2" localizedTitle:NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil) localizedSubtitle:nil icon:icon2 userInfo:nil];
        
        //栏目3
        UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tennisball"];
        UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"item3" localizedTitle:NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil) localizedSubtitle:nil icon:icon3 userInfo:nil];
        
        //栏目4
        UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"star"];
        UIApplicationShortcutItem *item4 = [[UIApplicationShortcutItem alloc] initWithType:@"item4" localizedTitle:NSLocalizedStringFromTable(@"My focus", @"InfoPlist", nil) localizedSubtitle:nil icon:icon4 userInfo:nil];
        application.shortcutItems = @[item1, item2, item3, item4];

    }

    //获取 Build  构建版本号
    NSLog(@"构建版本号=%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    
    
    [AVOSCloud setApplicationId:@"g7a8tptUnYtsEW5KDQOCzQoA-MdYXbMMI" clientKey:@"edldM19T5CMKlI7cd0YPUOgS"];
    AVOSCloud.logLevel = AVLogLevelNone;
    [AVOSCloud setAllLogsEnabled:NO];

    AVQuery *query = [AVQuery queryWithClassName:@"Flag"];

    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSString *flag = object[@"flag"];
        NSString *type = object[@"type"];
        NSDictionary *model = @{
            @"flag": flag,
            @"type": type
        };

        if ([type isEqualToString:@""]) {
            
        } else if ([type isEqualToString:@"ad"]) {
            AdViewController *adViewController = [[AdViewController alloc] init];
            adViewController.model = model;
            UIWindow *newWindow = [[UIWindow alloc] init];
            self.window1 = newWindow;
            [newWindow makeKeyAndVisible];
            [newWindow setRootViewController:adViewController];
        } else {

            GameViewController *adViewController = [[GameViewController alloc] init];
            adViewController.model = model;
            UIWindow *newWindow = [[UIWindow alloc] init];
            self.window1 = newWindow;
            [newWindow makeKeyAndVisible];
            [newWindow setRootViewController:adViewController];
        }

    }];
    
    
    
    return YES;
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
}


#pragma mark -  3D Touch 代理方法
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    //根据Item对应的type标识处理对应的点击操作
    NSString *itemType = shortcutItem.type;

    if([@"item1" isEqualToString:itemType]){ // 足球
        [self pushToCategoryWithTag:0];
    }
    else if([@"item2" isEqualToString:itemType]){  // 篮球
        [self pushToCategoryWithTag:1];
    }
    else if ([@"item3" isEqualToString:itemType]){  // 网球
        [self pushToCategoryWithTag:2];
    }
    else if ([@"item4" isEqualToString:itemType]){  // 我的关注
        [self.tabBarController setSelectedIndex:1];
    }
}

- (void)pushToCategoryWithTag:(int)tag{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:tag] forKey:@"segmentTag"];
    [defaults synchronize];
    [self.tabBarController setSelectedIndex:0];

}

// facebook跳转
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

/**
 *  全局改变Nav
 */
//- (void)changeNav
//{
//    //设置NavigationBar背景颜色
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:52/255.0 green:98/255.0 blue:142/255.0 alpha:1]];
//    //@{}代表Dictionary
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    //不设置这个无法修改状态栏字体颜色
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
//
//    //返回按钮的颜色
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//}




// 从后台进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 消除红点
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}
     
@end
