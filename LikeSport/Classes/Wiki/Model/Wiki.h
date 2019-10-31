//
//  Wiki.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/27.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WikiResult;
@interface Wiki : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) WikiResult *result;

@end
@interface WikiResult : NSObject

@property (nonatomic, strong) NSArray<WikiResult *> *t0;

@property (nonatomic, strong) NSArray<WikiResult *> *t2;

@property (nonatomic, strong) NSArray<WikiResult *> *t1;

@property (nonatomic, assign) NSInteger type;


@property (nonatomic, copy) NSString *matchtypefullname;

@property (nonatomic, assign) NSInteger match_id;

@property (nonatomic, assign) NSInteger mtype;

@property (nonatomic, assign) NSInteger starttime;

@property (nonatomic, copy) NSString *stagename;

@property (nonatomic, copy) NSString *ruletype;

@property (nonatomic, copy) NSString *teamname;

@property (nonatomic, assign) NSInteger rwxnb;

@property (nonatomic, assign) NSInteger stage_id;

@property (nonatomic, copy) NSString *cteamname;

@property (nonatomic, assign) NSInteger wikixs_id;

@property (nonatomic, assign) NSInteger cteam_id;

@property (nonatomic, copy) NSString *hteamname;

@property (nonatomic, assign) NSInteger team_id;

@property (nonatomic, assign) NSInteger matchtype_id;

@property (nonatomic, assign) NSInteger hteam_id;

@property (nonatomic, assign) NSInteger wikitype;


// for news
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@end

