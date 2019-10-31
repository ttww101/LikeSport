//
//  AnalyseController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/20.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "AnalyseController.h"
#import "KSAnalyse.h"
#import "KSKuaiShouTool.h"
#import "KSScoreCell.h"
#import "KSLineUpCell.h"
#import "KSLiveCell.h"
#import "KSBattleCell.h"
#import "KSGroupScoreCell.h"
#import "KSGoalsCell.h"
#import "KSHalfFullCell.h"
#import "KSScoreGoalCell.h"
#import "KSSingleDoubleCell.h"
#import "KSBasketAnalyse.h"

@interface AnalyseController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *scoreArray;
@property (nonatomic, strong) NSMutableArray *sectionTitle;
@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) NSMutableArray *allType;
@property (nonatomic, strong) AnalyseResult *analyseResult;
@property (nonatomic, strong) BasketAnalyseResult *basketAnalyseResult;

@property (nonatomic, assign) NSInteger isHalf;
@property (nonatomic, assign) BOOL isHomeAway;
@property (nonatomic, assign) BOOL isHome;
@property (nonatomic, assign) BOOL isAway;
@property (nonatomic, assign) BOOL isHome10;
@property (nonatomic, assign) BOOL isAway10;

@property (nonatomic, weak) UITableView *tableView;

@property (weak, nonatomic) UILabel *label;
@property (nonatomic, assign) BOOL canceled;


@end

@implementation AnalyseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    
    if (_type == 0) {
        [self setupAnalyse];
    } else if (_type == 1) {
        [self setupBasketAnalyse];
    }
//    _isHalf = 1;
//    _isHome10 = 1;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _isHalf = 1;
}

- (void)setupBasketAnalyse {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    // Set the bar determinate mode to show task progress.
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });

    
    [KSKuaiShouTool getAnalyseType:_type withMatchID:_matchID withCompleted:^(id result) {
        KSBasketAnalyse *analyse = [KSBasketAnalyse mj_objectWithKeyValues:result];
        _basketAnalyseResult = analyse.result;
        _sectionTitle = [[NSMutableArray alloc] initWithCapacity:4];
        _allData = [[NSMutableArray alloc] initWithCapacity:4];
        _allType = [[NSMutableArray alloc] initWithCapacity:4];
        if (analyse.ret_code == 0) {
            if (analyse.result.pk_data.count != 0) { // 对赛往绩
                [_allData addObject:analyse.result.pk_data];
                [_allType addObject:@"pk_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Head to Head", @"InfoPlist", nil)];
                
            }
            
            if (analyse.result.h_result_data.count != 0) {
                if (analyse.result.h_result_data.count > 10) {
                    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
                    [_allData addObject:[analyse.result.h_result_data objectsAtIndexes:indexes]];
                } else {
                    [_allData addObject:analyse.result.h_result_data];
                }
                [_allType addObject:@"h_result_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Recent Results", @"InfoPlist", nil)];
                
            }
            
            if (analyse.result.c_result_data.count != 0) {
                if (analyse.result.c_result_data.count > 10) {
                    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
                    [_allData addObject:[analyse.result.c_result_data objectsAtIndexes:indexes]];
                } else {
                    [_allData addObject:analyse.result.c_result_data];
                }
                [_allType addObject:@"c_result_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Recent Results", @"InfoPlist", nil)];
                
            }
            
            if (analyse.result.h_fixtures_data.count != 0) {
                [_allData addObject:analyse.result.h_fixtures_data];
                [_allType addObject:@"h_fixtures_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil)];
                
            }
            
            if (analyse.result.c_fixtures_data.count != 0) {
                [_allData addObject:analyse.result.c_fixtures_data];
                [_allType addObject:@"c_fixtures_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil)];
            }
            
        }
        [_allData mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            if (_allData.count == 0) {
                self.label.hidden = NO;
            } else if (_allData.count > 0) {
                self.label.hidden = YES;
            }
            [hud hideAnimated:YES];
        });
    }failure:^(NSError *error) {
        NSLog(@"分析请求%@",error);
        self.label.text = [error localizedDescription];
    }];
}

- (void)setupAnalyse {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    // Set the bar determinate mode to show task progress.

    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });

        [KSKuaiShouTool getAnalyseType:_type withMatchID:_matchID withCompleted:^(id result) {
            
        KSAnalyse *analyse = [KSAnalyse mj_objectWithKeyValues:result];
        _analyseResult = analyse.result;
        _scoreArray = [[NSMutableArray alloc] initWithCapacity:4];
        _sectionTitle = [[NSMutableArray alloc] initWithCapacity:4];
        _allData = [[NSMutableArray alloc] initWithCapacity:4];
        _allType = [[NSMutableArray alloc] initWithCapacity:4];
        if (analyse.ret_code == 0) {
            if (analyse.result.x_score.count != 0) {
                [_allData addObject:_analyseResult.x_score];
                [_allType addObject:@"x_score"];

                [_sectionTitle addObject:_analyseResult.groupname];
            }
            
            if (analyse.result.score_full_h != nil) { //主场全场积分榜
//                [_scoreArray addObject:[self setupScore:analyse.result.score_half_h]];
//                [_scoreArray addObject:[self setupScore:analyse.result.score_half_c]];
                
                
                [_scoreArray mutableCopy];
                [_allData addObject:[self setupScore:analyse.result.score_full_h]];
                [_allType addObject:@"score_full_h"];
                [_sectionTitle addObject:analyse.result.hteamname];
            }
            
            if (analyse.result.score_full_c != nil) {
//                [_scoreArray addObject:[self setupScore:analyse.result.score_full_h]];
//                [_scoreArray addObject:[self setupScore:analyse.result.score_full_c]];
                [_allType addObject:@"score_full_c"];
                [_allData addObject:[self setupScore:analyse.result.score_full_c]];
                [_sectionTitle addObject:analyse.result.cteamname];

            }
            

            
            if (analyse.result.pk_data.count != 0) { // 对赛往绩
                [_allData addObject:analyse.result.pk_data];
                [_allType addObject:@"pk_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Head to Head", @"InfoPlist", nil)];

            }
            
            if (analyse.result.h_result_data.count != 0) {
                if (analyse.result.h_result_data.count > 10) {
                    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
                    [_allData addObject:[analyse.result.h_result_data objectsAtIndexes:indexes]];
                } else {
                    [_allData addObject:analyse.result.h_result_data];
                }
                [_allType addObject:@"h_result_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Recent Results", @"InfoPlist", nil)];

            }
            
            if (analyse.result.c_result_data.count != 0) {
                if (analyse.result.c_result_data.count > 10) {
                    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
                    [_allData addObject:[analyse.result.c_result_data objectsAtIndexes:indexes]];
                } else {
                    [_allData addObject:analyse.result.c_result_data];
                }
                [_allType addObject:@"c_result_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Recent Results", @"InfoPlist", nil)];

            }
            
            if (analyse.result.h_fixtures_data.count != 0) {
                [_allData addObject:analyse.result.h_fixtures_data];
                [_allType addObject:@"h_fixtures_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil)];

            }
            
            if (analyse.result.c_fixtures_data.count != 0) {
                [_allData addObject:analyse.result.c_fixtures_data];
                [_allType addObject:@"c_fixtures_data"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil)];
            }
            
            if ([analyse.result.reporttype rangeOfString:@"N"].location != NSNotFound) {
                [_allType addObject:@"N_h"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Goals in 1st/2nd HT", @"InfoPlist", nil)];
            }
            
            if ([analyse.result.reporttype rangeOfString:@"I"].location != NSNotFound) {
                [_allType addObject:@"I_h"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Half/Full", @"InfoPlist", nil)];
            }

            if ([analyse.result.reporttype rangeOfString:@"O"].location != NSNotFound) {
                [_allType addObject:@"O_h"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Full Goals/Single/Double", @"InfoPlist", nil)];
            }
            
            if ([analyse.result.reporttype rangeOfString:@"A"].location != NSNotFound) {
                [_allType addObject:@"A_h"];
                [_sectionTitle addObject:NSLocalizedStringFromTable(@"Team Goals", @"InfoPlist", nil)];
            }

        }
        [_sectionTitle mutableCopy];
        [_allData mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (_allData.count == 0) {
                self.label.hidden = NO;
            } else if (_allData.count > 0) {
                self.label.hidden = YES;
            }
            [hud hideAnimated:YES];
        });

    } failure:^(NSError *error) {
        hud.label.text = [error localizedDescription];
//        self.label.text = [error localizedDescription];
    }];
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}


- (NSArray *)setupScore:(Score_Full *)score{
    NSDictionary *infoDic = [NSDictionary dictionary];
    NSMutableArray *scoreArray = [[NSMutableArray alloc] initWithCapacity:10];
    infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"a",
               NSLocalizedStringFromTable(@"P", @"InfoPlist", nil),@"b",
               NSLocalizedStringFromTable(@"W", @"InfoPlist", nil),@"c",
               NSLocalizedStringFromTable(@"D", @"InfoPlist", nil),@"d",
               NSLocalizedStringFromTable(@"L", @"InfoPlist", nil),@"e",
               NSLocalizedStringFromTable(@"GF/A", @"InfoPlist", nil),@"f",
//               NSLocalizedStringFromTable(@"GA", @"InfoPlist", nil),@"g",
               NSLocalizedStringFromTable(@"DIFF", @"InfoPlist", nil),@"h",
               NSLocalizedStringFromTable(@"Points", @"InfoPlist", nil),@"i",
               NSLocalizedStringFromTable(@"Pos", @"InfoPlist", nil),@"j",
               NSLocalizedStringFromTable(@"Winrate", @"InfoPlist", nil),@"k", nil];
    [scoreArray addObject:infoDic];
    
    infoDic = [NSDictionary dictionaryWithObjectsAndKeys:
               NSLocalizedStringFromTable(@"Total", @"InfoPlist", nil),@"a",
               [NSNumber numberWithInteger:score.t_match],@"b",
               [NSNumber numberWithInteger:score.t_win],@"c",
               [NSNumber numberWithInteger:score.t_draw],@"d",
               [NSNumber numberWithInteger:score.t_loss],@"e",
               [NSString stringWithFormat:@"%li/%li",(long)score.t_entergoals,(long)score.t_missgoals],@"f",
//               [NSNumber numberWithInteger:score.t_missgoals],@"g",
               [NSNumber numberWithInteger:score.t_jinsheng],@"h",
               [NSNumber numberWithInteger:score.t_Integral],@"i",
               [NSNumber numberWithInteger:score.t_pm],@"j",
               score.t_sl,@"k",
               nil];
    [scoreArray addObject:infoDic];

    infoDic = [NSDictionary dictionaryWithObjectsAndKeys:
               NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil),@"a",
               [NSNumber numberWithInteger:score.h_match],@"b",
               [NSNumber numberWithInteger:score.h_win],@"c",
               [NSNumber numberWithInteger:score.h_draw],@"d",
               [NSNumber numberWithInteger:score.h_loss],@"e",
               [NSString stringWithFormat:@"%li/%li",(long)score.h_entergoals,(long)score.h_missgoals],@"f",
               [NSNumber numberWithInteger:score.h_jingsheng],@"h",
               [NSNumber numberWithInteger:score.h_Integral],@"i",
               [NSNumber numberWithInteger:score.h_pm],@"j",
               score.h_sl,@"k",
               nil];
    [scoreArray addObject:infoDic];
    
    infoDic = [NSDictionary dictionaryWithObjectsAndKeys:
               NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil),@"a",
               [NSNumber numberWithInteger:score.c_match],@"b",
               [NSNumber numberWithInteger:score.c_win],@"c",
               [NSNumber numberWithInteger:score.c_draw],@"d",
               [NSNumber numberWithInteger:score.c_loss],@"e",
               [NSString stringWithFormat:@"%li/%li",(long)score.c_entergoals,(long)score.c_missgoals],@"f",
               [NSNumber numberWithInteger:score.c_jingsheng],@"h",
               [NSNumber numberWithInteger:score.c_Integral],@"i",
               [NSNumber numberWithInteger:score.c_pm],@"j",
               score.c_sl,@"k",
               nil];
    [scoreArray addObject:infoDic];
    
    infoDic = [NSDictionary dictionaryWithObjectsAndKeys:
               NSLocalizedStringFromTable(@"Last6", @"InfoPlist", nil),@"a",
               [NSNumber numberWithInteger:score.j6_match],@"b",
               [NSNumber numberWithInteger:score.j6_win],@"c",
               [NSNumber numberWithInteger:score.j6_draw],@"d",
               [NSNumber numberWithInteger:score.j6_loss],@"e",
               [NSString stringWithFormat:@"%li/%li",(long)score.j6_entergoals,(long)score.j6_missgoals],@"f",
               [NSNumber numberWithInteger:score.j6_jingsheng],@"h",
               [NSNumber numberWithInteger:score.j6_Integral],@"i",
               [NSNumber numberWithInteger:score.j6_pm],@"j",
               score.j6_sl,@"k",
               nil];
    [scoreArray addObject:infoDic];
    if (scoreArray.count == 0) {
        return nil;
    }else {
        return scoreArray;
    }
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([_allType[section] isEqualToString:@"N_h"]) {
        return 1;
    }
    
    else if ([_allType[section] isEqualToString:@"I_h"]) {
        return 12;
    }
    
    else if ([_allType[section] isEqualToString:@"O_h"]) {
        return 2;
    }
    
    else if ([_allType[section] isEqualToString:@"A_h"]) {
        return 10;
    }
    
    else {
        NSArray *score = _allData[section];
        return score.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _allType.count;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_allType[indexPath.section] isEqualToString:@"score_full_h"] || [_allType[indexPath.section] isEqualToString:@"score_full_c"] || [_allType[indexPath.section] isEqualToString:@"x_score"]) {
        return 25;
    }
    else if ([_allType[indexPath.section] isEqualToString:@"N_h"]) {
        return 100;
    }
    
    else if ([_allType[indexPath.section] isEqualToString:@"I_h"] || [_allType[indexPath.section] isEqualToString:@"A_h"]) {
        return 20;
    }
    
    else if ([_allType[indexPath.section] isEqualToString:@"O_h"]) {
        return 120;
    }
    
    else {
        return 50;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_allType[section] isEqualToString:@"score_full_h"] || [_allType[section] isEqualToString:@"h_result_data"] || [_allType[section] isEqualToString:@"c_result_data"] || [_allType[section] isEqualToString:@"x_score"]) {
        return 60;
    } else if ([_allType[section] isEqualToString:@"score_full_c"]){
        return 30;
    }
    return 30;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"技术统计";
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 30)];
    NSString *sectionTitle = _sectionTitle[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,kSceenWidth-20,15)];
    label.text = sectionTitle;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
//    label.textColor = [UIColor colorWithRed:0/255.0 green:135/255.0 blue:230/255.0 alpha:1];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    
    view.backgroundColor = KSBackgroundGray;
    
    if ([_allType[section] isEqualToString:@"x_score"]) {
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        view.frame = CGRectMake(0, 0, kSceenWidth, 35);
        
        UILabel *position = [[UILabel alloc] initWithFrame:CGRectMake(2,40,30,15)];
        position.text = NSLocalizedStringFromTable(@"Pos", @"InfoPlist", nil);
        position.font = [UIFont systemFontOfSize:12];
        position.textAlignment = NSTextAlignmentCenter;
        position.textColor = [UIColor darkGrayColor];
        [view addSubview:position];
        
        UILabel *teamname = [[UILabel alloc] initWithFrame:CGRectMake(40,40,40,15)];
        teamname.text = NSLocalizedStringFromTable(@"Team", @"InfoPlist", nil);
        teamname.font = [UIFont systemFontOfSize:12];
        teamname.textAlignment = NSTextAlignmentCenter;
        teamname.textColor = [UIColor darkGrayColor];
        [view addSubview:teamname];

        
        UILabel *Integral = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-30,40,30,15)];
        Integral.text = NSLocalizedStringFromTable(@"Points", @"InfoPlist", nil);
        Integral.font = [UIFont systemFontOfSize:12];
        Integral.textAlignment = NSTextAlignmentCenter;
        Integral.textColor = [UIColor darkGrayColor];
        [view addSubview:Integral];
        
        UILabel *t_jinsheng = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-60,40,30,15)];
        t_jinsheng.text = NSLocalizedStringFromTable(@"DIFF", @"InfoPlist", nil);
        t_jinsheng.font = [UIFont systemFontOfSize:12];
        t_jinsheng.textAlignment = NSTextAlignmentCenter;
        t_jinsheng.textColor = [UIColor darkGrayColor];
        [view addSubview:t_jinsheng];
        
        UILabel *t_entermiss = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-90,40,30,15)];
        t_entermiss.text = NSLocalizedStringFromTable(@"GF/A", @"InfoPlist", nil);
        t_entermiss.font = [UIFont systemFontOfSize:12];
        t_entermiss.textAlignment = NSTextAlignmentCenter;
        t_entermiss.textColor = [UIColor darkGrayColor];
        [view addSubview:t_entermiss];

        UILabel *t_loss = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-120,40,30,15)];
        t_loss.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
        t_loss.font = [UIFont systemFontOfSize:12];
        t_loss.textAlignment = NSTextAlignmentCenter;
        t_loss.textColor = [UIColor darkGrayColor];
        [view addSubview:t_loss];
        
        UILabel *t_draw = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-150,40,30,15)];
        t_draw.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
        t_draw.font = [UIFont systemFontOfSize:12];
        t_draw.textAlignment = NSTextAlignmentCenter;
        t_draw.textColor = [UIColor darkGrayColor];
        [view addSubview:t_draw];
        
        UILabel *t_win = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-180,40,30,15)];
        t_win.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
        t_win.font = [UIFont systemFontOfSize:12];
        t_win.textAlignment = NSTextAlignmentCenter;
        t_win.textColor = [UIColor darkGrayColor];
        [view addSubview:t_win];
        
        UILabel *t_match = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-210,40,30,15)];
        t_match.text = NSLocalizedStringFromTable(@"P", @"InfoPlist", nil);
        t_match.font = [UIFont systemFontOfSize:12];
        t_match.textAlignment = NSTextAlignmentCenter;
        t_match.textColor = [UIColor darkGrayColor];
        [view addSubview:t_match];

    }
    
    else if ([_allType[section] isEqualToString:@"score_full_h"]) {
        
        view.frame = CGRectMake(0, 0, kSceenWidth, 35);
        label.frame = CGRectMake(10, 40, kSceenWidth-20, 15);
        label.textAlignment = NSTextAlignmentCenter;
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10,kSceenWidth,20)];
        labelTitle.text = NSLocalizedStringFromTable(@"League Table", @"InfoPlist", nil);
        labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.textColor = KSFontBlue;
        [view addSubview:labelTitle];
        NSArray *segmentedData = [[NSArray alloc] initWithObjects:NSLocalizedStringFromTable(@"Half", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Full", @"InfoPlist", nil), nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
        segmentedControl.frame = CGRectMake(kSceenWidth-80, 5, 70, 25);
        
        //设置按下按钮时的颜色
//        segmentedControl.tintColor = [UIColor darkGrayColor];
        segmentedControl.tintColor = KSFontBlue;
        segmentedControl.selectedSegmentIndex = _isHalf;//默认选中的按钮索引
        
        [segmentedControl addTarget:self action:@selector(scoreInSegment:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:segmentedControl];
        
        view.backgroundColor = KSBackgroundGray;
//        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        return view;
    }
    
    else if ([_allType[section] isEqualToString:@"score_full_c"]) {
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    else if ([_allType[section] isEqualToString:@"pk_data"]) {
        label.frame = CGRectMake(10, 5, kSceenWidth / 2, 20);
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = KSFontBlue;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-120, 2, 120, 25)];
        [button setImage:[UIImage  imageNamed:@"check_false"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"check_true-1"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [button setTitle:NSLocalizedStringFromTable(@"Home/Away", @"InfoPlist", nil) forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentRight;
        if ([NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"en"]) {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        } else {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        }
        UIColor *fontColor = KSFontBlue;
        [button setTitleColor:fontColor forState:UIControlStateNormal];
        button.tintColor = KSFontBlue;
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        
        button.selected = _isHomeAway;
        [button addTarget:self action:@selector(homeOrAway:) forControlEvents:UIControlEventTouchDown];
        button.tag = section;
        [view addSubview:button];
    }
    
    else if ([_allType[section] isEqualToString:@"h_result_data"]) {
        view.frame = CGRectMake(0, 0, kSceenWidth, 35);
        label.frame = CGRectMake(0, 40, kSceenWidth, 15);
        label.textAlignment = NSTextAlignmentCenter;
        if (_type == 0) {
            label.text = _analyseResult.hteamname;
        } else if (_type == 1) {
            label.text = _basketAnalyseResult.hteamname;
        }
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10,kSceenWidth,15)];
        labelTitle.text = NSLocalizedStringFromTable(@"Recent Results", @"InfoPlist", nil);
        labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.textColor = KSFontBlue;
        [view addSubview:labelTitle];
        NSArray *segmentedData = [[NSArray alloc] initWithObjects:NSLocalizedStringFromTable(@"Last 10", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Last 30", @"InfoPlist", nil), nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
        segmentedControl.frame = CGRectMake(kSceenWidth-105, 5, 100, 25);
        
        //设置按下按钮时的颜色
        segmentedControl.tintColor = KSFontBlue;
        segmentedControl.selectedSegmentIndex = _isHome10;//默认选中的按钮索引
        [segmentedControl addTarget:self action:@selector(homeCountInSegment:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.tag = section;
        [view addSubview:segmentedControl];

        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-200, 5, 90, 25)];
        
        [button setImage:[UIImage  imageNamed:@"check_false"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"check_true-1"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        UIColor *fontColor = KSFontBlue;
        [button setTitleColor:fontColor forState:UIControlStateNormal];
        button.tintColor = KSFontBlue;
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [button setTitle:NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(home:) forControlEvents:UIControlEventTouchDown];
        button.tag = section;
        button.selected = _isHome;
        
        [view addSubview:button];
        
        view.backgroundColor = KSBackgroundGray;
        
        return view;
    }
    
    else if ([_allType[section] isEqualToString:@"c_result_data"]) {
        
        view.frame = CGRectMake(0, 0, kSceenWidth, 35);
        label.frame = CGRectMake(0, 40, kSceenWidth, 15);
        label.textAlignment = NSTextAlignmentCenter;
        if (_type == 0) {
            label.text = _analyseResult.cteamname;
        } else if (_type == 1) {
            label.text = _basketAnalyseResult.cteamname;
        }
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10,kSceenWidth,15)];
        labelTitle.text = NSLocalizedStringFromTable(@"Recent Results", @"InfoPlist", nil);
        labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.textColor = KSFontBlue;
        [view addSubview:labelTitle];
        NSArray *segmentedData = [[NSArray alloc] initWithObjects:NSLocalizedStringFromTable(@"Last 10", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Last 30", @"InfoPlist", nil), nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
        segmentedControl.frame = CGRectMake(kSceenWidth-105, 5, 100, 25);
        
        //设置按下按钮时的颜色
        segmentedControl.tintColor = KSFontBlue;
        segmentedControl.selectedSegmentIndex = _isAway10;//默认选中的按钮索引
        [segmentedControl addTarget:self action:@selector(awayCountInSegment:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.tag = section;

        [view addSubview:segmentedControl];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-200, 5, 90, 25)];
        
        [button setImage:[UIImage  imageNamed:@"check_false"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"check_true-1"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        UIColor *fontColor = KSFontBlue;
        [button setTitleColor:fontColor forState:UIControlStateNormal];
        button.tintColor = KSFontBlue;
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [button setTitle:NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(away:) forControlEvents:UIControlEventTouchDown];
        button.tag = section;
        button.selected = _isAway;
        
        [view addSubview:button];
        
        view.backgroundColor = KSBackgroundGray;
        
        return view;
        
        
    }
    
    else if ([_allType[section] isEqualToString:@"h_fixtures_data"]){
        label.frame = CGRectMake(80, 10, kSceenWidth-90, 15);
        label.textAlignment = NSTextAlignmentRight;
        label.text = _analyseResult.hteamname;
//        label.textColor = KSFontBlue;
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,15)];
        labelTitle.text = NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil);
        labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.textColor = KSFontBlue;
        [view addSubview:labelTitle];
    }
    
    else if ([_allType[section] isEqualToString:@"c_fixtures_data"]){
        label.frame = CGRectMake(80, 10, kSceenWidth-90, 15);
        label.textAlignment = NSTextAlignmentRight;
        label.text = _analyseResult.cteamname;
//        label.textColor = KSFontBlue;
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,15)];
        labelTitle.text = NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil);
        labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.textColor = KSFontBlue;
        [view addSubview:labelTitle];
    }

    else if ([_allType[section] isEqualToString:@"N_h"] || [_allType[section] isEqualToString:@"I_h"] || [_allType[section] isEqualToString:@"O_h"] || [_allType[section] isEqualToString:@"A_h"]) {
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = KSFontBlue;
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([_allType[indexPath.section] isEqualToString:@"x_score"]){
        KSGroupScoreCell *cell = [KSGroupScoreCell cellWithTableView:tableView];
        X_Score *xScore = _allData[indexPath.section][indexPath.row];
        cell.xScore = xScore;
        return cell;
    }
    
    else if ([_allType[indexPath.section] isEqualToString:@"score_full_h"] || [_allType[indexPath.section] isEqualToString:@"score_full_c"]) {
        
        KSScoreCell *cell = [KSScoreCell cellWithTableView:tableView];
        
        NSDictionary *dic = _allData[indexPath.section][indexPath.row];
        
        cell.a.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"a"]];
        cell.b.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"b"]];
        cell.c.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"c"]];
        cell.d.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"d"]];
        cell.e.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"e"]];
        cell.f.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"f"]];
        cell.h.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"h"]];
        cell.i.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"i"]];
        cell.j.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"j"]];
        cell.k.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"k"]];
        return cell;
    }
    
    else if ([_allType[indexPath.section] isEqualToString:@"N_h"]) {
        KSGoalsCell *cell = [KSGoalsCell cellWithTableView:tableView];
        cell.hteam.text = _analyseResult.hteamname;
        cell.cteam.text = _analyseResult.cteamname;
//            cell.t_sH.text = Nh.t_s;
//            cell.t_xH.text = Nh.t_x;
//            cell.h_sH.text = Nh.h_s;
//            cell.h_xH.text = Nh.h_x;
//            cell.c_sH.text = Nh.c_s;
//            cell.c_xH.text = Nh.c_x;
//            
//            cell.t_sC.text = Nc.t_s;
//            cell.t_xC.text = Nc.t_x;
//            cell.h_sC.text = Nc.h_s;
//            cell.h_xC.text = Nc.h_x;
//            cell.c_sC.text = Nc.c_s;
//            cell.c_xC.text = Nc.c_x;
        
        return cell;
    }
    
    else if ([_allType[indexPath.section] isEqualToString:@"I_h"]){
        KSHalfFullCell *cell = [KSHalfFullCell cellWithTableView:tableView];
        I_H *ih = _analyseResult.I_h;
        I_H *ic = _analyseResult.I_c;

        if (indexPath.row == 0) {
            cell1.textLabel.text = _analyseResult.hteamname;
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.textLabel.font = [UIFont systemFontOfSize:15];
            return cell1;
        }
        
        else if (indexPath.row == 1 || indexPath.row == 7) {
            cell.total.text = NSLocalizedStringFromTable(@"Half", @"InfoPlist", nil);
            cell.ww.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
            cell.wd.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
            cell.wl.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
            cell.dw.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
            cell.dd.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
            cell.dl.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
            cell.lw.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
            cell.ld.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
            cell.ll.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
            return cell;
        }
        
        else if (indexPath.row == 2 || indexPath.row == 8) {
            cell.total.text = NSLocalizedStringFromTable(@"Full", @"InfoPlist", nil);
            cell.ww.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
            cell.wd.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
            cell.wl.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
            cell.dw.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
            cell.dd.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
            cell.dl.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
            cell.lw.text = NSLocalizedStringFromTable(@"W", @"InfoPlist", nil);
            cell.ld.text = NSLocalizedStringFromTable(@"D", @"InfoPlist", nil);
            cell.ll.text = NSLocalizedStringFromTable(@"L", @"InfoPlist", nil);
            return cell;
        }

        else if (indexPath.row == 3) {
            cell.total.text = NSLocalizedStringFromTable(@"Total", @"InfoPlist", nil);
            cell.ww.text = [NSString stringWithFormat:@"%li",(long)ih.t_ww];
            cell.wd.text = [NSString stringWithFormat:@"%li",(long)ih.t_wd];
            cell.wl.text = [NSString stringWithFormat:@"%li",(long)ih.t_wl];
            cell.dw.text = [NSString stringWithFormat:@"%li",(long)ih.t_dw];
            cell.dd.text = [NSString stringWithFormat:@"%li",(long)ih.t_dd];
            cell.dl.text = [NSString stringWithFormat:@"%li",(long)ih.t_dl];
            cell.lw.text = [NSString stringWithFormat:@"%li",(long)ih.t_lw];
            cell.ld.text = [NSString stringWithFormat:@"%li",(long)ih.t_ld];
            cell.ll.text = [NSString stringWithFormat:@"%li",(long)ih.t_ll];
            return cell;
        }
        
        else if (indexPath.row == 4) {
            cell.total.text = NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil);
            cell.ww.text = [NSString stringWithFormat:@"%li",(long)ih.h_ww];
            cell.wd.text = [NSString stringWithFormat:@"%li",(long)ih.h_wd];
            cell.wl.text = [NSString stringWithFormat:@"%li",(long)ih.h_wl];
            cell.dw.text = [NSString stringWithFormat:@"%li",(long)ih.h_dw];
            cell.dd.text = [NSString stringWithFormat:@"%li",(long)ih.h_dd];
            cell.dl.text = [NSString stringWithFormat:@"%li",(long)ih.h_dl];
            cell.lw.text = [NSString stringWithFormat:@"%li",(long)ih.h_lw];
            cell.ld.text = [NSString stringWithFormat:@"%li",(long)ih.h_ld];
            cell.ll.text = [NSString stringWithFormat:@"%li",(long)ih.h_ll];
            return cell;
        }
        
        else if (indexPath.row == 5) {
            cell.total.text = NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil);
            cell.ww.text = [NSString stringWithFormat:@"%li",(long)ih.c_ww];
            cell.wd.text = [NSString stringWithFormat:@"%li",(long)ih.c_wd];
            cell.wl.text = [NSString stringWithFormat:@"%li",(long)ih.c_wl];
            cell.dw.text = [NSString stringWithFormat:@"%li",(long)ih.c_dw];
            cell.dd.text = [NSString stringWithFormat:@"%li",(long)ih.c_dd];
            cell.dl.text = [NSString stringWithFormat:@"%li",(long)ih.c_dl];
            cell.lw.text = [NSString stringWithFormat:@"%li",(long)ih.c_lw];
            cell.ld.text = [NSString stringWithFormat:@"%li",(long)ih.c_ld];
            cell.ll.text = [NSString stringWithFormat:@"%li",(long)ih.c_ll];
            return cell;
        }

        
        if (indexPath.row == 6) {
            cell1.textLabel.text = _analyseResult.cteamname;
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.textLabel.font = [UIFont systemFontOfSize:15];
            return cell1;
        }
        
        else if (indexPath.row == 9) {
            cell.total.text = NSLocalizedStringFromTable(@"Total", @"InfoPlist", nil);
            cell.ww.text = [NSString stringWithFormat:@"%li",(long)ic.t_ww];
            cell.wd.text = [NSString stringWithFormat:@"%li",(long)ic.t_wd];
            cell.wl.text = [NSString stringWithFormat:@"%li",(long)ic.t_wl];
            cell.dw.text = [NSString stringWithFormat:@"%li",(long)ic.t_dw];
            cell.dd.text = [NSString stringWithFormat:@"%li",(long)ic.t_dd];
            cell.dl.text = [NSString stringWithFormat:@"%li",(long)ic.t_dl];
            cell.lw.text = [NSString stringWithFormat:@"%li",(long)ic.t_lw];
            cell.ld.text = [NSString stringWithFormat:@"%li",(long)ic.t_ld];
            cell.ll.text = [NSString stringWithFormat:@"%li",(long)ic.t_ll];
            return cell;
        }
        
        else if (indexPath.row == 10) {
            cell.total.text = NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil);
            cell.ww.text = [NSString stringWithFormat:@"%li",(long)ic.h_ww];
            cell.wd.text = [NSString stringWithFormat:@"%li",(long)ic.h_wd];
            cell.wl.text = [NSString stringWithFormat:@"%li",(long)ic.h_wl];
            cell.dw.text = [NSString stringWithFormat:@"%li",(long)ic.h_dw];
            cell.dd.text = [NSString stringWithFormat:@"%li",(long)ic.h_dd];
            cell.dl.text = [NSString stringWithFormat:@"%li",(long)ic.h_dl];
            cell.lw.text = [NSString stringWithFormat:@"%li",(long)ic.h_lw];
            cell.ld.text = [NSString stringWithFormat:@"%li",(long)ic.h_ld];
            cell.ll.text = [NSString stringWithFormat:@"%li",(long)ic.h_ll];
            return cell;
        }
        
        else if (indexPath.row == 11) {
            cell.total.text = NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil);
            cell.ww.text = [NSString stringWithFormat:@"%li",(long)ic.c_ww];
            cell.wd.text = [NSString stringWithFormat:@"%li",(long)ic.c_wd];
            cell.wl.text = [NSString stringWithFormat:@"%li",(long)ic.c_wl];
            cell.dw.text = [NSString stringWithFormat:@"%li",(long)ic.c_dw];
            cell.dd.text = [NSString stringWithFormat:@"%li",(long)ic.c_dd];
            cell.dl.text = [NSString stringWithFormat:@"%li",(long)ic.c_dl];
            cell.lw.text = [NSString stringWithFormat:@"%li",(long)ic.c_lw];
            cell.ld.text = [NSString stringWithFormat:@"%li",(long)ic.c_ld];
            cell.ll.text = [NSString stringWithFormat:@"%li",(long)ic.c_ll];
            return cell;
        }
        return cell1;
    }
    
    else if ( [_allType[indexPath.section] isEqualToString:@"O_h"]){
        
        KSSingleDoubleCell *cell = [KSSingleDoubleCell cellWithTableView:tableView];
//            O_H *oh = [[O_H alloc] init];
        if (indexPath.row == 0) {
            cell.name.text = _analyseResult.hteamname;
            cell.oh = _analyseResult.O_h;
        } else if (indexPath.row == 1) {
            cell.name.text = _analyseResult.cteamname;
            cell.oc = _analyseResult.O_c;
        }
//            cell.t_01.text = [NSString stringWithFormat:@"%li",(long)oh.t_01];
//            cell.t_23.text = [NSString stringWithFormat:@"%li",(long)oh.t_23];
//            cell.t_46.text = [NSString stringWithFormat:@"%li",(long)oh.t_46];
//            cell.t_7.text = [NSString stringWithFormat:@"%li",(long)oh.t_7];
//            cell.t_d.text = [NSString stringWithFormat:@"%li",(long)oh.t_d];
//            cell.t_s.text = [NSString stringWithFormat:@"%li",(long)oh.t_s];
//            
//            cell.h_01.text = [NSString stringWithFormat:@"%li",(long)oh.h_01];
//            cell.h_23.text = [NSString stringWithFormat:@"%li",(long)oh.h_23];
//            cell.h_46.text = [NSString stringWithFormat:@"%li",(long)oh.h_46];
//            cell.h_7.text = [NSString stringWithFormat:@"%li",(long)oh.h_7];
//            cell.h_d.text = [NSString stringWithFormat:@"%li",(long)oh.h_d];
//            cell.h_s.text = [NSString stringWithFormat:@"%li",(long)oh.h_s];
//            
//            cell.c_01.text = [NSString stringWithFormat:@"%li",(long)oh.c_01];
//            cell.c_23.text = [NSString stringWithFormat:@"%li",(long)oh.c_23];
//            cell.c_46.text = [NSString stringWithFormat:@"%li",(long)oh.c_46];
//            cell.c_7.text = [NSString stringWithFormat:@"%li",(long)oh.c_7];
//            cell.c_d.text = [NSString stringWithFormat:@"%li",(long)oh.c_d];
//            cell.c_s.text = [NSString stringWithFormat:@"%li",(long)oh.c_s];

        return cell;
    }
    
    else if ([_allType[indexPath.section] isEqualToString:@"A_h"]){ // 球队入球数
        KSScoreGoalCell *cell = [KSScoreGoalCell cellWithTableView:tableView];
        A_H *ah = _analyseResult.A_h;
        A_H *ac = _analyseResult.A_c;
        if (indexPath.row == 0) {
            cell1.textLabel.text = _analyseResult.hteamname;
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.textLabel.font = [UIFont systemFontOfSize:15];
            return cell1;
        }
        
        else if (indexPath.row == 1) {
            cell.goal.text = NSLocalizedStringFromTable(@"Goals", @"InfoPlist", nil);
            cell.label0.text = @"0";
            cell.label1.text = @"1";
            cell.label2.text = @"2";
            cell.label3.text = @"3";
            cell.label4.text = @"4";
            cell.other.text = NSLocalizedStringFromTable(@"Others", @"InfoPlist", nil);
            return cell;
        }

        else if (indexPath.row == 2) {
            cell.goal.text = NSLocalizedStringFromTable(@"Total", @"InfoPlist", nil);
            cell.label0.text = [NSString stringWithFormat:@"%li",(long)ah.t_enter0];
            cell.label1.text = [NSString stringWithFormat:@"%li",(long)ah.t_enter1];
            cell.label2.text = [NSString stringWithFormat:@"%li",(long)ah.t_enter2];
            cell.label3.text = [NSString stringWithFormat:@"%li",(long)ah.t_enter3];
            cell.label4.text = [NSString stringWithFormat:@"%li",(long)ah.t_enter4];
            cell.other.text = [NSString stringWithFormat:@"%li",(long)ah.t_enter5];
            return cell;

        }
        
        else if (indexPath.row == 3) {
            cell.goal.text = NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil);
            cell.label0.text = [NSString stringWithFormat:@"%li",(long)ah.h_enter0];
            cell.label1.text = [NSString stringWithFormat:@"%li",(long)ah.h_enter1];
            cell.label2.text = [NSString stringWithFormat:@"%li",(long)ah.h_enter2];
            cell.label3.text = [NSString stringWithFormat:@"%li",(long)ah.h_enter3];
            cell.label4.text = [NSString stringWithFormat:@"%li",(long)ah.h_enter4];
            cell.other.text = [NSString stringWithFormat:@"%li",(long)ah.h_enter5];
            return cell;

        }
        
        else if (indexPath.row == 4) {
            cell.goal.text = NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil);
            cell.label0.text = [NSString stringWithFormat:@"%li",(long)ah.c_enter0];
            cell.label1.text = [NSString stringWithFormat:@"%li",(long)ah.c_enter1];
            cell.label2.text = [NSString stringWithFormat:@"%li",(long)ah.c_enter2];
            cell.label3.text = [NSString stringWithFormat:@"%li",(long)ah.c_enter3];
            cell.label4.text = [NSString stringWithFormat:@"%li",(long)ah.c_enter4];
            cell.other.text = [NSString stringWithFormat:@"%li",(long)ah.c_enter5];
            return cell;

        }
        
        else if (indexPath.row == 5) {
            cell1.textLabel.text = _analyseResult.cteamname;
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.textLabel.font = [UIFont systemFontOfSize:15];
            return cell1;
        }
        
        else if (indexPath.row == 6) {
            cell.goal.text = NSLocalizedStringFromTable(@"Goals", @"InfoPlist", nil);
            cell.label0.text = @"0";
            cell.label1.text = @"1";
            cell.label2.text = @"2";
            cell.label3.text = @"3";
            cell.label4.text = @"4";
            cell.other.text = NSLocalizedStringFromTable(@"Others", @"InfoPlist", nil);
            return cell;
        }
        
        else if (indexPath.row == 7) {
            cell.goal.text = NSLocalizedStringFromTable(@"Total", @"InfoPlist", nil);
            cell.label0.text = [NSString stringWithFormat:@"%li",(long)ac.t_enter0];
            cell.label1.text = [NSString stringWithFormat:@"%li",(long)ac.t_enter1];
            cell.label2.text = [NSString stringWithFormat:@"%li",(long)ac.t_enter2];
            cell.label3.text = [NSString stringWithFormat:@"%li",(long)ac.t_enter3];
            cell.label4.text = [NSString stringWithFormat:@"%li",(long)ac.t_enter4];
            cell.other.text = [NSString stringWithFormat:@"%li",(long)ac.t_enter5];
            return cell;
            
        }
        
        else if (indexPath.row == 8) {
            cell.goal.text = NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil);
            cell.label0.text = [NSString stringWithFormat:@"%li",(long)ac.h_enter0];
            cell.label1.text = [NSString stringWithFormat:@"%li",(long)ac.h_enter1];
            cell.label2.text = [NSString stringWithFormat:@"%li",(long)ac.h_enter2];
            cell.label3.text = [NSString stringWithFormat:@"%li",(long)ac.h_enter3];
            cell.label4.text = [NSString stringWithFormat:@"%li",(long)ac.h_enter4];
            cell.other.text = [NSString stringWithFormat:@"%li",(long)ac.h_enter5];
            return cell;
            
        }
        
        else if (indexPath.row == 9) {
            cell.goal.text = NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil);
            cell.label0.text = [NSString stringWithFormat:@"%li",(long)ac.c_enter0];
            cell.label1.text = [NSString stringWithFormat:@"%li",(long)ac.c_enter1];
            cell.label2.text = [NSString stringWithFormat:@"%li",(long)ac.c_enter2];
            cell.label3.text = [NSString stringWithFormat:@"%li",(long)ac.c_enter3];
            cell.label4.text = [NSString stringWithFormat:@"%li",(long)ac.c_enter4];
            cell.other.text = [NSString stringWithFormat:@"%li",(long)ac.c_enter5];
            return cell;
            
        }
        
        else {
            return cell;
        }
    }
    
    
    else {
        KSBattleCell *cell = [KSBattleCell cellWithTableView:tableView];
        if(_type == 0) {
            Pk_Data *pkData = _allData[indexPath.section][indexPath.row];
            if ([_allType[indexPath.section] isEqualToString:@"pk_data"]) {
                
                pkData.isPkData = YES;
            } else if ([_allType[indexPath.section] isEqualToString:@"h_result_data"] || [_allType[indexPath.section] isEqualToString:@"c_result_data"]) {
                pkData.hteamid = _analyseResult.hteam_id;
                pkData.cteamid = _analyseResult.cteam_id;
                if ([_allType[indexPath.section] isEqualToString:@"h_result_data"]) {
                    pkData.isHteam = YES;
                }
            }  else if ([_allType[indexPath.section] isEqualToString:@"h_fixtures_data"] || [_allType[indexPath.section] isEqualToString:@"c_fixtures_data"]) {
                pkData.isFixturesData = YES;
            }
            cell.pkData = pkData;
        } else if (_type == 1) {
            BasketPk_Data *pkData = _allData[indexPath.section][indexPath.row];
            if ([_allType[indexPath.section] isEqualToString:@"pk_data"]) {
                
                pkData.isPkData = YES;
            } else if ([_allType[indexPath.section] isEqualToString:@"h_result_data"] || [_allType[indexPath.section] isEqualToString:@"c_result_data"]) {
                pkData.hteamid = _basketAnalyseResult.hteam_id;
                pkData.cteamid = _basketAnalyseResult.cteam_id;
                if ([_allType[indexPath.section] isEqualToString:@"h_result_data"]) {
                    pkData.isHteam = YES;
                }
            }  else if ([_allType[indexPath.section] isEqualToString:@"h_fixtures_data"] || [_allType[indexPath.section] isEqualToString:@"c_fixtures_data"]) {
                pkData.isFixturesData = YES;
            }
            cell.basketPkData = pkData;
        }
        NSLog(@"%@",NSStringFromClass([cell class]));
        return cell;
    }
    return nil;
    
}

#pragma mark 对战往绩主客切换
- (void)homeOrAway:(UIButton *)sender {
    _isHomeAway = !_isHomeAway;
    UIButton *btn = sender;
    if (_isHomeAway) {
        if (_type == 0) {
            NSArray *array = _analyseResult.pk_data;
            NSMutableArray *pkD = [[NSMutableArray alloc] initWithCapacity:4];
            for (Pk_Data *pkData in array) {
                if (_analyseResult.hteam_id == pkData.hteam_id) {
                    [pkD addObject:pkData];
                }
            }
            [_allData replaceObjectAtIndex:btn.tag withObject:pkD];
        } else if (_type == 1) {
            NSArray *array = _basketAnalyseResult.pk_data;
            NSMutableArray *pkD = [[NSMutableArray alloc] initWithCapacity:4];
            for (BasketPk_Data *pkData in array) {
                if (_basketAnalyseResult.hteam_id == pkData.hteam_id) {
                    [pkD addObject:pkData];
                }
            }
            [_allData replaceObjectAtIndex:btn.tag withObject:pkD];
        }
        
    } else {
        if (_type == 0) {
            [_allData replaceObjectAtIndex:btn.tag withObject:_analyseResult.pk_data];
        } else if (_type == 1) {
            [_allData replaceObjectAtIndex:btn.tag withObject:_basketAnalyseResult.pk_data];
        }
    }
    [self.tableView reloadData];
}

- (void)home:(UIButton *)sender {
    _isHome = !_isHome;
    if (_type == 0) {
        [self homeWithArray:_analyseResult.h_result_data withSection:sender.tag];
    } else if (_type == 1) {
        [self homeWithArray:_basketAnalyseResult.h_result_data withSection:sender.tag];
    }

}

- (void)away:(UIButton *)sender {
    _isAway = !_isAway;
    if (_type == 0) {
        [self awayWithArray:_analyseResult.c_result_data withSection:sender.tag];
    } else if (_type == 1) {
        [self awayWithArray:_basketAnalyseResult.c_result_data withSection:sender.tag];

    }
    
}


#pragma mark 切换场次以及主客场
- (void)homeWithArray:(NSArray *)array withSection:(NSInteger)section {
    NSMutableArray *pkD = [[NSMutableArray alloc] initWithCapacity:4];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
    if (_isHome) {
        if (_type == 0) {
            for (Pk_Data *pkData in array) {
                if (_analyseResult.hteam_id == pkData.hteam_id) {
                    [pkD addObject:pkData];
                }
                
            }
        } else if (_type == 1) {
            for (BasketPk_Data *pkData in array) {
                if (_basketAnalyseResult.hteam_id == pkData.hteam_id) {
                    [pkD addObject:pkData];
                }
                
            }

        }
        
        if (_isHome10 == 0) {
            if (pkD.count > 10) {
                [_allData replaceObjectAtIndex:section withObject:[pkD objectsAtIndexes:indexes]];
            } else {
                [_allData replaceObjectAtIndex:section withObject:pkD];
            }
        } else {
            [_allData replaceObjectAtIndex:section withObject:pkD];
        }
    } else {
        if (_isHome10 == 0) {
            if (array.count > 10) {
                [_allData replaceObjectAtIndex:section withObject:[array objectsAtIndexes:indexes]];
            } else {
                [_allData replaceObjectAtIndex:section withObject:array];
            }
        } else {
            [_allData replaceObjectAtIndex:section withObject:array];
        }

    }
    [self.tableView reloadData];
}

- (void)awayWithArray:(NSArray *)array withSection:(NSInteger)section {
    NSMutableArray *pkD = [[NSMutableArray alloc] initWithCapacity:4];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
    if (_isAway) {
        if (_type == 0) {
            for (Pk_Data *pkData in array) {
                if (_analyseResult.cteam_id == pkData.cteam_id) {
                    [pkD addObject:pkData];
                }
                
            }
        } else if (_type == 1) {
            for (BasketPk_Data *pkData in array) {
                if (_basketAnalyseResult.cteam_id == pkData.cteam_id) {
                    [pkD addObject:pkData];
                }
            }
        }
        
        if (_isAway10 == 0) {
            if (pkD.count > 10) {
                [_allData replaceObjectAtIndex:section withObject:[pkD objectsAtIndexes:indexes]];
            } else {
                [_allData replaceObjectAtIndex:section withObject:pkD];
            }
        } else {
            [_allData replaceObjectAtIndex:section withObject:pkD];
        }
    } else {
        if (_isAway10 == 0) {
            if (array.count > 10) {
                [_allData replaceObjectAtIndex:section withObject:[array objectsAtIndexes:indexes]];
            } else {
                [_allData replaceObjectAtIndex:section withObject:array];
            }
        } else {
            [_allData replaceObjectAtIndex:section withObject:array];
        }
        
    }
    [self.tableView reloadData];
}

#pragma mark 积分榜全半场切换
- (void)scoreInSegment:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            
            [_allData replaceObjectAtIndex:0 withObject:[self setupScore:_analyseResult.score_half_h]];
            _isHalf = 0;
            [_allData replaceObjectAtIndex:1 withObject:[self setupScore:_analyseResult.score_half_c]];
            [self.tableView reloadData];
            break;
            
        case 1:
            [_allData replaceObjectAtIndex:0 withObject:[self setupScore:_analyseResult.score_full_h]];
            _isHalf = 1;
            [_allData replaceObjectAtIndex:1 withObject:[self setupScore:_analyseResult.score_full_c]];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

// 切换显示场次
- (void)homeCountInSegment:(UISegmentedControl *)seg {
    
    NSInteger index = seg.selectedSegmentIndex;

    switch (index) {
        case 0:
            _isHome10 = 0;
            break;
            
        case 1:
            _isHome10 = 1;
            break;
            
        default:
            break;
    }
    
    if (_type == 0) {
        [self homeWithArray:_analyseResult.h_result_data withSection:seg.tag];
    } else if (_type == 1) {
        [self homeWithArray:_basketAnalyseResult.h_result_data withSection:seg.tag];
    }
}

- (void)awayCountInSegment:(UISegmentedControl *)seg {
    
    NSInteger index = seg.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            _isAway10 = 0;
            break;
            
        case 1:
            _isAway10 = 1;
            break;
            
        default:
            break;
    }
    if (_type == 0) {
        [self awayWithArray:_analyseResult.c_result_data withSection:seg.tag];
    } else if (_type == 1) {
        [self awayWithArray:_basketAnalyseResult.c_result_data withSection:seg.tag];
    }
}



- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"KSGoalsCell" bundle:nil] forCellReuseIdentifier:@"goalsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSGroupScoreCell" bundle:nil] forCellReuseIdentifier:@"groupScoreCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSBattleCell" bundle:nil] forCellReuseIdentifier:@"battleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSScoreCell" bundle:nil] forCellReuseIdentifier:@"scoreCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSHalfFullCell" bundle:nil] forCellReuseIdentifier:@"halfFullCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSScoreGoalCell" bundle:nil] forCellReuseIdentifier:@"scoreGoalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSSingleDoubleCell" bundle:nil] forCellReuseIdentifier:@"singleDoubleCell"];



//    [self.tableView registerClass:[KSScore2Cell class] forCellReuseIdentifier:@"KSScore2Cell"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark private method

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kSceenWidth, kSceenHeight-175) style:UITableViewStylePlain];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = YES;
        
        //        _tableView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
        
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 200)];
        //        tableView.tableHeaderView = view;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth-220)/2 , 70, 220, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = 2;
        label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
        [self.tableView addSubview:label];
        [self.view insertSubview:label atIndex:1];
        _label = label;
    }
    return _label;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
