//
//  KSLikeSportTool.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "KSMoreResult.h"
#import "KSLive.h"
#import "MJExtension.h"
#import "KSFootballDetail.h"
#import "KSFootballBase.h"
#import "KSConstant.h"
#import "KSHttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "KSLastestParamResult.h"
#import "KSFootballBase.h"
#import "Login.h"
#import "KSAnalyse.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "KSBasketAnalyse.h"
#import "KSFootballBase.h"
#import "KSBasketballBase.h"
#import "Search.h"
#import "AppDelegate.h"
#import "KSChoose.h"

@implementation KSKuaiShouTool

+ (void)getLiveWithType:(NSInteger)type ofState:(NSString *)state withMatchID:(NSInteger)matchID WithCompleted:(Completed)completed failure:(Failure)failure
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"zzz"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [[dateFormatter stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@"GMT" withString:@""];
    NSString *sign = [currentDateStr substringWithRange:NSMakeRange(0, 1)];
    NSString *number = [currentDateStr substringFromIndex:1];
    NSMutableArray *match = [[number componentsSeparatedByString:@":"] mutableCopy];
    NSString *timeZone;
    
    if (match.count == 2) {
        timeZone = [NSString stringWithFormat:@"%@%@.%li",sign,match[0],[match[1] integerValue]/60];
    } else if (match.count == 1){
        timeZone = currentDateStr;
    }
    
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_json_get?MType=%li&MState=%@&T_FlagNum=%li&gmt=%@",appUrl,(long)type,state,(long)matchID,timeZone];
//    NSString *url = @"http://www.mocky.io/v2/5d54bcec2f00004e1986167c";
//    NSString *url = @"http://localhost:8888/api/match_json_get?";
    
    int gameType = 0;
    
    if ([state isEqualToString:@"ending"]) {
        gameType = 2;
    } else if ([state isEqualToString:@"live"]) {
        gameType = 1;
    } else {
        gameType = 3;
    }
    
    NSString *sportType = @"zq";
    if (type == 1) {
        sportType = @"lq";
    }
    

    NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/%@/list?type=%d", sportType, gameType];
    
    if ([state isEqualToString:@"follow"]) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        
        NSString *username = [defaults stringForKey:@"kUserName"];
        NSString *password = [defaults stringForKey:@"kPassword"];

        [KSKuaiShouTool userLoginWithName:username andPassword:password WithCompleted:^(id result) {
            NSString *token = result[@"result"][@"token"];
//            NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/my/match/%@/list?tk=%@", type==1?@"lq":@"zq", token];
            
            NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/my/match/%@/list?tk=%@", @"lq", token];
            
            [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
                
                // 当日的比赛 列表不需要缓存
                NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
                KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
                result.ret_code = @"0";
                KSLive *live = [[KSLive alloc] init];
                result.result = live;
                
                
                NSInteger count = [dict[@"data"] count];
                NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
                
                for (int i=0; i<count; ++i) {
                    // todo: type
                    KSLive *dataLive = [[KSLive alloc] init];
                    dataLive.matchtypefullname = dict[@"data"][i][@"league_name"];
                    dataLive.hteamname = dict[@"data"][i][@"home_name"];
                    dataLive.cteamname = dict[@"data"][i][@"away_name"];
                    NSInteger total_h = [dict[@"data"][i][@"home_score"] longValue];
                    NSInteger total_c = [dict[@"data"][i][@"away_score"] longValue];
                    dataLive.total_h = total_h;
                    dataLive.total_c = total_c;
                    dataLive.match_id = [dict[@"data"][i][@"id"] longValue];
                    //            dataLive.isFollowView = NO;
                    dataLive.is_follow = [state isEqualToString:@"follow"];
                    dataLive.type = 1;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                    NSDate *date = [dateFormatter dateFromString:dict[@"data"][i][@"match_date"]];
                    dataLive.starttime = [date timeIntervalSince1970];
                    
                    
                    NSDate *queryDate = [NSDate date];
                    NSCalendar * calendar = [NSCalendar currentCalendar];
                    NSDateComponents *queryDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: queryDate];
                    NSDateComponents *resultDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];
                    
                    [mutableArr addObject:dataLive];
                }
                if ([state isEqualToString:@"follow"]) {
                    live.t0 = mutableArr.copy;
                    live.data = mutableArr.copy;
                } else {
                    live.data = mutableArr.copy;
                }
                
                if (![state isEqualToString:@"follow"]) {
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    NSString *token = [defaults objectForKey:@"token"];
                    NSString *followUrl = [NSString stringWithFormat:@"http://23451.net:9900/my/match/zq/list?tk=%@", token];

                    [KSHttpTool GETWithURL:followUrl params:nil success:^(id responseObject) {
                        NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
                        NSInteger count = [dict[@"data"] count];
                        
                        NSArray *arr;
                        if ([state isEqualToString:@"follow"]) {
                            arr = live.t0;
                        } else {
                            arr = live.data;
                        }
                        
                        for (KSLive *live in arr) {
                            
                            for (int i=0; i<count; ++i) {
                                NSInteger match_id = [dict[@"data"][i][@"id"] longValue];
                                if (live.match_id == match_id) {
                                    live.is_follow = 1;
                                }
                            }
                        }
                        
                        NSDictionary *resultDict = result.mj_keyValues;
                        
                        !completed ? : completed(resultDict);
                    } failure:^(NSError *error) {
                        !failure ? : failure(error);
                        NSLog(@"即时比分请求出错");
                    }];
                } else {
                    
                    NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/my/match/%@/list?tk=%@", @"zq", token];
                    
                    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
                        
                        // 当日的比赛 列表不需要缓存
                        NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
                        KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
                        result.ret_code = @"0";
                        KSLive *live1 = [[KSLive alloc] init];
                        result.result = live1;
                        
                        
                        NSInteger count = [dict[@"data"] count];
                        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
                        
                        for (int i=0; i<count; ++i) {
                            KSLive *dataLive = [[KSLive alloc] init];
                            dataLive.matchtypefullname = dict[@"data"][i][@"league_name"];
                            dataLive.hteamname = dict[@"data"][i][@"home_name"];
                            dataLive.cteamname = dict[@"data"][i][@"away_name"];
                            NSInteger total_h = [dict[@"data"][i][@"home_score"] longValue];
                            NSInteger total_c = [dict[@"data"][i][@"away_score"] longValue];
                            dataLive.total_h = total_h;
                            dataLive.total_c = total_c;
                            dataLive.match_id = [dict[@"data"][i][@"id"] longValue];
                            //            dataLive.isFollowView = NO;
                            dataLive.is_follow = [state isEqualToString:@"follow"];
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                            NSDate *date = [dateFormatter dateFromString:dict[@"data"][i][@"match_date"]];
                            dataLive.starttime = [date timeIntervalSince1970];
                            
                            
                            NSDate *queryDate = [NSDate date];
                            NSCalendar * calendar = [NSCalendar currentCalendar];
                            NSDateComponents *queryDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: queryDate];
                            NSDateComponents *resultDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];
                            
                            [mutableArr addObject:dataLive];
                        }
                        if ([state isEqualToString:@"follow"]) {
                            // dodod
                            live1.t1 = live.t0;
                            live1.t0 = [mutableArr copy];
                            [mutableArr addObjectsFromArray:live.t0];
//                            live1.data = mutableArr.copy;
                        } else {
                            live1.data = mutableArr.copy;
                        }
                        
                        NSDictionary *resultDict = result.mj_keyValues;
                        !completed ? : completed(resultDict);
                        
                        
                    } failure:^(NSError *error) {
                        !failure ? : failure(error);
                        NSLog(@"即时比分请求出错");
                    }];
//                    NSDictionary *resultDict = result.mj_keyValues;
//
//                    !completed ? : completed(resultDict);
                }
                
                
            } failure:^(NSError *error) {
                !failure ? : failure(error);
                NSLog(@"即时比分请求出错");
            }];
        } failure:^{
            
        }];
        
    } else {
        [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
            
            // 当日的比赛 列表不需要缓存
            NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
            KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
            result.ret_code = @"0";
            KSLive *live = [[KSLive alloc] init];
            result.result = live;
            
            
            NSInteger count = [dict[@"data"] count];
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
            
            for (int i=0; i<count; ++i) {
                KSLive *dataLive = [[KSLive alloc] init];
                dataLive.matchtypefullname = dict[@"data"][i][@"league_name"];
                dataLive.hteamname = dict[@"data"][i][@"home_name"];
                dataLive.cteamname = dict[@"data"][i][@"away_name"];
                dataLive.type = type;
                NSInteger total_h = [dict[@"data"][i][@"home_score"] longValue];
                NSInteger total_c = [dict[@"data"][i][@"away_score"] longValue];
                dataLive.total_h = total_h;
                dataLive.total_c = total_c;
                
                
                dataLive.match_id = [dict[@"data"][i][@"id"] longValue];
                //            dataLive.isFollowView = NO;
                NSLog(@"%@ %@-%@(%zd)", dataLive.matchtypefullname, dataLive.hteamname, dataLive.cteamname, dataLive.match_id);
                
                
                
                dataLive.is_follow = [state isEqualToString:@"follow"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                NSDate *date = [dateFormatter dateFromString:dict[@"data"][i][@"match_date"]];
                dataLive.starttime = [date timeIntervalSince1970];
                
                NSString *resultStr = [NSString stringWithFormat:@"%@ %@-%@(%zd)", dataLive.matchtypefullname, dataLive.hteamname, dataLive.cteamname, dataLive.match_id];
                [((AppDelegate*)UIApplication.sharedApplication.delegate).searchResult addObject:dataLive];
                [((AppDelegate*)UIApplication.sharedApplication.delegate).filterList addObject:dataLive.matchtypefullname];
                
                
                NSDate *queryDate = [NSDate date];
                NSCalendar * calendar = [NSCalendar currentCalendar];
                NSDateComponents *queryDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: queryDate];
                NSDateComponents *resultDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];
                
                if (queryDateComponents.year == resultDateComponents.year && queryDateComponents.month == resultDateComponents.month && queryDateComponents.day == resultDateComponents.day)
                    [mutableArr addObject:dataLive];
            }
            if ([state isEqualToString:@"follow"]) {
                live.t0 = mutableArr.copy;
            } else {
                live.data = mutableArr.copy;
            }
            
            if (![state isEqualToString:@"follow"]) {
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                NSString *token = [defaults objectForKey:@"token"];
                NSString *followUrl = [NSString stringWithFormat:@"http://23451.net:9900/my/match/zq/list?tk=%@", token];
                
                
                
                [KSHttpTool GETWithURL:followUrl params:nil success:^(id responseObject) {
                    NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
                    NSInteger count = [dict[@"data"] count];
                    
                    NSArray *arr;
                    if ([state isEqualToString:@"follow"]) {
                        arr = live.t0;
                    } else {
                        arr = live.data;
                    }
                    
                    for (KSLive *live in arr) {
                        
                        for (int i=0; i<count; ++i) {
                            NSInteger match_id = [dict[@"data"][i][@"id"] longValue];
                            if (live.match_id == match_id) {
                                live.is_follow = 1;
                            }
                        }
                    }
                    
                    NSDictionary *resultDict = result.mj_keyValues;
                    
                    !completed ? : completed(resultDict);
                } failure:^(NSError *error) {
                    !failure ? : failure(error);
                    NSLog(@"即时比分请求出错");
                }];
            } else {
                NSDictionary *resultDict = result.mj_keyValues;
                
                !completed ? : completed(resultDict);
            }
            
            
        } failure:^(NSError *error) {
            !failure ? : failure(error);
            NSLog(@"即时比分请求出错");
        }];
    }
    
    
}

+ (void)getLiveMoreMatchID:(NSInteger)matchID WithCompleted:(Completed)completed failure:(Failure)failure{
    NSError *error = [[NSError alloc] init];
    !failure ? : failure(error);
    return;
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/ft_match_jq_player_get?mid=%li",appUrl,(long)matchID];
    
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
//        NSString *matchid = [responseObject objectForKey:@"result"];
//        !completed ? : completed(matchid);
        // 当日的比赛 列表不需要缓存
        KSMoreResult *last = [KSMoreResult mj_objectWithKeyValues:responseObject];
//        if (last.ret_code == 0) {
            !completed ? : completed(last.result);
//        }
    }failure:^(NSError *error) {
        !failure ? : failure(error);
//        NSLog(@"请求进球队员出错");
    }];
    
}

+ (void)getBasketballAndTennisLiveWithType:(NSInteger)type withFlagNum:(NSInteger)flayNum withCompleted:(Completed)completed failure:(Failure)failure{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/change_json_get?mtype=%ld&flag_num=%li",appUrl,(long)type,(long)flayNum];

    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);

    }];
}

// 足球详情
+ (void)getFootballDetailWithMatchID:(NSInteger)matchID withCompleted:(Completed)completed failure:(Failure)failure
{

//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_info_get?mid=%li",appUrl,(long)matchID];
//    NSString *url = @"http://localhost:8888/api/match_info_get?";
    NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/detail/zq/event?id=%li", matchID];
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
//        NSLog(@"result%@",responseObject);
        // 当日的比赛 列表不需要缓存
//        KSFootballDetail *footballDetail = [KSFootballDetail mj_objectWithKeyValues:responseObject];
        
        FootballDetailResult *detailResult = [[FootballDetailResult alloc] init];
        
        
        
        NSMutableArray *mutaArr = [[NSMutableArray alloc] init];
        for (NSDictionary *i in responseObject[@"data"]) {
            NSLog(@"%@", i[@"home_info"]);

//            1:进球 g
//            2: 乌龙 o
//            3:点球 p
//            4:黄牌 y
//            5:红牌 r
//            6:两黄牌变红 t
            
            MatchEvent *event = [[MatchEvent alloc] init];
            
            NSNumber *homeEventType = i[@"home_event"];
            NSNumber *awayEventType = i[@"away_event"];
            
            
            event.proctime = [[i[@"event_time"] substringToIndex:2] longLongValue];
            if ([homeEventType isEqualToNumber:@0]) {
                event.teamtag = @"C";
                event.playername = i[@"away_info"];
                if ([awayEventType isEqualToNumber:@1]) {
                    event.actiontype = @"g";
                } else if ([awayEventType isEqualToNumber:@2]) {
                    event.actiontype = @"o";
                } else if ([awayEventType isEqualToNumber:@3]) {
                    event.actiontype = @"p";
                } else if ([awayEventType isEqualToNumber:@4]) {
                    event.actiontype = @"y";
                } else if ([awayEventType isEqualToNumber:@5]) {
                    event.actiontype = @"r";
                } else if ([awayEventType isEqualToNumber:@6]) {
                    event.actiontype = @"t";
                } else if ([awayEventType isEqualToNumber:@8]) {
                    event.actiontype = @"s";
                    if ((id)event.playername != [NSNull null]) {
                        event.playername = [event.playername stringByReplacingOccurrencesOfString:@"$9#" withString:@"|"];
                        event.playername = [event.playername stringByReplacingOccurrencesOfString:@"$10" withString:@""];
                    }
                    
                } else {
                    event.actiontype = @"";
                }
            } else {
                event.teamtag = @"H";
                event.playername = i[@"home_info"];
                if ([homeEventType isEqualToNumber:@1]) {
                    event.actiontype = @"g";
                } else if ([homeEventType isEqualToNumber:@2]) {
                    event.actiontype = @"o";
                } else if ([homeEventType isEqualToNumber:@3]) {
                    event.actiontype = @"p";
                } else if ([homeEventType isEqualToNumber:@4]) {
                    event.actiontype = @"y";
                } else if ([homeEventType isEqualToNumber:@5]) {
                    event.actiontype = @"r";
                } else if ([homeEventType isEqualToNumber:@6]) {
                    event.actiontype = @"t";
                } else if ([homeEventType isEqualToNumber:@8]) {
                    event.actiontype = @"s";
                    event.playername = [event.playername stringByReplacingOccurrencesOfString:@"$9#" withString:@"|"];
                    event.playername = [event.playername stringByReplacingOccurrencesOfString:@"$10" withString:@""];
                } else {
                    event.actiontype = @"";
                }
            }
            
            
            
            
            [mutaArr addObject:event];
        }
        detailResult.match_event = [mutaArr copy];
        
        
        
        NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/detail/zq/count?id=%li", matchID];
    
        [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
            
            if (responseObject[@"success"]) {
                NSMutableDictionary *mutaDict = [[NSMutableDictionary alloc] init];
                for (NSDictionary *i in responseObject[@"data"]) {
                    [mutaDict setObject:i forKey:i[@"txt"]];
                    
                }
                
                MatchInfo *matchInfo = [[MatchInfo alloc] init];
                detailResult.match_info = matchInfo;
                matchInfo.hasextratime = 0;//--是否有加时赛  1 有 0 没有
                matchInfo.haspenalty = 0;//--是否有点球
                matchInfo.hasjq = 1;//--是否有角球，需要显示角球
                NSString *hjq = mutaDict[@"角球"][@"home_num"];
                matchInfo.hjq = [hjq longLongValue];//--主队角球数✅
                NSString *cjq = mutaDict[@"角球"][@"away_num"];
                matchInfo.cjq = [cjq longLongValue];
                NSString *h_smcs = mutaDict[@"射门"][@"home_num"];
                matchInfo.h_smcs = [h_smcs longLongValue]; //--主队射门次数✅
                NSString *c_smcs = mutaDict[@"射门"][@"away_num"];
                matchInfo.c_smcs = [c_smcs longLongValue];
                NSString *h_jq = mutaDict[@"角球"][@"home_num"];
                matchInfo.h_jq = [h_jq longLongValue];//--主队角球✅
                NSString *c_jq = mutaDict[@"角球"][@"away_num"];
                matchInfo.c_jq = [c_jq longLongValue];
                NSString *h_yw = mutaDict[@"越位"][@"home_num"];
                matchInfo.h_yw = [h_yw longLongValue];//--主队越位✅
                NSString *c_yw = mutaDict[@"越位"][@"away_num"];
                matchInfo.c_yw = [c_yw longLongValue];
                NSString *h_kqsjbl = mutaDict[@"控球"][@"home_num"];
                matchInfo.h_kqsjbl = [h_kqsjbl longLongValue];//--主队控球时间比例 ✅
                NSString *c_kqsjbl = mutaDict[@"控球"][@"away_num"];
                matchInfo.c_kqsjbl = [c_kqsjbl longLongValue];
                NSString *h_ryq = mutaDict[@"任意球"][@"home_num"];
                matchInfo.h_ryq = [h_ryq longLongValue];//--主队任意球 ✅
                NSString *c_ryq = mutaDict[@"任意球"][@"away_num"];
                matchInfo.c_ryq = [c_ryq longLongValue];
                NSString *h_fg = mutaDict[@"犯规"][@"home_num"];
                matchInfo.h_fg = [h_fg longLongValue];//--主队犯规✅
                NSString *c_fg = mutaDict[@"犯规"][@"away_num"];
                matchInfo.c_fg = [c_fg longLongValue];
                NSString *h_yp = mutaDict[@"黄牌"][@"home_num"];
                matchInfo.h_yp = [h_yp longLongValue];//--主队黄牌✅
                NSString *c_yp = mutaDict[@"黄牌"][@"away_num"];
                matchInfo.c_yp = [c_yp longLongValue];
                NSString *h_rp = mutaDict[@"红牌"][@"home_num"];
                matchInfo.h_rp = [h_rp longLongValue];//--主队红牌✅
                NSString *c_rp = mutaDict[@"红牌"][@"away_num"];
                matchInfo.c_rp = [c_rp longLongValue];
                NSString *h_szcs = mutaDict[@"射正"][@"home_num"];
                matchInfo.h_szcs = [h_szcs longLongValue];//--射正次数✅
                NSString *c_szcs = mutaDict[@"射正"][@"away_num"];
                matchInfo.c_szcs = [c_szcs longLongValue];

                matchInfo.firstgoal = -1;//--先开球 -1 不显示  0 主队 1 客队
                matchInfo.firstred = -1; //先红牌  -1 不显示  0 主队 1 客队
                matchInfo.firstyellow = -1;//先黄牌  -1 不显示  0 主队 1 客队
                matchInfo.firstcore = -1; //先角球  -1 不显示  0 主队 1 客队
            }
            
            NSDictionary *dict = detailResult.mj_keyValues;
            !completed ? : completed(dict);
        } failure:^(NSError *error) {
            !failure ? : failure(error);
            NSLog(@"足球详情请求网络出错");
        }];
        
    }failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"足球详情请求网络出错");
    }];
}

// 足球基本信息
+ (void)getFootballBaseType:(NSInteger)type withMatchID:(NSInteger)matchID withCompleted:(Completed)completed failure:(Failure)failure
{

//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_info_base_get?mid=%li&mtype=%li",appUrl,(long)matchID,(long)type];
//    NSString *url = @"http://localhost:8888/api/match_info_base_get?";
    
    if (type == 1) {
        NSInteger gameType = 2;
        NSString *sportType = @"lq";
        NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/%@/list?type=%zd", sportType, gameType];
        
        [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
            
            // 当日的比赛 列表不需要缓存
            NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
            KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
            result.ret_code = @"0";
            KSLive *live = [[KSLive alloc] init];
            result.result = live;
            
            
            NSInteger count = [dict[@"data"] count];
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
            
            for (int i=0; i<count; ++i) {
                NSString *strId = responseObject[@"data"][i][@"id"];
                NSInteger myId = [strId integerValue];
                if (myId == matchID) {
                    NSString *homeScoreStr = responseObject[@"data"][i][@"home_scores"];
                    NSString *guestScoreStr = responseObject[@"data"][i][@"away_scores"];
                    
                    NSArray<NSString *> *hScoreArr = [homeScoreStr componentsSeparatedByString:@"-"];
                    NSArray<NSString *> *cScoreArr = [guestScoreStr componentsSeparatedByString:@"-"];
                    
                    KSBasketballBase *base = [[KSBasketballBase alloc] init];

                    BasketResult *baseResult = [[BasketResult alloc] init];
                    base.result = baseResult;
                    
                    baseResult.st2_h = [hScoreArr[1] integerValue];
//                    baseResult.rmshow = 2;
//                    baseResult.rwxnb = 3;
//                    baseResult.momentname = @"a";
                    baseResult.cteam_id = [responseObject[@"data"][i][@"away_id"] longValue];
//                    baseResult.state = @"";
//                    baseResult.ot_h4 = 5;
                    baseResult.st1_h = [hScoreArr[0] integerValue];
//                    baseResult.total_c = 7;
//                    baseResult.ot_h2 = 8;
                    baseResult.hteamname = @"b";
//                    baseResult.total_h = 9;
                    baseResult.cteamname = @"c";
                    baseResult.st4_c = [cScoreArr[3] integerValue];
//                    baseResult.hascourts = 11;
//                    baseResult.ot_c3 = 12;
//                    baseResult.voteTeam = 13;
//                    baseResult.wiki_id = 14;
//                    baseResult.ot_c1 = 15;
                    baseResult.st3_c = [cScoreArr[2] integerValue];
//                    baseResult.match_id = 17;
                    baseResult.st4_h = [hScoreArr[3] integerValue];
                    baseResult.st2_c = [cScoreArr[1] integerValue];
//                    baseResult.ot_h3 = 20;
//                    baseResult.starttime = 21;
//                    baseResult.ot_h1 = 22;
                    baseResult.matchtypefullname = responseObject[@"data"][i][@"league_name"];
                    baseResult.st3_h = [hScoreArr[3] integerValue];
                    baseResult.hteam_id = [responseObject[@"data"][i][@"home_id"] longValue];
                    baseResult.st1_c = [cScoreArr[0] integerValue];
//                    baseResult.ot_c4 = 27;
//                    baseResult.ot_c2 = 28;
//                    baseResult.replycount = 29;
//                    baseResult.is_follow_matchtype = 30;
                    // 联赛ID
                    baseResult.matchtype_id = 31;
//                    baseResult.st5_h = 32;
//                    baseResult.st5_c = 33;


                    baseResult.total_c = [responseObject[@"data"][i][@"home_score"] longValue];
                    baseResult.total_h = [responseObject[@"data"][i][@"away_score"] longValue];



                    for (NSDictionary *dict in responseObject[@"data"][i]) {
                        NSLog(@"%@", dict);
                    }
                    baseResult.hteamname = responseObject[@"data"][i][@"home_name"];
                    baseResult.cteamname = responseObject[@"data"][i][@"away_name"];
                    
                    baseResult.cteamimgurl = responseObject[@"data"][i][@"away_logo_url"];
                    baseResult.hteamimgurl = responseObject[@"data"][i][@"home_logo_url"];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                    NSDate *date = [dateFormatter dateFromString:responseObject[@"data"][i][@"match_date"]];
                    baseResult.starttime = [date timeIntervalSince1970];
                    
                    NSDictionary *resultDict = base.mj_keyValues;
                    
                    !completed ? : completed(resultDict);
                    return;
                }
            }
//            KSBasketballBase *base = [[KSBasketballBase alloc] init];
//
//            BasketResult *baseResult = [[BasketResult alloc] init];
//            base.result = baseResult;
//            NSDictionary *resultDict = base.mj_keyValues;
//            !completed ? : completed(resultDict);
            
        } failure:^(NSError *error) {
            !failure ? : failure(error);
            NSLog(@"即时比分请求出错");
        }];
        
        NSString *url1 = [NSString stringWithFormat:@"http://23451.net:9900/match/%@/list?type=1", sportType];
        
        [KSHttpTool GETWithURL:url1 params:nil success:^(id responseObject) {
            
            // 当日的比赛 列表不需要缓存
            NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
            KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
            result.ret_code = @"0";
            KSLive *live = [[KSLive alloc] init];
            result.result = live;
            
            
            NSInteger count = [dict[@"data"] count];
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
            
            for (int i=0; i<count; ++i) {
                NSString *strId = responseObject[@"data"][i][@"id"];
                NSInteger myId = [strId integerValue];
                if (myId == matchID) {
                    NSString *homeScoreStr = responseObject[@"data"][i][@"home_scores"];
                    NSString *guestScoreStr = responseObject[@"data"][i][@"away_scores"];
                    
                    NSArray<NSString *> *hScoreArr = [homeScoreStr componentsSeparatedByString:@"-"];
                    NSArray<NSString *> *cScoreArr = [guestScoreStr componentsSeparatedByString:@"-"];
                    
                    KSBasketballBase *base = [[KSBasketballBase alloc] init];
                    
                    BasketResult *baseResult = [[BasketResult alloc] init];
                    base.result = baseResult;
                    
                    baseResult.st2_h = [hScoreArr[1] integerValue];
                    //                    baseResult.rmshow = 2;
                    //                    baseResult.rwxnb = 3;
                    //                    baseResult.momentname = @"a";
                    baseResult.cteam_id = [responseObject[@"data"][i][@"away_id"] longValue];
                    //                    baseResult.state = @"";
                    //                    baseResult.ot_h4 = 5;
                    baseResult.st1_h = [hScoreArr[0] integerValue];
                    //                    baseResult.total_c = 7;
                    //                    baseResult.ot_h2 = 8;
                    baseResult.hteamname = @"b";
                    //                    baseResult.total_h = 9;
                    baseResult.cteamname = @"c";
                    baseResult.st4_c = [cScoreArr[3] integerValue];
                    //                    baseResult.hascourts = 11;
                    //                    baseResult.ot_c3 = 12;
                    //                    baseResult.voteTeam = 13;
                    //                    baseResult.wiki_id = 14;
                    //                    baseResult.ot_c1 = 15;
                    baseResult.st3_c = [cScoreArr[2] integerValue];
                    //                    baseResult.match_id = 17;
                    baseResult.st4_h = [hScoreArr[3] integerValue];
                    baseResult.st2_c = [cScoreArr[1] integerValue];
                    //                    baseResult.ot_h3 = 20;
                    //                    baseResult.starttime = 21;
                    //                    baseResult.ot_h1 = 22;
                    baseResult.matchtypefullname = responseObject[@"data"][i][@"league_name"];
                    baseResult.st3_h = [hScoreArr[3] integerValue];
                    baseResult.hteam_id = [responseObject[@"data"][i][@"home_id"] longValue];
                    baseResult.st1_c = [cScoreArr[0] integerValue];
                    //                    baseResult.ot_c4 = 27;
                    //                    baseResult.ot_c2 = 28;
                    //                    baseResult.replycount = 29;
                    //                    baseResult.is_follow_matchtype = 30;
                    // 联赛ID
                    baseResult.matchtype_id = 31;
                    //                    baseResult.st5_h = 32;
                    //                    baseResult.st5_c = 33;
                    
                    
                    baseResult.total_c = [responseObject[@"data"][i][@"home_score"] longValue];
                    baseResult.total_h = [responseObject[@"data"][i][@"away_score"] longValue];
                    
                    
                    
                    for (NSDictionary *dict in responseObject[@"data"][i]) {
                        NSLog(@"%@", dict);
                    }
                    baseResult.hteamname = responseObject[@"data"][i][@"home_name"];
                    baseResult.cteamname = responseObject[@"data"][i][@"away_name"];
                    
                    baseResult.cteamimgurl = responseObject[@"data"][i][@"away_logo_url"];
                    baseResult.hteamimgurl = responseObject[@"data"][i][@"home_logo_url"];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                    NSDate *date = [dateFormatter dateFromString:responseObject[@"data"][i][@"match_date"]];
                    baseResult.starttime = [date timeIntervalSince1970];
                    
                    NSDictionary *resultDict = base.mj_keyValues;
                    
                    !completed ? : completed(resultDict);
                    return;
                }
            }
//            KSBasketballBase *base = [[KSBasketballBase alloc] init];
//
//            BasketResult *baseResult = [[BasketResult alloc] init];
//            base.result = baseResult;
//            NSDictionary *resultDict = base.mj_keyValues;
//            !completed ? : completed(resultDict);
            
        } failure:^(NSError *error) {
            !failure ? : failure(error);
            NSLog(@"即时比分请求出错");
        }];
        
        NSString *url2 = [NSString stringWithFormat:@"http://23451.net:9900/match/%@/list?type=3", sportType];
        
        [KSHttpTool GETWithURL:url2 params:nil success:^(id responseObject) {
            
            // 当日的比赛 列表不需要缓存
            NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
            KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
            result.ret_code = @"0";
            KSLive *live = [[KSLive alloc] init];
            result.result = live;
            
            
            NSInteger count = [dict[@"data"] count];
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
            
            for (int i=0; i<count; ++i) {
                NSString *strId = responseObject[@"data"][i][@"id"];
                NSInteger myId = [strId integerValue];
                if (myId == matchID) {
                    NSString *homeScoreStr = responseObject[@"data"][i][@"home_scores"];
                    NSString *guestScoreStr = responseObject[@"data"][i][@"away_scores"];
                    
                    NSArray<NSString *> *hScoreArr = [homeScoreStr componentsSeparatedByString:@"-"];
                    NSArray<NSString *> *cScoreArr = [guestScoreStr componentsSeparatedByString:@"-"];
                    
                    KSBasketballBase *base = [[KSBasketballBase alloc] init];
                    
                    BasketResult *baseResult = [[BasketResult alloc] init];
                    base.result = baseResult;
                    
                    baseResult.st2_h = [hScoreArr[1] integerValue];
                    //                    baseResult.rmshow = 2;
                    //                    baseResult.rwxnb = 3;
                    //                    baseResult.momentname = @"a";
                    baseResult.cteam_id = [responseObject[@"data"][i][@"away_id"] longValue];
                    //                    baseResult.state = @"";
                    //                    baseResult.ot_h4 = 5;
                    baseResult.st1_h = [hScoreArr[0] integerValue];
                    //                    baseResult.total_c = 7;
                    //                    baseResult.ot_h2 = 8;
                    baseResult.hteamname = @"b";
                    //                    baseResult.total_h = 9;
                    baseResult.cteamname = @"c";
                    baseResult.st4_c = [cScoreArr[3] integerValue];
                    //                    baseResult.hascourts = 11;
                    //                    baseResult.ot_c3 = 12;
                    //                    baseResult.voteTeam = 13;
                    //                    baseResult.wiki_id = 14;
                    //                    baseResult.ot_c1 = 15;
                    baseResult.st3_c = [cScoreArr[2] integerValue];
                    //                    baseResult.match_id = 17;
                    baseResult.st4_h = [hScoreArr[3] integerValue];
                    baseResult.st2_c = [cScoreArr[1] integerValue];
                    //                    baseResult.ot_h3 = 20;
                    //                    baseResult.starttime = 21;
                    //                    baseResult.ot_h1 = 22;
                    baseResult.matchtypefullname = responseObject[@"data"][i][@"league_name"];
                    baseResult.st3_h = [hScoreArr[3] integerValue];
                    baseResult.hteam_id = [responseObject[@"data"][i][@"home_id"] longValue];
                    baseResult.st1_c = [cScoreArr[0] integerValue];
                    //                    baseResult.ot_c4 = 27;
                    //                    baseResult.ot_c2 = 28;
                    //                    baseResult.replycount = 29;
                    //                    baseResult.is_follow_matchtype = 30;
                    // 联赛ID
                    baseResult.matchtype_id = 31;
                    //                    baseResult.st5_h = 32;
                    //                    baseResult.st5_c = 33;
                    
                    
                    baseResult.total_c = [responseObject[@"data"][i][@"home_score"] longValue];
                    baseResult.total_h = [responseObject[@"data"][i][@"away_score"] longValue];
                    
                    
                    
                    for (NSDictionary *dict in responseObject[@"data"][i]) {
                        NSLog(@"%@", dict);
                    }
                    baseResult.hteamname = responseObject[@"data"][i][@"home_name"];
                    baseResult.cteamname = responseObject[@"data"][i][@"away_name"];
                    
                    baseResult.cteamimgurl = responseObject[@"data"][i][@"away_logo_url"];
                    baseResult.hteamimgurl = responseObject[@"data"][i][@"home_logo_url"];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                    NSDate *date = [dateFormatter dateFromString:responseObject[@"data"][i][@"match_date"]];
                    baseResult.starttime = [date timeIntervalSince1970];
                    
                    NSDictionary *resultDict = base.mj_keyValues;
                    
                    !completed ? : completed(resultDict);
                    return;
                }
            }
//            KSBasketballBase *base = [[KSBasketballBase alloc] init];
//
//            BasketResult *baseResult = [[BasketResult alloc] init];
//            base.result = baseResult;
//            NSDictionary *resultDict = base.mj_keyValues;
//            !completed ? : completed(resultDict);
            
        } failure:^(NSError *error) {
            !failure ? : failure(error);
            NSLog(@"即时比分请求出错");
        }];
    } else {
        NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/detail/zq/info?id=%li", matchID];
        [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
            // 当日的比赛 列表不需要缓存
            KSFootballBase *result = [[KSFootballBase alloc] init];
            result.ret_code = 0;
            FootballBaseResult *live = [[FootballBaseResult alloc] init];
            result.result = live;
            
            if ([responseObject[@"data"] count] > 0) {
                live.hteamname = responseObject[@"data"][0][@"home_name"];
                live.cteamname = responseObject[@"data"][0][@"away_name"];
                live.matchtypefullname = responseObject[@"data"][0][@"league_name"];
                live.hteamname = responseObject[@"data"][0][@"home_name"];
                
                live.full_h = [responseObject[@"data"][0][@"home_score"] longValue];
                live.full_c = [responseObject[@"data"][0][@"away_score"] longValue];
                live.hteam_id = [responseObject[@"data"][0][@"home_id"] longValue];
                live.cteam_id = [responseObject[@"data"][0][@"away_id"] longValue];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                NSDate *date = [dateFormatter dateFromString:responseObject[@"data"][0][@"match_date"]];
                live.starttime = [date timeIntervalSince1970];
            }
            
            
            
            
            //        NSData *data = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingSortedKeys error:nil];
            NSDictionary *resultDict = result.mj_keyValues;
            !completed ? : completed(resultDict);
            
            //        !completed ? : completed(responseObject);
        }failure:^(NSError *error) {
            !failure ? : failure(error);
            
            NSLog(@"足球基本信息请求网络出错");
        }];
    }
    
}

+ (void)forceMatchWithState:(NSInteger)state Type:(NSInteger)type withMatchID:(NSInteger)matchID withCompleted:(Completed)completed failure:(Failure)failure
{
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_follow_set?mid=%i&token=%@&app_id=%i",appUrl,matchID,token,appID];
//    NSLog(@"链接%@",url);
//    [KSHttpTool POSTWithURL:url params:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
////        NSLog(@"error=%@",error);
//    }];
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_follow_set?mid=%li&mtype=%li&state=%li", appUrl,(long)matchID,(long)type,(long)state];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    
    NSString *token = [defaults objectForKey:@"token"];
    
    if (token.length > 0) {
    } else { // 跳转到登陆界面
        LoginViewController *loginVc = [[LoginViewController alloc] init];
//        loginVc.tokenBlock = ^(NSString *token){
//            //            NSLog(@"loginToken%@",token);
//            [self saveValue:token withKey:@"token"];
//            //            [self getUserInfoWithToken:token];
//            //            [self.tableView reloadData];
//            [self pushToFollowMatchOrTeamWithTag:button.tag];
//            [self updateDataWithMatchID:_matchID];
//        };
//        [loginVc setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:loginVc animated:YES];
    }
    
    NSString *username = [defaults stringForKey:@"kUserName"];
    NSString *password = [defaults stringForKey:@"kPassword"];
    
    [KSKuaiShouTool userLoginWithName:username andPassword:password WithCompleted:^(id result) {
        NSString *token = result[@"result"][@"token"];
        NSString *url = @"http://23451.net:9900/my/attention/add?";
        if (state == 2) { // cancel
            url = @"http://23451.net:9900/my/attention/cancel?";
        }
        
        NSDictionary *params = @{
                                 @"tk": token,
                                 @"type": type == 1 ? @10 : @20,
                                 @"objectId": [NSNumber numberWithInteger:matchID]
                                 };
        [KSHttpTool POSTWithURL:url params:params success:^(id responseObject) {
            NSNumber *num = responseObject[@"success"];
            BOOL success = num.boolValue;
            NSLog(@"follow %@ (token=\"%@\")", success ? @"Success": [NSString stringWithFormat:@"Fail %@", responseObject[@"msg"]], token);
            
            !completed ? : completed(responseObject);
        } failure:^(NSError *error) {
            !failure ? : failure(error);
        }];
    } failure:^{
        
    }];

}

// 足球分析
+ (void)getAnalyseType:(NSInteger)type withMatchID:(NSInteger)matchID withCompleted:(Completed)completed failure:(Failure)failure
{
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_pk_get?mid=%li&mtype=%li",appUrl,(long)matchID,(long)type];
//    NSString *url = @"http://localhost:8888/api/match_pk_get?";
    
    if (type == 1) { // 籃球
        NSInteger gameType = 2;
        NSString *sportType = @"lq";
        NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/%@/list?type=%zd", sportType, gameType];
        
        [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
            
            // 当日的比赛 列表不需要缓存
            NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
            KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
            result.ret_code = @"0";
            KSLive *live = [[KSLive alloc] init];
            result.result = live;
            
            
            NSInteger count = [dict[@"data"] count];
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
            
            
            
        
            for (int i=0; i<count; ++i) {
                NSString *strId = responseObject[@"data"][i][@"id"];
                NSInteger myId = [strId integerValue];
                if (myId == matchID) {
                    NSString *homeScoreStr = responseObject[@"data"][i][@"home_scores"];
                    NSString *guestScoreStr = responseObject[@"data"][i][@"away_scores"];
                    KSBasketAnalyse *analyse = [[KSBasketAnalyse alloc] init];
                    BasketAnalyseResult *analyseResult = [[BasketAnalyseResult alloc] init];
                    analyse.result = analyseResult;
                    
                    
                    for (NSDictionary *dict in responseObject[@"data"][i]) {
                        NSLog(@"%@", dict);
                    }
                    analyseResult.hteamname = responseObject[@"data"][i][@"home_name"];
                    analyseResult.cteamname = responseObject[@"data"][i][@"away_name"];
                    
                    BasketPk_Data *pkData = [[BasketPk_Data alloc] init];
                    
                    
                    // ****** start *******
                    
                    pkData.isPkData = YES;
                    pkData.isFixturesData = YES;
                    pkData.hteamid = 1;
                    pkData.cteamid = 2;
                    pkData.isHteam = YES;
                    pkData.st2_h = 3;
                    pkData.stagename = @"a";
                    pkData.cteam_id = 4;
                    pkData.state = @"b";
                    pkData.handicaprate = @"c";
                    pkData.st1_h = 5;
                    pkData.winer = @"d";
                    pkData.total_c = 6;
                    pkData.hteamname = @"e";
                    pkData.neutralgreen = @"f";
                    pkData.total_h = 7;
                    pkData.cteamname = @"g";
                    pkData.wintype = @"h";
                    pkData.st4_c = 8;
                    pkData.resultbs = @"i";
                    pkData.hascourts = 9;
                    pkData.stage_id = 10;
                    pkData.st3_c = 11;
                    pkData.match_id = 12;
                    pkData.op_hpl = @"j";
                    pkData.moment_id = 13;
                    pkData.op_cpl = @"k";
                    pkData.st4_h = 13;
                    pkData.st2_c = 14;
                    pkData.starttime = 15;
                    pkData.group = 16;
                    pkData.cpl = @"l";
                    pkData.hpl = @"m";
                    pkData.hbspl = @"n";
                    pkData.cbspl = @"o";
                    pkData.matchtypefullname = @"p";
                    pkData.pkbs = @"q";
                    pkData.st3_h = 17;
                    pkData.hteam_id = 18;
                    pkData.st1_c = 19;
                    pkData.matchtype_id = 20;
                    pkData.wintag = @"r";
                    pkData.teamtag = @"s";
                    pkData.round = 21;
                    pkData.isTeamInfo = YES;
                    pkData.momentname = @"t";
                    pkData.momenttype = @"u";
                    
                    // ******  end  *******
                    
                    
                    pkData.st1_h = 1;
                    pkData.st2_h = 2;
                    pkData.st3_h = 3;
                    pkData.st4_h = 4;
                    pkData.st1_c = 5;
                    pkData.st2_c = 6;
                    pkData.st3_c = 7;
                    pkData.st4_c = 8;
                    pkData.total_c = 10;
                    pkData.total_h = 20;
                    pkData.hteamname = responseObject[@"data"][i][@"home_name"];
                    pkData.cteamname = responseObject[@"data"][i][@"away_name"];
                    
                    analyseResult.pk_data = @[pkData];
                    analyseResult.h_result_data = @[pkData];
                    analyseResult.c_result_data = @[pkData];
                    analyseResult.h_fixtures_data = @[pkData];
                    analyseResult.c_fixtures_data = @[pkData];
                    
                    analyseResult.momenttype = @"a";
                    analyseResult.doreport = @"b";
                    analyseResult.groupname = @"c";
                    analyseResult.reporttype = @"d";
                    analyseResult.cteamname = @"e";
                    analyseResult.group = 99;
                    analyseResult.cteam_id = 98;
                    analyseResult.hteamname = @"f";
                    analyseResult.stageid = 97;
                    analyseResult.hteam_id = 96;
                    
                    NSDictionary *resultDict = analyse.mj_keyValues;
                    
                    !completed ? : completed(resultDict);
                    return;
                }
            }
            KSBasketAnalyse *analyse = [[KSBasketAnalyse alloc] init];
            BasketAnalyseResult *analyseResult = [[BasketAnalyseResult alloc] init];
            analyse.result = analyseResult;
            
            NSDictionary *resultDict = analyse.mj_keyValues;
            
            !completed ? : completed(resultDict);
        } failure:^(NSError *error) {
            !failure ? : failure(error);
            NSLog(@"即时比分请求出错");
        }];
    } else {
        NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/detail/zq/info?id=%li", matchID];
        [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
            // 当日的比赛 列表不需要缓存
            NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
            
            if ([dict[@"data"] count] > 0) {
                NSString *hteam_id = dict[@"data"][0][@"home_id"];
                NSString *hteamname = dict[@"data"][0][@"home_name"];
                NSString *cteamname = dict[@"data"][0][@"away_name"];
                NSString *momentname = dict[@"data"][0][@"momentname"];
                NSString *full_h = dict[@"data"][0][@"home_score"];
                NSString *full_c = dict[@"data"][0][@"away_score"];
                
                NSString *url = [NSString stringWithFormat: @"http://23451.net:9900/data/zq/rank?matchId=4826&teamId=%@", hteam_id];
                [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
                    
                    KSAnalyse *analyse = [[KSAnalyse alloc] init];
                    AnalyseResult *analyseResult = [[AnalyseResult alloc] init];
                    analyse.result = analyseResult;
                    
                    analyseResult.stageid = 6377;
                    analyseResult.momenttype = @"I";
                    analyseResult.doreport = @"N";
                    analyseResult.reporttype = @"S,J,A,D,E,I,K,L,N,O,P,Q,Z,";
                    analyseResult.group = 0;
                    analyseResult.hteam_id = 9832;
                    analyseResult.cteam_id = 6317;
                    analyseResult.groupname = @"分组赛 D";
                    analyseResult.hteamname = hteamname;
                    analyseResult.cteamname = cteamname;
                    
                    Score_Full *scoreFull = [[Score_Full alloc] init];
                    if ([responseObject[@"data"] count] > 0) {
                        //                analyseResult.hteamname = responseObject[@"data"][0][@"team_name"];
                        //                analyseResult.cteamname = responseObject[@"data"][0][@"team_name"];
                        NSString *t_match = responseObject[@"data"][0][@"play_num"];
                        scoreFull.t_match = [t_match longLongValue];
                        NSString *t_win = responseObject[@"data"][0][@"win_num"];
                        scoreFull.t_win = [t_win longLongValue];
                        NSString *t_draw = responseObject[@"data"][0][@"flat_num"];
                        scoreFull.t_draw = [t_draw longLongValue];
                        NSString *t_loss = responseObject[@"data"][0][@"lost_num"];
                        scoreFull.t_loss = [t_loss longLongValue];
                        NSString *t_entergoals = responseObject[@"data"][0][@"goal_num"];
                        scoreFull.t_entergoals = [t_entergoals longLongValue];
                        NSString *t_missgoals = responseObject[@"data"][0][@"lost_goal_num"];
                        scoreFull.t_missgoals = [t_missgoals longLongValue];
                        NSString *t_jinsheng = responseObject[@"data"][0][@"win_goal_num"];
                        scoreFull.t_jinsheng = [t_jinsheng longLongValue];
                        NSString *t_Integral = responseObject[@"data"][0][@"integral"];
                        scoreFull.t_Integral = [t_Integral longLongValue];
                        NSString *t_pm = responseObject[@"data"][0][@"rank_no"];
                        scoreFull.t_pm = [t_pm longLongValue];
                        scoreFull.t_sl = responseObject[@"data"][0][@"win_percent"];
                        analyseResult.score_full_h = scoreFull;
                        
                    }
                    
                    Pk_Data *pkData = [[Pk_Data alloc] init];
                    pkData.match_id = 1021264;
                    pkData.starttime = 1463198400;
                    pkData.matchtype_id = 301;
                    pkData.stage_id = 6377;
                    pkData.moment_id = 18822;
                    pkData.group = 0;
                    pkData.hteam_id = 9832;
                    pkData.cteam_id = 6317;
                    pkData.state = @"F";
                    pkData.neutralgreen = @"N";
                    pkData.hasextratime = @"N";
                    pkData.haspenalty = @"N";
                    pkData.matchtypefullname = momentname;
                    pkData.hteamname = hteamname;
                    pkData.cteamname = cteamname;
                    pkData.full_h = [full_h longLongValue],
                    pkData.full_c = [full_c longLongValue],
                    
                    analyseResult.pk_data = @[pkData];
                    NSDictionary *dict = analyse.mj_keyValues;
                    
                    !completed ? : completed(dict);
                }failure:^(NSError *error) {
                    !failure ? : failure(error);
                    NSLog(@"对阵分析请求网络出错");
                }];
            }
            
        }failure:^(NSError *error) {
            !failure ? : failure(error);
            
            NSLog(@"足球基本信息请求网络出错");
        }];
    }
    
    
    

}


// 筛选
+ (void)getChooseType:(NSInteger)type withMDay:(NSString *)MDay withCompleted:(Completed)completed failure:(Failure)failure {
    
    NSString *timeZone = [self getGMT:MDay];
    KSChoose *choose = [[KSChoose alloc] init];
    ChooseResult *chooseResult = [ChooseResult new];
    choose.result = chooseResult;
    
    
    NSMutableArray * unique = [NSMutableArray array];
    NSMutableSet * processed = [NSMutableSet set];
    for (NSString * string in ((AppDelegate*)UIApplication.sharedApplication.delegate).filterList) {
        if ([processed containsObject:string] == NO) {
            [unique addObject:string];
            [processed addObject:string];
        }
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (NSString *name in unique) {
        Matchtypes *match = [Matchtypes new];
        match.pinYin = @"a";
        match.name = name;
        match.rid = 1;
        match.region_id = 2;
        match.is_follow = 3;
        match.isMatch = YES;
        match.isSelect = YES;
        [arr addObject:match];
    }
    
    chooseResult.regions = arr.copy;
    chooseResult.matchtypes = arr.copy;
    NSDictionary *resultDict = choose.mj_keyValues;

    [KSKuaiShouTool getLiveWithType:1 ofState:@"" withMatchID:0 WithCompleted:^(id result) {
        !completed ? : completed(resultDict);
    } failure:^{
        
    }];
    
    
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_filter_json_get?MType=%li&MDay=%@&gmt=%@",appUrl,(long)type,MDay,timeZone];
    
    
//    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
//
//        !completed ? : completed(responseObject);
//    }failure:^(NSError *error) {
//        !failure ? : failure(error);
//        NSLog(@"筛选请求网络出错");
//    }];

}

// 赛程赛果
+ (void)getMatchWithType:(NSInteger)type ofState:(NSString *)state withMDay:(NSString *)MDay WithCompleted:(Completed)completed failure:(Failure)failure
{
//    [self getLiveWithType:type ofState:state withMatchID:0 WithCompleted:completed failure:failure];
    
    //实例化一个NSDateFormatter对象
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"zzz"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [[dateFormatter stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@"GMT" withString:@""];
    NSString *sign = [currentDateStr substringWithRange:NSMakeRange(0, 1)];
    NSString *number = [currentDateStr substringFromIndex:1];
    NSMutableArray *match = [[number componentsSeparatedByString:@":"] mutableCopy];
    NSString *timeZone;
    
    if (match.count == 2) {
        timeZone = [NSString stringWithFormat:@"%@%@.%li",sign,match[0],[match[1] integerValue]/60];
    } else if (match.count == 1){
        timeZone = currentDateStr;
    }
    
    //    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_json_get?MType=%li&MState=%@&T_FlagNum=%li&gmt=%@",appUrl,(long)type,state,(long)matchID,timeZone];
    //    NSString *url = @"http://www.mocky.io/v2/5d54bcec2f00004e1986167c";
    //    NSString *url = @"http://localhost:8888/api/match_json_get?";
    
    
    NSInteger unixInt = [MDay integerValue];
    
    NSDate *queryDate = [NSDate dateWithTimeIntervalSince1970:unixInt];
    
    
    
    int gameType = 2;
    if ([queryDate compare:[NSDate date]]  == NSOrderedDescending) gameType = 3;
    
    NSString *sportType = @"zq";
    if (type == 1) {
        sportType = @"lq";
    }
    
    
    NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/match/%@/list?type=%d", sportType, gameType];
    
    if ([state isEqualToString:@"follow"]) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        url = [NSString stringWithFormat:@"http://23451.net:9900/my/match/zq/list?tk=%@", token];
    }
    
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        // 当日的比赛 列表不需要缓存
        NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
        KSLastestParamResult *result = [[KSLastestParamResult alloc] init];
        result.ret_code = @"0";
        KSLive *live = [[KSLive alloc] init];
        result.result = live;
        
        
        NSInteger count = [dict[@"data"] count];
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (int i=0; i<count; ++i) {
            KSLive *dataLive = [[KSLive alloc] init];
            dataLive.matchtypefullname = dict[@"data"][i][@"league_name"];
            dataLive.hteamname = dict[@"data"][i][@"home_name"];
            dataLive.cteamname = dict[@"data"][i][@"away_name"];
            NSInteger total_h = [dict[@"data"][i][@"home_score"] longValue];
            NSInteger total_c = [dict[@"data"][i][@"away_score"] longValue];
            dataLive.total_h = total_h;
            dataLive.total_c = total_c;
            dataLive.match_id = [dict[@"data"][i][@"id"] longValue];
            //            dataLive.isFollowView = NO;
            dataLive.is_follow = [state isEqualToString:@"follow"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSDate *date = [dateFormatter dateFromString:dict[@"data"][i][@"match_date"]];
            dataLive.starttime = [date timeIntervalSince1970];
            
            NSCalendar * calendar = [NSCalendar currentCalendar];
            NSDateComponents *queryDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: queryDate];
            NSDateComponents *resultDateComponents = [calendar components: NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];

            if (queryDateComponents.year == resultDateComponents.year && queryDateComponents.month == resultDateComponents.month && queryDateComponents.day == resultDateComponents.day)
                [mutableArr addObject:dataLive];
        }
        if ([state isEqualToString:@"follow"]) {
            live.t0 = mutableArr.copy;
        } else {
            live.data = mutableArr.copy;
        }
        
        if (![state isEqualToString:@"follow"]) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *token = [defaults objectForKey:@"token"];
            NSString *followUrl = [NSString stringWithFormat:@"http://23451.net:9900/my/match/zq/list?tk=%@", token];
            
            
            
            [KSHttpTool GETWithURL:followUrl params:nil success:^(id responseObject) {
                NSDictionary *dict = ((NSObject*)responseObject).mj_keyValues;
                NSInteger count = [dict[@"data"] count];
                
                NSArray *arr;
                if ([state isEqualToString:@"follow"]) {
                    arr = live.t0;
                } else {
                    arr = live.data;
                }
                
                for (KSLive *live in arr) {
                    
                    for (int i=0; i<count; ++i) {
                        NSInteger match_id = [dict[@"data"][i][@"id"] longValue];
                        if (live.match_id == match_id) {
                            live.is_follow = 1;
                        }
                    }
                }
                
                NSDictionary *resultDict = result.mj_keyValues;
                
                !completed ? : completed(resultDict);
            } failure:^(NSError *error) {
                !failure ? : failure(error);
                NSLog(@"即时比分请求出错");
            }];
        } else {
            NSDictionary *resultDict = result.mj_keyValues;
            
            !completed ? : completed(resultDict);
        }
        
        
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"即时比分请求出错");
    }];
    
////    //实例化一个NSDateFormatter对象
////    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////    //设定时间格式,这里可以设置成自己需要的格式
////    [dateFormatter setDateFormat:@"zzz"];
////
////    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[MDay integerValue]];
////    NSString *currentDateStr = [[dateFormatter stringFromDate:confromTimesp] stringByReplacingOccurrencesOfString:@"GMT" withString:@""];
////    NSString *sign = [currentDateStr substringWithRange:NSMakeRange(0, 1)];
////    NSString *number = [currentDateStr substringFromIndex:1];
////    NSMutableArray *match = [[number componentsSeparatedByString:@":"] mutableCopy];
//    NSString *timeZone = [self getGMT:MDay];
//
////    if (match.count == 2) {
////        timeZone = [NSString stringWithFormat:@"%@%@.%i",sign,match[0],[match[1] integerValue]/60];
////    } else if (match.count == 1){
////        timeZone = currentDateStr;
////    }
//
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/match_json_get?MType=%li&MState=%@&MDay=%@&gmt=%@",appUrl,(long)type,state,MDay,timeZone];
//
//
//    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
//
//        // 当日的比赛 列表不需要缓存
////        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:responseObject];
//
//
//        !completed ? : completed(responseObject);
//    } failure:^(NSError *error) {
//        !failure ? : failure(error);
//        NSLog(@"赛程赛果请求出错");
//    }];
}

// 用户登陆 !!api!!
+ (void)userLoginWithName:(NSString *)uname andPassword:(NSString *)password WithCompleted:(Completed)completed failure:(Failure)failure {
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/app_login?uname=%@&password=%@&entype=1",appUrl,uname,password];
//    NSString *url = @"http://www.mocky.io/v2/5d53e8392f00002b00861284";
    NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/user/login?acct=%@&pwd=%@", uname, password];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    // test45678/000000
    [KSHttpTool POSTWithURL:url params:nil success:^(id responseObject) {
        Login *model = [[Login alloc] init];
        LoginResult * result = [[LoginResult alloc] init];
        model.result = result;
        if ([responseObject[@"success"] boolValue]) {
            model.err_msg = @"登入成功";
            result.token = responseObject[@"data"][@"tk"];
        } else {
            model.ret_code = 1001;
            model.err_msg = @"账号不存在或密码错误";
        }
        
        NSDictionary *dict =  model.mj_keyValues;
        
        // 当日的比赛 列表不需要缓存
        
        !completed ? : completed(dict);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"用户登陆请求出错");
    }];
}

// 第三方登陆
+ (void)userThirdLoginWithParams:(NSDictionary *)params WithCompleted:(Completed)completed failure:(Failure)failure {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/oauth_login?",appUrl];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [KSHttpTool GETWithURL:url params:params success:^(id responseObject) {
        
        // 当日的比赛 列表不需要缓存
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"第三方登陆请求出错");
    }];
}

// 用户信息请求
+ (void)getUserInfoWithToken:(NSString *)token withCompleted:(Completed)completed failure:(Failure)failure {
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/sns_info_get?userid=0",appUrl];
//    NSString *url = @"http://localhost:8888/api/sns_info_get?";
    NSString *url = [NSString stringWithFormat:@"http://23451.net:9900/my/info?tk=%@", token];
    
    [KSHttpTool POSTWithURL:url params:nil success:^(id responseObject) {
        
        // 当日的比赛 列表不需要缓存
        
        UserInfo *userInfo = [[UserInfo alloc] init];
        userInfo.err_msg = @"成功";
        UserInfoResult *result = [[UserInfoResult alloc] init];
        userInfo.result = result;
        
        result.userid = 1047;
        result.user_name = @"David";
        result.email = @"David@qq.com";
        result.avatar = @"/uploads/avatar/1047/{0}.jpg";
        result.status = 1;
        result.gold = 0;
        result.gem = 0;
        result.sex = 1;
        result.nick_name = @"David";
        result.address = @"";
        result.region_id = 4;
        result.region_parent = 0;
        result.score = 0;
        result.sns_level = @"Lv.1";
        
//        "userid": 1047,
//        "user_name": "zzsport",
//        "email": "zzsport@qq.com",
        NSDictionary *dict = userInfo.mj_keyValues;
        
        !completed ? : completed(dict);
//        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"即时比分请求出错");
    }];
}

// 用户注册
+ (void)userRegisterWithName:(NSString *)uname andPassword:(NSString *)password WithCompleted:(Completed)completed failure:(Failure)failure {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/user_register?uname=%@&password=%@&entype=1",appUrl,uname,password];

    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        // 当日的比赛 列表不需要缓存
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"用户注册请求出错");
    }];
    
}

+ (void)getWikiWithType:(NSInteger)type withCompleted:(Completed)completed failure:(Failure)failure{
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/live/wiki_list_get?mtype=%li",appUrl,(long)type];
    NSString *url = @"https://mobile.gunqiu.com/interface/v3.6/news/v1.2/infolist?";
    
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        // 当日的比赛 列表不需要缓存
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"维基请求出错");
    }];
}

// 维基提交
+ (void)wikiWithParam:(NSDictionary *)wikiParam withCompleted:(Completed)completed failure:(Failure)failure {

    NSDictionary *dic = @{@"data":wikiParam};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *myString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSLog(@"维基=%@",myString);
    NSDictionary *params =@{@"data":myString};
    NSLog(@"params--%@",params);
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/Log/wiki_set?",appUrl];
    NSLog(@"维基提交链接%@data=%@",url,myString);
    [KSHttpTool GETWithURL:url params:params success:^(id responseObject) {
                
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"维基提交请求出错");
    }];
    
}

// 个人资料修改
+ (void)userInfoWithParam:(NSDictionary *)userParam withCompleted:(Completed)completed failure:(Failure)failure {

    
    NSDictionary *dic = @{@"data":userParam};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *myString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

//    myString = [myString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"信息=%@",myString);
//    NSDictionary *params =@{@"data":myString};
//    NSLog(@"params--%@",params);
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/info_set?",appUrl];
//    NSLog(@"维基提交链接%@data=%@",url,myString);
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/info_set?",appUrl];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    // sign 加密
    NSString *sign = [NSString stringWithFormat:@"http://app.likesport.com/api/users/info_setapp_id=106data=%@token=%@",myString,token];
//    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"sing=%@",sign);
    
    const char *cStr = [sign UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, sign.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    NSDictionary *params = @{@"app_id":@106,@"data":myString,@"sign":result,@"token":token};
    
    // 网址编码
//    url = [NSString stringWithFormat:@"%@&token=%@&app_id=106&data=%@&sign=%@",url,token,myString,result];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"修改资料请求链接:%@&token=%@&app_id=106&data=%@&sign=%@",url,token,myString,result);
//    [KSHttpTool POSTWithURL:url params:param success:^(id responseObject) {
//        !completed ? : completed(responseObject);
//    } failure:^(NSError *error) {
//        !failure ? : failure(error);
//        NSLog(@"个人资料修改请求出错");
//    }];
    
    [KSHttpTool GETWithSignURL:url params:params success:^(id responseObject) {
        NSLog(@"");
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"个人资料修改请求出错");
    }];
}

//词典转换为字符串

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//- ()getlanguage
//{
//    NSArray *languages = [NSLocale preferredLanguages];
//    NSString *currentLan = [languages objectAtIndex:0];
//    if ([currentLan rangeOfString:@"zh-Hans"].location != NSNotFound) {
//        _language = @"gb";
//    } else if ([currentLan isEqualToString:@"zh-HK"]||[currentLan isEqualToString:@"zh-TW"]) {
//        _language = @"big";
//    } else if ([currentLan rangeOfString:@"zh-Hant"].location != NSNotFound) {
//        _language = @"big";
//    } else {
//        _language = @"en";
//    }
//}

// 关注联赛
+ (void)followMatchWithState:(NSInteger)state Type:(NSInteger)type withMatchID:(NSInteger)matchID withToken:(NSString *)token withCompleted:(Completed)completed failure:(Failure)failure{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/follow_ptype_set?ptype=3&mid=%li&mtype=%li&status=%li",appUrl,(long)matchID,(long)type,(long)state];
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
    }];
}
+ (void)followMatchWithParam:(NSDictionary *)param withCompleted:(Completed)completed failure:(Failure)failure {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/follow_ptype_set?",appUrl];
    [KSHttpTool GETWithURL:url params:param success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];  // 我的关注刷新标志
//        [defaults setBool:YES forKey:@"follow"];
        [defaults setBool:YES forKey:@"followView"];
        [defaults synchronize];
        
    } failure:^(NSError *error) {
        !failure ? : failure(error);
    }];
}

// 获取用户关注的联赛列表
+ (void)getMatchListWithUserID:(NSString *)UserID withCompleted:(Completed)completed failure:(Failure)failure {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/follow_matchtype_get?userid=0",appUrl];
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
    }];
}

// 获取用户关注的球队列表
+ (void)getTeamListWithUserID:(NSString *)UserID withCompleted:(Completed)completed failure:(Failure)failure {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/follow_teams_get?userid=0",appUrl];
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
    }];
}


// 获取评论列表
+ (void)getCommentType:(NSInteger)type withMatchID:(NSInteger)matchID withCompleted:(Completed)completed failure:(Failure)failure {
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/sns/match_comment_get?mid=%li&mtype=%li",appUrl,(long)matchID,(long)type];
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        // 当日的比赛 列表不需要缓存
        !completed ? : completed(responseObject);
    }failure:^(NSError *error) {
        !failure ? : failure(error);
        
        NSLog(@"评论请求网络出错");
    }];
}

// 评论提交
+ (void)commentWithType:(NSInteger)type withMid:(NSInteger)mid withReplyId:(NSInteger)replyId withContent:(NSString *)content withCompleted:(Completed)completed failure:(Failure)failure {

    
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/sns/match_comment_set?mtype=%li&mid=%li&replyid=%li&content=%@",appUrl,(long)type,(long)mid,(long)replyId,content];
//    NSLog(@"评论提交链接%@data=%@",url,myString);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"评论提交请求出错");
    }];
    
}

// 删除评论
+ (void)deleteCommentWithId:(NSInteger)Id withCompleted:(Completed)completed failure:(Failure)failure {
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/sns/match_comment_del?id=%li",appUrl,(long)Id];
    
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"评论删除请求出错");
    }];
}

// 设置信鸽
+ (void)settingXGWithState:(NSDictionary *)state withCompleted:(Completed)completed failure:(Failure)failure {
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
    NSLog(@"%@",state);
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/xgstate_set?",appUrl];
    
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:state options:0 error:nil];
    NSString *myString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"信鸽设置链接%@%@",url,myString);
//    NSDictionary *dic = @{@"data":wikiParam};
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
//    NSString *myString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *params =@{@"data":myString};
//    NSLog(@"params--%@",params);
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/Log/wiki_set?",appUrl];
//    NSLog(@"维基提交链接%@data=%@",url,myString);
    
    [KSHttpTool GETWithURL:url params:state success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"信鸽设置请求出错");
    }];
}

// 反馈提交
+ (void)feedback:(NSString *)feedback withCompleted:(Completed)completed failure:(Failure)failure {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/feedback_set?rmark=%@",appUrl,feedback];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"反馈提交出错");
    }];
    
}

// 搜索
+ (void)searchWithParams:(NSDictionary *)params withCompleted:(Completed)completed failure:(Failure)failure{
    NSString *url = @"http://h.likesport.com/DataSearch/Default.aspx?";
    
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//    NSString *myString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"信鸽设置链接%@%@",url,myString);
    
    Search *search = [[Search alloc] init];
    
    NSMutableArray *result =  ((AppDelegate*)UIApplication.sharedApplication.delegate).searchResult;
    
    
    NSMutableArray *searchArr = [NSMutableArray new];
    
    NSMutableArray * unique = [NSMutableArray array];
    NSMutableSet * processed = [NSMutableSet set];
    for (NSString * string in result) {
        if ([processed containsObject:string] == NO) {
            [unique addObject:string];
            [processed addObject:string];
        }
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (KSLive *live in unique) {
        NSString *str = [NSString stringWithFormat:@"%@ %@-%@(%zd)", live.matchtypefullname, live.hteamname, live.cteamname, live.match_id];
        if ([str containsString:params[@"key"]]) {
            SearchResult *searchResult = [[SearchResult alloc] init];
            searchResult.Sport = [NSString stringWithFormat:@"%zd", live.type]; // 类别
            searchResult.ID = [NSString stringWithFormat:@"%zd", live.match_id];
            searchResult.Name = str;
            searchResult.Type = @"B"; // A:球队 B:赛事类别 C:球员
            searchResult.RID = @"d";
            searchResult.RName = @"e";
            searchResult.RCode = @"f";
            [searchArr addObject:searchResult];
        }
        
    }
    
    search.result = [searchArr copy];
    
    NSDictionary *resultDict = search.mj_keyValues;
    !completed ? : completed(resultDict);
    
//    [KSHttpTool GETWithURL:url params:params success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//        !failure ? : failure(error);
//        NSLog(@"搜索请求出错");
//    }];
}

// 搜索球队结果页
+ (void)teamWithUrl:(NSString *)url WithParams:(NSDictionary *)params withCompleted:(Completed)completed failure:(Failure)failure {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/api/live/%@?",appUrl,url];
    
    [KSHttpTool GETWithURL:urlString params:params success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"搜索球队资料请求出错");
    }];
}

// 球队详情
+ (void)getTeamInfoWithParams:(NSDictionary *)params withCompleted:(Completed)completed failure:(Failure)failure {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/api/mdata/team_info_get?",appUrl];
    
    [KSHttpTool GETWithURL:urlString params:params success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"搜索球队资料请求出错");
    }];

}

// 球队赛程
+ (void)getTeamLeagueWithParams:(NSDictionary *)params withCompleted:(Completed)completed failure:(Failure)failure{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/api/mdata/team_stage_match?",appUrl];
    
    [KSHttpTool GETWithURL:urlString params:params success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
    } failure:^(NSError *error) {
        !failure ? : failure(error);
        NSLog(@"搜索球队赛程请求出错");
    }];
}

// 根据时间获取时区
+ (NSString *)getGMT:(NSString *)time {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"zzz"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSString *currentDateStr = [[dateFormatter stringFromDate:confromTimesp] stringByReplacingOccurrencesOfString:@"GMT" withString:@""];
    NSString *sign = [currentDateStr substringWithRange:NSMakeRange(0, 1)];
    NSString *number = [currentDateStr substringFromIndex:1];
    NSMutableArray *match = [[number componentsSeparatedByString:@":"] mutableCopy];
    NSString *timeZone;
    
    if (match.count == 2) {
        timeZone = [NSString stringWithFormat:@"%@%@.%li",sign,match[0],[match[1] integerValue]/60];
    } else if (match.count == 1){
        timeZone = currentDateStr;
    }
    
    return timeZone;
}

+ (void)updataAvatarWithImg:(UIImage *)img withCompleted:(Completed)completed failure:(Failure)failure
{
    KSDataObject *uploadParam = [[KSDataObject alloc] init];
    uploadParam.data = UIImagePNGRepresentation(img);
    uploadParam.name = @"avatar";
    uploadParam.filename = @"image.png";
    uploadParam.mimeType = @"image/png";
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *mac_token = [defaults objectForKey:@"mac_token"];//根据键值取出name
    NSString *token = [defaults objectForKey:@"token"];
//    NSDictionary *param = @{@"token":token,@"app_id":@"106"};
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/avatar_set?app_id=106&token=%@",appUrl,token];
    
//    NSLog(@"url=%@token=%@&app_id=%@",url,[param objectForKey:@"token"],[param objectForKey:@"app_id"]);
    NSLog(@"url=%@",url);

    [KSHttpTool POSTWithURL:url params:nil data:uploadParam success:^(id responseObject) {
        
        !completed ? : completed(responseObject);
//        NSString *ret_code = [responseObject objectForKey:@"ret_code"];
//        NSLog(@"response=%@",ret_code);
    } failure:^(NSError *error) {
        
    }];
//    NSData *imageData = UIImagePNGRepresentation(img);
//    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        
//        if (succeeded)
//        {
//            AVUser *currentUser = [AVUser currentUser];
//            currentUser[@"avaterUrl"] = imageFile.url;
//            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//             {
//                 if (succeeded)
//                 {
//                     NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:wUserInfo];
//                     NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//                     [muDic setObject:imageFile.url forKey:@"avaterUrl"];
//                     [[NSUserDefaults standardUserDefaults]setObject:[muDic copy] forKey:wUserInfo];
//                     [[NSUserDefaults standardUserDefaults]synchronize];
//                     
//                     successBlock(imageFile.url);
//                 }
//                 else
//                 {
//                     failureBlock(error);
//                 }
//             }];
//            
//        }
//        
//    } progressBlock:^(NSInteger percentDone) {
//        
//    }];
    
}

@end
