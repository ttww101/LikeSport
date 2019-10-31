//
//  KSFootballExpansion.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/14.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSFootballExpansion.h"
#import "KSLive.h"
#import "KSGoal.h"
#import "KSMore.h"

@interface KSFootballExpansion()

@property (weak, nonatomic) UILabel *hteamnameView;
@property (weak, nonatomic) UILabel *cteamnameView;
@property (weak, nonatomic) UILabel *full_bfView;
@property (weak, nonatomic) UILabel *half_bfView;
@property (weak, nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation KSFootballExpansion

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
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 25)];
//    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
//    [self addSubview:view];
    
    // 主队名
    UILabel *hteamnameView = [[UILabel alloc] init];
    hteamnameView.font = [UIFont systemFontOfSize:13];
    hteamnameView.tintColor = [UIColor darkGrayColor];
    [self addSubview:hteamnameView];
    _hteamnameView = hteamnameView;
    
    // 客队名
    UILabel *cteamnameView = [[UILabel alloc] init];
    cteamnameView.font = [UIFont systemFontOfSize:13];
    cteamnameView.tintColor = [UIColor darkGrayColor];
    cteamnameView.textAlignment = NSTextAlignmentRight;
    [self addSubview:cteamnameView];
    _cteamnameView = cteamnameView;
    
    // 全场得分
    UILabel *full_bfView = [[UILabel alloc] init];
    full_bfView.font = [UIFont systemFontOfSize:13];
    full_bfView.tintColor = [UIColor darkGrayColor];
    full_bfView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:full_bfView];
    _full_bfView = full_bfView;
    
    // 半场得分
    UILabel *half_bfView = [[UILabel alloc] init];
    half_bfView.font = [UIFont systemFontOfSize:13];
    half_bfView.tintColor = [UIColor darkGrayColor];
    half_bfView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:half_bfView];
    _half_bfView = half_bfView;
    
    
    
    
}

- (void)setLive:(KSLive *)live
{
    _live = live;
    
    // 设置frame
    [self setUpFrame];
    
    // 设置frame
    [self setUpData];
    
    if (_live.type != 0) {
        _activityView.hidden = YES;
    } else {
        _activityView.hidden = NO;
    }
    
    _more = live.more;
    [self setUpGoal];

}

- (void)setMore:(NSArray<KSMore *> *)more
{
    _more = more;
    
    // 设置frame
    [self setUpGoal];

    
}

- (void)setUpGoal
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kSceenWidth/2+40, 5, 15, 15)];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    //    [activityView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:activityView];
    _activityView = activityView;
    [activityView startAnimating];
    
    if (_live.total_h == 0 && _live.total_c == 0) {
        [_activityView stopAnimating];
    }
    
    
    if (_live.isGoalEnpty) {
        [_activityView stopAnimating];
    } else {
    
        for (int i = 0; i < _more.count; i++) {

            KSGoal *goalView = [[KSGoal alloc] initWithFrame:CGRectMake(0,20 + (20 * i), kSceenWidth, 15)];
            KSMore *more = _more[i];
            [_activityView stopAnimating];
            
            
            if (more.teamid == _live.hteam_id) {
                goalView.hNameView.text = more.playername;
                if ([more.actiontype isEqualToString:@"g"]) {
                    goalView.hGoalView.image = [UIImage imageNamed:@"icon_events_goal_medium"];
                } else if ([more.actiontype isEqualToString:@"p"]) {
                    goalView.hGoalView.image = [UIImage imageNamed:@"icon_events_penaltyGoal_medium"];
                } else if ([more.actiontype isEqualToString:@"o"]) {
                    goalView.hGoalView.image = [UIImage imageNamed:@"icon_events_ownGoal_medium"];
                } else if ([more.actiontype isEqualToString:@"r"]) {
                    goalView.hGoalView.image = [UIImage imageNamed:@"icon_events_redCard_medium"];
                }
                goalView.cGoalView.hidden = YES;
            } else if (more.teamid == _live.cteam_id){
                goalView.cNameView.text = more.playername;
                if ([more.actiontype isEqualToString:@"g"]) {
                    goalView.cGoalView.image = [UIImage imageNamed:@"icon_events_goal_medium"];
                } else if ([more.actiontype isEqualToString:@"p"]) {
                    goalView.cGoalView.image = [UIImage imageNamed:@"icon_events_penaltyGoal_medium"];
                } else if ([more.actiontype isEqualToString:@"o"]) {
                    goalView.cGoalView.image = [UIImage imageNamed:@"icon_events_ownGoal_medium"];
                } else if ([more.actiontype isEqualToString:@"r"]) {
                    goalView.cGoalView.image = [UIImage imageNamed:@"icon_events_redCard_medium"];
                }
                goalView.hGoalView.hidden = YES;

            }
            goalView.proctime.text = [NSString stringWithFormat:@"%li'",(long)more.proctime];
            [self addSubview:goalView];
        }
    }

}

- (void)setUpGoalData
{
    
    
}

- (void)setUpData
{
    KSLive *live = _live;
    
    _hteamnameView.text = live.hteamname;
    _cteamnameView.text = live.cteamname;
    _full_bfView.text = [NSString stringWithFormat:@"%li-%li",(long)live.total_h,(long)live.total_c];
    _half_bfView.text = [NSString stringWithFormat:@"(%@)",live.half_bf];

//    _half_bfView.text = [NSString stringWithFormat:@"(%@)",[live.half_bf stringByReplacingOccurrencesOfString:@"-" withString:@":"]];
    if ([live.state isEqualToString:@"W"]) {
        _full_bfView.text = @"-";
    }
    if (live.half_bf.length == 0) {
        _half_bfView.hidden = YES;
        _full_bfView.frame = CGRectMake(kSceenWidth/2-15, 5, 30, 15);
    } else {
        _half_bfView.hidden = NO;
    }
}

- (void)setUpFrame
{
    CGFloat min = kSceenWidth/2;
    
    _hteamnameView.frame = CGRectMake(10, 5, min - 45, 15);
    _cteamnameView.frame = CGRectMake(min + 30, 5, min - 35, 15);
    _full_bfView.frame = CGRectMake(min -35 , 5, 35, 15);
    _half_bfView.frame = CGRectMake(min-5, 5, 35, 15);
}

@end