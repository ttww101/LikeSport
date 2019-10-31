//
//  TopMenuView.m
//  TestJianshu
//
//  Created by fg122233 on 16/3/11.
//  Copyright © 2016年 尚联财富. All rights reserved.
//

#import "TopMenuView.h"
@interface TopMenuView (){
    CGFloat buttonWidth;
}
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TopMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.topMenuArray = @[@"进行中",@"已完场",@"未开赛",@"关注"];
        [self configBtttonWithFrame:frame];
    }
    return self;
}
- (void)configBtttonWithFrame:(CGRect )frame{
    buttonWidth = frame.size.width / 4;
    self.contentSize = CGSizeMake(self.topMenuArray.count * buttonWidth,frame.size.height);
    for (int i =0 ; i < self.topMenuArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        btn.tag = 100 + i;
        btn.frame = CGRectMake(i *buttonWidth, 0, buttonWidth, frame.size.height);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:self.topMenuArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, buttonWidth, 0.5)];
    _lineView.backgroundColor = [UIColor redColor];
    [self addSubview:_lineView];
}

- (void)clickBtn:(UIButton *)btn{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *tempButton = (UIButton *)subView;
            [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    CGRect originFrame =  btn.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.frame = CGRectMake(btn.frame.origin.x, originFrame.size.height-1, buttonWidth, 1);
        self.contentOffset = CGPointMake([self scrollViewOffsetWitBtn:btn], 0);
    }];
    
    if (self.menuDelegate && [self.menuDelegate respondsToSelector:@selector(clickButton:)]) {
        [self.menuDelegate clickButton:btn];
    }
}
//根据btn的frame计算顶部scrollview的最适偏移量
- (NSInteger)scrollViewOffsetWitBtn:(UIButton *)btn{
    NSInteger offset = btn.frame.origin.x - ([UIScreen mainScreen].bounds.size.width /2) + (buttonWidth / 2);
    if (offset < 0) {
        offset = 0;
    } else if (offset > self.topMenuArray.count * buttonWidth - [UIScreen mainScreen].bounds.size.width){
        offset = self.topMenuArray.count * buttonWidth - [UIScreen mainScreen].bounds.size.width;
    }
    return offset;
}
@end
