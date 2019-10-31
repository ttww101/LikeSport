//
//  TeamInformationController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/23.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "TeamInformationController.h"
#import "KSKuaiShouTool.h"
#import "Team.h"
#import "KSBattleCell.h"
#import "Btn_TableView.h"
#import "KSAnalyse.h"
#import "KSBasketAnalyse.h"
#import "LoginViewController.h"



@interface TeamInformationController ()<UITableViewDelegate, UITableViewDataSource,Btn_TableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) TeamResult *teamResult;
@property (weak, nonatomic) UIButton *followBtn;
@property (strong , nonatomic) Btn_TableView *m_btn_tableView;
@property (nonatomic, copy) NSString *dropMenoBtnName;
@property (nonatomic, strong) NSArray *dropMenoNameArray;
@property (nonatomic, strong) NSMutableArray *allData;

@end

@implementation TeamInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationTitleCenter];
    
    
    
    [self getTeamInfo];
    
////    [self addRightBtnWithImgName:@"follow" andSelector:@selector(followTeam)];
//    UIBarButtonItem *followBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"follow"] style:UIBarButtonItemStylePlain target:self action:@selector(followTeam)];
//    followBtn seti
//    UIBarButtonItem *followBtn =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Send", @"InfoPlist", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didClickSaveBtn)];
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [followBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"followed"] forState:UIControlStateHighlighted];
    [followBtn addTarget:self action:@selector(followTeam) forControlEvents:UIControlEventTouchUpInside];
    //    [someButton setShowsTouchWhenHighlighted:YES];
//    [followBtn setAdjustsImageWhenHighlighted:YES];
    _followBtn = followBtn;
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:followBtn];
    self.navigationItem.rightBarButtonItem = mailbutton;
    
//    NSLog(@"followTeamParam=%@",_teamResult.team_stage.mj_JSONString);

    [self createTableView];

}

#pragma mark -- 关注球队
- (void)followTeam {
    _followBtn.highlighted = YES;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    
    if (token.length > 0) {
        
        NSInteger state = 0;
        if (_teamResult.info.is_follow == 0) {
            state = 1;
        } else if (_teamResult.info.is_follow == 1){
            state = 2;
        }
        NSDictionary *param = @{@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"ptype":@2,@"mid":[NSString stringWithFormat:@"%li",(long)_teamid],@"status":[NSString stringWithFormat:@"%li",(long)state]};
//        NSLog(@"followTeam=%@",param.mj_JSONString);
        [KSKuaiShouTool followMatchWithParam:param withCompleted:^(id result) {
            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (_teamResult.info.is_follow == 0) {
                    _teamResult.info.is_follow = 1;
                    _followBtn.highlighted = YES;
                } else if (_teamResult.info.is_follow == 1){
                    _teamResult.info.is_follow = 0;
                    _followBtn.highlighted = NO;
                }
            } else {
                if (_teamResult.info.is_follow == 0) {
                    _teamResult.info.is_follow = 1;
                    _followBtn.highlighted = YES;
                } else if (_teamResult.info.is_follow == 1){
                    _teamResult.info.is_follow = 0;
                    _followBtn.highlighted = NO;

                }
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
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
            
            [self followTeam];
        };
        [loginVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}


// 设置导航条头居中，返回按钮中的文字不显示
- (void)setUpNavigationTitleCenter
{
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }
}

#pragma mark -- 获取球队详情资料
- (void)getTeamInfo {
    NSDictionary *params = @{@"MType":[NSString stringWithFormat:@"%li",(long)_type],@"teamid":[NSString stringWithFormat:@"%li",(long)_teamid]};
    NSLog(@"teamid=%li",(long)_teamid);
    [KSKuaiShouTool getTeamInfoWithParams:params withCompleted:^(id result) {
        Team *team = [Team mj_objectWithKeyValues:result];
        _teamResult = team.result;
        self.navigationItem.title = team.result.info.teamname;
        if (_teamResult.info.is_follow == 0) {
            _followBtn.highlighted = NO;
        } else if (_teamResult.info.is_follow == 1) {
            _followBtn.highlighted = YES;
        }
        NSMutableArray *array = [NSMutableArray array];
        for (Team_Stage *teamStage in _teamResult.team_stage) {
            if (teamStage.is_cur == 1) {
                _dropMenoBtnName = teamStage.matchtypefullname;
//                self.m_btn_tableView.m_Btn_Name = teamStage.matchtypefullname;
                [self setDataWithTeamStage:teamStage andBtnName:teamStage.matchtypefullname];
            }
            [array addObject:teamStage.matchtypefullname];
        }
        _dropMenoNameArray = [array mutableCopy];
        
        [self createHeadView];
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_btn_tableView.m_Btn_Name = _dropMenoBtnName;
            if ([_dropMenoBtnName isEqualToString:@""]) {
//                self.m_btn_tableView.m_Btn_Name = _dropMenoNameArray[0];
                NSArray *team = _teamResult.team_stage;
                Team_Stage *teamStage = team[0];
                [self setDataWithTeamStage:teamStage andBtnName:_dropMenoNameArray[0]];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}


- (void)createHeadView{
    // 获取主队图片
    NSString *taemSign = [NSString string];
    NSString *htog = [NSString string];
    NSString *ctog = [NSString string];
    if (_type == 0) {
        taemSign = @"TeamSign";
        htog = @"HTeamTog";
        ctog = @"CTeamTog";
    } else if (_type == 1){
        taemSign = @"TeamSign_BT";
        htog = @"HTeamTog_BT";
        ctog = @"CTeamTog_BT";
    }
    
    NSString *hteamUrl = [[NSString alloc] initWithFormat:@"http://www.likesport.com/MPIC/%@/%li.jpg",taemSign,(long)_teamid];
    NSString *hteamtog = [[NSString alloc] initWithFormat:@"http://www.likesport.com/MPIC/%@/%li.jpg",htog,(long)_teamid];
    NSString *cteamtog = [[NSString alloc] initWithFormat:@"http://www.likesport.com/MPIC/%@/%li.jpg",ctog,(long)_teamid];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 100)];
//    view.backgroundColor = KSBlue;
    CGFloat x = (kSceenWidth-3*80)/4;
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(2*x, 10, 80, 80)];
    [flagView sd_setImageWithURL:[NSURL URLWithString:hteamUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    flagView.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:flagView];
    
    UIImageView *hteamView = [[UIImageView alloc] initWithFrame:CGRectMake(3*x+80, 10, 80, 80)];
    [hteamView sd_setImageWithURL:[NSURL URLWithString:hteamtog] placeholderImage:[UIImage imageNamed:@"cloth_no"]];
    hteamView.contentMode =  UIViewContentModeScaleAspectFit;
    [view addSubview:hteamView];
    
    UIImageView *cteamView = [[UIImageView alloc] initWithFrame:CGRectMake(3*x+160, 10, 80, 80)];
    [cteamView sd_setImageWithURL:[NSURL URLWithString:cteamtog] placeholderImage:[UIImage imageNamed:@"cloth_no"]];
    cteamView.contentMode =  UIViewContentModeScaleAspectFit;
    [view addSubview:cteamView];
    

    self.tableView.tableHeaderView = view;
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSMutableArray *lives = _allData[section];
//    if (self.isExpand && self.selectedIndexPath.section == section) {
//        return lives.count + ExpandCount;
//    }
//    return lives.count;
        return _allData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 35)];
    self.m_btn_tableView = [[Btn_TableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 35)];
    self.m_btn_tableView.delegate_Btn_TableView = self;
    
    if ([_dropMenoBtnName isEqualToString:@""]) {
        self.m_btn_tableView.m_Btn_Name = _dropMenoNameArray[0];
//        [self.m_btn_tableView setM_Btn_Name:_dropMenoNameArray[0]];
    } else {
        self.m_btn_tableView.m_Btn_Name = _dropMenoBtnName;
//        [self.m_btn_tableView setM_Btn_Name:_dropMenoBtnName];
    }
    
    self.m_btn_tableView.tableViewHeigh = 34*(_dropMenoNameArray.count+1);
    
    self.m_btn_tableView.backgroundColor = KSBackgroundGray;
    
    self.m_btn_tableView.btnTitleColor = KSFontBlue;
    
    self.m_btn_tableView.cellColor = KSBackgroundGray;
    self.m_btn_tableView.isDownImage = YES;
    
    self.m_btn_tableView.m_TableViewData = _dropMenoNameArray;
    [self.m_btn_tableView addViewData];

    [view addSubview:self.m_btn_tableView];
    return self.m_btn_tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSBattleCell *cell = [KSBattleCell cellWithTableView:tableView];
    if(_type == 0) {
        Pk_Data *pkData = [Pk_Data mj_objectWithKeyValues:_allData[indexPath.row]];

        pkData.hteamid = _teamid;
        pkData.cteamid = _teamid;

    pkData.isTeamInfo = YES;
        cell.pkData = pkData;
    } else if (_type == 1) {
        BasketPk_Data *pkData = [BasketPk_Data mj_objectWithKeyValues:_allData[indexPath.row]];

        pkData.hteamid = _teamid;
        pkData.cteamid = _teamid;

        pkData.isTeamInfo = YES;

        cell.basketPkData = pkData;
    }
    cell.userInteractionEnabled = NO;

    return cell;

}



- (UITableView *)createTableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStylePlain];
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView registerNib:[UINib nibWithNibName:@"KSBattleCell" bundle:nil] forCellReuseIdentifier:@"battleCell"];
        
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark -- 下拉按钮的回调
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *team = _teamResult.team_stage;
    Team_Stage *teamStage = team[indexPath.row];
    
    [self setDataWithTeamStage:teamStage andBtnName:_dropMenoNameArray[indexPath.row]];

}

- (void)setDataWithTeamStage:(Team_Stage *)teamStage andBtnName:(NSString *)btnName {
    
    NSDictionary *params = @{@"MType":[NSString stringWithFormat:@"%li",(long)_type],@"teamid":[NSString stringWithFormat:@"%li",(long)_teamid],@"stage_id":[NSString stringWithFormat:@"%li",(long)teamStage.stage_id],@"moment_id":[NSString stringWithFormat:@"%li",(long)teamStage.moment_id]};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the bar determinate mode to show task progress.
    
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(3.);
    });
    
    [KSKuaiShouTool getTeamLeagueWithParams:params withCompleted:^(id result) {
        TeamStageResult *analyse = [TeamStageResult mj_objectWithKeyValues:result];
        if (analyse.ret_code == 0) {
            [_allData removeAllObjects];

            _allData = [analyse.result mutableCopy];
            
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_btn_tableView.m_Btn_Name = btnName;
                [hud hideAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        
    }];

    
}

- (NSMutableArray<Pk_Data *> *)allData {
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
