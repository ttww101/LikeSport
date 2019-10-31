//
//  AppDelegate.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/3/28.
//  Copyright © 2016年 likesport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KSTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) NSMutableArray *filterList;

@property (nonatomic, strong) NSString *appLanguage;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *window1;

@property (nonatomic, strong) KSTabBarController *tabBarController;

@property (nonatomic, strong) NSDictionary *pushInfo;


@end

