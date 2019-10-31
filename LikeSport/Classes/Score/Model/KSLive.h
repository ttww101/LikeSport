//
//  KSLive.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KSMore;
@interface KSLive : NSObject

@property (nonatomic, strong) NSArray<KSLive *> *t0;

@property (nonatomic, strong) NSArray<KSLive *> *t2;

@property (nonatomic, strong) NSArray<KSLive *> *t1;

@property (nonatomic, strong) NSArray<KSLive *> *data;

@property (nonatomic, strong) NSArray<KSMore *> *more;


// 搜索球队
@property (nonatomic, strong) NSArray<KSLive *> *result_data; // 球队近期战绩
@property (nonatomic, strong) NSArray<KSLive *> *fixtures_data; // 球队未来赛事
@property (nonatomic, strong) KSLive *live_data; // 球队正在进行中的赛事

@property (nonatomic, assign) NSInteger flag_num;

@property (nonatomic, assign) NSInteger t0_flag_num;
@property (nonatomic, assign) NSInteger t1_flag_num;
@property (nonatomic, assign) NSInteger t2_flag_num;

//@property (nonatomic, copy) NSString *result;

@property (nonatomic, strong) NSMutableArray *last;

@property (nonatomic, assign) BOOL isOpen;

/**
 *  比赛分数变化标示
 */
@property (nonatomic, assign) long timeH;
@property (nonatomic, assign) long timeC;
@property (nonatomic, assign) long st1T_h;
@property (nonatomic, assign) long st1T_c;
@property (nonatomic, assign) long st2T_h;
@property (nonatomic, assign) long st2T_c;
@property (nonatomic, assign) long st3T_h;
@property (nonatomic, assign) long st3T_c;
@property (nonatomic, assign) long st4T_h;
@property (nonatomic, assign) long st4T_c;
@property (nonatomic, assign) long st5T_h;
@property (nonatomic, assign) long st5T_c;

//@property (nonatomic, assign) BOOL isFootH;
//@property (nonatomic, assign) BOOL isFootC;
//@property (nonatomic, assign) BOOL isBasH;
//@property (nonatomic, assign) BOOL isBasC;
//@property (nonatomic, assign) BOOL isTenH;
//@property (nonatomic, assign) BOOL isTenC;

// 赛程赛果
@property (nonatomic, assign) BOOL isMatch;

// 关注页标志
@property (nonatomic, assign) BOOL isFollowView;



/**
 *  赛事类型
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  是否关注
 */
@property (nonatomic, assign) NSInteger is_follow;


/**
 *  赛事类型id
 */
@property (nonatomic, assign) NSInteger matchtype_id;

/**
 *  国家id
 */
@property (nonatomic, assign) NSInteger tregion_id;

/**
 *  国家简称
 */
@property (nonatomic, copy) NSString *tsigncode;


/**
 *  当前状态
 */
@property (nonatomic, copy) NSString *state;

/**
 *  赛事ID
 */
@property (nonatomic, assign) NSInteger match_id;

/**
 *  开赛时间
 */
@property (nonatomic, assign) long starttime;

/**
 *  维基ID
 */
@property (nonatomic, copy) NSString *wiki_id;

/**
 *  客队红牌
 */
@property (nonatomic, assign) NSInteger rcard_c;


/**
 *  主队红牌
 */
@property (nonatomic, assign) NSInteger rcard_h;


/**
 *  实际开赛时间
 */
@property (nonatomic, assign) NSInteger realstarttime;

/**
 *  客队全场得分
 */
//@property (nonatomic, assign) NSInteger full_c;

/**
 *  半场得分
 */
@property (nonatomic, copy) NSString *half_bf;

/**
 *  主队全场得分
 */
//@property (nonatomic, assign) NSInteger full_h;

/**
 *  客队名称
 */
@property (nonatomic, copy) NSString *cteamname;

/**
 *  半场分钟数
 */
@property (nonatomic, assign) NSInteger halfcourttime;

/**
 *  赛事类型全名
 */
@property (nonatomic, copy) NSString *matchtypefullname;

/**
 *  区域类别编码
 */
//@property (nonatomic, copy) NSString *tsigncode;

/**
 *  赛事类型ID
 */
//@property (nonatomic, copy) NSString *matchtype_id;

/**
 *  主队ID
 */
@property (nonatomic, assign) NSInteger hteam_id;

/**
 *  主队名
 */
@property (nonatomic, copy) NSString *hteamname;

/**
 *  客队ID
 */
@property (nonatomic, assign) NSInteger cteam_id;

/**
 *  是否中场
 */
@property (nonatomic, copy) NSString *neutralgreen;


///********  扩展  *********/
///**
// *  球员名
// */
//@property (nonatomic, copy) NSString *playername;
//
///**
// *  事件时间
// */
//@property (nonatomic, copy) NSString *proctime;
//
///**
// *  事件类型--进球g 点球p 乌龙球o 黄牌y 红牌r 双黄变红t 上场（被替换上场）s 下场（被替换下场）x 助攻z
// */
//@property (nonatomic, copy) NSString *actiontype;
//
///**
// *  主队或客队id
// */
//@property (nonatomic, copy) NSString *teamid;
//
///**
// *  扩展事件数量
// */
//@property (nonatomic, assign) NSInteger count;


/**
 *  篮球比分
 */
@property (nonatomic, assign) NSInteger total_h;
@property (nonatomic, assign) NSInteger total_c;

// 有第几节
@property (nonatomic, assign) NSInteger hascourts;

// 比赛时间
@property (nonatomic, strong) NSString *matchjs;
@property (nonatomic, assign) NSInteger st1_h;
@property (nonatomic, assign) NSInteger st1_c;
@property (nonatomic, assign) NSInteger st2_h;
@property (nonatomic, assign) NSInteger st2_c;
@property (nonatomic, assign) NSInteger st3_h;
@property (nonatomic, assign) NSInteger st3_c;
@property (nonatomic, assign) NSInteger st4_h;
@property (nonatomic, assign) NSInteger st4_c;
@property (nonatomic, assign) NSInteger st5_h;
@property (nonatomic, assign) NSInteger st5_c;
@property (nonatomic, assign) NSInteger ot_h;
@property (nonatomic, assign) NSInteger ot_c;

// 网球双打
@property (nonatomic, assign) NSInteger isDouble;
 
@property (nonatomic, strong) NSString *winer;

@property (nonatomic, strong) NSString *hteamname_2;
@property (nonatomic, strong) NSString *cteamname_2;

/**
 *  篮球即时数据
 */
@property (nonatomic, assign) NSInteger t;

@property (nonatomic, strong) NSString *d;


/**
 *  足球进球队员数据是否为空
 */
@property (nonatomic, assign) BOOL isGoalEnpty;


@end

