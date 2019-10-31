//
//  KSLiveView.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/26.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSLiveFrame;
@interface KSLiveView : UIImageView

@property (nonatomic, strong) KSLiveFrame *liveF;

@property (nonatomic, strong) UIView *bottonview;

-(void)setredcard:(UIColor*)color;

-(void)setMyLayout;
@end
