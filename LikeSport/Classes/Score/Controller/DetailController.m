//
//  DetailController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/18.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "DetailController.h"
#import "KSKuaiShouTool.h"
#import "KSFootballDetail.h"
#import "KSStatisticsCell.h"
#import "KSEventCell.h"
#import "KSLineUpCell.h"
#import "KSBasketCell.h"


@interface DetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *matchDetail;
@property (nonatomic, strong) NSMutableArray *matchInfo;
@property (nonatomic, strong) NSMutableArray *matchEvent;
@property (nonatomic, strong) NSMutableArray *elected;
@property (nonatomic, strong) NSMutableArray *substitute;
@property (nonatomic, strong) NSMutableArray *sectionTitle;
@property (nonatomic, strong) NSMutableArray *sectionNum;

@property (nonatomic, strong) NSMutableArray *basketballData;



@property (nonatomic, weak)UITableView *tableView;


@property (nonatomic, assign) BOOL canceled;
@property (weak, nonatomic) UILabel *label;

@end
static NSString *reuseid = @"useid";

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    if (_type == 0) {
        [self updateFootballInfo];
    } else if (_type == 1 || _type == 2){
        [self updasteBasketInfo];
    }
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)updateFootballInfo{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.userInteractionEnabled = NO;

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });

    [KSKuaiShouTool getFootballDetailWithMatchID:_matchID withCompleted:^(id result) {
//        NSLog(@"result%@",result);
        FootballDetailResult *detailResult = [FootballDetailResult mj_objectWithKeyValues:result];
        MatchInfo *matchInfo = detailResult.match_info;
        _matchDetail = [[NSMutableArray alloc] initWithCapacity:4];
        _sectionTitle = [[NSMutableArray alloc] initWithCapacity:4];
        _sectionNum = [[NSMutableArray alloc] initWithCapacity:4];
        _matchInfo = [[NSMutableArray alloc] initWithCapacity:3];
        
        NSDictionary * infoDic = [NSDictionary dictionary];
        
        if (detailResult.match_event.count != 0) {
            //            _matchEvent = [detailResult.match_event mutableCopy];
            [_matchDetail addObject:detailResult.match_event];
            [_sectionTitle addObject:NSLocalizedStringFromTable(@"Event", @"InfoPlist", nil)];
            [_sectionNum addObject:@"1"];
        }
        
        //--先开球 -1 不显示  0 主队 1 客队
        if (matchInfo.firstgoal == 0) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"h",NSLocalizedStringFromTable(@"Kick-off", @"InfoPlist", nil),@"z",@" ",@"c", nil];
            [_matchInfo addObject:infoDic];
        } else if (matchInfo.firstgoal == 1){
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"c",NSLocalizedStringFromTable(@"Kick-off", @"InfoPlist", nil),@"z",@" ",@"h", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if (matchInfo.firstcore == 0) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"h",NSLocalizedStringFromTable(@"Corner first", @"InfoPlist", nil),@"z",@" ",@"c", nil];
            [_matchInfo addObject:infoDic];
        } else if (matchInfo.firstyellow == 1){
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"c",NSLocalizedStringFromTable(@"Corner first", @"InfoPlist", nil),@"z",@" ",@"h", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if (matchInfo.firstyellow == 0) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"h",NSLocalizedStringFromTable(@"Yellow card first", @"InfoPlist", nil),@"z",@" ",@"c", nil];
            [_matchInfo addObject:infoDic];
        } else if (matchInfo.firstyellow == 1){
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"c",NSLocalizedStringFromTable(@"Yellow card first", @"InfoPlist", nil),@"z",@" ",@"h", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if (matchInfo.firstred == 0) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"h",NSLocalizedStringFromTable(@"Red card first", @"InfoPlist", nil),@"z",@" ",@"c", nil];
            [_matchInfo addObject:infoDic];
        } else if (matchInfo.firstred == 1){
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"√ ",@"c",NSLocalizedStringFromTable(@"Red card first", @"InfoPlist", nil),@"z",@" ",@"h", nil];
            [_matchInfo addObject:infoDic];
        }
        
        // 加时
//        if (matchInfo.hasextratime == 1) {
//            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.extratime_h],@"h",[NSNumber numberWithInteger:matchInfo.extratime_c],@"c",NSLocalizedStringFromTable(@"Extra time", @"InfoPlist", nil),@"z", nil];
//            [_matchInfo addObject:infoDic];
//        }
        
        if ((matchInfo.h_kqsjbl != 0) || (matchInfo.c_kqsjbl != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%li%%" ,(long)matchInfo.h_kqsjbl],@"h",[NSString stringWithFormat:@"%li%%" ,(long)matchInfo.c_kqsjbl],@"c",NSLocalizedStringFromTable(@"Possession", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
            
        }
        
        if ((matchInfo.h_smbd != 0) || (matchInfo.c_smbd != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_smbd],@"h",[NSNumber numberWithInteger:matchInfo.c_smbd],@"c",NSLocalizedStringFromTable(@"Shot blocked", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
            
        }
        
        if ((matchInfo.h_szcs != 0) || (matchInfo.c_szcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_szcs],@"h",[NSNumber numberWithInteger:matchInfo.c_szcs],@"c",NSLocalizedStringFromTable(@"On target", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
            
        }
        
        if ((matchInfo.h_smbz != 0) || (matchInfo.c_smbz != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_smbz],@"h",[NSNumber numberWithInteger:matchInfo.c_smbz],@"c",NSLocalizedStringFromTable(@"Off target", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_smcs != 0) || (matchInfo.c_smcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_smcs],@"h",[NSNumber numberWithInteger:matchInfo.c_smcs],@"c",NSLocalizedStringFromTable(@"Shot", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        
        if ((matchInfo.h_szmksc != 0) || (matchInfo.c_szmksc != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_szmksc],@"h",[NSNumber numberWithInteger:matchInfo.c_szmksc],@"c",NSLocalizedStringFromTable(@"Shots on goal", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];

        }
        
        // 点球
//        if (matchInfo.haspenalty == 1) {
//            infoDic = nil;
//            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.penalty_h],@"h",[NSNumber numberWithInteger:matchInfo.penalty_h],@"c",NSLocalizedStringFromTable(@"Penalty kick", @"InfoPlist", nil),@"z", nil];
//            [_matchInfo addObject:infoDic];
//        }
        
        if ((matchInfo.h_ryq != 0) || (matchInfo.c_ryq != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_ryq],@"h",[NSNumber numberWithInteger:matchInfo.c_ryq],@"c",NSLocalizedStringFromTable(@"Free kick", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
            
        }

        
        if ((matchInfo.h_jq_h != 0) || (matchInfo.c_jq_h != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_jq_h],@"h",[NSNumber numberWithInteger:matchInfo.c_jq_h],@"c",NSLocalizedStringFromTable(@"Corner(HT)", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if (matchInfo.hasjq == 1) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.hjq],@"h",[NSNumber numberWithInteger:matchInfo.cjq],@"c",NSLocalizedStringFromTable(@"Corner(FT)", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_yw != 0) || (matchInfo.c_yw != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_yw],@"h",[NSNumber numberWithInteger:matchInfo.c_yw],@"c",NSLocalizedStringFromTable(@"Offside", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];

        }
    
        
        if ((matchInfo.h_fg != 0) || (matchInfo.c_fg != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_fg],@"h",[NSNumber numberWithInteger:matchInfo.c_fg],@"c",NSLocalizedStringFromTable(@"Foul", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];

        }
        
        if ((matchInfo.h_yp != 0) || (matchInfo.c_yp != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_yp],@"h",[NSNumber numberWithInteger:matchInfo.c_yp],@"c",NSLocalizedStringFromTable(@"Yellow Card", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];

        }
        
        if ((matchInfo.h_rp != 0) || (matchInfo.c_rp != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_rp],@"h",[NSNumber numberWithInteger:matchInfo.c_rp],@"c",NSLocalizedStringFromTable(@"Red Card", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_jwq != 0) || (matchInfo.c_jwq != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_jwq],@"h",[NSNumber numberWithInteger:matchInfo.c_jwq],@"c",NSLocalizedStringFromTable(@"Throw in", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];

        }
        
        if ((matchInfo.h_jqcs != 0) || (matchInfo.c_jqcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_jqcs],@"h",[NSNumber numberWithInteger:matchInfo.c_jqcs],@"c",NSLocalizedStringFromTable(@"Save", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];

        }
        
 
        
        if ((matchInfo.h_zz != 0) || (matchInfo.c_zz != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_zz],@"h",[NSNumber numberWithInteger:matchInfo.c_zz],@"c",NSLocalizedStringFromTable(@"In the column", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_tqcs != 0) || (matchInfo.c_tqcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_tqcs],@"h",[NSNumber numberWithInteger:matchInfo.c_tqcs],@"c",NSLocalizedStringFromTable(@"Header", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_tqcgcs != 0) || (matchInfo.c_tqcgcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_tqcgcs],@"h",[NSNumber numberWithInteger:matchInfo.c_tqcgcs],@"c",NSLocalizedStringFromTable(@"Header Succeed", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_chanqcs != 0) || (matchInfo.c_chanqcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_chanqcs],@"h",[NSNumber numberWithInteger:matchInfo.c_chanqcs],@"c",NSLocalizedStringFromTable(@"Slide tackle", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_grcs != 0) || (matchInfo.c_grcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_grcs],@"h",[NSNumber numberWithInteger:matchInfo.c_grcs],@"c",NSLocalizedStringFromTable(@"break through", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_cqcs != 0) || (matchInfo.c_cqcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_cqcs],@"h",[NSNumber numberWithInteger:matchInfo.c_cqcs],@"c",NSLocalizedStringFromTable(@"pass the ball", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
        
        if ((matchInfo.h_cqcgcs != 0) || (matchInfo.h_cqcgcs != 0)) {
            infoDic = nil;
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:matchInfo.h_cqcgcs],@"h",[NSNumber numberWithInteger:matchInfo.h_cqcgcs],@"c",NSLocalizedStringFromTable(@"Passing succeed", @"InfoPlist", nil),@"z", nil];
            [_matchInfo addObject:infoDic];
        }
//        _matchEvent = [[NSMutableArray alloc] initWithCapacity:4];
//        _elected = [[NSMutableArray alloc] initWithCapacity:4];
//        _substitute = [[NSMutableArray alloc] initWithCapacity:4];

        if (_matchInfo.count != 0) {
            [_matchDetail addObject:_matchInfo];
            [_sectionTitle addObject:NSLocalizedStringFromTable(@"Statistics", @"InfoPlist", nil)];
            [_sectionNum addObject:@"2"];
        }
        

        
        if (detailResult.match_zr.elected.count != 0) {
            [_matchDetail addObject:detailResult.match_zr.elected];
//            _elected = [detailResult.match_zr.elected mutableCopy];
            [_sectionTitle addObject:NSLocalizedStringFromTable(@"Line-up", @"InfoPlist", nil)];
            [_sectionNum addObject:@"3"];


        }
        
        if (detailResult.match_zr.substitute != 0) {
            [_matchDetail addObject:detailResult.match_zr.substitute];
//            _substitute = [detailResult.match_zr.substitute mutableCopy];
            [_sectionTitle addObject:NSLocalizedStringFromTable(@"Substitute", @"InfoPlist", nil)];
            [_sectionNum addObject:@"4"];


        }
        
        [_matchDetail mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (_matchDetail.count == 0) {
                self.label.hidden = NO;
                self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
            } else if (_matchDetail.count > 0) {
                self.label.hidden = YES;
            }
            [hud hideAnimated:YES];

        });

    } failure:^(NSError *error) {
        self.label.hidden = NO;
        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        [hud hideAnimated:YES];
//        self.label.text = @"网络请求出错";//[error localizedDescription];
    }];
}


- (void)updasteBasketInfo {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//    hud.userInteractionEnabled = NO;
//
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        [self doSomeWork];
//    });
    
//    [KSLikeSportTool getFootballBaseType:_type withMatchID:_matchID withCompleted:^(id result) {
//        KSBasketballBase *basketballBase = [KSBasketballBase mj_objectWithKeyValues:result];
//        BasketResult *basketResult = basketballBase.result;
//    "1rd set"="第一盘";
//    "2rd set"="第二盘";
//    "3rd set"="第三盘";
//    "4rd set"="第四盘";
//    "5rd set"="第五盘";
    _basketballData = [[NSMutableArray alloc] initWithCapacity:5];
       NSDictionary *infoDic = [NSDictionary dictionary];
        BasketResult *basketResult = self.basketResult;
        if ((basketResult.st1_h != -1) && (basketResult.st1_c != -1)) {
            NSString *string;
            if (_type == 1) {
                string = NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil);
            } else {
                string = NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil);
            }
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.st1_h],@"h",[NSNumber numberWithInteger:basketResult.st1_c],@"c",string,@"z", nil];
            [_basketballData addObject:infoDic];
        }
        
//        if ((basketResult.ot_h1 != -1) && (basketResult.ot_c1 != -1)) {
//            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.ot_h1],@"h",[NSNumber numberWithInteger:basketResult.ot_c1],@"c",NSLocalizedStringFromTable(@"1 OT", @"InfoPlist", nil),@"z", nil];
//            [_basketballData addObject:infoDic];
//        }
    
        if ((basketResult.st2_h != -1) && (basketResult.st2_c != -1)) {
            NSString *string;
            if (_type == 1) {
                string = NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil);
            } else {
                string = NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil);
            }
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.st2_h],@"h",[NSNumber numberWithInteger:basketResult.st2_c],@"c",string,@"z", nil];
            [_basketballData addObject:infoDic];
        }
        
//        if ((basketResult.ot_h2 != -1) && (basketResult.ot_c2 != -1)) {
//            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.ot_h2],@"h",[NSNumber numberWithInteger:basketResult.ot_c2],@"c",NSLocalizedStringFromTable(@"2 OT", @"InfoPlist", nil),@"z", nil];
//            [_basketballData addObject:infoDic];
//        }
    
        if ((basketResult.st3_h != -1) && (basketResult.st3_c != -1)) {
            NSString *string;
            if (_type == 1) {
                string = NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil);
            } else {
                string = NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil);
            }
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.st3_h],@"h",[NSNumber numberWithInteger:basketResult.st3_c],@"c",string,@"z", nil];
            [_basketballData addObject:infoDic];
        }
        
//        if ((basketResult.ot_h3 != -1) && (basketResult.ot_c3 != -1)) {
//            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.ot_h3],@"h",[NSNumber numberWithInteger:basketResult.ot_c3],@"c",NSLocalizedStringFromTable(@"3 OT", @"InfoPlist", nil),@"z", nil];
//            [_basketballData addObject:infoDic];
//        }
    
        if ((basketResult.st4_h != -1) && (basketResult.st4_c != -1)) {
            NSString *string;
            if (_type == 1) {
                string = NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil);
            } else {
                string = NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil);
            }
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.st4_h],@"h",[NSNumber numberWithInteger:basketResult.st4_c],@"c",string,@"z", nil];
            [_basketballData addObject:infoDic];
        }
    
    if (_type == 2) {
        if ((basketResult.st5_h != -1) && (basketResult.st5_c != -1)) {
            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.st5_h],@"h",[NSNumber numberWithInteger:basketResult.st5_c],@"c",NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil),@"z", nil];
            [_basketballData addObject:infoDic];
        }
    }
    
    
    // 总加时比分
    NSInteger otH = ((basketResult.ot_h1 == -1) ? 0 : basketResult.ot_h1) + ((basketResult.ot_h2 == -1) ? 0 : basketResult.ot_h2) + ((basketResult.ot_h3 == -1) ? 0 : basketResult.ot_h3) + ((basketResult.ot_h4 == -1) ? 0 : basketResult.ot_h4);
    NSInteger otC = ((basketResult.ot_c1 == -1) ? 0 : basketResult.ot_c1) + ((basketResult.ot_c2 == -1) ? 0 : basketResult.ot_c2) + ((basketResult.ot_c3 == -1) ? 0 : basketResult.ot_c3) + ((basketResult.ot_c4 == -1) ? 0 : basketResult.ot_c4);
    if (otH != 0 && otC != 0) {
        infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:otH],@"h",[NSNumber numberWithInteger:otC],@"c",NSLocalizedStringFromTable(@"OT", @"InfoPlist", nil),@"z", nil];
        [_basketballData addObject:infoDic];
    }
        
//        if ((basketResult.ot_h4 != -1) && (basketResult.ot_c4 != -1)) {
//            infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:basketResult.ot_h4],@"h",[NSNumber numberWithInteger:basketResult.ot_c4],@"c",NSLocalizedStringFromTable(@"4 OT", @"InfoPlist", nil),@"z", nil];
//            [_basketballData addObject:infoDic];
//        }
//        NSLog(@"----%i",_basketballData.count);
    
    
        [_basketballData mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (_basketballData.count == 0) {
                self.label.hidden = NO;
            } else if (_basketballData.count > 0) {
                self.label.hidden = YES;
            }
//            [hud hideAnimated:YES];
        });
//    }failure:^(NSError *error) {
//        [hud hideAnimated:YES];
//        self.label.text = [error localizedDescription];
//    }];
}
#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *detail = _matchDetail[section];
    if (_type == 0) {
        return detail.count;
    } else if (_type == 1 || _type == 2) {
        return _basketballData.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_type == 0) {
        return _matchDetail.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_type == 0) {
        return 25;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"技术统计";
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_type == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,kSceenWidth,15)];
        label.text = _sectionTitle[section];
        
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = KSFontBlue;
        label.backgroundColor = KSBackgroundGray;
        return label;
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor grayColor];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 22)];
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text = @"adasdsa";
//    [myView addSubview:titleLabel];
//    
//    return myView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        if ([_sectionNum[indexPath.section] isEqualToString:@"1"])
        {
            KSEventCell *cell = [KSEventCell cellWithTableView:tableView];
            KSMore *more = _matchDetail[indexPath.section][indexPath.row];
            cell.more = more;
            return cell;
            
            
        } else if ([_sectionNum[indexPath.section] isEqualToString:@"2"])
        {
            KSStatisticsCell *cell = [KSStatisticsCell cellWithTableView:tableView];
            NSDictionary *dic = _matchDetail[indexPath.section][indexPath.row];
            cell.zhong.text = [dic objectForKey:@"z"];
            cell.zuo.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"h"]];
            cell.you.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"c"]];
            return cell;
            
        }  else if ([_sectionNum[indexPath.section] isEqualToString:@"3"] || [_sectionNum[indexPath.section] isEqualToString:@"4"])
        {
            KSLineUpCell *cell = [KSLineUpCell cellWithTableView:tableView];
            Elected *elected = _matchDetail[indexPath.section][indexPath.row];
            cell.elected = elected;
            return cell;
        }
    }
   /**
    KSBasketCell *cell = [KSBasketCell cellWithTableView:tableView];
    NSDictionary *dic = _basketballData[indexPath.row];
    cell.time.text = [dic objectForKey:@"z"];
    cell.hteam.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"h"]];
    cell.cteam.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"c"]];
    **/
    KSBasketCell *cell = [KSBasketCell cellWithTableView:tableView];
    NSDictionary *dic = _basketballData[indexPath.row];
    if ([self.basketResult.matchtypefullname isEqualToString:@"美国 - NCAA"]) {
        cell.hteam.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"h"]];
        cell.cteam.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"c"]];
        if (indexPath.row==0) {
            cell.time.text = NSLocalizedStringFromTable(@"1st Half", @"InfoPlist",nil);
        }else{
            cell.time.text = NSLocalizedStringFromTable(@"2nd Half", @"InfoPlist",nil);
        }
        
    }else{
    
        cell.time.text = [dic objectForKey:@"z"];
        cell.hteam.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"h"]];
        cell.cteam.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"c"]];
    }
    return cell;
    
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"KSStatisticsCell" bundle:nil] forCellReuseIdentifier:@"statisticsCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"KSEventCell" bundle:nil] forCellReuseIdentifier:@"eventCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"KSLineUpCell" bundle:nil] forCellReuseIdentifier:@"lineUpCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KSBasketCell" bundle:nil] forCellReuseIdentifier:@"basketCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark private method

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kSceenWidth, kSceenHeight-175) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.rowHeight = 100;
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

- (NSMutableArray *)matchDetail {
    if (!_matchDetail) {
        _matchDetail = [@[] mutableCopy];
    }
    return _matchDetail;
}

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth-220)/2 , 70, 220, 40)];
        label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
        label.textAlignment = NSTextAlignmentCenter;
        [self.tableView addSubview:label];
        [self.view insertSubview:label atIndex:1];
        _label = label;
    }
    return _label;
}

// 分割线对齐左边
-(void)viewDidLayoutSubviews
{
    //    UITableView *tableView = _scrollTableViews[_currentPage%2];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
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
