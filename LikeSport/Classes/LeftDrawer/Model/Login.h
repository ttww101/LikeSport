//
//  Login.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginResult;
@interface Login : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) LoginResult *result;

@end
@interface LoginResult : NSObject

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) NSInteger expire_time_stamp;

@property (nonatomic, copy) NSString *expire_time;

@end

@interface XGStateResult : NSObject

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger mtype0_state;

@property (nonatomic, assign) NSInteger mtype1_state;

@property (nonatomic, assign) NSInteger mtype2_state;


@end

