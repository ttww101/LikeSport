//
//  RegisterViewController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (nonatomic, copy) void(^tokenBlock)(NSString *token,BOOL isRegister);

@end
