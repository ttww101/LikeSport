//
//  KSLiveView.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/26.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLiveView.h"
#import "KSLiveFrame.h"
#import "KSLive.h"
#import "KSFootballExpansion.h"
#import "KSExpansionView.h"
#import "BasketExpansionView.h"
#import "Masonry.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface KSLiveView()
@property(nonatomic,weak) KSExpansionView *expansionView;
@property (weak, nonatomic) KSFootballExpansion *footballExpansion;
@property (weak, nonatomic) BasketExpansionView *basketExpansion;

@property (assign, nonatomic) BOOL flag;

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

@property (nonatomic,weak) UILabel *hteamname2View;
@property (nonatomic,weak) UILabel *cteamname2View;

@property (nonatomic,weak) UILabel *total_hView;
@property (nonatomic,weak) UILabel *total_cView;
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
@property (weak, nonatomic) UILabel *quarter1;
@property (weak, nonatomic) UILabel *quarter2;
@property (weak, nonatomic) UILabel *half;
@property (weak, nonatomic) UILabel *quarter3;
@property (weak, nonatomic) UILabel *quarter4;
@property (weak, nonatomic) UILabel *half2;


@end

@implementation KSLiveView

-(void)setredcard:(UIColor*)color{
    [self.rcard_cView setBackgroundColor:color];
    [self.rcard_hView setBackgroundColor:color];
}
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
    [self removeFromSuperview];
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
//    NSInteger fontSize = [[self getValueWithKey:@"fontSize"] integerValue]+13;
    hteamnameView.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:hteamnameView];
    _hteamnameView = hteamnameView;
    
    // 客队名
    UILabel *cteamnameView = [[UILabel alloc] init];
    cteamnameView.font = [UIFont boldSystemFontOfSize:16];
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
    full_cView.textColor = [UIColor blueColor];
    [self addSubview:full_cView];
    _full_cView = full_cView;
    
    // 主队红牌
    UILabel *rcard_hView = [[UILabel alloc] init];
    rcard_hView.font = [UIFont systemFontOfSize:15];
    rcard_hView.textColor = [UIColor whiteColor];
    rcard_hView.textAlignment = NSTextAlignmentCenter;
    rcard_hView.backgroundColor = [UIColor redColor];
    [self addSubview:rcard_hView];
    _rcard_hView = rcard_hView;
    
    // 客队红牌
    UILabel *rcard_cView = [[UILabel alloc] init];
    rcard_cView.font = [UIFont systemFontOfSize:15];
    rcard_cView.textColor = [UIColor whiteColor];
    rcard_cView.textAlignment = NSTextAlignmentCenter;
    rcard_cView.backgroundColor = [UIColor redColor];
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
    
    // 主队名
//    UILabel *hteamname2View = [[UILabel alloc] init];
//    hteamname2View.font = [UIFont systemFontOfSize:15];
//    [self addSubview:hteamname2View];
//    _hteamnameView = hteamname2View;
//    
//    // 客队名
//    UILabel *cteamname2View = [[UILabel alloc] init];
//    cteamname2View.font = [UIFont systemFontOfSize:15];
//    [self addSubview:cteamname2View];
//    _cteamnameView = cteamname2View;
    
    // 主队得分
//    UILabel *total_hView = [[UILabel alloc] init];
//    total_hView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    total_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:total_hView];
//    _total_hView = total_hView;
//    
//    // 客队得分
//    UILabel *total_cView = [[UILabel alloc] init];
//    total_cView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    total_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:total_cView];
//    _total_cView = total_cView;
//    
//    UILabel *st1_hView = [[UILabel alloc] init];
//    st1_hView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st1_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st1_hView];
//    _st1_hView = st1_hView;
//    
//    UILabel *st1_cView = [[UILabel alloc] init];
//    st1_cView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st1_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st1_cView];
//    _st1_cView = st1_cView;
//    
//    UILabel *st2_hView = [[UILabel alloc] init];
//    st2_hView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st2_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st2_hView];
//    _st2_hView = st2_hView;
//    
//    UILabel *st2_cView = [[UILabel alloc] init];
//    st2_cView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st2_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st2_cView];
//    _st2_cView = st2_cView;
//    
//    UILabel *half_hSView = [[UILabel alloc] init];
//    half_hSView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    half_hSView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_hSView];
//    _half_hSView = half_hSView;
//    
//    UILabel *half_cSView = [[UILabel alloc] init];
//    half_cSView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    half_cSView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_cSView];
//    _half_cSView = half_cSView;
//    
//    UILabel *st3_hView = [[UILabel alloc] init];
//    st3_hView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st3_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st3_hView];
//    _st3_hView = st3_hView;
//    
//    UILabel *st3_cView = [[UILabel alloc] init];
//    st3_cView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st3_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st3_cView];
//    _st3_cView = st3_cView;
//    
//    UILabel *st4_hView = [[UILabel alloc] init];
//    st4_hView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st4_hView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st4_hView];
//    _st4_hView = st4_hView;
//    
//    UILabel *st4_cView = [[UILabel alloc] init];
//    st4_cView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    st4_cView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:st4_cView];
//    _st4_cView = st4_cView;
//    
//    UILabel *half_hXView = [[UILabel alloc] init];
//    half_hXView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    half_hXView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_hXView];
//    _half_hXView = half_hXView;
//    
//    UILabel *half_cXView = [[UILabel alloc] init];
//    half_cXView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    half_cXView.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:half_cXView];
//    _half_cXView = half_cXView;
//    if (_liveF.live.type == 0) {
    
        // 足球展开
//    KSFootballExpansion *footballExpansion = [[KSFootballExpansion alloc] init];
//    footballExpansion.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    [self addSubview:footballExpansion];
//    footballExpansion.hidden = YES;
//    _footballExpansion = footballExpansion;
////    } else {
//    KSExpansionView *expansionView = [[KSExpansionView alloc] init];
//    expansionView.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    [self addSubview:expansionView];
//    expansionView.hidden = YES;
//    _expansionView = expansionView;
//    
//    BasketExpansionView *basketExpansion = [[BasketExpansionView alloc] init];
//    basketExpansion.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    [self addSubview:basketExpansion];
//    basketExpansion.hidden = YES;
//    _basketExpansion = basketExpansion;
//    }
    self.bottonview=[[UIView alloc]initWithFrame:CGRectMake(0, self.liveF.cellHeight-0.2f, [UIScreen mainScreen].bounds.size.width,0.2f)];
    [self.bottonview setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:self.bottonview];
     [self.bottonview setHidden:YES];
    
    [self setMyLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
//    for (UIView *subview in self.subviews) {
//        [subview layoutIfNeeded];
//    }

    
}

- (void)setMyLayout {
    [_matchtypefullnameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self).offset(4);
    }];
    
    [_starttimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_matchtypefullnameView.mas_right).offset(8);
        make.centerY.equalTo(_matchtypefullnameView.mas_centerY);
    }];
    
    [_hteamnameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_matchtypefullnameView.mas_left);
        make.top.equalTo(_matchtypefullnameView.mas_bottom).offset(10);
    }];
    
    [_cteamnameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_matchtypefullnameView.mas_left);
        make.top.equalTo(_hteamnameView.mas_bottom).offset(6);
    }];
    
    [_full_hView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hteamnameView);
        make.right.equalTo(self.mas_right).offset(-50);
    }];
    
    [_full_cView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cteamnameView);
        make.right.equalTo(self.mas_right).offset(-50);
    }];
}


- (NSString *)getValueWithKey:(NSString *)key {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:key];//根据键值取出name
    return token;
}

- (void)setLiveF:(KSLiveFrame *)liveF
{
    _liveF = liveF;
    
    // 设置frame
//    [self setUpFrame];
    
    // 设置frame
    [self setUpData];

    
//    if (liveF.isExpand) {
//        if (liveF.live.type == 0) {
//            _footballExpansion.more = _liveF.live.more;
//            _footballExpansion.live = _liveF.live;
//            _footballExpansion.hidden = NO;
//        } else if (liveF.live.type == 1) {
//            _basketExpansion.frame = CGRectMake(0, 60, kSceenWidth, 60);
//            _basketExpansion.live = _liveF.live;
//            _basketExpansion.hidden = NO;
//        }else {
//            _expansionView.frame = CGRectMake(0, 65, kSceenWidth, 60);
//            _expansionView.liveF = _liveF;
//            _expansionView.hidden = NO;
//        }
//        
//    } else {
//        if (liveF.live.type == 0) {
//            _footballExpansion.hidden = YES;
//        } else {
//            _expansionView.hidden = YES;
//        }
//    }
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
    if (live.tsigncode != nil)
        _flagView.image = [UIImage imageNamed:live.tsigncode];

    
    // 赛事名称
    NSArray<UIColor *> *colors = @[UIColorFromRGB(0x236e23), UIColorFromRGB(0x1b1b1b), UIColorFromRGB(0xd5881c), UIColorFromRGB(0xef3f3f), UIColorFromRGB(0xe8e8e8), UIColorFromRGB(0xea35b0), UIColorFromRGB(0x0999aa), UIColorFromRGB(0x8b5a2b), UIColorFromRGB(0xc85e63), UIColorFromRGB(0x0999aa), UIColorFromRGB(0x924154), UIColorFromRGB(0x8f20b6), ];
    
    NSInteger hashInt = [live.matchtypefullname hash] % [colors count];
    _matchtypefullnameView.textColor = colors[hashInt];
    _matchtypefullnameView.layer.borderColor = colors[hashInt].CGColor;
    _matchtypefullnameView.layer.borderWidth = 0.7f;
    
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
//                NSInteger haf = live.realstarttime + live.halfcourttime;
//                NSLog(@"realstarttime = %i,half = %i",live.realstarttime,live.halfcourttime)
//                if (haf > live.halfcourttime*2) {
//                    _halfcourttimeView.text = [NSString stringWithFormat:@"%ld'+",(long)live.halfcourttime*2];
//                } else {
//                    _halfcourttimeView.text = [NSString stringWithFormat:@"%ld'",(long)haf];
//                }
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
    
    if (live.type == 1) { // 篮球上下半场时间状态
        _halfcourttimeView.text = live.matchjs;
        _halfcourttimeView.hidden = NO;
    }
    
    if ([live.state isEqualToString:@"J"]) { // 加时
        _stateView.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"ET", @"InfoPlist", nil)];
    }
    
    
//    _stateView.text = live.state;
//    if ([live.state isEqualToString:@"1"] || [live.state isEqualToString:@"2"] || [live.state isEqualToString:@"3"] || [live.state isEqualToString:@"4"]) {
//        _stateView.text = [NSString stringWithFormat:@"%@%@",live.state,NSLocalizedStringFromTable(@"th", @"InfoPlist", nil)];
//    }
    
    
    
    // 中立场
    if ([live.neutralgreen isEqualToString:@"Y"]) {
        _neutralgreenView.text = NSLocalizedStringFromTable(@"[N]", @"InfoPlist", nil);
    }
    
//    UIColor *redCard = [UIColor colorWithPatternImage:[UIImage imageNamed:@"redCard.png"]];
    // 主队红牌
    if (live.rcard_h > 0) {
        _rcard_hView.backgroundColor = [UIColor redColor];
//        [_rcard_hView setBackgroundColor:redCard];
        _rcard_hView.text = [NSString stringWithFormat:@"%li",(long)live.rcard_h];
        _rcard_hView.hidden = NO;
    } else {
        _rcard_hView.hidden = YES;
    }

    // 客队红牌
    if (live.rcard_c > 0) {
        _rcard_cView.backgroundColor = [UIColor redColor];
//        [_rcard_cView setBackgroundColor:redCard];
        _rcard_cView.text = [NSString stringWithFormat:@"%li",(long)live.rcard_c];
        _rcard_cView.hidden = NO;
    } else {
        _rcard_cView.hidden = YES;
    }
    
    // 主队得分
    _full_hView.text = [NSString stringWithFormat:@"%li",(long)live.total_h];
    
    // 客队得分
    _full_cView.text = [NSString stringWithFormat:@"%li",(long)live.total_c];
    
//    if ([live.state isEqualToString:@"S"] || [live.state isEqualToString:@"X"] || [live.state isEqualToString:@"1"] || [live.state isEqualToString:@"2"] || [live.state isEqualToString:@"3"] || [live.state isEqualToString:@"4"] || [live.state isEqualToString:@"F"] || [live.state isEqualToString:@"Z"] || [live.state isEqualToString:@"J"]) {
//        _full_hView.hidden = NO;
//        _full_cView.hidden = NO;
//    } else {
//        _full_hView.hidden = YES;
//        _full_cView.hidden = YES;
//    }
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
    
    
//    switch (live.type) {
//        case 0:
//            if (live.isFootH) {
//                _full_hView.textColor = [UIColor redColor];
//                [self performSelector:@selector(changeColor) withObject:nil afterDelay:15];
//            } else {
//                _full_hView.textColor = [UIColor blackColor];
//            }
//            
//            if (live.isFootC) {
//                _full_hView.textColor = [UIColor redColor];
//                [self performSelector:@selector(changeColor) withObject:nil afterDelay:30];
//            } else {
//                _full_hView.textColor = [UIColor blackColor];
//            }
//            
//            break;
//        case 1:
//            if (live.isBasH) {
//                _full_hView.textColor = [UIColor redColor];
//                [self performSelector:@selector(changeColor) withObject:nil afterDelay:15];
//            }
//            if (live.isBasC) {
//                _full_cView.textColor = [UIColor redColor];
//                [self performSelector:@selector(changeColor) withObject:nil afterDelay:30];
//            }
//            
//            break;
//        case 2:
//            if (live.isTenH) {
//                _full_hView.textColor = [UIColor redColor];
//                [self performSelector:@selector(changeColor) withObject:nil afterDelay:15];
//            }
//            if (live.isTenC) {
//                _full_cView.textColor = [UIColor redColor];
//                [self performSelector:@selector(changeColor) withObject:nil afterDelay:30];
//            }
//            
//            break;
//            
//        default:
//            break;
//    }
    
    [_matchtypefullnameView layoutIfNeeded];
    [_matchtypefullnameView setNeedsLayout];
    
}

- (void)setUpFrame
{
//    _footballExpansion.frame = CGRectMake(0, 65, kSceenWidth, 60);
    

    _starttimeView.frame = _liveF.starttimeFrame;
    
//    _flagView.frame = _liveF.flagFrame;
    
    _matchtypefullnameView.frame = _liveF.matchtypefullnameFrame;
//
//    _stateView.frame = _liveF.stateFrame;
//
//    _halfcourttimeView.frame = _liveF.halfcourttimeFrame;
//
    _hteamnameView.frame = _liveF.hteamnameFrame;

    _cteamnameView.frame = _liveF.cteamnameFrame;

//    _neutralgreenView.frame = _liveF.neutralgreenFrame;
//
//    _rcard_hView.frame = _liveF.rcard_hFrame;
//
//    _rcard_cView.frame = _liveF.rcard_cFrame;
//
    _full_hView.frame = _liveF.full_hFrame;

    _full_cView.frame = _liveF.full_cFrame;
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
