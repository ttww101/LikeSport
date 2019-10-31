//
//  SettingViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "SettingViewController.h"
#import "KSHttpTool.h"
#import "KSKuaiShouTool.h"
#import "Login.h"
#import "ModifyPasswordController.h"
#import "UserInfoSetting.h"

//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "KSFontSizeController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *allData;
@property (weak, nonatomic) UISwitch *switchBtn;
@property (nonatomic, strong) XGStateResult *xgState;
@property (nonatomic, strong) NSArray<XGStateResult *> *allBtnState;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setBackBtn];
    [self setData];
    //    "Text Size"="Text Size";
    //    "Standard"="Standard";
    self.navigationItem.title = NSLocalizedStringFromTable(@"Setting", @"InfoPlist", nil);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setData {
    // 获取开关状态
    NSString *url = [[NSString alloc] initWithFormat:@"http://app.likesport.com/api/users/xgstate_get?"];
//    if ([self checkLogin]) {
//        _allData = @[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil)];
//        _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil),        NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)],
//                     @[NSLocalizedStringFromTable(@"Change the password", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Sign out", @"InfoPlist", nil)]];
//    } else {
        _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil),        NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)]
//                     ,@[NSLocalizedStringFromTable(@"Text Size", @"InfoPlist", nil)]
                     ];
//    }
//    [self.tableView reloadData];
    
    [KSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        
        _xgState = [XGStateResult mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
        
        if (_xgState.state == 1) {
//            if ([self checkLogin]) {
//                _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil),        NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)],
//                             @[NSLocalizedStringFromTable(@"Change the password", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Sign out", @"InfoPlist", nil)]];
//            } else {
                _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil),        NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)]
//                             ,@[NSLocalizedStringFromTable(@"Text Size", @"InfoPlist", nil)]
                             ];
//            }
            
        } else if (_xgState.state == 2) {
//            if ([self checkLogin]) {
//                _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil)],
//                             @[NSLocalizedStringFromTable(@"Change the password", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Sign out", @"InfoPlist", nil)]];
//            } else {
                _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil)]
//                             ,@[NSLocalizedStringFromTable(@"Text Size", @"InfoPlist", nil)]
                             ];
//            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
            
    }];

}

- (void)setBackBtn {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Setting", @"InfoPlist", nil)];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [backBtn setTitle:NSLocalizedStringFromTable(@"Back", @"InfoPlist", nil) forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [backBtn addTarget:self action:@selector(didClickedBackButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];

    [bar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:bar];

    //    [someButton setShowsTouchWhenHighlighted:YES];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = mailbutton;
}

- (void)didClickedBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *match = _allData[section];
    return match.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _allData.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kSceenWidth - 60, 4, 30, 25)];
        [switchBtn addTarget:self action:@selector(switchBtnDidChange) forControlEvents:UIControlEventValueChanged];
//        switchBtn.thumbTintColor = KSBlue; //滑块颜色
        switchBtn.onTintColor = KSBlue;
//        switchBtn.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"switchType"]; // 按钮状态
        switchBtn.on = NO;
        if (_xgState.state == 1) {
            switchBtn.on = YES;
        } else if (_xgState.state == 2) {
            switchBtn.on = NO;
        }
        [cell addSubview:switchBtn];
        
        _switchBtn = switchBtn;
        
    } else if (indexPath.section == 0 && indexPath.row != 0) {
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-80, 0, 80, 40)];
        [button2 setImage:[UIImage  imageNamed:@"check_false-1"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"check_true-1"] forState:UIControlStateSelected];
//        button2.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 5, 0);
        button2.titleLabel.font = [UIFont systemFontOfSize:15];
        [button2 setTitle:NSLocalizedStringFromTable(@"Results", @"InfoPlist", nil) forState:UIControlStateNormal];
        [button2 setTitleColor:KSBlue forState:UIControlStateNormal];
//        [button2 setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [cell addSubview:button2];
        [button2 addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = indexPath.row * 10 + 2;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-160, 0, 80, 40)];
        [button setImage:[UIImage  imageNamed:@"check_false-1"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"check_true-1"] forState:UIControlStateSelected];
//        button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 5, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:NSLocalizedStringFromTable(@"Instant", @"InfoPlist", nil) forState:UIControlStateNormal];
        [button setTitleColor:KSBlue forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [cell addSubview:button];
        [button addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = indexPath.row * 10 + 1;
        
        switch (indexPath.row) {
            case 1:
                if (_xgState.mtype0_state == 0) {
                    button2.selected = NO;
                    button.selected = NO;
                } else if (_xgState.mtype0_state == 1) {
                    button2.selected = NO;
                    button.selected = YES;
                } else if (_xgState.mtype0_state == 2) {
                    button2.selected = YES;
                    button.selected = NO;
                }
                break;
            case 2:
                if (_xgState.mtype1_state == 0) {
                    button2.selected = NO;
                    button.selected = NO;
                } else if (_xgState.mtype1_state == 1) {
                    button2.selected = NO;
                    button.selected = YES;
                } else if (_xgState.mtype1_state == 2) {
                    button2.selected = YES;
                    button.selected = NO;
                }
                break;
            case 3:
                if (_xgState.mtype2_state == 0) {
                    button2.selected = NO;
                    button.selected = NO;
                } else if (_xgState.mtype2_state == 1) {
                    button2.selected = NO;
                    button.selected = YES;
                } else if (_xgState.mtype2_state == 2) {
                    button2.selected = YES;
                    button.selected = NO;
                }
                break;
                
            default:
                break;
        }


    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _allData[indexPath.section][indexPath.row];
    return cell;
}

// 推送内容详细开关
- (void)didClick:(UIButton *)sender {
//    sender.selected = !sender.selected;

//    NSLog(@"点击了第%i个按钮",sender.tag);
    switch (sender.tag) {
        case 11:
            if (_xgState.mtype0_state == 1) {
                _xgState.mtype0_state = 0;
            } else {
                _xgState.mtype0_state = 1;
            }
            break;
        case 12:
            if (_xgState.mtype0_state == 2) {
                _xgState.mtype0_state = 0;
            } else {
                _xgState.mtype0_state = 2;
            }
            break;
        case 21:
            if (_xgState.mtype1_state == 1) {
                _xgState.mtype1_state = 0;
            } else {
                _xgState.mtype1_state = 1;
            }
            break;
            
        case 22:
            if (_xgState.mtype1_state == 2) {
                _xgState.mtype1_state = 0;
            } else {
                _xgState.mtype1_state = 2;
            }
            break;

        case 31:
            if (_xgState.mtype2_state == 1) {
                _xgState.mtype2_state = 0;
            } else {
                _xgState.mtype2_state = 1;
            }
            break;
        case 32:
            if (_xgState.mtype2_state == 2) {
                _xgState.mtype2_state = 0;
            } else {
                _xgState.mtype2_state = 2;
            }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];

    [KSKuaiShouTool settingXGWithState:_xgState.mj_keyValues withCompleted:^(id result) {
//        Login *last = [Login mj_objectWithKeyValues:result];
//        if (last.ret_code == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
//    _isHomeAway = !_isHomeAway;
//    [self.tableView reloadData];
    
}

- (void) switchBtnDidChange {

    
    if (_xgState.state == 2) {
        _xgState.state = 1;
    } else if (_xgState.state == 1) {
        _xgState.state = 2;
    }
    
    if (_xgState != nil) {
        [KSKuaiShouTool settingXGWithState:_xgState.mj_keyValues withCompleted:^(id result) {
            Login *last = [Login mj_objectWithKeyValues:result];
            if (last.ret_code == 0) {
                
                if (_xgState.state == 1) {
                    _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil),        NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)],@[NSLocalizedStringFromTable(@"Text Size", @"InfoPlist", nil)]];

                } else if (_xgState.state == 2) {
                    _allData = @[@[NSLocalizedStringFromTable(@"Push my attention", @"InfoPlist", nil)],@[NSLocalizedStringFromTable(@"Text Size", @"InfoPlist", nil)]];

                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section == 0 && indexPath.row == 0) {
        [self switchBtnDidChange];
    } else if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            KSFontSizeController *vc = [[KSFontSizeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {

        }
        
    }

}

#pragma mark -- 退出登陆
- (void)cancelLogin{
    
    // 退出facebook登陆
//    FBSDKLoginManager *login=[[FBSDKLoginManager alloc]init];
//    [login logOut];
    if (self.tokenBlock) {
        self.tokenBlock();
    }
}

#pragma mark private method

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStyleGrouped];
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.tableFooterView = [[UIView alloc] init];
//        [tableView registerNib:[UINib nibWithNibName:@"LeagueCell" bundle:nil] forCellReuseIdentifier:@"leagueCell"];
        
        //        [tableView registerClass:[KSLiveCell class] forCellReuseIdentifier:@"KSLiveCell"];
        //        [tableView registerClass:[KSExpansionCell class] forCellReuseIdentifier:@"KSExpansionCell"];
        //        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        
        //        UIRefreshControl *control=[[UIRefreshControl alloc]init];
        //        [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
        //        [tableView addSubview:control];
        //        [control beginRefreshing];
        //        [self refreshStateChange:control];
        
        //        _tableView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
        
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 200)];
        //        tableView.tableHeaderView = view;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


// 分割线对齐左边
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (XGStateResult *)xgState {
//    if (!_xgState) {
//        _xgState = [[XGStateResult alloc] init];
//    }
//    return _xgState;
//}

#pragma mark -- 查看用户是否有登陆
- (BOOL)checkLogin {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出name
    BOOL isLogin;
    if (token.length == 0) {
        isLogin = NO;
    } else {
        isLogin = YES;
    }
    return isLogin;
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
