//
//  KSBasketballBase.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/20.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BasketResult;

@interface KSBasketballBase : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) BasketResult *result;


@end

@interface BasketResult : NSObject

@property (nonatomic, assign) NSInteger st2_h;

@property (nonatomic, assign) NSInteger rmshow;

@property (nonatomic, assign) NSInteger rwxnb;

@property (nonatomic, copy) NSString *momentname;

@property (nonatomic, assign) NSInteger cteam_id;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) NSInteger ot_h4;

@property (nonatomic, assign) NSInteger st1_h;

@property (nonatomic, assign) NSInteger total_c;

@property (nonatomic, assign) NSInteger ot_h2;

@property (nonatomic, copy) NSString *hteamname;

@property (nonatomic, assign) NSInteger total_h;

@property (nonatomic, copy) NSString *cteamname;

@property (nonatomic, assign) NSInteger st4_c;

@property (nonatomic, assign) NSInteger hascourts;

@property (nonatomic, assign) NSInteger ot_c3;

@property (nonatomic, assign) NSInteger voteTeam;

@property (nonatomic, assign) NSInteger wiki_id;

@property (nonatomic, assign) NSInteger ot_c1;

@property (nonatomic, assign) NSInteger st3_c;

@property (nonatomic, assign) NSInteger match_id;

@property (nonatomic, assign) NSInteger st4_h;

@property (nonatomic, assign) NSInteger st2_c;

@property (nonatomic, assign) NSInteger ot_h3;

@property (nonatomic, assign) NSInteger starttime;

@property (nonatomic, assign) NSInteger ot_h1;

@property (nonatomic, copy) NSString *matchtypefullname;

@property (nonatomic, assign) NSInteger st3_h;

@property (nonatomic, assign) NSInteger hteam_id;

@property (nonatomic, assign) NSInteger st1_c;

@property (nonatomic, assign) NSInteger ot_c4;

@property (nonatomic, assign) NSInteger ot_c2;

@property (nonatomic, assign) NSInteger replycount;

@property (nonatomic, assign) NSInteger is_follow_matchtype;

// 联赛ID
@property (nonatomic, assign) NSInteger matchtype_id;

@property (nonatomic, assign) NSInteger st5_h;
@property (nonatomic, assign) NSInteger st5_c;

@property (nonatomic, copy) NSString *hteamimgurl;
@property (nonatomic, copy) NSString *cteamimgurl;
@end

