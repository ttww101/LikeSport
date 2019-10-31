//
//  WikiParam.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/28.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiParam : NSObject
@property (nonatomic, assign) NSInteger mtype;
@property (nonatomic, assign) NSInteger s_h_bf;
@property (nonatomic, assign) NSInteger s_c_bf;
@property (nonatomic, assign) NSInteger h_bf;
@property (nonatomic, assign) NSInteger c_bf;
@property (nonatomic, assign) NSInteger s_half_h;
@property (nonatomic, assign) NSInteger s_half_c;
@property (nonatomic, assign) NSInteger half_h;
@property (nonatomic, assign) NSInteger half_c;
@property (nonatomic, copy) NSString *s_statetxt;
@property (nonatomic, copy) NSString *statetxt;
@property (nonatomic, copy) NSString *rmark;
@property (nonatomic, assign) NSInteger typeid;
@property (nonatomic, assign) NSInteger wikitype;
@property (nonatomic, assign) NSInteger wikixs_id;
@property (nonatomic, copy) NSString *wiki_lan;
@property (nonatomic, assign) NSInteger stage_id;

@end
