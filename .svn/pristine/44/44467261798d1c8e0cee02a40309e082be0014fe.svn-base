//
//  BaseViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/3/29.
//  Copyright © 2016年 likesport. All rights reserved.
//

#import "BaseViewController.h"
#import "UMMobClick/MobClick.h"

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1];
    
    // automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addRightBtnWithStr:(NSString *)str andSelector:(SEL)sel
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStylePlain target:self action:sel];
}

- (void)addLeftBtnWithStr:(NSString *)str andSelector:(SEL)sel
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStylePlain target:self action:sel];
}

- (void)addRightBtnWithImgName:(NSString *)imgName andSelector:(SEL)sel
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[self removeRendering:imgName] style:UIBarButtonItemStylePlain target:self action:sel];
    
    //微调一下图片的位置
    [self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, WGiveWidth(-6), 0, WGiveWidth(6))];
}

- (void)addLeftBtnWithImgName:(NSString *)imgName andSelector:(SEL)sel
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[self removeRendering:imgName] style:UIBarButtonItemStylePlain target:self action:sel];
    
    //微调一下图片的位置
//    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, WGiveWidth(-6), 0, WGiveWidth(6))];
}

/**
 *  修改状态颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  返回取消渲染的image
 */
- (UIImage *)removeRendering:(NSString *)imageName
{
    UIImage * image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// 自定义导航视图
- (void)naviBarAddView:(UIView *)view
{
    if (view)
    {
        [self.view addSubview:view];
    }else{}
}

// 友盟页面统计
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self setNeedsStatusBarAppearanceUpdate];
//    [MobClick beginLogPageView:@"PageOne"];//("PageOne"为页面名称，可自定义)
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[self getCurrentViewController].title];
//    NSLog(@"title=%@",[self getCurrentViewController].nibName);
//}
//
///** 获取当前View的控制器对象 */
//-(UIViewController *)getCurrentViewController{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
//}


@end
