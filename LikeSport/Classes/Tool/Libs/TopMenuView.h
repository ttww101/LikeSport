//
//  TopMenuView.h
//  TestJianshu
//
//  Created by fg122233 on 16/3/11.
//  Copyright © 2016年 尚联财富. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TopMenuViewDelegate <NSObject>

- (void)clickButton:(UIButton *)btn;

@end

@interface TopMenuView : UIScrollView
@property (nonatomic, assign) id<TopMenuViewDelegate> menuDelegate;
@property (nonatomic, strong) NSArray *topMenuArray;
- (void)clickBtn:(UIButton *)btn;
@end
