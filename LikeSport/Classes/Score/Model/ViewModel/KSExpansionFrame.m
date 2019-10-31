//
//  KSExpansionFrame.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/10.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSExpansionFrame.h"
#import "KSLive.h"
@implementation KSExpansionFrame

- (void)setLive:(KSLive *)live
{
    _live = live;
    
    // 计算比分frame
    [self setUpLiveViewFrame];
    
    // 计算cell高度
//    _cellHeight = CGRectGetMaxY(_cteamnameFrame) + 5;
}

- (void)setUpLiveViewFrame
{

    
    
    // 主队总分Frame
    CGFloat total_hX = kSceenWidth/2 - 30;
    CGFloat total_hY = 10;
    CGSize total_hSize = CGSizeMake(30, 15);
    _total_hFrame = (CGRect){{total_hX,total_hY},total_hSize};

    //  客队总分Frame
    CGFloat total_cX = kSceenWidth/2;
    CGFloat total_cY = 10;
    CGSize total_cSize = CGSizeMake(30, 15);
    _total_cFrame = (CGRect){{total_cX,total_cY},total_cSize};

    CGFloat hteamnameX = 10;
    CGFloat hteamnameY = 10;
    //    CGSize hteamnameSize = [_live.hteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGSize hteamnameSize = CGSizeMake(total_hX - 10, 15);
    _hteamnameFrame = (CGRect){{hteamnameX,hteamnameY},hteamnameSize};
    
    
//    CGSize cteamnameSize = [_live.cteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGSize cteamnameSize = CGSizeMake(kSceenWidth - CGRectGetMaxX(_total_cFrame), 15);
    CGFloat cteamnameX = kSceenWidth - cteamnameSize.width - 10;
    CGFloat cteamnameY = CGRectGetMaxX(_cteamnameFrame) -10;
    _cteamnameFrame = (CGRect){{cteamnameX,cteamnameY},cteamnameSize};

    if (_live.hascourts == 4) {
        
        
//        CGFloat st1_hX = kSceenWidth/2 - 30;
//        CGFloat st1_hY = CGRectGetMaxY(_total_hFrame) + 5;
//        CGSize st1_hSize = CGSizeMake(30, 15);
//        _st1_hFrame = (CGRect){{st1_hX,st1_hY},st1_hSize};
//
//        CGFloat st1_cX = kSceenWidth/2;
//        CGFloat st1_cY = st1_hY;
//        CGSize st1_cSize = CGSizeMake(30, 15);
//        _st1_cFrame = (CGRect){{st1_cX,st1_cY},st1_cSize};
//
//        CGFloat quarter1X = CGRectGetMaxX(_st1_cFrame);
//        CGFloat quarter1Y = st1_cY;
//        CGSize quarter1Size = CGSizeMake(40, 15);
//        _quarter1Frame = (CGRect){{quarter1X,quarter1Y},quarter1Size};
//
//        CGFloat st2_hX = kSceenWidth/2 - 30;
//        CGFloat st2_hY = CGRectGetMaxY(_st1_hFrame) + 5;
//        CGSize st2_hSize = CGSizeMake(30, 15);
//        _st2_hFrame = (CGRect){{st2_hX,st2_hY},st2_hSize};
//
//        CGFloat st2_cX = kSceenWidth/2;
//        CGFloat st2_cY = st2_hY;
//        CGSize st2_cSize = CGSizeMake(30, 15);
//        _st2_cFrame = (CGRect){{st2_cX,st2_cY},st2_cSize};
//
//        CGFloat quarter2X = CGRectGetMaxX(_st2_cFrame);
//        CGFloat quarter2Y = st2_cY;
//        CGSize quarter2Size = CGSizeMake(40, 15);
//        _quarter1Frame = (CGRect){{quarter2X,quarter2Y},quarter2Size};
//
//
//        CGFloat half_hSX = kSceenWidth/2 - 30;
//        CGFloat half_hSY = CGRectGetMaxY(_st2_hFrame) + 5;
//        CGSize half_hSSize = CGSizeMake(30, 15);
//        _half_hSFrame = (CGRect){{half_hSX,half_hSY},half_hSSize};
//
//        CGFloat half_cSX = kSceenWidth/2;
//        CGFloat half_cSY = half_hSY;
//        CGSize half_cSSize = CGSizeMake(30, 15);
//        _half_cSFrame = (CGRect){{half_cSX,half_cSY},half_cSSize};
//
//        CGFloat st3_hX = kSceenWidth/2 - 30;
//        CGFloat st3_hY = CGRectGetMaxY(_half_hSFrame) + 5;
//        CGSize st3_hSize = CGSizeMake(30, 15);
//        _st3_hFrame = (CGRect){{st3_hX,st3_hY},st3_hSize};
//
//        CGFloat st3_cX = kSceenWidth/2;
//        CGFloat st3_cY = st3_hY;
//        CGSize st3_cSize = CGSizeMake(30, 15);
//        _st3_cFrame = (CGRect){{st3_cX,st3_cY},st3_cSize};
//
//        CGFloat quarter3X = CGRectGetMaxX(_st3_cFrame);
//        CGFloat quarter3Y = st2_cY;
//        CGSize quarter3Size = CGSizeMake(40, 15);
//        _quarter1Frame = (CGRect){{quarter3X,quarter3Y},quarter3Size};
//
//        CGFloat st4_hX = kSceenWidth/2 - 30;
//        CGFloat st4_hY = CGRectGetMaxY(_st3_hFrame) + 5;
//        CGSize st4_hSize = CGSizeMake(30, 15);
//        _st4_hFrame = (CGRect){{st4_hX,st4_hY},st4_hSize};
//
//        CGFloat st4_cX = kSceenWidth/2;
//        CGFloat st4_cY = st4_hY;
//        CGSize st4_cSize = CGSizeMake(30, 15);
//        _st4_cFrame = (CGRect){{st4_cX,st4_cY},st4_cSize};
//
//        CGFloat half_hXX = kSceenWidth/2 - 30;
//        CGFloat half_hXY = CGRectGetMaxY(_st4_hFrame) + 5;
//        CGSize half_hXSize = CGSizeMake(30, 15);
//        _half_hXFrame = (CGRect){{half_hXX,half_hXY},half_hXSize};
//
//        CGFloat half_cXX = kSceenWidth/2;
//        CGFloat half_cXY = half_hXY;
//        CGSize half_cXSize = CGSizeMake(30, 15);
//        _half_cXFrame = (CGRect){{half_cXX,half_cXY},half_cXSize};
//
    } else if (_live.hascourts == 2) {
        
        
        
//        CGFloat half_hSX = kSceenWidth/2 - 30;
//        CGFloat half_hSY = CGRectGetMaxY(_total_hFrame) + 5;
//        CGSize half_hSSize = CGSizeMake(30, 15);
//        _half_hSFrame = (CGRect){{half_hSX,half_hSY},half_hSSize};
//
//        CGFloat half_cSX = kSceenWidth/2;
//        CGFloat half_cSY = half_hSY;
//        CGSize half_cSSize = CGSizeMake(30, 15);
//        _half_cSFrame = (CGRect){{half_cSX,half_cSY},half_cSSize};
//
//        CGFloat half_hXX = kSceenWidth/2 - 30;
//        CGFloat half_hXY = CGRectGetMaxY(_half_hSFrame) + 5;
//        CGSize half_hXSize = CGSizeMake(30, 15);
//        _half_hXFrame = (CGRect){{half_hXX,half_hXY},half_hXSize};
//        
//        CGFloat half_cXX = kSceenWidth/2;
//        CGFloat half_cXY = half_hSY;
//        CGSize half_cXSize = CGSizeMake(30, 15);
//        _half_cXFrame = (CGRect){{half_cXX,half_cXY},half_cXSize};
        
    }
    
    
}

@end
