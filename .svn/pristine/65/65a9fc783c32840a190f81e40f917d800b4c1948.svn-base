//
//  League.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/6.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LeagueResult,T0;
@interface League : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) LeagueResult *result;

@end
@interface LeagueResult : NSObject

@property (nonatomic, strong) NSArray<T0 *> *t0;

@property (nonatomic, strong) NSArray<T0 *> *t1;

@property (nonatomic, strong) NSArray<T0 *> *t2;


@end

@interface T0 : NSObject

@property (nonatomic, assign) NSInteger mtype;

// 联赛名
@property (nonatomic, copy) NSString *matchtypefullname;

// 球队名
@property (nonatomic, copy) NSString *teamname;

// 通用名
@property (nonatomic, copy) NSString *name;


@property (nonatomic, copy) NSString *signcode;

// 联赛ID
@property (nonatomic, assign) NSInteger matchtype_id;

// 球队ID
@property (nonatomic, assign) NSInteger team_id;

// 通用ID
@property (nonatomic, assign) NSInteger ID;


@property (nonatomic, assign) NSInteger LastContactTime;

@property (nonatomic, assign) NSInteger is_follow;


@end


