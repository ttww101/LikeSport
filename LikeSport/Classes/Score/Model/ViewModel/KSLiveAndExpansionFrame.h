//
//  KSLiveAndExpansionFrame.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/13.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSLive;
@class KSMore;

@interface KSLiveAndExpansionFrame : NSObject
// 即时比分数据
@property (nonatomic, strong) KSLive *live;

//// 扩展数据
@property (nonatomic, strong) KSMore *more;


// 即时比分frame
@property (nonatomic, assign) CGRect liveViewFrame;

// 实际开赛时间Frame
@property (nonatomic, assign) CGRect starttimeFrame;

// 国旗
@property (nonatomic, assign) CGRect flagFrame;

//  赛事类型全名Frame
@property (nonatomic, assign) CGRect matchtypefullnameFrame;

//  半场时间Frame
@property (nonatomic, assign) CGRect halfcourttimeFrame;

//  比赛状态Frame
@property (nonatomic, assign) CGRect stateFrame;

//  主队名Frame
@property (nonatomic, assign) CGRect hteamnameFrame;

//  客队名Frame
@property (nonatomic, assign) CGRect cteamnameFrame;

//  主队得分Frame
@property (nonatomic, assign) CGRect full_hFrame;

//  客队得分Frame
@property (nonatomic, assign) CGRect full_cFrame;

//  主队红牌Frame
@property (nonatomic, assign) CGRect rcard_hFrame;

//  客队红牌Frame
@property (nonatomic, assign) CGRect rcard_cFrame;

//  中立场Frame
@property (nonatomic, assign) CGRect neutralgreenFrame;

////  关注按钮Frame
//@property (nonatomic, assign) CGRect forceBtnFrame;
//
////  更多展开按钮Frame
//@property (nonatomic, assign) CGRect moreBtnFrame;



// 比分之外更多数据
@property (nonatomic, assign) CGRect moreViewFrame;

@property (nonatomic, assign) CGRect expansionViewFrame;
@property (nonatomic, assign) CGRect hteamname2Frame;
@property (nonatomic, assign) CGRect cteamname2Frame;
@property (nonatomic, assign) CGRect hteamname_2Frame;
@property (nonatomic, assign) CGRect cteamname_2Frame;
@property (nonatomic, assign) CGRect total_hFrame;
@property (nonatomic, assign) CGRect total_cFrame;
@property (nonatomic, assign) CGRect st1Frame;
@property (nonatomic, assign) CGRect st2Frame;
@property (nonatomic, assign) CGRect st3Frame;
@property (nonatomic, assign) CGRect st4Frame;
@property (nonatomic, assign) CGRect halfSFrame;
@property (nonatomic, assign) CGRect halfXFrame;


//@property (nonatomic, assign) CGRect st1_hFrame;
//@property (nonatomic, assign) CGRect st1_cFrame;
//@property (nonatomic, assign) CGRect st2_hFrame;
//@property (nonatomic, assign) CGRect st2_cFrame;
//@property (nonatomic, assign) CGRect half_hSFrame;
//@property (nonatomic, assign) CGRect half_cSFrame;
//@property (nonatomic, assign) CGRect st3_hFrame;
//@property (nonatomic, assign) CGRect st3_cFrame;
//@property (nonatomic, assign) CGRect st4_hFrame;
//@property (nonatomic, assign) CGRect st4_cFrame;
//@property (nonatomic, assign) CGRect half_hXFrame;
//@property (nonatomic, assign) CGRect half_cXFrame;

@property (nonatomic, assign) CGRect quarter1Frame;
@property (nonatomic, assign) CGRect quarter2Frame;
@property (nonatomic, assign) CGRect halfFrame;
@property (nonatomic, assign) CGRect quarter3Frame;
@property (nonatomic, assign) CGRect quarter4Frame;
@property (nonatomic, assign) CGRect half2Frame;



// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat basketballHeight;
@property (nonatomic, assign) CGFloat tennisHeight;


@end