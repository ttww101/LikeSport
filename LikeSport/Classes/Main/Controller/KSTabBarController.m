//
//  TabBarViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/3/29.
//  Copyright © 2016年 likesport. All rights reserved.
//

#import "KSTabBarController.h"

#import "RecommendViewController.h"
#import "WikiViewController.h"
#import "MatchViewController.h"
#import "KSNavigationController.h"
#import "FollowViewController.h"
#import "AppDelegate.h"
#import "MeController.h"
#import "LiveViewController.h"

@interface KSTabBarController ()

@property (nonatomic, weak) UIButton *leftButton;

@property (weak, nonatomic) UIImageView *averView;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation KSTabBarController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTabBarItem];
//    [self setTabBarColor];
    [[UINavigationBar appearance] setBarTintColor:KSBlue];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"1"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsCompact];
    
    // 关闭navigationBar的模糊效果
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    // 使用背景图片
//    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"xxx"]];
//    [UITabBar appearance].translucent = NO;
    
    
//    [self leftButton];
//    [self averView];
    
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //pushName 是我给后天约定的通知必传值，所以我可以根据他是否为空来判断是否有通知
//    NSString *pushName = [app.pushInfo objectForKey:@"action"];
//    if([pushName isEqualToString:@"follow"]){
//        [self setSelectedIndex:2];
//    }
    
    // 右滑动
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    
}

//- (IBAction)handleSwipes:(id)sender
//{
//    if (self.childViewControllers.count == 0) {
//        [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
//    }
//}

// 从后台启动时检查推送
- (void)receiveNotification {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //pushName 是我给后天约定的通知必传值，所以我可以根据他是否为空来判断是否有通知
    NSString *pushName = [app.pushInfo objectForKey:@"action"];
    if([pushName isEqualToString:@"follow"]){
        [self setSelectedIndex:1];
    }
}

- (void)setTabBarItem
{

    LiveViewController *scoreVc = [[LiveViewController alloc] init];
    scoreVc.tabBarItem.title = NSLocalizedStringFromTable(@"Live", @"InfoPlist", nil);
    scoreVc.navigationItem.title = NSLocalizedStringFromTable(@"Live", @"InfoPlist", nil);
    
    
    FollowViewController *followVc = [[FollowViewController alloc] init];
    followVc.tabBarItem.title = NSLocalizedStringFromTable(@"My focus", @"InfoPlist", nil);
    followVc.navigationItem.title = NSLocalizedStringFromTable(@"My focus", @"InfoPlist", nil);
    
    WikiViewController *wikiVc = [[WikiViewController alloc] init];
    wikiVc.tabBarItem.title = NSLocalizedStringFromTable(@"News", @"InfoPlist", nil);
    wikiVc.navigationItem.title = NSLocalizedStringFromTable(@"News", @"InfoPlist", nil);
    
    RecommendViewController *recVc = [[RecommendViewController alloc] init];
    recVc.tabBarItem.title = NSLocalizedStringFromTable(@"Tips", @"InfoPlist", nil);
    recVc.navigationItem.title = NSLocalizedStringFromTable(@"Tips", @"InfoPlist", nil);
    
    MeController *userVc = [[MeController alloc] init];
    userVc.tabBarItem.title = NSLocalizedStringFromTable(@"Me", @"InfoPlist", nil);
    userVc.navigationItem.title = NSLocalizedStringFromTable(@"Me", @"InfoPlist", nil);

    
    
    self.viewControllers = @[
         [self giveMeNavWithVC:scoreVc andImgName:@"tabbar_score" andSelectedImgName:@"tabbar_score"],
         
         [self giveMeNavWithVC:wikiVc andImgName:@"tabbar_wiki" andSelectedImgName:@"tabbar_wiki"],
         
         [self giveMeNavWithVC:followVc andImgName:@"star" andSelectedImgName:@"star"],
         
         [self giveMeNavWithVC:userVc andImgName:@"tabbar_me" andSelectedImgName:@"tabbar_me"]
    ];
    
    // 设置tabbar背景色
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.tintColor = KSBlue;
    
//    self.tabBar.tintColor = [UIColor colorWithRed:254/255.0 green:198/255.0 blue:22/255.0 alpha:1];
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 49)];
//    backView.backgroundColor = KSBlue;
//    [self.tabBar insertSubview:backView atIndex:0];
   //self.tabBar.opaque = YES;
    self.tabBar.translucent=NO;
    self.tabBar.barTintColor=KSBlue;
    self.tabBar.barTintColor=[UIColor whiteColor];
    
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:200/255.0 green:224/255.0 blue:251/255.0 alpha:1]];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], UITextAttributeTextColor, nil]forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:200/255.0 green:224/255.0 blue:251/255.0 alpha:1]} forState:UIControlStateNormal];
    
}
//- (void)setTabBarColor {
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor grayColor], UITextAttributeTextColor,
//                                                       nil] forState:UIControlStateNormal];
//    UIColor *titleHighlightedColor = KSBlue;
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       titleHighlightedColor, UITextAttributeTextColor,
//                                                       nil] forState:UIControlStateSelected];
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 49)];
//    backView.backgroundColor = [UIColor colorWithRed:52/255.0 green:98/255.0 blue:147/255.0 alpha:1];
//    [self.tabBarController.tabBar insertSubview:backView atIndex:0];
//    self.tabBarController.tabBar.opaque = YES;
//}

/**
 *  返回取消渲染的image
 */
- (UIImage *)removeRendering:(NSString *)imageName
{
    UIImage * image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



/**
 *  快速创建Nav
 */
- (KSNavigationController *)giveMeNavWithVC:(UIViewController *)VC andImgName:(NSString *)imgName andSelectedImgName:(NSString *)selImgName
{
    KSNavigationController * nav = [[KSNavigationController alloc]initWithRootViewController:VC];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:VC.tabBarItem.title image:[UIImage imageNamed:imgName] tag:0];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selImgName];
//    nav.tabBarItem.image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
//    nav.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"aver"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedMenuButton:)];
    
    return nav;
}

//- (UIImageView *)averView
//{
//    if (!_averView) {
//        UIImageView *averView = [[UIImageView alloc] init];
//        averView.frame = CGRectMake(10, 25, 30, 30);
//        averView.image = [UIImage imageNamed:@"aver"];
//        averView.layer.cornerRadius = 15;
//        averView.layer.masksToBounds = YES;
//        
////        [averView ]
//    }
//    return _averView;
//}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *leftButton = [[UIButton alloc] init];
        leftButton.frame = CGRectMake(10, 25, 30, 30);
        //设置头像按钮圆形
        leftButton.layer.cornerRadius = 15;
        leftButton.layer.masksToBounds = YES;

        
        
        [leftButton addTarget:self action:@selector(didClickedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"aver"] forState:UIControlStateNormal];
        [self.view addSubview:leftButton];
        _leftButton = leftButton;
    }
    return _leftButton;
}



#pragma mark event action
- (void)didClickedMenuButton:(UIButton *)sender {
    [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveNotification" object:nil];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
