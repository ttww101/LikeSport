//
//  KSExpansionView.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/10.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSExpansionView.h"
#import "KSLiveFrame.h"
#import "KSLive.h"


@interface KSExpansionView()
@property (nonatomic,weak) UILabel *hteamnameView;
@property (nonatomic,weak) UILabel *cteamnameView;
@property (nonatomic,weak) UILabel *hteamname_2View;
@property (nonatomic,weak) UILabel *cteamname_2View;
@property (nonatomic,weak) UILabel *total_hView;
@property (nonatomic,weak) UILabel *total_cView;
@property (nonatomic,weak) UILabel *st1View;
@property (nonatomic,weak) UILabel *st2View;
@property (nonatomic,weak) UILabel *st3View;
@property (nonatomic,weak) UILabel *st4View;
@property (nonatomic,weak) UILabel *halfSView;
@property (nonatomic,weak) UILabel *halfXView;


@property (nonatomic,weak) UILabel *st1_hView;
@property (nonatomic,weak) UILabel *st1_cView;
@property (nonatomic,weak) UILabel *st2_hView;
@property (nonatomic,weak) UILabel *st2_cView;
@property (nonatomic,weak) UILabel *half_hSView;
@property (nonatomic,weak) UILabel *half_cSView;
@property (nonatomic,weak) UILabel *st3_hView;
@property (nonatomic,weak) UILabel *st3_cView;
@property (nonatomic,weak) UILabel *st4_hView;
@property (nonatomic,weak) UILabel *st4_cView;
@property (nonatomic,weak) UILabel *half_hXView;
@property (nonatomic,weak) UILabel *half_cXView;
@property (nonatomic,weak) UILabel *otView;


@property (weak, nonatomic) UILabel *fullLabel;
@property (weak, nonatomic) UILabel *halfSLabel;
@property (weak, nonatomic) UILabel *halfXLabel;
@property (weak, nonatomic) UILabel *quarter1Label;
@property (weak, nonatomic) UILabel *quarter2Label;
@property (weak, nonatomic) UILabel *quarter3Label;
@property (weak, nonatomic) UILabel *quarter4Label;
@property (weak, nonatomic) UILabel *otLabel;

@end

@implementation KSExpansionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加所有子控件
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

// 添加所有子控件
- (void)setUpAllChildView
{
    // 主队名
    UILabel *hteamnameView = [[UILabel alloc] init];
    hteamnameView.font = [UIFont systemFontOfSize:14];
    [self addSubview:hteamnameView];
    _hteamnameView = hteamnameView;
    
    // 客队名
    UILabel *cteamnameView = [[UILabel alloc] init];
    cteamnameView.font = [UIFont systemFontOfSize:14];
    cteamnameView.textAlignment = NSTextAlignmentRight;
    [self addSubview:cteamnameView];
    _cteamnameView = cteamnameView;
    
    // 主队名
    UILabel *hteamname_2View = [[UILabel alloc] init];
    hteamname_2View.font = [UIFont systemFontOfSize:14];
    [self addSubview:hteamname_2View];
    _hteamname_2View = hteamname_2View;
    
    // 客队名
    UILabel *cteamname_2View = [[UILabel alloc] init];
    cteamname_2View.font = [UIFont systemFontOfSize:14];
    cteamname_2View.textAlignment = NSTextAlignmentRight;
    [self addSubview:cteamname_2View];
    _cteamname_2View = cteamname_2View;

    // 主队得分
    UILabel *total_hView = [[UILabel alloc] init];
    total_hView.font = [UIFont systemFontOfSize:14];
    total_hView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:total_hView];
    _total_hView = total_hView;
    
    // 客队得分
    UILabel *total_cView = [[UILabel alloc] init];
    total_cView.font = [UIFont systemFontOfSize:14];
    total_cView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:total_cView];
    _total_cView = total_cView;
    
    UILabel *st1View = [[UILabel alloc] init];
    st1View.font = [UIFont systemFontOfSize:14];
    st1View.textAlignment = NSTextAlignmentCenter;
    [self addSubview:st1View];
    _st1View = st1View;
    
    UILabel *st2View = [[UILabel alloc] init];
    st2View.font = [UIFont systemFontOfSize:14];
    st2View.textAlignment = NSTextAlignmentCenter;
    [self addSubview:st2View];
    _st2View = st2View;
    
    UILabel *st3View = [[UILabel alloc] init];
    st3View.font = [UIFont systemFontOfSize:14];
    st3View.textAlignment = NSTextAlignmentCenter;
    [self addSubview:st3View];
    _st3View = st3View;
    
    UILabel *st4View = [[UILabel alloc] init];
    st4View.font = [UIFont systemFontOfSize:14];
    st4View.textAlignment = NSTextAlignmentCenter;
    [self addSubview:st4View];
    _st4View = st4View;
    
    UILabel *halfSView = [[UILabel alloc] init];
    halfSView.font = [UIFont systemFontOfSize:14];
    halfSView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:halfSView];
    _halfSView = halfSView;

    UILabel *halfXView = [[UILabel alloc] init];
    halfXView.font = [UIFont systemFontOfSize:14];
    halfXView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:halfXView];
    _halfXView = halfXView;
    
    UILabel *otView = [[UILabel alloc] init];
    otView.font = [UIFont systemFontOfSize:14];
    otView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:otView];
    _otView = otView;
    
//    UILabel *st1_hView = [[UILabel alloc] init];
//    st1_hView.font = [UIFont systemFontOfSize:14];
//    st1_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st1_hView];
//    _st1_hView = st1_hView;
//    
//    UILabel *st1_cView = [[UILabel alloc] init];
//    st1_cView.font = [UIFont systemFontOfSize:14];
//    st1_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st1_cView];
//    _st1_cView = st1_cView;
//    
//
//    
//    UILabel *st2_hView = [[UILabel alloc] init];
//    st2_hView.font = [UIFont systemFontOfSize:14];
//    st2_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st2_hView];
//    _st2_hView = st2_hView;
//    
//    UILabel *st2_cView = [[UILabel alloc] init];
//    st2_cView.font = [UIFont systemFontOfSize:14];
//    st2_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st2_cView];
//    _st2_cView = st2_cView;
//    
//
//    
////    if (_liveF.live.type == 1) {
////        UIView *halfView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, kSceenWidth, 20)];
////        halfView.backgroundColor = [UIColor lightGrayColor];
////        [self addSubview:halfView];
////    }
//    
//    UILabel *half_hSView = [[UILabel alloc] init];
//    half_hSView.font = [UIFont systemFontOfSize:14];
//    half_hSView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_hSView];
//    _half_hSView = half_hSView;
//    
//    UILabel *half_cSView = [[UILabel alloc] init];
//    half_cSView.font = [UIFont systemFontOfSize:14];
//    half_cSView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_cSView];
//    _half_cSView = half_cSView;
//    
//
//    
//    UILabel *st3_hView = [[UILabel alloc] init];
//    st3_hView.font = [UIFont systemFontOfSize:14];
//    st3_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st3_hView];
//    _st3_hView = st3_hView;
//    
//    UILabel *st3_cView = [[UILabel alloc] init];
//    st3_cView.font = [UIFont systemFontOfSize:14];
//    st3_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st3_cView];
//    _st3_cView = st3_cView;
//    
//    
//    
//    UILabel *st4_hView = [[UILabel alloc] init];
//    st4_hView.font = [UIFont systemFontOfSize:14];
//    st4_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st4_hView];
//    _st4_hView = st4_hView;
//    
//    UILabel *st4_cView = [[UILabel alloc] init];
//    st4_cView.font = [UIFont systemFontOfSize:14];
//    st4_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st4_cView];
//    _st4_cView = st4_cView;
//    
//   
//    
//    
//    UILabel *half_hXView = [[UILabel alloc] init];
//    half_hXView.font = [UIFont systemFontOfSize:14];
//    half_hXView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_hXView];
//    _half_hXView = half_hXView;
//    
//    UILabel *half_cXView = [[UILabel alloc] init];
//    half_cXView.font = [UIFont systemFontOfSize:14];
//    half_cXView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_cXView];
//    _half_cXView = half_cXView;
    
    


    UILabel *fullLabel = [[UILabel alloc] init];
    fullLabel.font = [UIFont systemFontOfSize:13];
    fullLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:fullLabel];
    _fullLabel = fullLabel;
    
    UILabel *quarter1Label = [[UILabel alloc] init];
    quarter1Label.font = [UIFont systemFontOfSize:13];
    quarter1Label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:quarter1Label];
    _quarter1Label = quarter1Label;
    
    UILabel *quarter2Label = [[UILabel alloc] init];
    quarter2Label.font = [UIFont systemFontOfSize:13];
    quarter2Label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:quarter2Label];
    _quarter2Label = quarter2Label;
    
    UILabel *halfSLabel = [[UILabel alloc] init];
    halfSLabel.font = [UIFont systemFontOfSize:13];
    halfSLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:halfSLabel];
    _halfSLabel = halfSLabel;
    
    UILabel *quarter3Label = [[UILabel alloc] init];
    quarter3Label.font = [UIFont systemFontOfSize:13];
    quarter3Label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:quarter3Label];
    _quarter3Label = quarter3Label;
    
    UILabel *quarter4Label = [[UILabel alloc] init];
    quarter4Label.font = [UIFont systemFontOfSize:13];
    quarter4Label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:quarter4Label];
    _quarter4Label = quarter4Label;
    
    UILabel *halfXLabel = [[UILabel alloc] init];
    halfXLabel.font = [UIFont systemFontOfSize:13];
    halfXLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:halfXLabel];
    _halfXLabel = halfXLabel;
    
    UILabel *otLabel = [[UILabel alloc] init];
    otLabel.font = [UIFont systemFontOfSize:13];
    otLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:otLabel];
    _otLabel = otLabel;

}

- (void)setLiveF:(KSLiveFrame *)liveF
{
    _liveF = liveF;
    
    // 设置frame
    [self setUpFrame];
    
    // 设置frame
    [self setUpData];
}

- (void)setUpData
{
    KSLive *live = _liveF.live;
    if (live.type != 0 && !live.isDouble) {
//        CGFloat h = 11;
//        for (int i = 1; i < 4; i++) {
//            UILabel *st1 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, h, 10, 20)];
//            st1.font = [UIFont systemFontOfSize:14];
//            st1.textAlignment = NSTextAlignmentCenter;
//            st1.text = @"-";
//            [self addSubview:st1];
//        }
        
        
//        UILabel *st1 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 11, 10, 20)];
//        st1.font = [UIFont systemFontOfSize:14];
//        st1.textAlignment = NSTextAlignmentCenter;
//        st1.text = @"-";
//        [self addSubview:st1];
//        
//        UILabel *st2 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 31, 10, 20)];
//        st2.font = [UIFont systemFontOfSize:14];
//        st2.textAlignment = NSTextAlignmentCenter;
//        st2.text = @"-";
//        [self addSubview:st2];
//        
//        UILabel *half = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 51, 10, 20)];
//        half.font = [UIFont systemFontOfSize:14];
//        half.textAlignment = NSTextAlignmentCenter;
//        half.text = @"-";
//        [self addSubview:half];
    }
    
//    if (live.type == 1) {
//        UILabel *st3 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 71, 10, 20)];
//        st3.font = [UIFont systemFontOfSize:14];
//        st3.textAlignment = NSTextAlignmentCenter;
//        st3.text = @"-";
//        [self addSubview:st3];
//        
//        UILabel *st4 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 91, 10, 20)];
//        st4.font = [UIFont systemFontOfSize:14];
//        st4.textAlignment = NSTextAlignmentCenter;
//        st4.text = @"-";
//        [self addSubview:st4];
//        
//        UILabel *halfX = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 111, 10, 20)];
//        halfX.font = [UIFont systemFontOfSize:14];
//        halfX.textAlignment = NSTextAlignmentCenter;
//        halfX.text = @"-";
//        [self addSubview:halfX];
//    }
    
    if (live.isDouble) {
//        UILabel *st1 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 71, 10, 20)];
//        st1.font = [UIFont systemFontOfSize:14];
//        st1.textAlignment = NSTextAlignmentCenter;
//        st1.text = @"-";
//        [self addSubview:st1];
//        
//        UILabel *st2 = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 31, 10, 20)];
//        st2.font = [UIFont systemFontOfSize:14];
//        st2.textAlignment = NSTextAlignmentCenter;
//        st2.text = @"-";
//        [self addSubview:st2];
//        
//        UILabel *half = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 51, 10, 20)];
//        half.font = [UIFont systemFontOfSize:14];
//        half.textAlignment = NSTextAlignmentCenter;
//        half.text = @"-";
//        [self addSubview:half];

        
        _hteamnameView.text = live.hteamname;
        _cteamnameView.text = live.cteamname;
        _hteamname_2View.text = live.hteamname_2;
        _cteamname_2View.text = live.cteamname_2;
    } else {
        // 主队名
        _hteamnameView.text = live.hteamname;
        // 客队名
        _cteamnameView.text = live.cteamname;
    }
    
    if (live.type == 1) {
    
//        if (live.total_h == -1) {
//            _total_hView.text = @"-";
//        } else {
//            _total_hView.text = [NSString stringWithFormat:@"%li",(long)live.total_h];
//        }
//        
//        if (live.total_c == -1) {
//            _total_cView.text = @"-";
//
//        } else {
//            _total_cView.text = [NSString stringWithFormat:@"%li",(long)live.total_c];
//
//        }
        
        if (live.st1_h != -1 && live.st1_c != -1) {
            _st1View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st1_h,(long)live.st1_c];
        }
        
        if (live.st2_h != -1 && live.st2_c != -1) {
            _st2View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st2_h,(long)live.st2_c];
        }
        
        if (live.st3_h != -1 && live.st3_c != -1) {
            _st3View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st3_h,(long)live.st3_c];
        }
        
        if (live.st4_h != -1 && live.st4_c != -1) {
            _st4View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st4_h,(long)live.st4_c];
        }
        
        if (live.ot_h != -1 && live.ot_c != -1) {
            _otView.text = [NSString stringWithFormat:@"%li - %li",(long)live.ot_h,(long)live.ot_c];
        }
        
        NSInteger half_hS = (long)live.st1_h + (long)live.st2_h;
        NSInteger half_cS = (long)live.st1_c + (long)live.st2_c;
//        NSLog(@"half %i -- %i",half_cS,half_hS);
        if (live.st1_h != -1 && live.st2_h != -1 && live.st1_c != -1 && live.st2_c != -1) {
            _halfSView.text = [NSString stringWithFormat:@"%li - %li",(long)half_hS,(long)half_cS];
        }
        
        NSInteger half_hX = (long)live.st3_h + (long)live.st4_h;
        NSInteger half_cX = (long)live.st3_c + (long)live.st4_c;
        if (live.st3_h != -1 && live.st4_h != -1 && live.st3_c != -1 && live.st4_c != -1) {
            _halfXView.text = [NSString stringWithFormat:@"%li - %li",(long)half_hX,(long)half_cX];
        }
        
        if (live.hascourts == 2) {
            _halfSView.text = [NSString stringWithFormat:@"%li - %li",(long)live.st1_h,(long)live.st1_c];
            _halfXView.text = [NSString stringWithFormat:@"%li - %li",(long)live.st3_h,(long)live.st3_c];
        }
        
        
        
        
//        if (live.st1_h == -1) {
//            _st1_hView.text = @"";
//
//        } else {
//            _st1_hView.text = [NSString stringWithFormat:@"%li",(long)live.st1_h];
//
//        }
//        
//        if (live.st1_c == -1) {
//            _st1_cView.text = @"";
//
//        } else {
//            _st1_cView.text = [NSString stringWithFormat:@"%li",(long)live.st1_c];
//
//        }
//        
//        if (live.st2_h == -1) {
//            _st2_hView.text = @"";
//
//        } else {
//            _st2_hView.text = [NSString stringWithFormat:@"%li",(long)live.st2_h];
//
//        }
//        
//        if (live.st2_c == -1) {
//            _st2_cView.text = @"";
//
//        } else {
//            _st2_cView.text = [NSString stringWithFormat:@"%li",(long)live.st2_c];
//
//        }
//        
//        
//        NSInteger half_hS = (long)live.st1_h + (long)live.st2_h;
//        if (live.st1_h != -1 && live.st2_h != -1) {
//            _half_hSView.text = [NSString stringWithFormat:@"%li",(long)half_hS];
//        } else {
//            _half_hSView.text = @"";
//        }
//        
//        
//        NSInteger half_cS = (long)live.st1_c + (long)live.st2_c;
//        if (live.st1_c != -1 && live.st2_c != -1) {
//            _half_cSView.text = [NSString stringWithFormat:@"%li",(long)half_cS];
//        } else {
//            _half_cSView.text = @"";
//        }
//        
//        if (live.st3_h == -1) {
//            _st3_hView.text = @"";
//
//        } else {
//            _st3_hView.text = [NSString stringWithFormat:@"%li",(long)live.st3_h];
//
//        }
//        
//        if (live.st3_c == -1) {
//            _st3_cView.text = @"";
//
//        } else {
//            _st3_cView.text = [NSString stringWithFormat:@"%li",(long)live.st3_c];
//
//        }
//        
//        if (live.st4_h == -1) {
//            _st4_hView.text = @"";
//
//        } else {
//            _st4_hView.text = [NSString stringWithFormat:@"%li",(long)live.st4_h];
//
//        }
//        
//        if (live.st4_c == -1) {
//            _st4_cView.text = @"";
//
//        } else {
//            _st4_cView.text = [NSString stringWithFormat:@"%li",(long)live.st4_c];
//
//        }
//        
//        NSInteger half_hX = (long)live.st3_h + (long)live.st4_h;
//        if (live.st3_h != -1 && live.st4_h != -1) {
//            _half_hXView.text = [NSString stringWithFormat:@"%li",(long)half_hX];
//        } else {
//            _half_hXView.text = @"";
//        }
//        
//        NSInteger half_cX = (long)live.st3_c + (long)live.st4_c;
//        if (live.st3_c != -1 && live.st4_c != -1) {
//            _half_cXView.text = [NSString stringWithFormat:@"%li",(long)half_cX];
//        } else {
//            _half_cXView.text = @"";
//        }
    
    }
    

    
//    _fullLabel.text = @"全场";
    _quarter1Label.text = NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil);
    _quarter2Label.text = NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil);
    _halfSLabel.text = NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
    _quarter3Label.text = NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil);
    _quarter4Label.text = NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil);
    _halfXLabel.text = NSLocalizedStringFromTable(@"2nd Half", @"InfoPlist", nil);
    _otLabel.text = NSLocalizedStringFromTable(@"ET", @"InfoPlist", nil);

    _halfXLabel.hidden = NO;
    
    
#pragma mark 网球展开部分
    if (live.type == 2) {
        if (live.isDouble) {
            _quarter1Label.hidden = YES;
            _quarter2Label.text = NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil);
            _halfSLabel.text = NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil);
            _quarter3Label.text = NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil);
            _quarter4Label.text = NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil);
            _halfXLabel.text = NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil);
//            if (live.total_h >= 0) {
//                _total_hView.text = [NSString stringWithFormat:@"%li",(long)live.total_h];
//            } else {
//                _total_hView.text = @"";
//            }
//            
//            if (live.total_c >= 0) {
//                _total_cView.text = [NSString stringWithFormat:@"%li",(long)live.total_c];
//            } else {
//                _total_cView.text = @"";
//            }
            
//            _st1_hView.hidden = YES;
//            _st1_cView.hidden = YES;
            _st1View.hidden = YES;
            if (live.st1_h != -1 && live.st1_c != -1) {
                _st2View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st1_h,(long)live.st1_c];
            }
            
            if (live.st2_h != -1 && live.st2_c != -1) {
                _halfSView.text = [NSString stringWithFormat:@"%li - %li",(long)live.st2_h,(long)live.st2_c];
            }
            
            if (live.st3_h != -1 && live.st3_c != -1) {
                _st3View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st3_h,(long)live.st3_c];
            }
            
            if (live.st4_h != -1 && live.st4_c != -1) {
                _st4View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st4_h,(long)live.st4_c];
            }
            
            if (live.st5_h != -1 && live.st5_c != -1) {
                _halfXView.text = [NSString stringWithFormat:@"%li - %li",(long)live.st5_h,(long)live.st5_c];
            }
            
            
            
//            if (live.st1_h >= 0) {
//                _st2_hView.text = [NSString stringWithFormat:@"%li",(long)live.st1_h];
//            } else {
//                _st2_hView.text = @"";
//            }
//            
//            if (live.st1_c >= 0) {
//                _st2_cView.text = [NSString stringWithFormat:@"%li",(long)live.st1_c];
//            } else {
//                _st2_cView.text = @"";
//            }
//            
//            
//            if (live.st2_h >= 0) {
//                _half_hSView.text = [NSString stringWithFormat:@"%li",(long)live.st2_h];
//            } else {
//                _half_hSView.text = @"";
//            }
//            
//            
//            if (live.st2_c >= 0) {
//                _half_cSView.text = [NSString stringWithFormat:@"%li",(long)live.st2_c];
//            } else {
//                _half_cSView.text = @"";
//            }
//            
//            if (live.st3_h >= 0) {
//                _st3_hView.text = [NSString stringWithFormat:@"%li",(long)live.st3_h];
//            } else {
//                _st3_hView.text = @"";
//            }
//            
//            if (live.st3_c >= 0) {
//                _st3_cView.text = [NSString stringWithFormat:@"%li",(long)live.st3_c];
//            } else {
//                _st3_cView.text = @"";
//            }
//            
//            if (live.st4_h >= 0) {
//                _st4_hView.text = [NSString stringWithFormat:@"%li",(long)live.st4_h];
//            } else {
//                _st4_hView.text = @"";
//            }
//            
//            if (live.st4_c >= 0) {
//                _st4_cView.text = [NSString stringWithFormat:@"%li",(long)live.st4_c];
//            } else {
//                _st4_cView.text = @"";
//            }
            
        } else {
            _st1_hView.hidden = NO;
            _st1_cView.hidden = NO;
            _quarter1Label.hidden = NO;
            _quarter1Label.text = NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil);
            _quarter2Label.text = NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil);
            _halfSLabel.text = NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil);
            _quarter3Label.text = NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil);
            _quarter4Label.text = NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil);
            _halfXLabel.text = @"";
            _halfXLabel.hidden = YES;
//            if (live.total_h >= 0) {
//                _total_hView.text = [NSString stringWithFormat:@"%li",(long)live.total_h];
//            } else {
//                _total_hView.text = @"";
//            }
//            
//            if (live.total_c >= 0) {
//                _total_cView.text = [NSString stringWithFormat:@"%li",(long)live.total_c];
//            } else {
//                _total_cView.text = @"";
//            }
            
            if (live.st1_h != -1 && live.st1_c != -1) {
                _st1View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st1_h,(long)live.st1_c];
            }
            
            if (live.st2_h != -1 && live.st2_c != -1) {
                _st2View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st2_h,(long)live.st2_c];
            }
            
            if (live.st3_h != -1 && live.st3_c != -1) {
                _halfSView.text = [NSString stringWithFormat:@"%li - %li",(long)live.st3_h,(long)live.st3_c];
            }
            
            if (live.st4_h != -1 && live.st4_c != -1) {
                _st3View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st4_h,(long)live.st4_c];
            }
            
            if (live.st5_h != -1 && live.st5_c != -1) {
                _st4View.text = [NSString stringWithFormat:@"%li - %li",(long)live.st5_h,(long)live.st5_c];
            }
            
//            if (live.st1_h >= 0) {
//                _st1_hView.text = [NSString stringWithFormat:@"%li",(long)live.st1_h];
//            } else {
//                _st1_hView.text = @"";
//            }
//            
//            if (live.st1_c >= 0) {
//                _st1_cView.text = [NSString stringWithFormat:@"%li",(long)live.st1_c];
//            } else {
//                _st1_cView.text = @"";
//            }
//            
//            if (live.st2_h >= 0) {
//                _st2_hView.text = [NSString stringWithFormat:@"%li",(long)live.st2_h];
//            } else {
//                _st2_hView.text = @"";
//            }
//            
//            if (live.st2_c >= 0) {
//                _st2_cView.text = [NSString stringWithFormat:@"%li",(long)live.st2_c];
//            } else {
//                _st2_cView.text = @"";
//            }
//            
//            
//            if (live.st3_h >= 0) {
//                _half_hSView.text = [NSString stringWithFormat:@"%li",(long)live.st3_h];
//            } else {
//                _half_hSView.text = @"";
//            }
//            
//            
//            if (live.st3_c >= 0) {
//                _half_cSView.text = [NSString stringWithFormat:@"%li",(long)live.st3_c];
//            } else {
//                _half_cSView.text = @"";
//            }
//            
//            if (live.st4_h >= 0) {
//                _st3_hView.text = [NSString stringWithFormat:@"%li",(long)live.st4_h];
//            } else {
//                _st3_hView.text = @"";
//            }
//            
//            if (live.st4_c >= 0) {
//                _st3_cView.text = [NSString stringWithFormat:@"%li",(long)live.st4_c];
//            } else {
//                _st3_cView.text = @"";
//            }
//            
//            if (live.st5_h >= 0) {
//                _st4_hView.text = [NSString stringWithFormat:@"%li",(long)live.st5_h];
//            } else {
//                _st4_hView.text = @"";
//            }
//            
//            if (live.st5_c >= 0) {
//                _st4_cView.text = [NSString stringWithFormat:@"%li",(long)live.st5_c];
//            } else {
//                _st4_cView.text = @"";
//            }
        }
        
        
        
        if (live.hascourts == 3) {
            if (live.isDouble) {
                _quarter4Label.hidden = YES;
                _halfXLabel.hidden = YES;
                _st4_hView.hidden = YES;
                _st4_cView.hidden = YES;
                _half_hXView.hidden = YES;
                _half_cXView.hidden = YES;
            } else {
                _st3_hView.hidden = YES;
                _st3_cView.hidden = YES;
                _quarter3Label.hidden = YES;
                _quarter4Label.hidden = YES;
                _halfXLabel.hidden = YES;
                _st4_hView.hidden = YES;
                _st4_cView.hidden = YES;
                _half_hXView.hidden = YES;
                _half_cXView.hidden = YES;
            }
        } else {
            _st3_hView.hidden = NO;
            _st3_cView.hidden = NO;
            _quarter3Label.hidden = NO;
            _quarter4Label.hidden = NO;
            _halfXLabel.hidden = NO;
            _st4_hView.hidden = NO;
            _st4_cView.hidden = NO;
            _half_hXView.hidden = NO;
            _half_cXView.hidden = NO;
        }
        }
//    if (live.isOpen) {
//        _hteamnameView.hidden = NO;
//        _cteamnameView.hidden = NO;
//        _total_hView.hidden = NO;
//        _total_cView.hidden = NO;
//        _st1_hView.hidden = NO;
//        _st1_cView.hidden = NO;
//        _st2_hView.hidden = NO;
//        _st2_cView.hidden = NO;
//        _half_hSView.hidden = NO;
//        _half_cSView.hidden = NO;
//        _st3_hView.hidden = NO;
//        _st3_cView.hidden = NO;
//        _st4_hView.hidden = NO;
//        _st4_cView.hidden = NO;
//        _half_hXView.hidden = NO;
//        _half_cXView.hidden = NO;
//    } else {
//        _hteamnameView.hidden = YES;
//        _cteamnameView.hidden = YES;
//        _total_hView.hidden = YES;
//        _total_cView.hidden = YES;
//        _st1_hView.hidden = YES;
//        _st1_cView.hidden = YES;
//        _st2_hView.hidden = YES;
//        _st2_cView.hidden = YES;
//        _half_hSView.hidden = YES;
//        _half_cSView.hidden = YES;
//        _st3_hView.hidden = YES;
//        _st3_cView.hidden = YES;
//        _st4_hView.hidden = YES;
//        _st4_cView.hidden = YES;
//        _half_hXView.hidden = YES;
//        _half_cXView.hidden = YES;
//        
//    }
    

}

- (void)setUpFrame
{
    if ([_liveF.live.state isEqualToString:@"W"]) {
        
    }
    _hteamnameView.frame = _liveF.hteamname2Frame;
    _cteamnameView.frame = _liveF.cteamname2Frame;
    _hteamname_2View.frame = _liveF.hteamname_2Frame;
    _cteamname_2View.frame = _liveF.cteamname_2Frame;
    _total_hView.frame = _liveF.total_hFrame;
    _total_cView.frame = _liveF.total_cFrame;
    _st1View.frame = _liveF.st1Frame;
    _st2View.frame = _liveF.st2Frame;
    _st3View.frame = _liveF.st3Frame;
    _st4View.frame = _liveF.st4Frame;
    _halfSView.frame = _liveF.halfSFrame;
    _halfXView.frame = _liveF.halfXFrame;
    _otView.frame = _liveF.otFrame;
    
    _st1_hView.frame = _liveF.st1_hFrame;
    _st1_cView.frame = _liveF.st1_cFrame;
    _st2_hView.frame = _liveF.st2_hFrame;
    _st2_cView.frame = _liveF.st2_cFrame;
    _half_hSView.frame = _liveF.half_hSFrame;
    _half_cSView.frame = _liveF.half_cSFrame;
    _st3_hView.frame = _liveF.st3_hFrame;
    _st3_cView.frame = _liveF.st3_cFrame;
    _st4_hView.frame = _liveF.st4_hFrame;
    _st4_cView.frame = _liveF.st4_cFrame;
    _half_hXView.frame = _liveF.half_hXFrame;
    _half_cXView.frame = _liveF.half_cXFrame;
    
    CGFloat labelX = kSceenWidth/2 + 30;
//    CGFloat labelX = kSceenWidth - 60;

//    _fullLabel.frame = CGRectMake(labelX, -5, 45, 15);
    _halfSLabel.frame = CGRectMake(labelX, _liveF.halfSFrame.origin.y, 60, 15);
    _halfXLabel.frame = CGRectMake(labelX, _liveF.halfXFrame.origin.y, 60, 15);
    if (_liveF.live.type == 1) {

        if (_liveF.live.hascourts != 2) { // 4节赛制
            _halfSView.textColor = [UIColor grayColor];
            _halfXView.textColor = [UIColor grayColor];
            _halfSLabel.textColor = [UIColor grayColor];
            _halfXLabel.textColor = [UIColor grayColor];
            _quarter1Label.frame = CGRectMake(labelX, _liveF.st1Frame.origin.y, 60, 15);
            _quarter2Label.frame = CGRectMake(labelX, _liveF.st2Frame.origin.y, 60, 15);
            _quarter3Label.frame = CGRectMake(labelX, _liveF.st3Frame.origin.y, 60, 15);
            _quarter4Label.frame = CGRectMake(labelX, _liveF.st4Frame.origin.y, 60, 15);
            if (_liveF.live.st1_h == -1) {
                _quarter1Label.frame = CGRectZero;
                _quarter2Label.frame = CGRectZero;
                _quarter3Label.frame = CGRectZero;
                _quarter4Label.frame = CGRectZero;
                _halfSLabel.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
            } else if (_liveF.live.st2_h == -1) {
                _quarter2Label.frame = CGRectZero;
                _quarter3Label.frame = CGRectZero;
                _quarter4Label.frame = CGRectZero;
                _halfSLabel.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
//                _otLabel.frame = CGRectZero;
            } else if (_liveF.live.st3_h == -1) {
                _quarter3Label.frame = CGRectZero;
                _quarter4Label.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
//                _otLabel.frame = CGRectZero;
            } else if (_liveF.live.st4_h == -1) {
                _quarter4Label.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
//                _otLabel.frame = CGRectZero;
            } else if (_liveF.live.ot_h != -1){
                _otLabel.frame = CGRectMake(labelX, _liveF.otFrame.origin.y, 60, 15);

            }
        }  else {
            _quarter1Label.frame = CGRectZero;
            _quarter2Label.frame = CGRectZero;
            _quarter3Label.frame = CGRectZero;
            _quarter4Label.frame = CGRectZero;
        }
    }else if (_liveF.live.type == 2) {
//        _quarter1Label.text = NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil);
//        _quarter2Label.text = NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil);
//        _halfSLabel.text = NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil);
//        _quarter3Label.text = NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil);
//        _quarter4Label.text = NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil);

//        if (_liveF.live.isDouble) {
            _quarter1Label.frame = CGRectMake(labelX, _liveF.st1Frame.origin.y, 60, 15);
            _quarter2Label.frame = CGRectMake(labelX, _liveF.st2Frame.origin.y, 60, 15);
            _halfSLabel.frame = CGRectMake(labelX, _liveF.halfSFrame.origin.y, 60, 15);
            _quarter3Label.frame = CGRectMake(labelX, _liveF.st3Frame.origin.y, 60, 15);
            _quarter4Label.frame = CGRectMake(labelX, _liveF.st4Frame.origin.y, 60, 15);
            _halfXLabel.frame = CGRectMake(labelX, _liveF.halfXFrame.origin.y, 60, 15);
            
//        }  else {
//            _quarter1Label.frame = CGRectMake(labelX, _liveF.st1Frame.origin.y, 60, 15);
//            _quarter2Label.frame = CGRectMake(labelX, _liveF.st2Frame.origin.y, 60, 15);
//            _quarter3Label.frame = CGRectMake(labelX, _liveF.halfSFrame.origin.y, 60, 15);
//        }
        if (_liveF.live.st1_h == -1) {
            if (!_liveF.live.isDouble) {
                _quarter1Label.frame = CGRectZero;
            }
            _quarter2Label.frame = CGRectZero;
            _quarter3Label.frame = CGRectZero;
            _quarter4Label.frame = CGRectZero;
            _halfSLabel.frame = CGRectZero;
            _halfXLabel.frame = CGRectZero;
        }else if (_liveF.live.st2_h == -1) {
            if (!_liveF.live.isDouble) {
                _quarter2Label.frame = CGRectZero;
            }
            _quarter3Label.frame = CGRectZero;
            _quarter4Label.frame = CGRectZero;
            _halfSLabel.frame = CGRectZero;
            _halfXLabel.frame = CGRectZero;
        } else if (_liveF.live.st3_h == -1) {
            if (!_liveF.live.isDouble) {
                _halfSLabel.frame = CGRectZero;
            }
            _quarter3Label.frame = CGRectZero;
            _quarter4Label.frame = CGRectZero;
            _halfXLabel.frame = CGRectZero;
        } else if (_liveF.live.st4_h == -1) { // 第三盘正在进行
            if (!_liveF.live.isDouble) {
                _quarter3Label.frame = CGRectZero;
            }
            _quarter4Label.frame = CGRectZero;
            _halfXLabel.frame = CGRectZero;
        } else if (_liveF.live.st5_h == -1) {
            if (!_liveF.live.isDouble) {
                _quarter4Label.frame = CGRectZero;
            }
            _halfXLabel.frame = CGRectZero;
        }

    }
    
    
}

@end
