//
//  NavigationViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/5.
//  Copyright © 2016年 likesport. All rights reserved.
//
#import "AppDelegate.h"
#import "KSNavigationController.h"

@interface KSNavigationController ()//<UINavigationBarDelegate>

@end

@implementation KSNavigationController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 去掉返回按钮里面的文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    
}

//#pragma mark navigation delegate
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    // 在进入收藏页面(一级页面，若打开返回手势，会影响收藏页面上的操作)时， 或者进入到其他的二级页面，关闭返回手势
//        if ((navigationController.childViewControllers.count == 1) || navigationController.childViewControllers.count > 1) {
//            delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//        } else {
//            delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//        }
//    
//}
//
//
//#pragma mark pop mothed
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    // 当一级页面需要返回时，打开抽屉
//    if (self.childViewControllers.count == 0) {
//        [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
//    }
//    
//    return [super popViewControllerAnimated:animated];
//}

- (void)viewDidAppear:(BOOL)animated {
//    for (UIViewController *vc in self.childViewControllers) {
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        NSString *averUrl = [defaults objectForKey:@"averUrl"];
//        NSString *aver = [averUrl stringByReplacingOccurrencesOfString:@"180x180" withString:@"50x50"];
//
//        //FIXME: tabBar切换子视图时都会重新请求头像的图片
//        UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//        NSURL * url = [NSURL URLWithString:averUrl];
//        UIImage *image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//        if (aver.length == 0 || [aver isEqualToString:@"http://app.likesport.com/"]) {
//            image3 = [UIImage imageNamed:@"img_default"];
//        }
//        
//        [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
//        //设置头像按钮圆形
//        someButton.layer.cornerRadius = 18;
//        someButton.layer.masksToBounds = YES;
//        
//        [someButton addTarget:self action:@selector(didClickedMenuButton:) forControlEvents:UIControlEventTouchUpInside];[someButton setShowsTouchWhenHighlighted:YES];
//        UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
//        vc.navigationItem.leftBarButtonItem = mailbutton;

//    }
    [super viewDidAppear:animated];
}

- (void)didClickedMenuButton:(UIButton *)sender {
    [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
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
