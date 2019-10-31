//
//  KSGoal.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSGoal.h"
#import "KSMore.h"
@interface KSGoal ()

@end

@implementation KSGoal

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加所有子控件
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setUpAllChildView
{
    CGFloat min = kSceenWidth/2;

    // 主队名
    UILabel *hNameView = [[UILabel alloc] init];
    hNameView.font = [UIFont systemFontOfSize:13];
    hNameView.frame = CGRectMake(10, 5, min - 50, 15);
    hNameView.textAlignment = NSTextAlignmentRight;
    [self addSubview:hNameView];
    _hNameView = hNameView;
    
    UILabel *cNameView = [[UILabel alloc] init];
    cNameView.font = [UIFont systemFontOfSize:13];
    cNameView.frame = CGRectMake(min + 50, 5, min - 30, 15);
    cNameView.textAlignment = NSTextAlignmentLeft;
    [self addSubview:cNameView];
    _cNameView = cNameView;
    
    UIImageView *hGoalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_events_goal_medium"]];
    hGoalView.frame = CGRectMake(min - 30, 5, 15, 15);
    [self addSubview:hGoalView];
    _hGoalView = hGoalView;
    
    UIImageView *cGoalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_events_goal_medium"]];
    cGoalView.frame = CGRectMake(min + 25, 5, 15, 15);
    [self addSubview:cGoalView];
    _cGoalView = cGoalView;
    
    UILabel *proctime = [[UILabel alloc] init];
    proctime.font = [UIFont systemFontOfSize:13];
    proctime.frame = CGRectMake(min - 10, 5, 30, 15);
    proctime.textAlignment = NSTextAlignmentCenter;
    [self addSubview:proctime];
    _proctime = proctime;
}

- (void)setHNameView:(UILabel *)hNameView
{
    _hNameView = hNameView;
}

- (void)setCNameView:(UILabel *)cNameView
{
    _cNameView = cNameView;
}

- (void)setHGoalView:(UILabel *)hGoalView
{
    _hGoalView = hGoalView;
}

- (void)setCGoalView:(UILabel *)cGoalView
{
    _cGoalView = cGoalView;
}

- (void)setProctime:(UILabel *)proctime
{
    _proctime = proctime;
}

@end
