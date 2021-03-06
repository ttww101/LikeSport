//
//  KSFootballBase.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FootballBaseResult;
@interface KSFootballBase : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) FootballBaseResult *result;

@end
@interface FootballBaseResult : NSObject

@property (nonatomic, assign) NSInteger wiki_id;

@property (nonatomic, copy) NSString *momentname;

@property (nonatomic, assign) NSInteger cteam_id;

@property (nonatomic, assign) NSInteger full_h;

@property (nonatomic, assign) NSInteger full_c;

@property (nonatomic, assign) NSInteger starttime;

@property (nonatomic, assign) NSInteger voteteam;

@property (nonatomic, assign) NSInteger match_id;

@property (nonatomic, assign) NSInteger replycount;

@property (nonatomic, copy) NSString *matchtypefullname;

@property (nonatomic, copy) NSString *countname;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *hteamname;

@property (nonatomic, copy) NSString *cteamname;

@property (nonatomic, assign) NSInteger rwxnb;

@property (nonatomic, assign) NSInteger site_id;

@property (nonatomic, copy) NSString *audiencecount;

@property (nonatomic, copy) NSString *weather;

@property (nonatomic, assign) NSInteger rmshow;

@property (nonatomic, assign) NSInteger half_h;

@property (nonatomic, assign) NSInteger hteam_id;

@property (nonatomic, assign) NSInteger half_c;

@property (nonatomic, assign) NSInteger is_follow_matchtype;

// 联赛ID
@property (nonatomic, assign) NSInteger matchtype_id;

// 加时
@property (nonatomic, assign) NSInteger extratime_h;
@property (nonatomic, assign) NSInteger extratime_c;

// 点球
@property (nonatomic, assign) NSInteger penalty_h;
@property (nonatomic, assign) NSInteger penalty_c;

///**
// *  篮球
// */
//@property (nonatomic, assign) NSInteger total_h;
//@property (nonatomic, assign) NSInteger total_c;
//@property (nonatomic, assign) NSInteger st1_h;
//@property (nonatomic, assign) NSInteger st1_c;
//@property (nonatomic, assign) NSInteger st2_h;
//@property (nonatomic, assign) NSInteger st2_c;
//@property (nonatomic, assign) NSInteger st3_h;
//@property (nonatomic, assign) NSInteger st3_c;
//@property (nonatomic, assign) NSInteger st4_h;
//@property (nonatomic, assign) NSInteger st4_c;



@end

