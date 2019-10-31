//
//  KSChooseController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/31.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
#import "KSChoose.h"

@protocol ChooseDelegate <NSObject>

@optional
- (void)chooseArray:(NSArray *)array chooseType:(NSInteger)chooseType type:(NSInteger)type residueCount:(NSString *)count;

@end

@interface KSChooseController : BaseViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSString *MDay;
@property (nonatomic, copy) void(^chooseBlock)(NSArray *chooseArray);

@property (nonatomic, assign) NSInteger chooseType;  // 0为不筛选  1为赛事筛选  2为国家筛选 
@property (nonatomic, assign) NSInteger isMatch; // 1 赛事  2 国家

@property (nonatomic, strong) NSMutableArray<Matchtypes *> *chooseArray;


@property (weak, nonatomic) id<ChooseDelegate> delegate;


@end
