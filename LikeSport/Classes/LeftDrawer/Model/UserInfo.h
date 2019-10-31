//
//  UserInfo.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoResult;
@interface UserInfo : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) UserInfoResult *result;

@end
@interface UserInfoResult : NSObject

@property (nonatomic, assign) NSInteger userid;

@property (nonatomic, assign) NSInteger sns_shu_num;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger gem;

@property (nonatomic, assign) NSInteger sns_fans_num;

@property (nonatomic, assign) NSInteger sns_gz_1_num;

@property (nonatomic, assign) NSInteger sns_news_count;

@property (nonatomic, copy) NSString *sns_level;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) NSInteger region_id;

@property (nonatomic, assign) NSInteger sns_win_num;

@property (nonatomic, assign) NSInteger region_parent;

@property (nonatomic, assign) NSInteger sns_gz_2_num;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, assign) NSInteger sns_he_num;

@property (nonatomic, assign) NSInteger sns_gz_0_num;

@property (nonatomic, assign) NSInteger gold;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *user_name;

@end

@interface User : NSObject

@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;

@end
