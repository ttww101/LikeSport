//
//  KSMore.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/25.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMore : NSObject

@property (nonatomic, assign)NSInteger hteam_id;
@property (nonatomic, copy) NSString *hteamname;
@property (nonatomic, copy) NSString *cteamname;
@property (nonatomic, copy) NSString *full_bf;
@property (nonatomic, copy) NSString *half_bf;
@property (nonatomic, copy) NSString *teamtag;


/********  扩展  *********/
/**
 *  球员名
 */
@property (nonatomic, copy) NSString *playername;

/**
 *  事件时间
 */
@property (nonatomic, assign) NSInteger proctime;

/**
 *  事件类型--进球g 点球p 乌龙球o 黄牌y 红牌r 双黄变红t 上场（被替换上场）s 下场（被替换下场）x 助攻z
 */
@property (nonatomic, copy) NSString *actiontype;

/**
 *  主队或客队id
 */
@property (nonatomic, assign) NSInteger teamid;



/**
 *  扩展事件数量
 */
@property (nonatomic, assign) NSInteger count;



@end
