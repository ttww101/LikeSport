//
//  UserController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/15.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "MeController.h"
#import "FollowLeagueController.h"
#import "FeedbackController.h"
#import "SettingViewController.h"
#import "PersonCell.h"
#import "LoginViewController.h"
#import "KSKuaiShouTool.h"
#import "UserInfo.h"
#import "UserInfoController.h"
#import "AboutUsViewController.h"
#import "FollowTeamViewController.h"

@interface MeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UserInfoResult *userInfo;

@property (nonatomic, assign) NSInteger followMatchCount;


@end

@implementation MeController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    [self createTableView];
    
}

- (void)setData {

    NSString *token = [self getValueWithKey:@"token"];
    if (token.length > 0) {
        _dataSource = @[@[@""],
                        @[
                            NSLocalizedStringFromTable(@"Feedback", @"InfoPlist", nil),NSLocalizedStringFromTable(@"About us", @"InfoPlist", nil),
                            NSLocalizedStringFromTable(@"Share with friends", @"InfoPlist", nil)]/*,
                        @[NSLocalizedStringFromTable(@"Setting", @"InfoPlist", nil)]*/];
        [self getUserInfoWithToken:token];

    } else {
        _dataSource = @[@[NSLocalizedStringFromTable(@"Sign in/Sign up", @"InfoPlist", nil)],
                        @[
                            NSLocalizedStringFromTable(@"Feedback", @"InfoPlist",nil),
                            NSLocalizedStringFromTable(@"About us", @"InfoPlist", nil),
                            NSLocalizedStringFromTable(@"Share with friends", @"InfoPlist", nil)]/*,
                        @[NSLocalizedStringFromTable(@"Setting", @"InfoPlist", nil)]*/];
    }
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray * rowArr = _dataSource[section];
    return rowArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *token = [self getValueWithKey:@"token"];
        if (token.length > 0) {
            return 100;
        } else {
            return 50;
        }
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *token = [self getValueWithKey:@"token"];
    UITableViewCell *cell1 = [[UITableViewCell alloc] init];
    if (indexPath.section == 0 && token.length > 0)
    {
        PersonCell * cell = [[PersonCell alloc]init];
        return cell;
    }
    else
    {
        static NSString * identifier = @"meCell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            //右侧小箭头
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    return cell1;
}

//养成习惯在WillDisplayCell中处理数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *token = [self getValueWithKey:@"token"];
    if(indexPath.section == 0 && token.length > 0) {
        PersonCell *personCell = (PersonCell *)cell;
        [personCell setUserInfo:_userInfo];
//        [personCell setModel:_model];
    }
    else {
        cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];

    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *token = [self getValueWithKey:@"token"];
        if (token.length > 0) { // 个人信息修改

            if (_userInfo != nil) {
                UserInfoController *userInfoVc = [[UserInfoController alloc] init];
                userInfoVc.userInfo = _userInfo;
                [userInfoVc setHidesBottomBarWhenPushed:YES];
                userInfoVc.tokenBlock = ^(){
                    [self saveValue:@"" withKey:@"token"];
                    [self saveValue:@"" withKey:@"averUrl"];
                    [self saveValue:@"" withKey:@"userid"];
                    _dataSource = @[@[NSLocalizedStringFromTable(@"Sign in/Sign up", @"InfoPlist", nil)],
                                    @[
                                        NSLocalizedStringFromTable(@"Feedback", @"InfoPlist", nil),NSLocalizedStringFromTable(@"About us", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Share with friends", @"InfoPlist", nil)]/*,
                                    @[NSLocalizedStringFromTable(@"Setting", @"InfoPlist", nil)]*/];
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:userInfoVc animated:YES];
            }
            
        } else {
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            loginVc.tokenBlock = ^(NSString *token){
                NSLog(@"loginToken%@",token);
                [self saveValue:token withKey:@"token"];
                [self getUserInfoWithToken:token];
                [self.tableView reloadData];
            };
            [loginVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
    } else if (indexPath.section == 1) {

        if (indexPath.row == 0){
            FeedbackController *vc = [[FeedbackController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1){
            AboutUsViewController *vc = [[AboutUsViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 2) {
            NSString *textToShare = NSLocalizedStringFromTable(@"分享快手体育", @"InfoPlist", nil);
            
            UIImage *imageToShare = [UIImage imageNamed:@"icon"];
            NSURL *urlToShare = [NSURL URLWithString:@"http://url.cn/40l3U4Z"];
            
            NSArray *activityItems = @[textToShare];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
            
            //不出现在活动项目
            
            activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,   
                                                 
                                                 UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
            
            [self presentViewController:activityVC animated:TRUE completion:nil];

        }
    } else if (indexPath.section == 2) {
        SettingViewController *vc = [[SettingViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)getUserInfoWithToken:(NSString *)token {
    [KSKuaiShouTool getUserInfoWithToken:token withCompleted:^(id result) {
        UserInfo *last = [UserInfo mj_objectWithKeyValues:result];

        _userInfo = last.result;
        _dataSource = @[@[@""],
                        @[
                            NSLocalizedStringFromTable(@"Feedback", @"InfoPlist", nil),NSLocalizedStringFromTable(@"About us", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Share with friends", @"InfoPlist", nil)]/*,
                        @[NSLocalizedStringFromTable(@"Setting", @"InfoPlist", nil)]*/];

        // 存储用户id
        [self saveValue:[NSString stringWithFormat:@"%li",(long)_userInfo.userid] withKey:@"userid"];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 字段持久缓存(保存在数据库)
- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSString *)getValueWithKey:(NSString *)key {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:key];//根据键值取出name
    return token;
}


- (UITableView *)createTableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStyleGrouped];
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.tableFooterView = [[UIView alloc] init];
 
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setData];
    
    [self.tableView reloadData];
    
    
    
}


@end
