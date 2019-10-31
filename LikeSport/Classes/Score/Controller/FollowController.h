//
//  FollowController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"

@interface FollowController : BaseViewController

@property (nonatomic, copy) void(^detailBlock)(NSInteger type,NSInteger matchID,NSInteger state);

@property (nonatomic, assign) NSInteger type;
- (void)initWithType:(NSInteger)type;

@end
