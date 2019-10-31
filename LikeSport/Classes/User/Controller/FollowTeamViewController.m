//
//  FollowTeamViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/26.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "FollowTeamViewController.h"
#import "KSLiveCell.h"
#import "KSTabBarController.h"
#import "KSKuaiShouTool.h"
#import "League.h"
#import "LeagueCell.h"
#import "TeamInformationController.h"

@interface FollowTeamViewController ()<UITableViewDelegate, UITableViewDataSource,LeagueCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) NSMutableArray *allTitle;
@property (nonatomic, strong) NSMutableArray *allType;

//@property (nonatomic, strong) LeagueResult *leagueResult;
@property (weak, nonatomic) UILabel *label;

@end

@implementation FollowTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView reloadData];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    
    self.title = NSLocalizedStringFromTable(@"Focus on the team", @"InfoPlist", nil);
    
    if (token.length > 0){
        [self setData];
    } else {
        self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
    }

}

- (void)setData {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"token"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });
    
    [KSKuaiShouTool getTeamListWithUserID:userid withCompleted:^(id result) {
        League *last = [League mj_objectWithKeyValues:result];
        
        _allData = [NSMutableArray arrayWithCapacity:2];
        _allTitle = [NSMutableArray arrayWithCapacity:3];
        _allType = [NSMutableArray arrayWithCapacity:3];
        //        _allData = last.result;
        //        NSArray *array;
        if (last.result.t0.count > 0) {
            //            array = [last.result.t0 mutableCopy];
            //            [_allData addObject:array];
            [_allData addObject:last.result.t0];
            [_allTitle addObject:NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil)];
            [_allType addObject:@"0"];
        }
        
        if (last.result.t1.count > 0) {
            //            array = [last.result.t1 mutableCopy];
            //            [_allData addObject:array];
            [_allData addObject:last.result.t1];
            [_allTitle addObject:NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil)];
            [_allType addObject:@"1"];
        }
        
//        if (last.result.t2.count > 0) {
//            //            array = [last.result.t1 mutableCopy];
//            //            [_allData addObject:array];
//            [_allData addObject:last.result.t2];
//            [_allTitle addObject:NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)];
//            [_allType addObject:@"2"];
//        }
        
        [_allData mutableCopy];
        NSLog(@"allData=%lu",(unsigned long)_allData.count);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //            [self.tableView.mj_header endRefreshing];
            [hud hideAnimated:YES];
            if (_allData.count == 0) {
                self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
            }
            
        });
    } failure:^(NSError *error) {
        [self networdError];
        
        [hud hideAnimated:YES];
        
    }];
    
}

#pragma mark -- 网络出错
-(void)networdError {
    if (_allData.count > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:1] animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.f];
        hud.label.numberOfLines = 3;
        hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
    } else {
        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        self.label.hidden = NO;
    }
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *match = _allData[section];
    return match.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _allType.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    
    label.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:236/255.0 alpha:1];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    label.text = _allTitle[section];
    
    
    return label;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeagueCell *cell = [LeagueCell cellWithTableView:tableView];
    T0 *t0 = _allData[indexPath.section][indexPath.row];
    //    t0.is_follow = 1;
    cell.t1 = t0;
    cell.delegate = self;
    return cell;
}

#pragma mark tabelView点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    T0 *t0 = _allData[indexPath.section][indexPath.row];
    if (t0.mtype == 0 || t0.mtype == 1) {
        TeamInformationController *teamVC = [[TeamInformationController alloc] init];
        teamVC.type = t0.mtype;
        teamVC.teamid = t0.team_id;
        [self.navigationController pushViewController:teamVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark private method

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStylePlain];
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView registerNib:[UINib nibWithNibName:@"LeagueCell" bundle:nil] forCellReuseIdentifier:@"leagueCell"];
        

        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)followMatch:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    T0 *match = _allData[indexPath.section][indexPath.row];
    //    NSLog(@"赛事类型%@  type%li id%li",liveF.live.matchtypefullname,(long)_type,(long)liveF.live.match_id);
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    
    if (token.length > 0) {
        
        NSInteger state = 0;
        if (match.is_follow == 0) {
            state = 2;
        } else if (match.is_follow == 1){
            state = 1;
        }
//        NSDictionary *param = @{@"mtype":[NSString stringWithFormat:@"%i",match.mtype],@"ptype":@3,@"mid":[NSString stringWithFormat:@"%i",match.team_id],@"status":[NSString stringWithFormat:@"%i",state]};
        NSDictionary *param = @{@"mtype":[NSString stringWithFormat:@"%li",(long)match.mtype],@"ptype":@2,@"mid":[NSString stringWithFormat:@"%li",(long)match.team_id],@"status":[NSString stringWithFormat:@"%li",(long)state]};
        [KSKuaiShouTool followMatchWithParam:param withCompleted:^(id result) {
            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (match.is_follow == 0) {
                    match.is_follow = 1;
                } else if (match.is_follow == 1){
                    match.is_follow = 0;
                }
            } else {
                if (match.is_follow == 0) {
                    match.is_follow = 1;
                } else if (match.is_follow == 1){
                    match.is_follow = 0;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"followView"];
            [defaults synchronize];
        } failure:^(NSError *error) {
            
        }];
        
    
    } else {
       
        [self.tableView reloadData];
        
    }
    
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth-220)/2 , 110, 220, 40)];
        label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:label];
        //        [self.view insertSubview:label atIndex:1];
        _label = label;
    }
    return _label;
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
