//
//  KSTeamDetailViewController.h
//  LikeSport
//
//  Created by 罗剑玉 on 2017/5/3.
//  Copyright © 2017年 swordfish. All rights reserved.
//

#import "BaseViewController.h"

@interface KSTeamDetailViewController : BaseViewController
typedef void(^backaction)();
@property (nonatomic, assign) NSInteger type; // 赛事类别
@property (nonatomic, assign) NSInteger teamid;
@property (nonatomic, copy) NSString *sportType; // 类型  A:球队 B:赛事类别 C:球员
@property(nonatomic,copy)backaction baction;

@end
