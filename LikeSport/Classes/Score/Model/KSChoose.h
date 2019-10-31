//
//  KSChoose.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/3.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChooseResult,Matchtypes;
@interface KSChoose : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) ChooseResult *result;

@end
@interface ChooseResult : NSObject

@property (nonatomic, strong) NSArray<Matchtypes *> *regions;

@property (nonatomic, strong) NSArray<Matchtypes *> *matchtypes;


@end


@interface Matchtypes : NSObject

@property(retain,nonatomic)NSString *pinYin;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, assign) NSInteger region_id;

@property (nonatomic, assign) NSInteger is_follow;

@property (nonatomic, assign) BOOL isMatch;

@property (nonatomic, assign) BOOL isSelect;


@end

