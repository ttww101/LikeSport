//
//  FootballDetailController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
#import "KSTopView.h"
@interface FootballDetailController : BaseViewController
@property (nonatomic, strong) KSTopView *topView;
@property (nonatomic, assign) NSInteger matchID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger state;


@end
