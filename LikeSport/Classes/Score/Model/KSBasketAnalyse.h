//
//  KSBasketAnalyse.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/31.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BasketAnalyseResult,BasketPk_Data;
@interface KSBasketAnalyse : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) BasketAnalyseResult *result;

@end
@interface BasketAnalyseResult : NSObject

@property (nonatomic, copy) NSString *momenttype;

@property (nonatomic, copy) NSString *doreport;

@property (nonatomic, copy) NSString *groupname;

@property (nonatomic, strong) NSArray<BasketPk_Data *> *h_result_data;

@property (nonatomic, strong) NSArray<BasketPk_Data *> *c_result_data;

@property (nonatomic, copy) NSString *reporttype;

@property (nonatomic, strong) NSArray<BasketPk_Data *> *h_fixtures_data;

@property (nonatomic, strong) NSArray<BasketPk_Data *> *c_fixtures_data;

@property (nonatomic, copy) NSString *cteamname;

@property (nonatomic, assign) NSInteger group;

@property (nonatomic, assign) NSInteger cteam_id;

@property (nonatomic, copy) NSString *hteamname;

@property (nonatomic, assign) NSInteger stageid;

@property (nonatomic, assign) NSInteger hteam_id;

@property (nonatomic, strong) NSArray<BasketPk_Data *> *pk_data;

@end

@interface BasketPk_Data : NSObject

@property (nonatomic, assign) BOOL isPkData;

@property (nonatomic, assign) BOOL isFixturesData;
@property (nonatomic, assign) NSInteger hteamid;
@property (nonatomic, assign) NSInteger cteamid;
@property (nonatomic, assign) BOOL isHteam;


@property (nonatomic, assign) NSInteger st2_h;

@property (nonatomic, copy) NSString *stagename;

@property (nonatomic, assign) NSInteger cteam_id;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *handicaprate;

@property (nonatomic, assign) NSInteger st1_h;

@property (nonatomic, copy) NSString *winer;

@property (nonatomic, assign) NSInteger total_c;

@property (nonatomic, copy) NSString *hteamname;

@property (nonatomic, copy) NSString *neutralgreen;

@property (nonatomic, assign) NSInteger total_h;

@property (nonatomic, copy) NSString *cteamname;

@property (nonatomic, copy) NSString *wintype;

@property (nonatomic, assign) NSInteger st4_c;

@property (nonatomic, copy) NSString *resultbs;

@property (nonatomic, assign) NSInteger hascourts;

@property (nonatomic, assign) NSInteger stage_id;

@property (nonatomic, assign) NSInteger st3_c;

@property (nonatomic, assign) NSInteger match_id;

@property (nonatomic, copy) NSString *op_hpl;

@property (nonatomic, assign) NSInteger moment_id;

@property (nonatomic, copy) NSString *op_cpl;

@property (nonatomic, assign) NSInteger st4_h;

@property (nonatomic, assign) NSInteger st2_c;

@property (nonatomic, assign) NSInteger starttime;

@property (nonatomic, assign) NSInteger group;

@property (nonatomic, copy) NSString *cpl;

@property (nonatomic, copy) NSString *hpl;

@property (nonatomic, copy) NSString *hbspl;

@property (nonatomic, copy) NSString *cbspl;

@property (nonatomic, copy) NSString *matchtypefullname;

@property (nonatomic, copy) NSString *pkbs;

@property (nonatomic, assign) NSInteger st3_h;

@property (nonatomic, assign) NSInteger hteam_id;

@property (nonatomic, assign) NSInteger st1_c;

@property (nonatomic, assign) NSInteger matchtype_id;

@property (nonatomic, copy) NSString *wintag;

@property (nonatomic, copy) NSString *teamtag;

@property (nonatomic, assign) NSInteger round;

@property (nonatomic, assign) BOOL isTeamInfo;
@property (nonatomic, copy) NSString *momentname;
@property (nonatomic, copy) NSString *momenttype;

@end


