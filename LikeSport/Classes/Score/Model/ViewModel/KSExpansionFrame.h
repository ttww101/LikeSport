//
//  KSExpansionFrame.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/10.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KSLive;

@interface KSExpansionFrame : NSObject
// 即时比分数据
@property (nonatomic, strong) KSLive *live;

@property (nonatomic, assign) CGRect expansionViewFrame;
@property (nonatomic, assign) CGRect hteamnameFrame;
@property (nonatomic, assign) CGRect cteamnameFrame;
@property (nonatomic, assign) CGRect total_hFrame;
@property (nonatomic, assign) CGRect total_cFrame;

@property (nonatomic, assign) CGRect st1_hFrame;
@property (nonatomic, assign) CGRect st1_cFrame;
@property (nonatomic, assign) CGRect st2_hFrame;
@property (nonatomic, assign) CGRect st2_cFrame;
@property (nonatomic, assign) CGRect half_hSFrame;
@property (nonatomic, assign) CGRect half_cSFrame;
@property (nonatomic, assign) CGRect st3_hFrame;
@property (nonatomic, assign) CGRect st3_cFrame;
@property (nonatomic, assign) CGRect st4_hFrame;
@property (nonatomic, assign) CGRect st4_cFrame;
@property (nonatomic, assign) CGRect half_hXFrame;
@property (nonatomic, assign) CGRect half_cXFrame;

@property (nonatomic, assign) CGRect quarter1Frame;
@property (nonatomic, assign) CGRect quarter2Frame;
@property (nonatomic, assign) CGRect halfFrame;
@property (nonatomic, assign) CGRect quarter3Frame;
@property (nonatomic, assign) CGRect quarter4Frame;
@property (nonatomic, assign) CGRect half2Frame;

//@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat expansionHeight;

@end
