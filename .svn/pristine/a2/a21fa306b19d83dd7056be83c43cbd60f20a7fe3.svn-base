//
//  PlayingController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^removetimerblock)();
@interface PlayingController : BaseViewController

@property (nonatomic, copy) void(^detailBlock)(NSInteger type,NSInteger matchID,NSInteger state);

@property (nonatomic, copy) void(^moreBlock)();

@property (nonatomic, assign) NSInteger type;

@property(nonatomic,copy)removetimerblock removeaction;

- (void)initWithType:(NSInteger)type;
- (void)addTimer;
- (void)addMinuteTimer;
- (void)conditionTadayArray:(NSArray *)array withChooseType:(NSInteger)chooseType; // 当前日筛选
- (void)selectTodayAllData;  // 当前日全部筛选

@end
