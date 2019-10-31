//
//  FollowLeagueController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/4.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "FollowLeagueController.h"
#import "KSLiveCell.h"
#import "KSTabBarController.h"
#import "KSKuaiShouTool.h"
#import "League.h"
#import "LeagueCell.h"

@interface FollowLeagueController ()<UITableViewDelegate, UITableViewDataSource,LeagueCellDelegate>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) NSMutableArray *allTitle;
@property (nonatomic, strong) NSMutableArray *allType;

//@property (nonatomic, strong) LeagueResult *leagueResult;
@property (weak, nonatomic) UILabel *label;

//@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@end

@implementation FollowLeagueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setBackBtn];
    
    [self.tableView reloadData];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    
    self.title = NSLocalizedStringFromTable(@"Focus on the league", @"InfoPlist", nil);
    
    if (token.length > 0){
        [self setData];
    } else {
        self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
    }
    
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}


//- (IBAction)handleSwipes:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
////    [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
//}


//- (void)setBackBtn {
//    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
////    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//    [saveBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [saveBtn addTarget:self action:@selector(didClickedBackButton) forControlEvents:UIControlEventTouchUpInside];
//    //    [someButton setShowsTouchWhenHighlighted:YES];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
//    self.navigationItem.leftBarButtonItem = mailbutton;
//}

- (void)setBackBtn {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
    //    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [bar setShadowImage:[UIImage new]];
    [self.view addSubview:bar];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

    [bar addSubview:backBtn];
    //    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [backBtn setTitle:NSLocalizedStringFromTable(@"Back", @"InfoPlist", nil) forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didClickedBackButton) forControlEvents:UIControlEventTouchUpInside];
    //    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = mailbutton;
}


- (void)didClickedBackButton {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setData {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"token"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });
    
    [KSKuaiShouTool getMatchListWithUserID:userid withCompleted:^(id result) {
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
        
        if (last.result.t2.count > 0) {
            //            array = [last.result.t1 mutableCopy];
            //            [_allData addObject:array];
            [_allData addObject:last.result.t2];
            [_allTitle addObject:NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)];
            [_allType addObject:@"2"];
        }
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _allType.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row == self.selectedIndexPath.row+1) {
//        if ([_allType[indexPath.section] isEqualToString:@"1"]) {
//            
//            return 150;
//        } else if ([_allType[indexPath.section] isEqualToString:@"2"]) {
//            return 90;
//        } else {
//            return (_more.count + 1 ) * 20 + 5;
//        }
//    } else {
//        return 65;
//    }
    return 30;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
//    if (section == 0) {
//        label.backgroundColor = [UIColor colorWithRed:31/255.0 green:101/255.0 blue:74/255.0 alpha:1];
//    } else if (section == 1) {
//        label.backgroundColor = [UIColor colorWithRed:178/255.0 green:123/255.0 blue:5/255.0 alpha:1];
//    }
    label.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:236/255.0 alpha:1];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    label.text = _allTitle[section];
    
    //    UIView *hView;
    //    if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
    //        UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
    //    {
    //        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 40)];
    //    }
    //    else
    //    {
    //        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    //    }
    //
    //    UIButton* eButton = [[UIButton alloc] init];
    //
    //    //按钮填充整个视图
    //    eButton.frame = hView.frame;
    //    [eButton addTarget:self action:@selector(expandButtonClicked:)
    //      forControlEvents:UIControlEventTouchUpInside];
    //    eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
    //
    //
    //    //4个参数是上边界，左边界，下边界，右边界。
    ////    eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ////    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
    ////    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    //
    //
    //    //设置按钮显示颜色
    //    eButton.backgroundColor = [UIColor lightGrayColor];
    //    [eButton setTitle:_allTitle[section] forState:UIControlStateNormal];
    //    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    //[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //
    ////    [eButton setBackgroundImage: [ UIImage imageNamed: @"btn_listbg.png" ] forState:UIControlStateNormal];//btn_line.png"
    //    //[eButton setTitleShadowColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
    //    //[eButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    //
    //    [hView addSubview: eButton];
    //    return hView;
    return label;
}

////对指定的节进行“展开/折叠”操作
//-(void)collapseOrExpand:(int)section{
//    Boolean expanded = NO;
//    //Boolean searched = NO;
//    NSMutableDictionary* d=[_allData objectAtIndex:section];
//
//    //若本节model中的“expanded”属性不为空，则取出来
//    if([d objectForKey:@"expanded"]!=nil)
//        expanded=[[d objectForKey:@"expanded"]intValue];
//
//    //若原来是折叠的则展开，若原来是展开的则折叠
//    [d setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
//}
//
////返回指定节的“expanded”值
//-(Boolean)isExpanded:(int)section{
//    Boolean expanded = NO;
//    NSMutableDictionary* d=[_allData objectAtIndex:section];
//
//    //若本节model中的“expanded”属性不为空，则取出来
//    if([d objectForKey:@"expanded"]!=nil)
//        expanded=[[d objectForKey:@"expanded"]intValue];
//
//    return expanded;
//}
//
//
////按钮被点击时触发
//-(void)expandButtonClicked:(id)sender{
//
//    UIButton* btn= (UIButton*)sender;
//    int section= btn.tag; //取得tag知道点击对应哪个块
//
//    // NSLog(@"click %d", section);
//    [self collapseOrExpand:section];
//
//    //刷新tableview
//    [self.tableView reloadData];
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeagueCell *cell = [LeagueCell cellWithTableView:tableView];
    T0 *t0 = _allData[indexPath.section][indexPath.row];
//    t0.is_follow = 1;
    cell.t0 = t0;
    cell.delegate = self;
    return cell;
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
        NSDictionary *param = @{@"mtype":[NSString stringWithFormat:@"%li",(long)match.mtype],@"ptype":@3,@"mid":[NSString stringWithFormat:@"%li",(long)match.matchtype_id],@"status":[NSString stringWithFormat:@"%li",(long)state]};
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedStringFromTable(@"Please login first", @"InfoPlist", nil);
        [hud hideAnimated:YES afterDelay:1.f];
        [self.tableView reloadData];
        
    }
    //    [_dataSource mutableCopy];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = NO;

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
