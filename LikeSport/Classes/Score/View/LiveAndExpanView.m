//
//  LiveAndExpanView.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/13.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "LiveAndExpanView.h"
#import "KSLiveAndExpansionFrame.h"
#import "KSLive.h"

@interface LiveAndExpanView()
// 状态
@property (nonatomic,weak) UILabel *stateView;

// 国旗
@property (weak, nonatomic) UIImageView *flagView;


// 赛事全名
@property (nonatomic,weak) UILabel *matchtypefullnameView;

// 开赛时间
@property (nonatomic,weak) UILabel *starttimeView;

// 半场时间
@property (nonatomic,weak) UILabel *halfcourttimeView;

// 主队名
@property (nonatomic,weak) UILabel *hteamnameView;

// 客队名
@property (nonatomic,weak) UILabel *cteamnameView;

// 主队得分
@property (nonatomic,weak) UILabel *full_hView;

// 客队得分
@property (nonatomic,weak) UILabel *full_cView;

// 主队红牌
@property (nonatomic,weak) UILabel *rcard_hView;

// 客队红牌
@property (nonatomic,weak) UILabel *rcard_cView;

// 中立场
@property (nonatomic,weak) UILabel *neutralgreenView;


//// 关注按钮
//@property (nonatomic,weak) UIButton *forceBtn;
//
//// 展开按钮
//@property (weak, nonatomic) UIButton *moreBtn;



// 展开部分
// 主队名
@property (nonatomic,weak) UILabel *hteamname1View;

// 客队名
@property (nonatomic,weak) UILabel *cteamname1View;
// 主队名
@property (nonatomic,weak) UILabel *hteamname2View;

// 客队名
@property (nonatomic,weak) UILabel *cteamname2View;

@property (nonatomic,weak) UILabel *total_hView;
@property (nonatomic,weak) UILabel *total_cView;
@property (nonatomic,weak) UILabel *st1View;
@property (nonatomic,weak) UILabel *st2View;
@property (nonatomic,weak) UILabel *st3View;
@property (nonatomic,weak) UILabel *st4View;
@property (nonatomic,weak) UILabel *halfSView;
@property (nonatomic,weak) UILabel *halfXView;

@property (weak, nonatomic) UILabel *fullLabel;
@property (weak, nonatomic) UILabel *halfSLabel;
@property (weak, nonatomic) UILabel *halfXLabel;
@property (weak, nonatomic) UILabel *quarter1Label;
@property (weak, nonatomic) UILabel *quarter2Label;
@property (weak, nonatomic) UILabel *quarter3Label;
@property (weak, nonatomic) UILabel *quarter4Label;

//@property (nonatomic,weak) UILabel *hteamname2View;
//@property (nonatomic,weak) UILabel *cteamname2View;
//
//@property (nonatomic,weak) UILabel *total_hView;
//@property (nonatomic,weak) UILabel *total_cView;
//@property (nonatomic,weak) UILabel *st1_hView;
//@property (nonatomic,weak) UILabel *st1_cView;
//@property (nonatomic,weak) UILabel *st2_hView;
//@property (nonatomic,weak) UILabel *st2_cView;
//@property (nonatomic,weak) UILabel *half_hSView;
//@property (nonatomic,weak) UILabel *half_cSView;
//@property (nonatomic,weak) UILabel *st3_hView;
//@property (nonatomic,weak) UILabel *st3_cView;
//@property (nonatomic,weak) UILabel *st4_hView;
//@property (nonatomic,weak) UILabel *st4_cView;
//@property (nonatomic,weak) UILabel *half_hXView;
//@property (nonatomic,weak) UILabel *half_cXView;
//@property (weak, nonatomic) UILabel *quarter1;
//@property (weak, nonatomic) UILabel *quarter2;
//@property (weak, nonatomic) UILabel *half;
//@property (weak, nonatomic) UILabel *quarter3;
//@property (weak, nonatomic) UILabel *quarter4;
//@property (weak, nonatomic) UILabel *half2;

@end

@implementation LiveAndExpanView

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
    // 开赛时间
    UILabel *starttimeView = [[UILabel alloc] init];
    starttimeView.font = [UIFont systemFontOfSize:13];
    starttimeView.textColor = KSBlue;//[UIColor lightGrayColor];
    [self addSubview:starttimeView];
    _starttimeView = starttimeView;
    
    // 国旗
    UIImageView *flagView = [[UIImageView alloc] init];
    //    flagView.image = [UIImage imageNamed:@"icon1"];
    //    NSString *flag = @"icon1";
    //    flagView.image = [UIImage imageNamed:flag];
    
    [self addSubview:flagView];
    _flagView = flagView;
    
    // 赛事全名
    UILabel *matchtypefullnameView = [[UILabel alloc] init];
    matchtypefullnameView.font = [UIFont systemFontOfSize:13];
    matchtypefullnameView.textColor = KSBlue;//[UIColor darkGrayColor];
    [self addSubview:matchtypefullnameView];
    _matchtypefullnameView = matchtypefullnameView;
    
    // 进程
    UILabel *stateView = [[UILabel alloc] init];
    stateView.font = [UIFont systemFontOfSize:14];
    stateView.textAlignment = NSTextAlignmentCenter;
    stateView.textColor = [UIColor darkGrayColor];
    [self addSubview:stateView];
    _stateView = stateView;
    
    // 半场时间
    UILabel *halfcourttimeView = [[UILabel alloc] init];
    halfcourttimeView.font = [UIFont systemFontOfSize:13];
    halfcourttimeView.textAlignment = NSTextAlignmentCenter;
    halfcourttimeView.textColor = [UIColor orangeColor];
    [self addSubview:halfcourttimeView];
    _halfcourttimeView = halfcourttimeView;
    
    // 主队名
    UILabel *hteamnameView = [[UILabel alloc] init];
    hteamnameView.font = [UIFont systemFontOfSize:15];
    [self addSubview:hteamnameView];
    _hteamnameView = hteamnameView;
    
    // 客队名
    UILabel *cteamnameView = [[UILabel alloc] init];
    cteamnameView.font = [UIFont systemFontOfSize:15];
    [self addSubview:cteamnameView];
    _cteamnameView = cteamnameView;
    
    // 主队得分
    UILabel *full_hView = [[UILabel alloc] init];
    full_hView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    full_hView.textAlignment = NSTextAlignmentCenter;
    full_hView.textColor = [UIColor blueColor];
    [self addSubview:full_hView];
    _full_hView = full_hView;
    
    // 客队得分
    UILabel *full_cView = [[UILabel alloc] init];
    full_cView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    full_cView.textAlignment = NSTextAlignmentCenter;
    full_hView.textColor = [UIColor blueColor];
    [self addSubview:full_cView];
    _full_cView = full_cView;
    
    // 主队红牌
    UILabel *rcard_hView = [[UILabel alloc] init];
    rcard_hView.font = [UIFont systemFontOfSize:15];
    rcard_hView.textColor = [UIColor whiteColor];
    rcard_hView.textAlignment = NSTextAlignmentCenter;
    rcard_hView.backgroundColor = [UIColor blackColor];
    [self addSubview:rcard_hView];
    _rcard_hView = rcard_hView;
    
    // 客队红牌
    UILabel *rcard_cView = [[UILabel alloc] init];
    rcard_cView.font = [UIFont systemFontOfSize:15];
    rcard_cView.textColor = [UIColor whiteColor];
    rcard_cView.textAlignment = NSTextAlignmentCenter;
    rcard_cView.backgroundColor = [UIColor yellowColor];
    [self addSubview:rcard_cView];
    _rcard_cView = rcard_cView;
    
    // 中立场
    UILabel *neutralgreenView = [[UILabel alloc] init];
    neutralgreenView.font = [UIFont systemFontOfSize:13];
    neutralgreenView.textColor = [UIColor orangeColor];
    [self addSubview:neutralgreenView];
    _neutralgreenView = neutralgreenView;
    
    // 关注按钮
    //    UIButton *forceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    forceBtn.frame = CGRectMake(kSceenWidth - 40, -7, 40, 40);
    ////    [forceBtn addTarget:self action:@selector(didClickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [forceBtn setTitle:@"展开" forState:UIControlStateNormal];
    //    [forceBtn setTitle:@"关闭" forState:UIControlStateHighlighted];
    //    [self addSubview:forceBtn];
    //    [forceBtn setBackgroundImage:baseGreen forState:UIControlStateNormal];
    //    [forceBtn setBackgroundImage:altGreen forState:UIControlStateHighlighted];
    
    // 展开按钮
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setTitle:@"展开" forState:UIControlStateNormal];
    [moreBtn setTitle:@"关闭" forState:UIControlStateHighlighted];
    //    [forceBtn setBackgroundImage:baseGreen forState:UIControlStateNormal];
    //    [forceBtn setBackgroundImage:altGreen forState:UIControlStateHighlighted];
    
    // 主队名1
    UILabel *hteamname1View = [[UILabel alloc] init];
    hteamname1View.font = [UIFont systemFontOfSize:14];
    [self addSubview:hteamname1View];
    _hteamname1View = hteamname1View;
    
    // 客队名1
    UILabel *cteamname1View = [[UILabel alloc] init];
    cteamname1View.font = [UIFont systemFontOfSize:14];
    cteamname1View.textAlignment = NSTextAlignmentRight;
    [self addSubview:cteamname1View];
    _cteamname1View = cteamname1View;
    
    // 主队名2
    UILabel *hteamname2View = [[UILabel alloc] init];
    hteamname2View.font = [UIFont systemFontOfSize:15];
    [self addSubview:hteamname2View];
    _hteamname2View = hteamname2View;
    
    // 客队名2
    UILabel *cteamname2View = [[UILabel alloc] init];
    cteamname2View.font = [UIFont systemFontOfSize:15];
    [self addSubview:cteamname2View];
    _cteamname2View = cteamname2View;
    
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

}

- (void)setLiveF:(KSLiveAndExpansionFrame *)liveF
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
    // 开赛时间
    // 根据本地时区更改时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//[NSTimeZone timeZoneWithName:@"shanghai"];
    //    if ([dateFormatter.timeZone isDaylightSavingTime]) {
    //        NSLog(@"有夏令时");
    //    }
    
    if (live.isMatch || live.isFollowView) {
        if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        } else {
            [dateFormatter setDateFormat:@"dd/MM HH:mm"];
        }
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:live.starttime];
    NSString *date = [dateFormatter stringFromDate:theday];
    _starttimeView.text = date;
    
    //    if ([live.tsigncode isEqualToString:@"fifa"]) {
    //        _flagView.image = [UIImage imageNamed:@"2"];
    //    } else {
    //        _flagView.image = [UIImage imageNamed:live.tsigncode];
    //    }
    _flagView.image = [UIImage imageNamed:live.tsigncode];
    
    
    // 赛事名称
    _matchtypefullnameView.text = live.matchtypefullname;
    
    // 状态
    if ([live.state isEqualToString:@"J"] || [live.state isEqualToString:@"1"] || [live.state isEqualToString:@"2"] || [live.state isEqualToString:@"3"] || [live.state isEqualToString:@"4"]) {
        if (live.type == 1) {
            _halfcourttimeView.text = live.matchjs;
        } else if (live.type == 2) {
            _halfcourttimeView.text = nil;
        }
        
    }
    
    // 主队名
    if (live.isDouble) {
        _hteamnameView.text = [NSString stringWithFormat:@"%@/%@",live.hteamname,live.hteamname_2];
        _cteamnameView.text = [NSString stringWithFormat:@"%@/%@",live.cteamname,live.cteamname_2];
        
    } else {
        _hteamnameView.text = live.hteamname;
        // 客队名
        _cteamnameView.text = live.cteamname;
    }
    
    
    
    
    
    // 半场时间
    _halfcourttimeView.hidden = YES;
    NSString *theString = live.state;
    NSArray *items = @[@"W",@"S",@"Z",@"X",@"J",@"F",@"D",@"Y",@"T",@"Q",@"C",@"R",@"E"];
    NSInteger item = [items indexOfObject:theString];
    switch (item) {
        case 0:
            _stateView.text = @"";// NSLocalizedStringFromTable(@"Not", @"InfoPlist", nil)
            //            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Wei", @"InfoPlist", nil)];
            break;
        case 1:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"1st", @"InfoPlist", nil)];
            if (live.realstarttime > live.halfcourttime) {
                _halfcourttimeView.text = [NSString stringWithFormat:@"%ld'+",(long)live.halfcourttime];
            } else {
                _halfcourttimeView.text = [NSString stringWithFormat:@"%ld'",(long)live.realstarttime];
            }
            _halfcourttimeView.hidden = NO;
            break;
        case 2:
            
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"HT", @"InfoPlist", nil)];
            break;
        case 3:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"2nd", @"InfoPlist", nil)];

            if (live.realstarttime > live.halfcourttime) {
                if (live.halfcourttime == 0) {
                    _halfcourttimeView.text = @"90'+";
                } else {
                    _halfcourttimeView.text = [NSString stringWithFormat:@"%ld'+",(long)live.halfcourttime*2];
                }
            } else {
                NSInteger haf = live.realstarttime + live.halfcourttime;
                _halfcourttimeView.text = [NSString stringWithFormat:@"%ld'",(long)haf];
            }
            _halfcourttimeView.hidden = NO;
            break;
        case 4:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"ET", @"InfoPlist", nil)];
            break;
        case 5:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil)];
            
            break;
        case 6:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil)];
            break;
        case 7:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil)];
            break;
        case 8:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil)];
            break;
        case 9:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil)];
            break;
        case 10:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil)];
            break;
        case 11:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Withdraw", @"InfoPlist", nil)];
            if ([live.winer isEqualToString:@"H"]) {
                [self setDeleteName:live.cteamname withLabel:_cteamnameView];
            } else if ([live.winer isEqualToString:@"C"] && live.type == 2) {
                [self setDeleteName:live.hteamname withLabel:_hteamnameView];
            }
            break;
        case 12:
            _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Suspended", @"InfoPlist", nil)];
            break;
        default:
            break;
    }
    
    _stateView.textAlignment = NSTextAlignmentCenter;
    //    if (live.type == 2) {
    //        _stateView.textAlignment = NSTextAlignmentLeft;
    //    }
    // 篮球时间状态
    NSInteger sta = [live.state integerValue];
    switch (sta) {
        case 1:
            if (live.type == 1) {
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil)];
                _halfcourttimeView.text = live.matchjs;
                _halfcourttimeView.hidden = NO;
                
            } else if (live.type == 2){
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil)];
                if (live.type == 2) {
                    _stateView.textAlignment = NSTextAlignmentLeft;
                }
                
            }
            break;
        case 2:
            if (live.type == 1) {
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil)];
                _halfcourttimeView.text = live.matchjs;
                _halfcourttimeView.hidden = NO;
                
            } else if (live.type == 2){
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil)];
                if (live.type == 2) {
                    _stateView.textAlignment = NSTextAlignmentLeft;
                }
            }
            break;
        case 3:
            if (live.type == 1) {
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil)];
                _halfcourttimeView.text = live.matchjs;
                _halfcourttimeView.hidden = NO;
                
            } else if (live.type == 2){
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil)];
                if (live.type == 2) {
                    _stateView.textAlignment = NSTextAlignmentLeft;
                }
            }
            break;
        case 4:
            if (live.type == 1) {
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil)];
                _halfcourttimeView.text = live.matchjs;
                _halfcourttimeView.hidden = NO;
                
            } else if (live.type == 2){
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil)];
                if (live.type == 2) {
                    _stateView.textAlignment = NSTextAlignmentLeft;
                }
            }
            break;
        case 5:
            if (live.type == 2){
                _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil)];
                if (live.type == 2) {
                    _stateView.textAlignment = NSTextAlignmentLeft;
                }
            }
        default:
            break;
    }
    
    // 中立场
    if ([live.neutralgreen isEqualToString:@"Y"]) {
        _neutralgreenView.text = NSLocalizedStringFromTable(@"[N]", @"InfoPlist", nil);
    }
    
    // 主队红牌
    if (live.rcard_h > 0) {
        _rcard_hView.backgroundColor = [UIColor redColor];
        _rcard_hView.text = [NSString stringWithFormat:@"%li",(long)live.rcard_h];
        _rcard_hView.hidden = NO;
    } else {
        _rcard_hView.hidden = YES;
    }
    
    // 客队红牌
    if (live.rcard_c > 0) {
        _rcard_cView.backgroundColor = [UIColor redColor];
        _rcard_cView.text = [NSString stringWithFormat:@"%li",(long)live.rcard_c];
        _rcard_cView.hidden = NO;
    } else {
        _rcard_cView.hidden = YES;
    }
    
    // 主队得分
    _full_hView.text = [NSString stringWithFormat:@"%li",(long)live.total_h];
    
    // 客队得分
    _full_cView.text = [NSString stringWithFormat:@"%li",(long)live.total_c];
    
    if ([live.state isEqualToString:@"W"] || [live.state isEqualToString:@"T"] || [live.state isEqualToString:@"Q"] || [live.state isEqualToString:@"C"] || [live.state isEqualToString:@"Y"] || [live.state isEqualToString:@"D"]) {
        _full_hView.hidden = YES;
        _full_cView.hidden = YES;
    } else {
        _full_hView.hidden = NO;
        _full_cView.hidden = NO;
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    NSLog(@"time%f--%li",time,live.timeH);
    if (time - live.timeH < 20) {
        _full_hView.textColor = [UIColor orangeColor];
        
    } else {
        _full_hView.textColor = [UIColor colorWithRed:0/255.0 green:124/255.0 blue:226/255.0 alpha:1];
        
    }
    
    if (time - live.timeC < 20) {
        _full_cView.textColor = [UIColor orangeColor];
        
    } else {
        _full_cView.textColor = [UIColor colorWithRed:0/255.0 green:124/255.0 blue:226/255.0 alpha:1];
        
    }

}

- (void)setUpExpanData {
    KSLive *live = _liveF.live;
    if (live.type != 0 && !live.isDouble) {

    }
    
    if (live.isDouble) {
        
        _hteamname1View.text = live.hteamname;
        _cteamname1View.text = live.cteamname;
        _hteamname2View.text = live.hteamname_2;
        _cteamname2View.text = live.cteamname_2;
    } else {
        // 主队名
        _hteamnameView.text = live.hteamname;
        // 客队名
        _cteamnameView.text = live.cteamname;
    }
    
    if (live.type == 1) {
        
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
        
    }
    
    
    
    //    _fullLabel.text = @"全场";
    _quarter1Label.text = NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil);
    _quarter2Label.text = NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil);
    _halfSLabel.text = NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
    _quarter3Label.text = NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil);
    _quarter4Label.text = NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil);
    _halfXLabel.text = NSLocalizedStringFromTable(@"2nd Half", @"InfoPlist", nil);
    
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
            
            
        } else {
//            _st1_hView.hidden = NO;
//            _st1_cView.hidden = NO;
            _quarter1Label.hidden = NO;
            _quarter1Label.text = NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil);
            _quarter2Label.text = NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil);
            _halfSLabel.text = NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil);
            _quarter3Label.text = NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil);
            _quarter4Label.text = NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil);
            _halfXLabel.text = @"";
            _halfXLabel.hidden = YES;

            
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
            
 
        }
        
        
        
        if (live.hascourts == 3) {
            if (live.isDouble) {
                _quarter4Label.hidden = YES;
                _halfXLabel.hidden = YES;
//                _st4_hView.hidden = YES;
//                _st4_cView.hidden = YES;
//                _half_hXView.hidden = YES;
//                _half_cXView.hidden = YES;
            } else {
//                _st3_hView.hidden = YES;
//                _st3_cView.hidden = YES;
                _quarter3Label.hidden = YES;
                _quarter4Label.hidden = YES;
                _halfXLabel.hidden = YES;
//                _st4_hView.hidden = YES;
//                _st4_cView.hidden = YES;
//                _half_hXView.hidden = YES;
//                _half_cXView.hidden = YES;
            }
        } else {
//            _st3_hView.hidden = NO;
//            _st3_cView.hidden = NO;
            _quarter3Label.hidden = NO;
            _quarter4Label.hidden = NO;
            _halfXLabel.hidden = NO;
//            _st4_hView.hidden = NO;
//            _st4_cView.hidden = NO;
//            _half_hXView.hidden = NO;
//            _half_cXView.hidden = NO;
        }
    }

}

- (void)setUpFrame
{
    _starttimeView.frame = _liveF.starttimeFrame;
    
    _flagView.frame = _liveF.flagFrame;
    
    _matchtypefullnameView.frame = _liveF.matchtypefullnameFrame;
    
    _stateView.frame = _liveF.stateFrame;
    
    _halfcourttimeView.frame = _liveF.halfcourttimeFrame;
    
    _hteamnameView.frame = _liveF.hteamnameFrame;
    
    _cteamnameView.frame = _liveF.cteamnameFrame;
    
    _neutralgreenView.frame = _liveF.neutralgreenFrame;
    
    _rcard_hView.frame = _liveF.rcard_hFrame;
    
    _rcard_cView.frame = _liveF.rcard_cFrame;
    
    _full_hView.frame = _liveF.full_hFrame;
    
    _full_cView.frame = _liveF.full_cFrame;
    
}

- (void)setUpExpanFrame{
    if ([_liveF.live.state isEqualToString:@"W"]) {
        
    }
    _hteamname1View.frame = _liveF.hteamname2Frame;
    _cteamname1View.frame = _liveF.cteamname2Frame;
    _hteamname2View.frame = _liveF.hteamname_2Frame;
    _cteamname2View.frame = _liveF.cteamname_2Frame;
    _total_hView.frame = _liveF.total_hFrame;
    _total_cView.frame = _liveF.total_cFrame;
    _st1View.frame = _liveF.st1Frame;
    _st2View.frame = _liveF.st2Frame;
    _st3View.frame = _liveF.st3Frame;
    _st4View.frame = _liveF.st4Frame;
    _halfSView.frame = _liveF.halfSFrame;
    _halfXView.frame = _liveF.halfXFrame;
    
//    _st1_hView.frame = _liveF.st1_hFrame;
//    _st1_cView.frame = _liveF.st1_cFrame;
//    _st2_hView.frame = _liveF.st2_hFrame;
//    _st2_cView.frame = _liveF.st2_cFrame;
//    _half_hSView.frame = _liveF.half_hSFrame;
//    _half_cSView.frame = _liveF.half_cSFrame;
//    _st3_hView.frame = _liveF.st3_hFrame;
//    _st3_cView.frame = _liveF.st3_cFrame;
//    _st4_hView.frame = _liveF.st4_hFrame;
//    _st4_cView.frame = _liveF.st4_cFrame;
//    _half_hXView.frame = _liveF.half_hXFrame;
//    _half_cXView.frame = _liveF.half_cXFrame;
    
    CGFloat labelX = kSceenWidth/2 + 30;
    //    CGFloat labelX = kSceenWidth - 60;
    
    //    _fullLabel.frame = CGRectMake(labelX, -5, 45, 15);
    _halfSLabel.frame = CGRectMake(labelX, _liveF.halfSFrame.origin.y, 60, 15);
    _halfXLabel.frame = CGRectMake(labelX, _liveF.halfXFrame.origin.y, 60, 15);
    if (_liveF.live.type == 1) {
        if (_liveF.live.hascourts != 2) {
            _halfSView.textColor = [UIColor grayColor];
            _halfXView.textColor = [UIColor grayColor];
            _halfSLabel.textColor = [UIColor grayColor];
            _halfXLabel.textColor = [UIColor grayColor];
            _quarter1Label.frame = CGRectMake(labelX, _liveF.st1Frame.origin.y, 60, 15);
            _quarter2Label.frame = CGRectMake(labelX, _liveF.st2Frame.origin.y, 60, 15);
            _quarter3Label.frame = CGRectMake(labelX, _liveF.st3Frame.origin.y, 60, 15);
            _quarter4Label.frame = CGRectMake(labelX, _liveF.st4Frame.origin.y, 60, 15);
            if (_liveF.live.st2_h == -1) {
                _quarter2Label.frame = CGRectZero;
                _quarter3Label.frame = CGRectZero;
                _quarter4Label.frame = CGRectZero;
                _halfSLabel.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
            } else if (_liveF.live.st3_h == -1) {
                _quarter3Label.frame = CGRectZero;
                _quarter4Label.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
            } else if (_liveF.live.st4_h == -1) {
                _quarter4Label.frame = CGRectZero;
                _halfXLabel.frame = CGRectZero;
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
        
        if (_liveF.live.st2_h == -1) {
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


- (void)setDeleteName:(NSString *)name withLabel:(UILabel *)label
{
    NSUInteger length = [name length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:name];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, length)];
    [label setAttributedText:attri];
}

// 得分变色
- (void)changeColor {
    _full_hView.textColor = [UIColor blackColor];
    _full_cView.textColor = [UIColor blackColor];
    
}

@end
