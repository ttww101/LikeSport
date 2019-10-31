//
//  KSTopView.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/3.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KSFootballBase.h"
#import "KSBasketballBase.h"

@interface KSTopView : UIView
@property (nonatomic, strong) FootballBaseResult *footballResult;
@property (nonatomic, strong) BasketResult *basketballResult;
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet UIImageView *hteamImage;
@property (weak, nonatomic) IBOutlet UIImageView *cteamImage;

+ (instancetype)topView;
@end
