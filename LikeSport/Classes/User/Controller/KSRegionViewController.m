//
//  KSRegionViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/26.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSRegionViewController.h"
#import "RegionTool.h"
#import "Region.h"
#import "KSKuaiShouTool.h"

@interface KSRegionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation KSRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setData];
    
    [self createTableView];
    
}

- (void)setData {
    _dataSource = [[RegionTool manager] getRegionWithParent:_regionID];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return WGiveHeight(15);
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.001;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WGiveHeight(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ChangeSexCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    Region *region = _dataSource[indexPath.row];
    cell.textLabel.text = region.country;
//    cell.textLabel.text = indexPath.row == 0?@"男":@"女";
    
    //    if ([cell.textLabel.text isEqualToString:[[UserInfoManager manager]sex] == YES?@"男":@"女"])
    //    {
    //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    }
    //    else
    //    {
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Region *region = _dataSource[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]setInteger:region.region_id forKey:@"region_id"];
    [[NSUserDefaults standardUserDefaults]setInteger:region.parent forKey:@"region_parent"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [KSKuaiShouTool userInfoWithParam:@{@"region_id":[NSString stringWithFormat:@"%li",(long)region.region_id]} withCompleted:^(id result) {
        NSLog(@"ret_code=%@",[result objectForKey:@"ret_code"]);
        if ([[result objectForKey:@"ret_code"] intValue] == 0) {
            
            NSArray *controllers = self.navigationController.viewControllers;
            //根据索引号直接pop到指定视图
            [self.navigationController popToViewController:[controllers objectAtIndex:1] animated:NO];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.f];
        hud.label.numberOfLines = 3;
        hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
    }];

    
    //    MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    if (self.sexBlock) {
//        self.sexBlock(indexPath.row+1);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    //    [[WWeChatApi giveMeApi]updataSexWithIsMan:indexPath.row == 0?YES:NO andSuccess:^(id response) {
    
    //        [hub hideAnimated:YES];
    //        [self.tableView reloadData];
    //
    //    } andFailure:^(NSError *error) {
    //        
    //    }];
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
