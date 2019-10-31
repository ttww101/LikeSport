//
//  KSLiveAndExpansionFrame.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/13.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLiveAndExpansionFrame.h"
#import "KSLive.h"
#import "KSMore.h"

@implementation KSLiveAndExpansionFrame
- (void)setLive:(KSLive *)live
{
    _live = live;
    
    // 计算比分frame
    [self setUpLiveViewFrame];
    
    // 计算cell高度
    _cellHeight = CGRectGetMaxY(_cteamnameFrame) + 15;
//    _basketballHeight = CGRectGetMaxY(_half_hXFrame) + 15;
    
}

- (void)setMore:(KSMore *)more
{
    _more = more;
    
    // 计算扩展frame
    //    [self setUpMoreViewFrame];
    
    //    _cellHeight = CGRectGetMaxY(_moreViewFrame);
}

- (void)setUpLiveViewFrame
{
    // 开赛时间Frame
    CGFloat starttimeX = KSLiveCellMargin*2;
    CGFloat starttimeY = -7;
    //    CGSize starttimeSize = [[NSString stringWithFormat:@"%li",_live.starttime] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    CGSize starttimeSize;
    if (_live.isMatch || _live.isFollowView) {
        starttimeSize = CGSizeMake(80, 15);
    } else {
        starttimeSize = CGSizeMake(40, 15);
    }
    _starttimeFrame = (CGRect){{starttimeX,starttimeY},starttimeSize};
    
    // 国旗Frame
    CGFloat flagX = CGRectGetMaxX(_starttimeFrame);
    CGFloat flagY = -6;
    //    CGSize starttimeSize = [[NSString stringWithFormat:@"%li",_live.starttime] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    CGSize flagSize = CGSizeMake(18, 12);
    _flagFrame = (CGRect){{flagX,flagY},flagSize};
    
    //  半场时间Frame
    CGFloat halfcourttimeX = kSceenWidth - 40;
    CGFloat halfcourttimeY = -7;
    CGSize halfcourttimeSize = CGSizeMake(40, 15);
    //    CGSize halfcourttimeSize = [_live.halfcourttime sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    _halfcourttimeFrame = (CGRect){{halfcourttimeX,halfcourttimeY},halfcourttimeSize};
    
    
    
    //  比赛状态Frame
    CGFloat stateX;
    if (([_live.state isEqualToString:@"F"] || [_live.state isEqualToString:@"R"] || [_live.state isEqualToString:@"C"] || [_live.state isEqualToString:@"Q"] || [_live.state isEqualToString:@"T"] || [_live.state isEqualToString:@"Y"] || [_live.state isEqualToString:@"D"] || [_live.state isEqualToString:@"E"]) && !_live.isFollowView) {
        stateX = kSceenWidth - 45;
    } else {
        stateX = kSceenWidth - 85;
    }
    
    CGFloat stateY = -7;
    CGSize stateSize;
    if (_live.type == 2 && !_live.isFollowView) {
        stateSize = CGSizeMake(kSceenWidth - stateX, 15);
    } else if (_live.type == 2 && _live.isFollowView) {
        stateSize = CGSizeMake(45, 15);
    }
    else {
        stateSize = CGSizeMake(45, 15);
    }
    
    //    CGSize stateSize = [_live.state sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _stateFrame = (CGRect){{stateX,stateY},stateSize};
    
    //  主队得分Frame
    CGFloat full_hX = stateX;
    CGFloat full_hY = CGRectGetMaxY(_starttimeFrame) + KSLiveCellMargin;
    CGSize full_hSize = CGSizeMake(45, 15);
    
    //    CGSize full_hSize = [_live.full_h sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _full_hFrame = (CGRect){{full_hX,full_hY},full_hSize};
    
    //  客队得分Frame
    CGFloat full_cX = full_hX;
    CGFloat full_cY = CGRectGetMaxY(_full_hFrame) + KSLiveCellMargin;
    CGSize full_cSize = CGSizeMake(45, 15);
    
    //    CGSize full_cSize = [_live.full_c sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _full_cFrame = (CGRect){{full_cX,full_cY},full_cSize};
    
    //  赛事类型全名Frame
    CGFloat matchtypefullnameX = CGRectGetMaxX(_flagFrame) + KSLiveCellMargin;
    CGFloat matchtypefullnameY = -7;
    CGSize matchtypefullnameSize = CGSizeMake(stateX - matchtypefullnameX, 15);
    if ([_live.state isEqualToString:@"W"]) {
        matchtypefullnameSize = CGSizeMake(kSceenWidth - matchtypefullnameX, 15);
    }
    //    CGSize matchtypefullnameSize = [_live.matchtypefullname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    _matchtypefullnameFrame = (CGRect){{matchtypefullnameX,matchtypefullnameY},matchtypefullnameSize};
    
    //  主队名Frame
    CGFloat hteamnameX = KSLiveCellMargin*2;
    CGFloat hteamnameY = full_hY;
    CGSize hteamnameSize;
    if (_live.type == 0) {
        hteamnameSize = CGSizeMake(full_hX - hteamnameX - 20, 18);
    } else {
        hteamnameSize = CGSizeMake(full_hX - hteamnameX, 18);
    }
    //    CGSize hteamnameSize = [_live.hteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    _hteamnameFrame = (CGRect){{hteamnameX,hteamnameY},hteamnameSize};
    
    //  客队名Frame
    CGFloat cteamnameX = KSLiveCellMargin*2;
    CGFloat cteamnameY = full_cY;
    CGSize cteamnameSize;
    if (_live.type == 0) {
        cteamnameSize = CGSizeMake(full_cX - cteamnameX - 20, 18);
    } else {
        cteamnameSize = CGSizeMake(full_cX - cteamnameX, 18);
    }
    
    //    CGSize cteamnameSize = [_live.cteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    _cteamnameFrame = (CGRect){{cteamnameX,cteamnameY},cteamnameSize};
    
    
    if (_live.type == 0) {
        //  中立场Frame   neutralgreen
        
        CGSize hSize = [_live.hteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        if ([_live.neutralgreen isEqualToString:@"Y"]) {
            CGFloat neutralgreenX = hSize.width + KSLiveCellMargin*3;
            CGFloat neutralgreenY = CGRectGetMaxY(_starttimeFrame) + KSLiveCellMargin;
            CGSize neutralgreenSize = CGSizeMake(25, 15);
            //            CGSize neutralgreenSize = [_live.neutralgreen sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            _neutralgreenFrame = (CGRect){{neutralgreenX,neutralgreenY},neutralgreenSize};
        }
        
        //  主队红牌Frame
        CGFloat rcard_hX;
        if ([_live.neutralgreen isEqualToString:@"Y"]) {
            rcard_hX = hSize.width + 35 + KSLiveCellMargin;
        } else {
            rcard_hX = hSize.width + KSLiveCellMargin*3;
        }
        CGFloat rcard_hY = CGRectGetMaxY(_starttimeFrame) + KSLiveCellMargin;
        CGSize rcard_hSize = CGSizeMake(10, 15);
        //    CGSize rcard_hSize = [_live.rcard_h sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _rcard_hFrame = (CGRect){{rcard_hX,rcard_hY},rcard_hSize};
        
        
        //  客队红牌Frame
        
        CGSize cSize = [_live.cteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        CGFloat rcard_cX = cSize.width + KSLiveCellMargin*3;
        CGFloat rcard_cY = CGRectGetMaxY(_hteamnameFrame) + KSLiveCellMargin;
        CGSize rcard_cSize = CGSizeMake(10, 15);
        //    CGSize rcard_cSize = [_live.rcard_c sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        _rcard_cFrame = (CGRect){{rcard_cX,rcard_cY},rcard_cSize};
        
        
    }
    
    
    
    //  关注按钮Frame
    //    CGFloat forceBtnX = kSceenWidth - 45;
    //    CGFloat forceBtnY = KSLiveCellMargin;
    //    CGFloat forceBtnWH = 35;
    //    _forceBtnFrame = CGRectMake(forceBtnX, forceBtnY, forceBtnWH, forceBtnWH);
    //
    //    //  更多展开按钮Frame
    //    CGFloat moreBtnX = kSceenWidth - 45;
    //    CGFloat moreBtnY = KSLiveCellMargin;
    //    CGFloat moreBtnWH = 35;
    //    _forceBtnFrame = CGRectMake(moreBtnX, moreBtnY, moreBtnWH, moreBtnWH);
    
    
    // 即时比分的frame
    CGFloat liveX = 0;
    CGFloat liveY = 10;
    CGFloat liveW = kSceenWidth;
    CGFloat liveH;
    liveH = CGRectGetMaxY(_hteamnameFrame) + KSLiveCellMargin;
    //        liveH = CGRectGetMaxY(_cteamnameFrame) + KSLiveCellMargin;
    _liveViewFrame = CGRectMake(liveX, liveY, liveW, liveH);
    
#pragma mark 篮球和网球展开frame
    
    // 主队总分Frame
    CGFloat total_hX = kSceenWidth/2 - 30;
    CGFloat total_hY = liveY + liveH;
    CGSize total_hSize = CGSizeMake(30, 15);
    _total_hFrame = (CGRect){{total_hX,total_hY},total_hSize};
    
    //  客队总分Frame
    CGFloat total_cX = kSceenWidth/2;
    CGFloat total_cY = total_hY;
    CGSize total_cSize = CGSizeMake(30, 15);
    _total_cFrame = (CGRect){{total_cX,total_cY},total_cSize};
    
    
    
    CGFloat hteamname2X = 10;
    CGFloat hteamname2Y = total_hY;
    //    CGSize hteamname2Size = [_live.hteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGSize hteamname2Size = CGSizeMake(total_hX - 10, 15);
    
    if (_live.type != 0) { // 足球中间有比分，篮球和网球没有
        hteamname2Size = CGSizeMake(kSceenWidth/2-15, 15);
    }
    _hteamname2Frame = (CGRect){{hteamname2X,hteamname2Y},hteamname2Size};
    
    //    CGSize cteamname2Size = [_live.cteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGSize cteamname2Size = CGSizeMake(kSceenWidth - CGRectGetMaxX(_total_cFrame), 15);
    if (_live.type != 0) { // 足球中间有比分，篮球和网球没有
        cteamname2Size = CGSizeMake(kSceenWidth/2-15, 15);
    }
    CGFloat cteamname2X = kSceenWidth - cteamname2Size.width - 5;
    CGFloat cteamname2Y = hteamname2Y;
    _cteamname2Frame = (CGRect){{cteamname2X,cteamname2Y},cteamname2Size};
    
    if (_live.isDouble) {
        
        CGFloat hteamname_2X = 10;
        CGFloat hteamname_2Y = 15;
        //        CGSize hteamname_2Size = [_live.hteamname_2 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _hteamname_2Frame = (CGRect){{hteamname_2X,hteamname_2Y},hteamname2Size};
        
        //        CGSize cteamname_2Size = [_live.cteamname_2 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        CGFloat cteamname_2X = cteamname2X;//kSceenWidth/ 2 + 20;
        CGFloat cteamname_2Y = hteamname_2Y;
        CGSize cteamname_2Size = CGSizeMake(kSceenWidth/2 - 15, 15);
        _cteamname_2Frame = (CGRect){{cteamname_2X,cteamname_2Y},cteamname_2Size};
    }
    //    CGFloat hteamnameX = 10;
    //    CGFloat hteamnameY = 10;
    //    //    CGSize hteamnameSize = [_live.hteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    //    CGSize hteamnameSize = CGSizeMake(total_hX - 10, 15);
    //    _hteamnameFrame = (CGRect){{hteamnameX,hteamnameY},hteamnameSize};
    //
    //
    //    //    CGSize cteamnameSize = [_live.cteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    //    CGSize cteamnameSize = CGSizeMake(kSceenWidth - CGRectGetMaxX(_total_cFrame), 15);
    //    CGFloat cteamnameX = kSceenWidth - cteamnameSize.width - 10;
    //    CGFloat cteamnameY = CGRectGetMaxX(_cteamnameFrame) -10;
    //    _cteamnameFrame = (CGRect){{cteamnameX,cteamnameY},cteamnameSize};
    
    if (_live.hascourts == 4) {
        CGFloat st1X = kSceenWidth/2 - 40;
        CGFloat st1Y = CGRectGetMaxY(_hteamname2Frame) + 5;
        CGSize st1Size = CGSizeMake(80, 15);
        _st1Frame = (CGRect){{st1X,st1Y},st1Size};
        
        CGFloat st2X = kSceenWidth/2 - 40;
        CGFloat st2Y = CGRectGetMaxY(_st1Frame) + 5;
        CGSize st2Size = CGSizeMake(80, 15);
        _st2Frame = (CGRect){{st2X,st2Y},st2Size};
        
        CGFloat halfSX = kSceenWidth/2 - 40;
        CGFloat halfSY = CGRectGetMaxY(_st2Frame) + 5;
        CGSize halfSSize = CGSizeMake(80, 15);
        _halfSFrame = (CGRect){{halfSX,halfSY},halfSSize};
        
        CGFloat st3X = kSceenWidth/2 - 40;
        CGFloat st3Y = CGRectGetMaxY(_halfSFrame) + 5;
        CGSize st3Size = CGSizeMake(80, 15);
        _st3Frame = (CGRect){{st3X,st3Y},st3Size};
        
        CGFloat st4X = kSceenWidth/2 - 40;
        CGFloat st4Y = CGRectGetMaxY(_st3Frame) + 5;
        CGSize st4Size = CGSizeMake(80, 15);
        _st4Frame = (CGRect){{st4X,st4Y},st4Size};
        
        CGFloat halfXX = kSceenWidth/2 - 40;
        CGFloat halfXY = CGRectGetMaxY(_st4Frame) + 5;
        CGSize halfXSize = CGSizeMake(80, 15);
        _halfXFrame = (CGRect){{halfXX,halfXY},halfXSize};
        

        
    } else if (_live.hascourts == 2) {
        CGFloat halfSX = kSceenWidth/2 - 40;
        CGFloat halfSY = CGRectGetMaxY(_hteamname2Frame) + 5;
        CGSize halfSSize = CGSizeMake(80, 15);
        _halfSFrame = (CGRect){{halfSX,halfSY},halfSSize};
        
        CGFloat halfXX = kSceenWidth/2 - 40;
        CGFloat halfXY = CGRectGetMaxY(_halfSFrame) + 5;
        CGSize halfXSize = CGSizeMake(80, 15);
        _halfXFrame = (CGRect){{halfXX,halfXY},halfXSize};
        
        
    } else if (_live.type == 2) {
        CGFloat st1X = kSceenWidth/2 - 40;
        CGFloat st1Y = CGRectGetMaxY(_hteamname2Frame) + 5;
        CGSize st1Size = CGSizeMake(80, 15);
        _st1Frame = (CGRect){{st1X,st1Y},st1Size};
        
        CGFloat st2X = kSceenWidth/2 - 40;
        CGFloat st2Y = CGRectGetMaxY(_st1Frame) + 5;
        CGSize st2Size = CGSizeMake(80, 15);
        _st2Frame = (CGRect){{st2X,st2Y},st2Size};
        
        CGFloat halfSX = kSceenWidth/2 - 40;
        CGFloat halfSY = CGRectGetMaxY(_st2Frame) + 5;
        CGSize halfSSize = CGSizeMake(80, 15);
        _halfSFrame = (CGRect){{halfSX,halfSY},halfSSize};
        
        CGFloat st3X = kSceenWidth/2 - 40;
        CGFloat st3Y = CGRectGetMaxY(_halfSFrame) + 5;
        CGSize st3Size = CGSizeMake(80, 15);
        _st3Frame = (CGRect){{st3X,st3Y},st3Size};
        
        CGFloat st4X = kSceenWidth/2 - 40;
        CGFloat st4Y = CGRectGetMaxY(_st3Frame) + 5;
        CGSize st4Size = CGSizeMake(80, 15);
        _st4Frame = (CGRect){{st4X,st4Y},st4Size};
        
        CGFloat halfXX = kSceenWidth/2 - 40;
        CGFloat halfXY = CGRectGetMaxY(_st4Frame) + 5;
        CGSize halfXSize = CGSizeMake(80, 15);
        _halfXFrame = (CGRect){{halfXX,halfXY},halfXSize};
    }
    
//    CGFloat expansionX = 0;
//    CGFloat expansionY = 10;
//    CGFloat expansionW = kSceenWidth;
//    CGFloat expansionH = CGRectGetMaxY(_half_cXFrame) + KSLiveCellMargin;
//    //        liveH = CGRectGetMaxY(_cteamnameFrame) + KSLiveCellMargin;
//    _expansionViewFrame = CGRectMake(expansionX, expansionY, expansionW, expansionH);
    
}




// 比分之外更多数据frame
- (void)setUpMoreViewFrame
{
    
    CGFloat moreX = KSLiveCellMargin;
    CGFloat moreY = CGRectGetMaxY(_liveViewFrame) + KSLiveCellMargin;
    CGFloat moreW = kSceenWidth;
    CGFloat moreH = (KSLiveCellMargin + CGRectGetMaxY(_cteamnameFrame)) * _more.count;
    
    _moreViewFrame = CGRectMake(moreX, moreY, moreW, moreH);
    
}


#pragma mark    篮球展开数据
//- (void)setUpBasketballExpansionFrame
//{
//    CGFloat hteamname2X = 10;
//    CGFloat hteamname2Y = CGRectGetMaxY(_cteamnameFrame) + 5;
//    CGSize hteamname2Size = [_live.hteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    _hteamname2Frame = (CGRect){{hteamname2X,hteamname2Y},hteamname2Size};
//
//
//    CGSize cteamname2Size = [_live.cteamname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    CGFloat cteamname2X = kSceenWidth - cteamname2Size.width - 10;
//    CGFloat cteamname2Y = hteamname2Y;
//    _cteamname2Frame = (CGRect){{cteamname2X,cteamname2Y},cteamname2Size};
//
//    //  主队总分Frame
//    CGFloat total_hX = kSceenWidth/2 - 30;
//    CGFloat total_hY = hteamname2Y;
//    CGSize total_hSize = CGSizeMake(30, 15);
//    _total_hFrame = (CGRect){{total_hX,total_hY},total_hSize};
//
//    //  客队总分Frame
//    CGFloat total_cX = kSceenWidth/2;
//    CGFloat total_cY = hteamname2Y;
//    CGSize total_cSize = CGSizeMake(30, 15);
//    _total_cFrame = (CGRect){{total_cX,total_cY},total_cSize};
//
//
//
//    if (_live.hascourts == 4) {
//        CGFloat st1_hX = kSceenWidth/2 - 30;
//        CGFloat st1_hY = CGRectGetMaxY(_total_hFrame) + 5;
//        CGSize st1_hSize = CGSizeMake(30, 15);
//        _st1_hFrame = (CGRect){{st1_hX,st1_hY},st1_hSize};
//
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
//    } else if (_live.hascourts == 2) {
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
//        
//    }
//}
@end
