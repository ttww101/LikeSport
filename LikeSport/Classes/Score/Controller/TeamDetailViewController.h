//
//  TeamDetailViewController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^backaction)();
@interface TeamDetailViewController : BaseViewController
@property (nonatomic, assign) NSInteger type; // 赛事类别
@property (nonatomic, assign) NSInteger teamid;
@property (nonatomic, copy) NSString *sportType; // 类型  A:球队 B:赛事类别 C:球员
@property(nonatomic,copy)backaction baction;
@end
