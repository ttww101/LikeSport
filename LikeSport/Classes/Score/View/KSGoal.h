//
//  KSGoal.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KSMore;
@interface KSGoal : UIImageView

@property (nonatomic,weak) UILabel *hNameView;
@property (nonatomic,weak) UILabel *cNameView;
@property (nonatomic,weak) UIImageView *hGoalView;
@property (nonatomic,weak) UIImageView *cGoalView;
@property (weak, nonatomic) UILabel *proctime;

@end