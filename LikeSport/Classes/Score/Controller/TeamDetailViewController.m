//
//  TeamDetailViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "KSLiveCell.h"
#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "KSLiveFrame.h"
#import "FootballDetailController.h"
#import "KSExpansionCell.h"
#import "GDataXMLNode.h"
#import "TeamInformationController.h"
#import "LoginViewController.h"

#import "KSTeamDetailTableViewCell.h"
#import "KSLiveView.h"
#define ExpandCount 1


@interface TeamDetailViewController ()<KSLiveCellDelegate,UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) NSMutableArray *allTitle;
@property (nonatomic, assign) NSInteger matchID;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *minuteTimer;
@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic, assign) BOOL isMinuteTimer;

@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *more;
@property (nonatomic, strong) NSMutableArray<KSLive *> *live;
@property (nonatomic, strong) NSMutableArray *lastLive;

@property (nonatomic, assign) BOOL hasLive; // 有正在进行中的比赛

@property (weak, nonatomic) UIButton *followBtn;
@property (nonatomic, assign) NSInteger is_follow;

@end

@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
//        
//    }
//    
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
//        
//    }

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarController.view setBackgroundColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
//    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[UIImage new]];
//    [self.view addSubview:bar];
    [self createTableView];

    [self setData];
    

//    if (([_sportType isEqualToString:@"B"] && _type == 2) || [_sportType isEqualToString:@"C"]) {
        UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [followBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [followBtn setImage:[UIImage imageNamed:@"followed"] forState:UIControlStateHighlighted];
        [followBtn addTarget:self action:@selector(followMatch) forControlEvents:UIControlEventTouchUpInside];
        //    [someButton setShowsTouchWhenHighlighted:YES];
        _followBtn = followBtn;
        UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:followBtn];
        self.navigationItem.rightBarButtonItem = mailbutton;
//    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
   // if (_type==0&&indexPath.row==self.allData.count) {
    
    
        [cell.layer setMasksToBounds:YES];
        [cell.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
        [cell.layer setBorderWidth:0.5f];
 //  }
    
    
}
// 关注按钮
- (void)followMatch{
    _followBtn.highlighted = YES;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    
    if (token.length > 0) {
        
        NSInteger state = 0;
        if (_is_follow == 0) {
            state = 1;
        } else if (_is_follow == 1){
            state = 2;
        }
        NSString *ptype;
        if ([_sportType isEqualToString:@"A"] || [_sportType isEqualToString:@"C"]) { // A:球队 C:队员
            ptype = @"2";
        } else if ([_sportType isEqualToString:@"B"]) { // B:赛事类别
            ptype = @"3";
        }
        NSDictionary *param = @{@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"ptype":ptype,@"mid":[NSString stringWithFormat:@"%li",(long)_teamid],@"status":[NSString stringWithFormat:@"%li",(long)state]};
        
        [KSKuaiShouTool followMatchWithParam:param withCompleted:^(id result) {
            NSLog(@"param=%@",result);

            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (_is_follow == 0) {
                    _is_follow = 1;
                    _followBtn.highlighted = YES;
                } else if (_is_follow == 1){
                    _is_follow = 0;
                    _followBtn.highlighted = NO;
                }
            } else {
                if (_is_follow == 0) {
                    _followBtn.highlighted = NO;
//                    _is_follow = 1;
                } else if (_is_follow == 1){
                    _followBtn.highlighted = YES;
//                    _is_follow = 0;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
            });
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"followView"];
            [defaults synchronize];
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Tip", @"InfoPlist", nil) message:NSLocalizedStringFromTable(@"Please login first", @"InfoPlist", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil) otherButtonTitles:NSLocalizedStringFromTable(@"Yes", @"InfoPlist", nil), nil];
        //        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        alert.delegate = self;
        [alert show];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.userInteractionEnabled = NO;
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = NSLocalizedStringFromTable(@"Please login first", @"InfoPlist", nil);
//        [hud hideAnimated:YES afterDelay:1.f];
//        [self.tableView reloadData];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSString* msg = [[NSString alloc] initWithFormat:@"您按下的第%ld个按钮！",(long)buttonIndex];
    if (buttonIndex == 1) {
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        loginVc.tokenBlock = ^(NSString *token){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"token"];
            //获得UIImage实例
            [defaults synchronize];
            
            [self followMatch];
        };
        [loginVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

#pragma mark --  指示器更新数据
- (void)setData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(3.);
    });
    NSDictionary *params = [NSDictionary dictionary];
    NSString *url;
    if ([_sportType isEqualToString:@"A"] || [_sportType isEqualToString:@"C"]) { // 球队和队员
        params = @{@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"teamid":[NSString stringWithFormat:@"%li",(long)_teamid]};
        url = @"search_team_info_get";
    } else if ([_sportType isEqualToString:@"B"]) { // 联赛
        params = @{@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"matchtypeid":[NSString stringWithFormat:@"%li",(long)_teamid]};
        url = @"search_matchtype_info_get";
    }
    
    [KSKuaiShouTool teamWithUrl:url WithParams:params withCompleted:^(id result) {
//        NSLog(@"球队数据=%@",result)
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        _is_follow = last.result.is_follow;
        if (_is_follow == 0) {
            _followBtn.highlighted = NO;
        } else if (_is_follow == 1) {
            _followBtn.highlighted = YES;
        }
        _allData = [NSMutableArray arrayWithCapacity:3];
        _allTitle = [NSMutableArray arrayWithCapacity:3];
//        _allType = [NSMutableArray arrayWithCapacity:3];
        
        NSMutableArray *array = [NSMutableArray array];
        for (KSLive *live in last.result.live_data.data) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = _type;
//            live.isFollowView = YES;
            liveF.live = live;
            [array addObject:liveF];
            live.timeH = 1;
            live.timeC = 1;
            live.st1T_h = 1;
            live.st1T_c = 1;
            live.st2T_h = 1;
            live.st2T_c = 1;
            live.st3T_h = 1;
            live.st3T_c = 1;
            live.st4T_h = 1;
            live.st4T_c = 1;
            live.st5T_h = 1;
            live.st5T_c = 1;

        }
        
        if (array.count > 0) {
            [_allTitle addObject:NSLocalizedStringFromTable(@"Playing2", @"InfoPlist", nil)];
            [_allData addObject:array];
            _matchID = last.result.live_data.flag_num;
    //        [_allType addObject:@"0"];
            
            _hasLive = YES;
            [self updateLastLive]; // 即时刷新比分
            [self addTimer];
            if (_type == 0) {
                [self addMinuteTimer];
            }
        }
        
        
        array = [NSMutableArray array];
        for (KSLive *live in last.result.result_data) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = _type;
//            live.isFollowView = YES;
            live.isMatch = YES;
            liveF.live = live;
            [array addObject:liveF];
//            live.timeH = 1;
//            live.timeC = 1;
        }
        if (array.count > 0) {
            [_allTitle addObject:NSLocalizedStringFromTable(@"Results", @"InfoPlist", nil)];
            [_allData addObject:array];
//        [_allType addObject:@"1"];
        }
//
        array = [NSMutableArray array];
        for (KSLive *live in last.result.fixtures_data) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = _type;
//            live.isFollowView = YES;
            live.isMatch = YES;
            liveF.live = live;
            [array addObject:liveF];
//            live.timeH = 1;
//            live.timeC = 1;
        }
        if (array.count > 0) {
            [_allTitle addObject:NSLocalizedStringFromTable(@"Fixtures", @"InfoPlist", nil)];
            [_allData addObject:array];
    //        [_allType addObject:@"2"];
        }
     
        [_allData mutableCopy];
        self.isExpand = NO;
        self.selectedIndexPath = nil;
        
//        if (_allData.count!=0&&_allTitle.count!=0) {
//            
//            NSArray *alld = [[_allData reverseObjectEnumerator] allObjects];
//            NSArray *allt = [[_allTitle reverseObjectEnumerator] allObjects];
//            _allData=[NSMutableArray arrayWithArray:alld];
//            _allTitle=[NSMutableArray arrayWithArray:allt];
//        }

        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.tableView.mj_header endRefreshing];
            [hud hideAnimated:YES];
            if (_allData.count == 0) {
//                self.label.hidden = NO;
//                //                if (_chooseType == 0) {
//                self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
                //                } else {
                //                    self.label.text = @"没有符合筛选条件的赛事";
                //                }
            } else if (_allData.count > 0) {
                
//                self.label.hidden = YES;
            }
            
            
        });
        
//        [self checkIfMatchIsComing];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        //        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        //        self.label.hidden = NO;
//        [self networdError];
        //        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *lives = _allData[section];
    if (_type==0) {
//    _type==0&&[_sportType isEqualToString:@"A"]&&(_allTitle.count>1&&section!=0)||(_allTitle.count==1
    if (_type==0&&[_sportType isEqualToString:@"A"]&&(section==_allTitle.count-1)) {
        
        return lives.count+1;
        
    }else{
        
       return lives.count;
        
    }
    }else{
        return lives.count;

    }
    
    
   // return lives.count;
    
    
    
//    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allTitle.count;
//    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type==0) {
        NSMutableArray *lives = _allData[indexPath.section];
        if (indexPath.row==lives.count) {
            
            if (indexPath.section==_allTitle.count-1) {
                
                return 150.0f;
            }
           // return 30.0f;
    
        }

    }
    
   KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row];
    if (liveF.isExpand) {
        if (_type == 0) {
     
            return (liveF.live.more.count + 1 ) * 20 + 5 + 65;
            
        } else {
            
            return 125;
        }
        //        else if ([_allType[indexPath.section] isEqualToString:@"1"] && [_allType[indexPath.section] isEqualToString:@"2"]) {
        //            return 125;
        //        } else {
        //            return 160;
        //        }
    } else {
        
        return 65;
    }
 
    
//    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row == self.selectedIndexPath.row+1) {
//        if (_type == 1) {
//            KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row-1];
//            if (liveF.live.hascourts == 2) {
//                if (liveF.live.st3_h == -1) {
//                    return 45;
//                } else {
//                    return 65;
//                }
//            } else {
//                if (liveF.live.st2_h == -1) {
//                    return 45;
//                } else if (liveF.live.st3_h == -1) {
//                    return 85;
//                } else if (liveF.live.st4_h == -1) {
//                    return 105;
//                } else {
//                    return 150;
//                }
//            }
//            return 150;
//        } else if (_type == 2) {
//            KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row-1];
//            //            KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row-1];
//            if (liveF.live.hascourts == 3) { // hascourts
//                if (liveF.live.isDouble) {
//                    if (liveF.live.st2_h == -1) {
//                        return 70;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 90;
//                    } else {
//                        return 110;
//                    }
//                } else {
//                    if (liveF.live.st2_h == -1) {
//                        return 50;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 70;
//                    } else {
//                        return 90;
//                    }
//                }
//            } else if (liveF.live.hascourts == 5) {
//                if (liveF.live.isDouble) {
//                    if (liveF.live.st2_h == -1) {
//                        return 70;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 90;
//                    } else if (liveF.live.st4_h == -1) {
//                        return 110;
//                    } else if (liveF.live.st5_h == -1) {
//                        return 130;
//                    } else if (liveF.live.ot_h != -1) {
//                        return 170;
//                    } else {
//                        return 150;
//                    }
//                    return 150;
//                } else {
//                    if (liveF.live.st2_h == -1) {
//                        return 50;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 70;
//                    } else if (liveF.live.st4_h == -1) {
//                        return 90;
//                    } else if (liveF.live.st5_h == -1) {
//                        return 110;
//                    } else {
//                        return 130;
//                    }
//                }
//            }
//            //            if (liveF.live.hascourts == 3) { // hascourts
//            //                if (liveF.live.isDouble) {
//            //                    return 110;
//            //                } else {
//            //                    return 90;
//            //                }
//            //            } else if (liveF.live.hascourts == 5) {
//            //                if (liveF.live.isDouble) {
//            //                    return 150;
//            //                } else {
//            //                    return 130;
//            //                }
//            //            }
//            return 110;
//        } else {
//            return (_more.count + 1 ) * 20 + 5;
//        }
//    } else {
//        return 65;
//    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSceenWidth, 1)];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
   // return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.0f, kSceenWidth, 20)];
    view.backgroundColor = KSBackgroundGray;
    label.textColor = KSFontBlue;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.text = _allTitle[section];
    [view addSubview:label];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 50)];
//    UIView* spaceview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSceenWidth, 20.0f)];
//    [spaceview setBackgroundColor:[UIColor whiteColor]];
//    //[view addSubview:spaceview];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 22.0f, kSceenWidth, 20)];
//    view.backgroundColor = KSBackgroundGray;
//    //view.backgroundColor=[UIColor whiteColor];
//    label.textColor = KSFontBlue;
//    label.textAlignment = NSTextAlignmentLeft;
//    label.font = [UIFont systemFontOfSize:16];
//    label.text = _allTitle[section];
//    [view addSubview:label];

    
    return view;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if ([_sportType isEqualToString:@"A"] && section == _allData.count-1) {
//        return 30;
//    }
//    return 0.001;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if ([_sportType isEqualToString:@"A"] && section == _allData.count-1) {
//        UIButton *teamBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 30)];
//        [teamBtn setTitle:NSLocalizedStringFromTable(@"Click to load more", @"InfoPlist", nil) forState:UIControlStateNormal];
//        [teamBtn addTarget:self action:@selector(pushToTeamDetail) forControlEvents:UIControlEventTouchUpInside];
//        [teamBtn setTitleColor:KSBlue forState:UIControlStateNormal];
//        teamBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        return teamBtn;
//    }
//    return nil;
//}

#pragma mark -- 跳转到球队详情页
- (void)pushToTeamDetail {
    TeamInformationController *teamVC = [[TeamInformationController alloc] init];
    teamVC.type = _type;
    teamVC.teamid = _teamid;
    [self.navigationController pushViewController:teamVC animated:YES];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    KSExpansionCell *expansionCell = [[KSExpansionCell alloc] init];
//    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];
//    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + ExpandCount) {     // Expand Cell
//        if (_type == 1 || _type == 2) {
//            KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row - ExpandCount];
//            
//            expansionCell.liveF = liveF;
//            expansionCell.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//            //        cell = lcell;
//            return expansionCell;
//        } else {
//            KSExpansionCell *footballCell = [[KSExpansionCell alloc] init];
//            KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row - ExpandCount];
//            NSLog(@"hteamname%@",liveF.live.hteamname);
//            footballCell.live = liveF.live;
//            footballCell.more = _more;
//            footballCell.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//            //            expansionCell.count = 1;
//            return footballCell;
//        }
//        //                UITableViewCell *cell2 = [[UITableViewCell alloc] init];
//        //                return cell2;
//        
//    } else {    // Normal cell
////
//        cell.delegate = self;
//        if (_allData.count != 0) {
//            KSLiveFrame *liveF;
//            if (self.selectedIndexPath.section == indexPath.section) {
//                if (self.isExpand && self.selectedIndexPath.row < indexPath.row) {
//                    liveF = _allData[indexPath.section][indexPath.row - 1];
////                    NSLog(@"%i-%i",indexPath.section,indexPath.row);
//                    
//                } else {
//                    liveF = _allData[indexPath.section][indexPath.row];
////                    NSLog(@"%i-%i",indexPath.section,indexPath.row);
//                    
//                }
//            } else {
//                liveF = _allData[indexPath.section][indexPath.row];
//
//            }
//            
//            cell.liveF = liveF;
//            
//        }
//        return cell;
//
////
////        
//    }
    if (_type==0) {
        
        NSMutableArray *lives = _allData[indexPath.section];
        if (indexPath.row==lives.count) {
            KSTeamDetailTableViewCell* cell;
            cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
            if (cell==nil) {
                cell=[[KSTeamDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
                cell.pushAction=^(){
                    [self pushToTeamDetail];
                };
            }
           [ cell.titlelabel setTitle:NSLocalizedStringFromTable(@"Click to load more", @"InfoPlist", nil) forState:UIControlStateNormal];
//            UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 149, [UIScreen mainScreen].bounds.size.width, 1.0f)];
//            [separatorLine setBackgroundColor:[UIColor lightTextColor]];
           // [cell.contentView addSubview:separatorLine];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
           //cell.preservesSuperviewLayoutMargins=YES;
            return cell;
        }

    }
    
    
    
    
    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];
    cell.delegate = self;
    
    KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row];
    cell.liveF = liveF;
    
    if (liveF.isExpand && _type == 0) {
        KSLiveCell *footballCell = [[KSLiveCell alloc] init];
        footballCell.delegate = self;
        footballCell.liveF = liveF;
        return footballCell;
    }
//    if (_type==0) {
//        [cell.liveView.bottonview setHidden:NO];
//        cell.liveView.bottonview.frame=CGRectMake(0, cell.liveF.cellHeight-0.2f, [UIScreen mainScreen].bounds.size.width, 0.2f);
//        [cell.liveView.bottonview setBackgroundColor:[UIColor lightGrayColor]];
//    }

    return cell;
}

#pragma mark 点击扩展
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    
    if (_type == 0) {
     
        KSLiveFrame *liveFrame = _allData[indexPath.section][indexPath.row];
        liveFrame.isExpand = !liveFrame.isExpand;
        if (_type == 0) {
            NSIndexPath* targetindexpath;
            NSArray* newalldata=(NSArray*)_allData[indexPath.section];
            for (int i=0; i<newalldata.count; i++) {
                KSLiveFrame *subliveFrame =newalldata[i];
                if (subliveFrame.isExpand==YES&&i!=indexPath.row) {
                    subliveFrame.isExpand=NO;
                    if (_allTitle.count>1) {
                         targetindexpath=[NSIndexPath indexPathForRow:i inSection:1];
                    }else{
                        targetindexpath=[NSIndexPath indexPathForRow:i inSection:0];
                    }
                   
                }
            }
            
            NSLog(@"%@--%@",targetindexpath,indexPath);
            
            if (_type == 0) {
                [KSKuaiShouTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
                    //
                    if ([result count] == 0) {
                        liveFrame.live.isGoalEnpty = YES;
                        
                        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                        if (self.isExpand == YES && self.selectedIndexPath == indexPath) {
                            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    //            _more = [result mutableCopy];
                    liveFrame.live.more = [result mutableCopy];
                    if (targetindexpath!=nil) {
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath,targetindexpath] withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath,] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                }failure:^(NSError *error) {
                    
                }];
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                
               // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            
            }
        }
    }else{

    
    KSLiveFrame *liveFrame = _allData[indexPath.section][indexPath.row];
    liveFrame.isExpand = !liveFrame.isExpand;
    if (_type == 0) {
        if (self.selectedIndexPath) {
            if (self.isExpand) {
                if (self.selectedIndexPath == indexPath) {
                    self.isExpand = NO;
                    self.selectedIndexPath = nil;
                } else {
                    KSLiveFrame *select = _allData[self.selectedIndexPath.section][self.selectedIndexPath.row];
                    select.isExpand = NO;
                    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    self.isExpand = YES;
                    self.selectedIndexPath = indexPath;
                    //                    [self.tableView reloadSections:self.selectedIndexPath withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
        } else {
            self.isExpand = YES;
            self.selectedIndexPath = indexPath;
        }
        
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (_type == 0) {
        [KSKuaiShouTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
            //
            if ([result count] == 0) {
                liveFrame.live.isGoalEnpty = YES;
                
                NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                if (self.isExpand == YES && self.selectedIndexPath == indexPath) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            //            _more = [result mutableCopy];
            liveFrame.live.more = [result mutableCopy];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }failure:^(NSError *error) {
            
        }];
    }
    
    if (indexPath.section+1 == [_allData count] && indexPath.row+1 == [_allData[indexPath.section] count]) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
     
    }
    
}


- (void)followTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    //    NSLog(@"点击关注");
   KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row];
//    KSLiveFrame *liveF;
//    if (self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row < indexPath.row) {
//        liveF = _allData[indexPath.section][indexPath.row-1];
//    } else {
//        liveF = _allData[indexPath.section][indexPath.row];
//    }
    //    NSLog(@"赛事类型%@  type%li id%li",liveF.live.matchtypefullname,(long)_type,(long)liveF.live.match_id);
    NSInteger state;
    if (liveF.live.is_follow == 0) {
        state = 1;
    } else if (liveF.live.is_follow == 1){
        state = 2;
    }
    //    [_dataSource mutableCopy];
    
   
    
    [KSKuaiShouTool forceMatchWithState:state Type:_type withMatchID:liveF.live.match_id withCompleted:^(id result) {
        if ([result objectForKey:@"ret_code"] == 0) {
            if (liveF.live.is_follow == 0) {
                liveF.live.is_follow = 1;
            } else if (liveF.live.is_follow == 1){
                liveF.live.is_follow = 0;
            }
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setBool:NO forKey:@"followView"];
            [defaults synchronize];
            
        } else {
            if (liveF.live.is_follow == 0) {
                liveF.live.is_follow = 1;
            } else if (liveF.live.is_follow == 1){
                liveF.live.is_follow = 0;
            }
        }
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"followView"];
        [defaults synchronize];
     

//        NSIndexPath *index;
//        if (self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row < indexPath.row) {
////            liveF = _allData[indexPath.section][indexPath.row-1];
//            index = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
//            
//        } else {
////            liveF = _allData[indexPath.section][indexPath.row];
//            index = indexPath;
//        }
//        
//        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//        
//        NSLog(@"%i-%i",index.section,index.row);
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
           //[self.tableView reloadData];
        });
    }failure:^(NSError *error) {
        
    }];
    
}



//- (NSArray *)indexPathsForExpandSection:(NSInteger)section withRow:(NSInteger)row {
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    for (int i = 1; i <= ExpandCount; i++) {
//        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row inSection:section];
//        [indexPaths addObject:idxPth];
//    }
//    return [indexPaths copy];
//}

#pragma mark tabelView点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type==0) {
        
        NSMutableArray *lives = _allData[indexPath.section];
        if (indexPath.row==lives.count) {
            return;
        }
        
    }
//    if (_type == 0 || _type == 1) {
        KSLiveFrame *liveF;
        if (self.isExpand ) {
            if (self.selectedIndexPath.section == indexPath.section) {
                if (self.selectedIndexPath.row >= indexPath.row) {
                    liveF = _allData[indexPath.section][indexPath.row];
                } else if (self.selectedIndexPath.row < indexPath.row) {
                    liveF = _allData[indexPath.section][indexPath.row-1];
                }
            } else {
                liveF = _allData[indexPath.section][indexPath.row];
            }
            //            if ( self.selectedIndexPath.row != indexPath.row) {
            ////                NSLog(@"section=%li,row=%li,row-1=%li",(long)self.selectedIndexPath.row,(long)indexPath.row,indexPath.row-1);
            //
            //                liveF = _allData[indexPath.section][indexPath.row-1];
            //            } else {
            //                liveF = _allData[indexPath.section][indexPath.row];
            //            }
        } else {
            liveF = _allData[indexPath.section][indexPath.row];
        }
        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
        footballDetailVc.matchID = liveF.live.match_id;
        footballDetailVc.type = _type;
        if ([liveF.live.state isEqualToString:@"W"]) {
            footballDetailVc.state = 1;
        }
        [footballDetailVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:footballDetailVc animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UITableView *)createTableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStylePlain];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = NO;
       // tableView.tableFooterView = [[UIView alloc] init];
        [tableView registerClass:[KSLiveCell class] forCellReuseIdentifier:@"KSLiveCell"];
        [tableView registerClass:[KSExpansionCell class] forCellReuseIdentifier:@"KSExpansionCell"];
//        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
    }
    return _tableView;
}



#pragma mark 分类即时比分变化数据请求
- (void)updateLastLive
{
    if (_type == 0) {
        [self loadFootballLive];
//        [self addTimer];
//        [self addMinuteTimer];
    } else if (_type == 1 || _type == 2) {
        //@194942|0:04|4|96|98|20|27|22|20|42(-5)|47(89)|27|25|27|26|96(-2)|98(194)||
        [self loadBasketballLive];
//        [self addTimer];
    }
}

// 篮球最新变化
- (void)loadBasketballLive {
    [KSKuaiShouTool getBasketballAndTennisLiveWithType:_type withFlagNum:_matchID withCompleted:^(id responseObject) {
        LiveResult *last = [LiveResult mj_objectWithKeyValues:responseObject];
        self.live = [last.result mutableCopy];
        
        if (self.live.count > 0) {
            NSString *liveD = _live[0].d;
            _matchID = self.live[0].flag_num;
            
            NSMutableArray *match = [[liveD componentsSeparatedByString:@"@"] mutableCopy];
            for (int i = 0; i < match.count; i++) {
                
                [self.lastLive removeAllObjects];
                self.lastLive = [[match[i] componentsSeparatedByString:@"|"] mutableCopy];
//                NSMutableArray *liveFrame = _allData[0];
                
                KSLiveFrame *liveF = _allData[0][0];
                if ([_lastLive[0] intValue] == liveF.live.match_id) {
                    if (_type == 1) {

                        if (liveF.live.total_h != [_lastLive[3] integerValue] || liveF.live.total_c != [_lastLive[4] integerValue]) {
                            [liveF.live setValue:_lastLive[3] forKey:@"total_h"];
                            [liveF.live setValue:_lastLive[4] forKey:@"total_c"];
                        }
                        [liveF.live setValue:_lastLive[1] forKey:@"matchjs"];
                        [liveF.live setValue:_lastLive[2] forKey:@"state"];
                        
                        [liveF.live setValue:_lastLive[5] forKey:@"st1_h"];
                        [liveF.live setValue:_lastLive[6] forKey:@"st1_c"];
                        [liveF.live setValue:_lastLive[7] forKey:@"st2_h"];
                        [liveF.live setValue:_lastLive[8] forKey:@"st2_c"];
                        [liveF.live setValue:_lastLive[11] forKey:@"st3_h"];
                        [liveF.live setValue:_lastLive[12] forKey:@"st3_c"];
                        [liveF.live setValue:_lastLive[13] forKey:@"st4_h"];
                        [liveF.live setValue:_lastLive[14] forKey:@"st4_c"];
                    } else if (_type == 2) {
                        if (liveF.live.total_h < [_lastLive[3] integerValue] || liveF.live.total_c < [_lastLive[4] integerValue]) {
                            [liveF.live setValue:_lastLive[2] forKey:@"total_h"];
                            [liveF.live setValue:_lastLive[3] forKey:@"total_c"];
                        }
                        [liveF.live setValue:_lastLive[1] forKey:@"state"];
                        
                        [liveF.live setValue:_lastLive[4] forKey:@"st1_h"];
                        [liveF.live setValue:_lastLive[5] forKey:@"st1_c"];
                        [liveF.live setValue:_lastLive[6] forKey:@"st2_h"];
                        [liveF.live setValue:_lastLive[7] forKey:@"st2_c"];
                        [liveF.live setValue:_lastLive[8] forKey:@"st3_h"];
                        [liveF.live setValue:_lastLive[9] forKey:@"st3_c"];
                        [liveF.live setValue:_lastLive[10] forKey:@"st4_h"];
                        [liveF.live setValue:_lastLive[11] forKey:@"st4_c"];
                        [liveF.live setValue:_lastLive[12] forKey:@"st5_h"];
                        [liveF.live setValue:_lastLive[13] forKey:@"st5_c"];
                    }
                    
                    [_allData mutableCopy];
//                    if ([_allType containsObject:@"0"]) {
//                        [_allData[1] mutableCopy];
//                    } else {
//                        [_allData[0] mutableCopy];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        [self.tableView reloadData];
                        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                    });
                        
                    
                }
            }
        
    }failure:^(NSError *error) {
        
    }];
}

//- (void)loadTennisLive {
//    [KSLikeSportTool getBasketballAndTennisLiveWithType:2 withFlagNum:_tennisID withCompleted:^(id responseObject) {
//        LiveResult *last = [LiveResult mj_objectWithKeyValues:responseObject];
//        
//        self.live = [last.result mutableCopy];
//        if (self.live.count > 0) {
//            
//            NSString *liveD = _live[0].d;
//            _tennisID = self.live[0].flag_num;
//            NSMutableArray *match = [[liveD componentsSeparatedByString:@"@"] mutableCopy];
//            for (int i = 0; i < match.count; i++) {
//                
//                [self.lastLive removeAllObjects];
//                self.lastLive = [[match[i] componentsSeparatedByString:@"|"] mutableCopy];
//                NSMutableArray *liveFrame;
//                if ([_allType containsObject:@"0"] && [_allType containsObject:@"1"]) {
//                    liveFrame = _allData[2];
//                } else if ([_allType containsObject:@"0"] || [_allType containsObject:@"1"]) {
//                    liveFrame = _allData[1];
//                } else if ([_allType containsObject:@"2"]){
//                    liveFrame = _allData[0];
//                }
//                
//                for (int i = 0; i < liveFrame.count; i++) {
//                    KSLiveFrame *liveF = liveFrame[i];
//                    NSLog(@"%@ ---- %li",self.lastLive[0],(long)liveF.live.match_id);
//                    if ([_lastLive[0] intValue] == liveF.live.match_id) {
//                        
//                        if (liveF.live.total_h < [_lastLive[3] integerValue] || liveF.live.total_c < [_lastLive[4] integerValue]) {
//                            [liveF.live setValue:_lastLive[2] forKey:@"total_h"];
//                            [liveF.live setValue:_lastLive[3] forKey:@"total_c"];
//                        }
//                        [liveF.live setValue:_lastLive[1] forKey:@"state"];
//                        
//                        [liveF.live setValue:_lastLive[4] forKey:@"st1_h"];
//                        [liveF.live setValue:_lastLive[5] forKey:@"st1_c"];
//                        [liveF.live setValue:_lastLive[6] forKey:@"st2_h"];
//                        [liveF.live setValue:_lastLive[7] forKey:@"st2_c"];
//                        [liveF.live setValue:_lastLive[8] forKey:@"st3_h"];
//                        [liveF.live setValue:_lastLive[9] forKey:@"st3_c"];
//                        [liveF.live setValue:_lastLive[10] forKey:@"st4_h"];
//                        [liveF.live setValue:_lastLive[11] forKey:@"st4_c"];
//                        [liveF.live setValue:_lastLive[12] forKey:@"st5_h"];
//                        [liveF.live setValue:_lastLive[13] forKey:@"st5_c"];
//                        
//                        
//                        if ([_allType containsObject:@"0"] && [_allType containsObject:@"1"]) {
//                            [_allData[2] mutableCopy];
//                        } else if ([_allType containsObject:@"0"] || [_allType containsObject:@"1"]) {
//                            [_allData[1] mutableCopy];
//                        } else {
//                            [_allData[0] mutableCopy];
//                        }
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                            [self.tableView reloadData];
//                        });
//                        
//                    }
//                }
//            }
//        }
//    }failure:^(NSError *error) {
//        
//    }];
//}


//- (void)getID {
//    // 取到数据就把ID加1，取不到数据就继续取
//    
//    // 获取变化ID
//    [KSHttpTool GETWithURL:@"http://app.likesport.com/api/live/match_flagid_json_get?" params:nil success:^(id responseObject) {
//        NSInteger matchid = [[responseObject objectForKey:@"result"] intValue];
//        if (_matchID != matchid) {
//            _matchID = matchid;
//            [self loadFootballLive];
//        }
//        
//    }failure:nil];
//    //    [self reload];
//    
//    //    [self dataUpdate];
//    //    dispatch_async(dispatch_get_main_queue(), ^{
//    //        [self.tableView reloadData];
//    //    });
//}

// 获取足球最新变化
- (void)loadFootballLive{
    
    //1. url
    NSString *urlStr = [NSString stringWithFormat:@"http://s.likesport.com/updateData/%li.xml",(long)_matchID];
    
    //    NSLog(@"之前ID=%li",(long)_matchID);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    //2. 请求
    //3. 连接
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (![data isEqual:@"<>"]) {
//            [self analysisXML:data];
        [self handAnalysisXML:data];
//        }
        
    }];
    [dataTask resume];
    
}

- (void)handAnalysisXML:(NSData *)data {
    NSString *searchText  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = NULL;
    NSRegularExpression *fn = [NSRegularExpression regularExpressionWithPattern:@"<Fn>.*?</Fn>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *fnResult = [fn firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    NSString *Fn = [searchText substringWithRange:fnResult.range];
    Fn = [Fn stringByReplacingOccurrencesOfString:@"<Fn>" withString:@""];
    Fn = [Fn stringByReplacingOccurrencesOfString:@"</Fn>" withString:@""];
    //    NSLog(@"Fn=%@",Fn);
    // 判断请求到的ID是否正确，正解就把ID加1继续请求
    if (_matchID == [Fn intValue]) {
        _matchID++;
    }
    
    NSRegularExpression *rst = [NSRegularExpression regularExpressionWithPattern:@"<Rst>.*?</Rst>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *rstResult = [rst firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    NSString *Rst = [searchText substringWithRange:rstResult.range];
    Rst = [Rst stringByReplacingOccurrencesOfString:@"<Rst>" withString:@""];
    Rst = [Rst stringByReplacingOccurrencesOfString:@"</Rst>" withString:@""];
    //    NSLog(@"Rst=%@",Rst);
    
    if ([Rst isEqualToString:@"Y"] || [Rst isEqualToString:@"L"]) {
//        [self updateDataWithMatchID:[Fn intValue]];
        
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<C>.*?</C>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *array = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    for (NSTextCheckingResult *result in array) {
        NSString *C = [searchText substringWithRange:result.range];
        C = [C stringByReplacingOccurrencesOfString:@"<C>" withString:@""];
        C = [C stringByReplacingOccurrencesOfString:@"</C>" withString:@""];
        
        NSMutableArray *lastLive = [[C componentsSeparatedByString:@"|"] mutableCopy];
        KSLiveFrame *liveF = _allData[0][0];
        //            NSLog(@"%li----%@",(long)liveF.live.match_id,lastLive[0]);
        //            KSLiveFrame *liveF = self.liveFrames[i];
        if ([lastLive[0] intValue] == liveF.live.match_id) {
            
            //
            //                NSLog(@"之前主队%ld",(long)liveF.live.total_h);
            //                NSLog(@"之前客队%ld",(long)liveF.live.total_c);
            
            if (liveF.live.total_h  != [lastLive[2] integerValue] || liveF.live.total_c  != [lastLive[3] integerValue]) {
                [liveF.live setValue:lastLive[2] forKey:@"total_h"];
                [liveF.live setValue:lastLive[3] forKey:@"total_c"];
                
            }
            [liveF.live setValue:lastLive[1] forKey:@"state"];
            [liveF.live setValue:lastLive[4] forKey:@"rcard_h"];
            [liveF.live setValue:lastLive[5] forKey:@"rcard_c"];
            
            [_allData mutableCopy];
            //                NSLog(@"之后主队%ld",(long)liveF.live.total_h);
            //                NSLog(@"之后客队%ld",(long)liveF.live.total_c);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                //                    [self.tableView reloadData];
            });
        }
        //        NSLog(@"C=%@",C);
    }
    
}

- (void)analysisXML:(NSData *)data {
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *users = [rootElement elementsForName:@"R"];
    
    for (GDataXMLElement *user in users) {
        
        //获取Rst节点的值
        GDataXMLElement *RstElement = [[user elementsForName:@"Rst"] objectAtIndex:0];
        NSString *Rst = [RstElement stringValue];
        //            NSLog(@"R Rst is:%@",Rst);
        //R\Rst    是否刷新全盘数据   默认N  ，Y时重新请求全盘数据
        if ([Rst isEqualToString:@"Y"] || [Rst isEqualToString:@"L"]) {
            GDataXMLElement *FnElement = [[user elementsForName:@"Fn"] objectAtIndex:0];
//            NSString *Fn = [FnElement stringValue];
            //            [self updateDataWithPage:0 with:[Fn intValue]];
            
//            [self setDataWithMatchID:[Fn intValue]];
            NSLog(@"------------刷全盘");
        }
        //获取Fn节点的值
        GDataXMLElement *FnElement = [[user elementsForName:@"Fn"] objectAtIndex:0];
        NSString *Fn = [FnElement stringValue];
        // 判断请求到的ID是否正确，正解就把ID加1继续请求
        if (_matchID == [Fn intValue]) {
            _matchID++;
        }
        
        //获取C节点的值
        GDataXMLElement *match = [[user elementsForName:@"C"] objectAtIndex:0];
        //            NSArray *matchs = [user elementsForName:@"C"];
        //            for (GDataXMLElement *match in matchs) {
        NSString *C = [match stringValue];
        //        [self.lastLive removeAllObjects];
        NSArray *lastLive = [[C componentsSeparatedByString:@"|"] mutableCopy];
        NSLog(@"matchID%@",lastLive[0]);
        NSLog(@"-------------有新数据");
        
        
        NSLog(@"count = %lu",(unsigned long)self.live.count);
//        NSMutableArray *liveFrame;
//        if ([_allType containsObject:@"0"]) {
//            liveFrame = _allData[0];
//        }
        
//        for (int i = 0; i < liveFrame.count; i++) {
            KSLiveFrame *liveF = _allData[0][0];
//            NSLog(@"%li----%@",(long)liveF.live.match_id,lastLive[0]);
            //            KSLiveFrame *liveF = self.liveFrames[i];
            if ([lastLive[0] intValue] == liveF.live.match_id) {
                
                //
//                NSLog(@"之前主队%ld",(long)liveF.live.total_h);
//                NSLog(@"之前客队%ld",(long)liveF.live.total_c);
                
                if (liveF.live.total_h  != [lastLive[2] integerValue] || liveF.live.total_c  != [lastLive[3] integerValue]) {
                    [liveF.live setValue:lastLive[2] forKey:@"total_h"];
                    [liveF.live setValue:lastLive[3] forKey:@"total_c"];
                    
                }
                [liveF.live setValue:lastLive[1] forKey:@"state"];
                [liveF.live setValue:lastLive[4] forKey:@"rcard_h"];
                [liveF.live setValue:lastLive[5] forKey:@"rcard_c"];
                
                [_allData mutableCopy];
//                NSLog(@"之后主队%ld",(long)liveF.live.total_h);
//                NSLog(@"之后客队%ld",(long)liveF.live.total_c);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
//                    [self.tableView reloadData];
                });
            }
//        }
    }
    
}

#pragma mark 添加或移除定时器
- (void)addTimer {
    if (!_isTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateLastLive) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        _isTimer = YES;
//        NSLog(@"添加定时器1");
    }
}

- (void)addMinuteTimer
{
    if (!_isMinuteTimer) {
        self.minuteTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.minuteTimer forMode:NSRunLoopCommonModes];
        _isMinuteTimer = YES;
//        NSLog(@"添加定时器2");
    }
}

// 刷新表格
- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)removeTimer {
    if (_isTimer) {
        [self.timer invalidate];
        _isTimer = NO;
//        NSLog(@"移除定时器1");
    }
    
}

- (void)removeMinuteTimer
{
    if (_isMinuteTimer) {
        [self.minuteTimer invalidate];
        _isMinuteTimer = NO;
//        NSLog(@"移除定时器2");
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_hasLive) {
        [self addTimer];
        if (_type == 0) {
            [self addMinuteTimer];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeTimer];
    [self removeMinuteTimer];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
