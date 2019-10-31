//
//  Team.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeamResult,TeamInfo,Team_Stage;
@interface Team : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) TeamResult *result;

@end
@interface TeamResult : NSObject

@property (nonatomic, strong) NSArray *players;

@property (nonatomic, strong) TeamInfo *info;

@property (nonatomic, strong) NSArray<Team_Stage *> *team_stage;

@end

@interface TeamInfo : NSObject

@property (nonatomic, copy) NSString *teamname;

@property (nonatomic, copy) NSString *cityname;

@property (nonatomic, assign) NSInteger is_follow;

@property (nonatomic, assign) NSInteger teamsign;

@property (nonatomic, copy) NSString *wikiwebsite;

@property (nonatomic, assign) NSInteger cteamtog;

@property (nonatomic, assign) NSInteger hteamtog;

@property (nonatomic, assign) NSInteger foundedtime;

@end

@interface Team_Stage : NSObject

@property (nonatomic, assign) NSInteger moment_id;

@property (nonatomic, assign) NSInteger stage_id;

@property (nonatomic, copy) NSString *matchtypefullname;

@property (nonatomic, assign) NSInteger matchtype_id;

@property (nonatomic, assign) NSInteger is_cur;

@end

