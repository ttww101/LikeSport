//
//  LoginViewController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (nonatomic, copy) void(^tokenBlock)(NSString *token);

@end
