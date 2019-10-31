//
//  UserInfoController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/15.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfo.h"

@interface UserInfoController : BaseViewController

@property (nonatomic, strong) UserInfoResult *userInfo;

@property(nonatomic,strong)UIImageView * avaterView;
@property (nonatomic, copy) void(^tokenBlock)();


@end
