//
//  FollowViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "FollowViewController.h"
#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "KSLive.h"
#import "KSLiveCell.h"
#import "KSExpansionCell.h"
#import "KSLiveFrame.h"
#import "FootballDetailController.h"
#import "MJRefresh.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"
#import "KxMenu.h"
#import "LoginViewController.h"
#import "FollowLeagueController.h" 
#import "FollowTeamViewController.h"
//#import "TipsViewController.h"
#import "KGModal.h"

#import "KSTapGestureRecognizer.h"

#define ExpandCount 1

@interface FollowViewController () <KSLiveCellDelegate,UITableViewDelegate, UITableViewDataSource,UITabBarDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (weak, nonatomic) UILabel *label;
@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) NSMutableArray *allTitle;
@property (nonatomic, strong) NSMutableArray *allType;
@property (nonatomic, strong) NSMutableArray *more;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *minuteTimer;
@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic, assign) BOOL isMinuteTimer;
@property (nonatomic, assign) NSInteger matchID;
@property (nonatomic, assign) NSInteger basketID;
@property (nonatomic, assign) NSInteger tennisID;
@property (nonatomic, strong) NSMutableArray *lastLive;
@property (nonatomic, strong) NSMutableArray<KSLive *> *live;


@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

// 时间戳，超过60秒左右滑动就自动刷新
@property (nonatomic, assign) NSTimeInterval nowSp;


@property (nonatomic, strong) UIView *scrollBar;
@property (nonatomic, assign) BOOL isScrollBar;
@property (nonatomic, assign) CGPoint lastPosition;

@end

@implementation FollowViewController
{
    UIButton *typeBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
//    [self.tableView reloadData];
    [self createTableView];

    
//    [self.tableView.mj_header beginRefreshing];
//    [self setDataWithMatchID:0];
    [self updateDataWithMatchID:0];
    
    self.tabBarController.delegate = self;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    _nowSp = time;
    
    // 应用开始活动时自动刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    // 快速滚动条
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _scrollBar = [[UIView alloc] initWithFrame:CGRectMake(kSceenWidth-40, 30, 40, 40)];
    [_scrollBar addGestureRecognizer:pan];
    _scrollBar.alpha = 0.6;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 3, 34, 34)];
    imageView.image = [UIImage imageNamed:@"scrollBar"];
    [_scrollBar addSubview:imageView];
    [self.view addSubview:_scrollBar];
    self.scrollBar.hidden = YES;
    
//    NSLog(@"tableView%f",self.tableView.frame.size.height);
    
    // 更多按钮
    [self addMoreBtn];
    
    [self addLeftBtnWithImgName:@"tips" andSelector:@selector(pushToTipsView)];
    
    
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeRight;
    
}

- (void)pushToTipsView{

    CGFloat infoLabelHigh;
    CGFloat contentHigh;
    if ([NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"gb"] || [NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"big"]) {
        infoLabelHigh = 200;
        contentHigh = 250;
    } else {
        infoLabelHigh = 270;
        contentHigh = 300;
    }
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, contentHigh)];
//    contentView.backgroundColor = KSBlue;
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 280, 20)];
    [contentView addSubview:welcomeLabel];
    

    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:19];
//    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = NSLocalizedStringFromTable(@"Tip", @"InfoPlist", nil);
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];

    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 280, infoLabelHigh)];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"text1", @"InfoPlist", nil)];
    
    // 创建图片图片附件
    NSTextAttachment *star = [[NSTextAttachment alloc] init];
    star.image = [UIImage imageNamed:@"starred"];
    star.bounds = CGRectMake(0, 0, 18, 18);
    NSAttributedString *starString = [NSAttributedString attributedStringWithAttachment:star];
    
    [string appendAttributedString:starString];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"text2", @"InfoPlist", nil)]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"text3", @"InfoPlist", nil)]];
    
    NSTextAttachment *follow = [[NSTextAttachment alloc] init];
    follow.image = [UIImage imageNamed:@"followed"];
    follow.bounds = CGRectMake(0, 0, 15, 15);
    NSAttributedString *followString = [NSAttributedString attributedStringWithAttachment:follow];
    [string appendAttributedString:followString];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"text4", @"InfoPlist", nil)]];
    [string appendAttributedString:starString];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"text5", @"InfoPlist", nil)]];
    
    [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0,string.length)];

    infoLabel.attributedText = string;
    
    infoLabel.numberOfLines = 13;
    infoLabel.textColor = [UIColor whiteColor];
//    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

- (BOOL)isNotchScreen {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }
    
    return NO;
}

- (void)addMoreBtn {
    
    typeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    typeBtn.frame = CGRectMake(kSceenWidth-40, 20, 40, 40);
    if ([self isNotchScreen]) typeBtn.frame = CGRectMake(kSceenWidth-40, 44, 40, 40);
    [typeBtn setImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    typeBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 5, 5, 8);
    [typeBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.view addSubview:typeBtn];
    
    
    //设置整个菜单块的背景颜色，如果不设置，就采用默认的背景颜色（代码中有体现）
//    [KxMenu setTintColor: [UIColor colorWithRed:15/255.0f green:97/255.0f blue:33/255.0f alpha:1.0]];
    [KxMenu setTintColor:KSBlue];
    
    //设置所有菜单项的字体，如果不设置，就采用默认的字体（代码中有体现）
    [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];

}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:NSLocalizedStringFromTable(@"Focus on the league", @"InfoPlist", nil)
                     image:nil
                       tag:0
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:NSLocalizedStringFromTable(@"Focus on the team", @"InfoPlist", nil)
                     image:nil
                       tag:1
                    target:self
                    action:@selector(pushMenuItem:)],    //点击菜单项处理事件
      
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = KSBackgroundGray;  //设置菜单项的foreColor字体颜色，前背景颜色
    first.alignment = NSTextAlignmentCenter;   //设置菜单项的对其方式
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender
{
    KxMenuItem *button = sender;

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    if (token.length > 0) {
        [self pushToFollowMatchOrTeamWithTag:button.tag];
    } else { // 跳转到登陆界面
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        loginVc.tokenBlock = ^(NSString *token){
//            NSLog(@"loginToken%@",token);
            [self saveValue:token withKey:@"token"];
//            [self getUserInfoWithToken:token];
//            [self.tableView reloadData];
            [self pushToFollowMatchOrTeamWithTag:button.tag];
            [self updateDataWithMatchID:_matchID];
        };
        [loginVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

- (void)pushToFollowMatchOrTeamWithTag:(NSInteger)tag {
    if (tag == 0) {
        FollowLeagueController *vc = [[FollowLeagueController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 1) {
        FollowTeamViewController *vc = [[FollowTeamViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark 后台切换回前台
- (void)applicationDidBecomeActive {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    if (time - _nowSp > 60) {
        [self updateDataWithMatchID:0];
        _nowSp = time;
    }
}

/* 识别拖动 */
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    [self drawImageForGestureRecognizer:gestureRecognizer atPoint:location underAdditionalSituation:nil];
    [gestureRecognizer setTranslation:location inView:self.view];
    
    
    NSInteger count = 0;
    NSInteger row0 = 0;
    NSInteger row1 = 0;
    NSInteger row2 = 0;
    
    
    for (int i = 0; i < _allData.count; i++) {
        count += [_allData[i] count];
        switch (i) {
            case 0:
                if (_allData.count >= 1) {
                    row0 = [_allData[0] count];
                }
                break;
            case 1:
                if (_allData.count >= 2) {
                    row1 = [_allData[1] count];
                }
                break;
            case 2:
                if (_allData.count >= 3) {
                    row2 = [_allData[2] count];
                }
                break;
            default:
                break;
        }
    }
    //    NSLog(@"location=%f",location.y);
    
    int a = count*(location.y-0)/(self.tableView.frame.size.height-40);
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:a];//第a个区域里的第b行。
//    NSLog(@"count=%i,a=%i",count,a);

    NSIndexPath *index;//第a个区域里的第b行。
    if (a < row0) {
        index = [NSIndexPath indexPathForRow:a inSection:0];
    } else if (a < row0+row1) {
        index = [NSIndexPath indexPathForRow:a-row0 inSection:1];
    } else if (a < count) {
        index = [NSIndexPath indexPathForRow:a-row0-row1 inSection:2];
    }
    
    if (a > 0 && a < count) {
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    _isScrollBar = YES;
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self performSelector:@selector(hideScrollBar) withObject:nil afterDelay:1.0];
        
        _isScrollBar = NO;
    }
    
}

- (void)hideScrollBar {
    self.scrollBar.hidden = YES;
}

- (void)drawImageForGestureRecognizer:(UIGestureRecognizer *)recognizer
                              atPoint:(CGPoint)centerPoint underAdditionalSituation:(NSString *)addtionalSituation{
    
    
    if ([recognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        //    self.scrollBar.image = [UIImage imageNamed:imageName];
        if (centerPoint.y > 20 && centerPoint.y < self.tableView.frame.size.height-65) {
            //        self.scrollBar.center = centerPoint;
            self.scrollBar.center = CGPointMake(kSceenWidth-20, centerPoint.y);
        }
        //    self.scrollBar.hidden = NO;
        //    self.scrollBar.alpha = 1.0;
    }
    
    
    
}


- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

#pragma mark --  指示器更新数据
- (void)updateDataWithMatchID:(NSInteger)matchID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });
    _allTitle = [NSMutableArray arrayWithCapacity:3];
    [_allTitle addObject:NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil)];
    [_allTitle addObject:NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil)];
//    [_allTitle addObject:NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)];

    [KSKuaiShouTool getLiveWithType:-1 ofState:@"follow" withMatchID:matchID WithCompleted:^(id result) {
        FollowResult *last = [FollowResult mj_objectWithKeyValues:result];
        _allData = [NSMutableArray arrayWithCapacity:3];
        _allType = [NSMutableArray arrayWithCapacity:3];
        _matchID = last.result.t0_flag_num;
        _basketID = last.result.t1_flag_num;
        _tennisID = last.result.t2_flag_num;
        
        NSMutableArray *array = [NSMutableArray array];
        for (KSLive *live in last.result.t0) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = 0;
            live.isFollowView = YES;
            liveF.live = live;
            [array addObject:liveF];
            live.timeH = 1;
            live.timeC = 1;
            
        }
        //        if (array.count > 0) {
        [_allData addObject:array];
        [_allType addObject:@"0"];
        //        }
        
        array = [NSMutableArray array];
        for (KSLive *live in last.result.t1) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = 1;
            live.isFollowView = YES;
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
        }
        //        if (array.count > 0) {
        [_allData addObject:array];
        [_allType addObject:@"1"];
        //        }
        
        array = [NSMutableArray array];
        for (KSLive *live in last.result.t2) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = 2;
            live.isFollowView = YES;
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
        //        if (array.count > 0) {
        [_allData addObject:array];
        [_allType addObject:@"2"];
        //        }
        
        [_allData mutableCopy];
//        [self reloadTableView];
        self.isExpand = NO;
        self.selectedIndexPath = nil;
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
            [hud hideAnimated:YES];
            if (_allData.count == 0) {
                self.label.hidden = NO;
                //                if (_chooseType == 0) {
                self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
                //                } else {
                //                    self.label.text = @"没有符合筛选条件的赛事";
                //                }
            } else if (_allData.count > 0) {

                self.label.hidden = YES;
            }
            
            
        });
        
        [self checkIfMatchIsComing];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
//        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//        self.label.hidden = NO;
        [self networdError];
//        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark -- 网络出错
-(void)networdError {
    if (_allData.count > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.f];
        hud.label.numberOfLines = 3;
        hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
    } else {
        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        self.label.hidden = NO;
    }
}

#pragma mark -- 下拉刷新数据
- (void)setDataWithMatchID:(NSInteger)matchID {

    
    [KSKuaiShouTool getLiveWithType:-1 ofState:@"follow" withMatchID:matchID WithCompleted:^(id result) {
        FollowResult *last = [FollowResult mj_objectWithKeyValues:result];
        _allData = [NSMutableArray arrayWithCapacity:3];
        _allTitle = [NSMutableArray arrayWithCapacity:3];
        _allType = [NSMutableArray arrayWithCapacity:3];
        _matchID = last.result.t0_flag_num;
        _basketID = last.result.t1_flag_num;
        _tennisID = last.result.t2_flag_num;
        
        NSMutableArray *array = [NSMutableArray array];
        for (KSLive *live in last.result.t0) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = 0;
            live.isFollowView = YES;
            liveF.live = live;
            [array addObject:liveF];
            live.timeH = 1;
            live.timeC = 1;
        }
//        if (array.count > 0) {
            [_allTitle addObject:NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil)];
            [_allData addObject:array];
            [_allType addObject:@"0"];
//        }
        
        array = [NSMutableArray array];
        for (KSLive *live in last.result.t1) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = 1;
            live.isFollowView = YES;
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


        }
//        if (array.count > 0) {
            [_allTitle addObject:NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil)];
            [_allData addObject:array];
            [_allType addObject:@"1"];
//        }
        
        array = [NSMutableArray array];
        for (KSLive *live in last.result.t2) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = 2;
            live.isFollowView = YES;
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
//        if (array.count > 0) {
//            [_allTitle addObject:NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)];
//            [_allData addObject:array];
//            [_allType addObject:@"2"];
//        }
        
        [_allData mutableCopy];
//        [self reloadTableView];
        self.isExpand = NO;
        self.selectedIndexPath = nil;
        [self.tableView reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
//            [hud hideAnimated:YES];
            if (_allData.count == 0) {
                self.label.hidden = NO;
                //                if (_chooseType == 0) {
                self.label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
                //                } else {
                //                    self.label.text = @"没有符合筛选条件的赛事";
                //                }
            } else if (_allData.count > 0) {
                self.label.hidden = YES;
            }


        });
        
        [self checkIfMatchIsComing];
    } failure:^(NSError *error) {
//        [hud hideAnimated:YES];
        if (self.allData.count > 0) {
            [self networdError];
        } else {
            self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
            self.label.hidden = NO;
        }
        
        [self.tableView.mj_header endRefreshing];
    }];
    
}

// 查看是否有正在进行中的比赛
- (void)checkIfMatchIsComing {
    
    for (int i = 0; i < _allData.count; i++) {
        NSArray *array = _allData[i];
        for (int j = 0; j < array.count; j++) {
            KSLiveFrame *liveF = array[j];
            if ([liveF.live.state isEqualToString:@"S"] || [liveF.live.state isEqualToString:@"X"] || [liveF.live.state isEqualToString:@"Z"] || [liveF.live.state isEqualToString:@"1"] || [liveF.live.state isEqualToString:@"2"] || [liveF.live.state isEqualToString:@"3"] || [liveF.live.state isEqualToString:@"4"]) {
                if (self.matchID == 0) {
                    [self getID];
                }
                
                if (!_isTimer) {
                    [self addTimer];
                }
                
                if ([_allType containsObject:@"0"]) {
                    if (!_isMinuteTimer) {
                        [self addMinuteTimer];
                    }

                }
                //        }
            }
        }
    }
}

#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *lives = _allData[section];
//    if (self.isExpand && self.selectedIndexPath.section == section) {
//        return lives.count + ExpandCount;
//    }
    return lives.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allTitle.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row];
    if (liveF.isExpand) {
        if ([_allType[indexPath.section] isEqualToString:@"0"]) {
            return (liveF.live.more.count + 1 ) * 20 + 5 + 65;
        } else {
            return 125;
        }

    } else {
        return 65 + 28;
    }
    

    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, kSceenWidth, 20)];
    
    view.backgroundColor = KSBackgroundGray;
    label.textColor = KSFontBlue;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 26, 26)];
    if (section == 0) {
        imageView.frame = CGRectMake(12, 4, 22, 22);
        imageView.image = [UIImage imageNamed:@"football"];

    } else if (section == 1) {
        imageView.image = [UIImage imageNamed:@"basketball2"];

    } else if (section == 2) {
        imageView.image = [UIImage imageNamed:@"tennisball2"];
    }
    [view addSubview:imageView];
    
    label.textAlignment = NSTextAlignmentLeft;

    label.font = [UIFont systemFontOfSize:16];
    label.text = _allTitle[section];
    
    [view addSubview:label];
    
      UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth - 40, 0, 40, 30)];
    Btn.tag = section;
    UIImage *image = [UIImage imageNamed:@"arrow_right"];
    [Btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    Btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    UIColor *fontBlue = KSFontBlue;
    [Btn setTintColor:fontBlue];
    [Btn addTarget:self action:@selector(didClickArrow:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:Btn];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSceenWidth, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineView];
    
    view.userInteractionEnabled=YES;
    KSTapGestureRecognizer* tap=[[KSTapGestureRecognizer alloc]initWithTarget:self action:@selector(didclick:)];
    tap.tapbnt=Btn;
    [view addGestureRecognizer:tap];
    
    return view;
}
-(void)didclick:(KSTapGestureRecognizer*)sender{
    [self didClickArrow:sender.tapbnt];
}

// 点击箭头跳转到即时比分
- (void)didClickArrow:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(setSegmentTag:)]) {
        [self.delegate setSegmentTag:sender.tag];
    }
    
    if (self.segmentBlock) {
        self.segmentBlock(sender.tag);
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:sender.tag] forKey:@"segmentTag"];
    //获得UIImage实例
    [defaults synchronize];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@'SegmentTag' object:self userInfo:@{@'tag':sender}];
    
    
    [self.tabBarController setSelectedIndex:0];

}

#pragma mark - 字段持久缓存(保存在数据库)
- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    //获得UIImage实例
    [defaults synchronize];
}

- (NSString *)getValueWithKey:(NSString *)key {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:key];//根据键值取出name
    return token;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];
    cell.delegate = self;
    
    KSLiveFrame *liveF = _allData[indexPath.section][indexPath.row];
    cell.liveF = liveF;
    
    if (liveF.isExpand && [_allType[indexPath.section] isEqualToString:@"0"]) {
        KSLiveCell *footballCell = [[KSLiveCell alloc] init];
        footballCell.delegate = self;
        footballCell.liveF = liveF;
        return footballCell;
    }
    return cell;
    
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数（减速停止，结束拖动）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
    _lastPosition = scrollView.contentOffset;
    
    //    self.scrollBar.hidden = YES;
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
    
    
    // 切换视图时请求更新数据
    //    NSLog(@"滚动页数%ld",(long)_currentPage);
    //            [self.tableView reloadData];
    self.scrollBar.hidden = YES;
    
    
}

// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x - 20 > _lastPosition.x || scrollView.contentOffset.x - 20 < _lastPosition.x) {
        self.scrollBar.hidden = YES;
    }
}

// scrollView 正在滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    NSInteger count = 0;
    NSInteger row0 = 0;
    NSInteger row1 = 0;
    NSInteger row2 = 0;

    for (int i = 0; i < _allData.count; i++) {
        count += [_allData[i] count];
        switch (i) {
            case 0:
                row0 = [_allData[0] count];
                break;
            case 1:
                row1 = [_allData[1] count];
                break;
            case 2:
                row2 = [_allData[2] count];

                break;
            default:
                break;
        }
    }
    NSIndexPath *path =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    NSInteger indexPath = 0;
    switch (path.section) {
        case 0:
            indexPath = path.row;
            break;
        case 1:
            indexPath = row0 + path.row;
            break;
        case 2:
            indexPath = row0 + row1 + path.row;
            break;
            
        default:
            break;
    }
    
    CGFloat y = 20+(self.tableView.mj_size.height-90)*indexPath/(count-(self.tableView.mj_size.height-50)/65-6);
//    NSLog(@"count=%i,y=%f",count,y);
    if (!_isScrollBar) {
        self.scrollBar.center = CGPointMake(kSceenWidth-20, y);
    }
    
    if (count > 30 && (scrollView.contentOffset.x - 20 > _lastPosition.x || scrollView.contentOffset.x - 20 < _lastPosition.x) && (scrollView.contentOffset.y - 30 > _lastPosition.y || scrollView.contentOffset.y - 30 < _lastPosition.y)) {
        self.scrollBar.hidden = NO;
    }
}



#pragma mark 点击扩展
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//  if ([_allType[section] isEqualToString:@"0"]){
//     NSArray* newalldata=(NSArray*)_allData[0];
//    if (newalldata.count>=8) {
//       return 200;
//    }else{
//        return 40;
//    }
//  }
//    return 0;
//}
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
   
    if ([_allType[indexPath.section] isEqualToString:@"0"]) {
    
    KSLiveFrame *liveFrame = _allData[indexPath.section][indexPath.row];
    liveFrame.isExpand = !liveFrame.isExpand;
    if ([_allType[indexPath.section] isEqualToString:@"0"]) {
        

              NSIndexPath* targetindexpath;
               NSArray* newalldata=(NSArray*)_allData[indexPath.section];
                for (int i=0; i<newalldata.count; i++) {
                    KSLiveFrame *subliveFrame =newalldata[i];
                    if (subliveFrame.isExpand==YES&&i!=indexPath.row) {
                        subliveFrame.isExpand=NO;
                        targetindexpath=[NSIndexPath indexPathForRow:i inSection:0];
                    }
            }
        
        NSLog(@"%@--%@",targetindexpath,indexPath);
        
        if ([_allType[indexPath.section] isEqualToString:@"0"]) {
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
                    
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }failure:^(NSError *error) {
                
            }];
            
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
        }else{
                KSLiveFrame *liveFrame = _allData[indexPath.section][indexPath.row];
                liveFrame.isExpand = !liveFrame.isExpand;
                if ([_allType[indexPath.section] isEqualToString:@"0"]) {
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
                if ([_allType[indexPath.section] isEqualToString:@"0"]) {
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

        }
    
//    KSLiveFrame *liveFrame = _allData[indexPath.section][indexPath.row];
//    liveFrame.isExpand = !liveFrame.isExpand;
//    if ([_allType[indexPath.section] isEqualToString:@"0"]) {
//        if (self.selectedIndexPath) {
//            if (self.isExpand) {
//                if (self.selectedIndexPath == indexPath) {
//                    self.isExpand = NO;
//                    self.selectedIndexPath = nil;
//                } else {
//                    KSLiveFrame *select = _allData[self.selectedIndexPath.section][self.selectedIndexPath.row];
//                    select.isExpand = NO;
//                    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//                    
//                    self.isExpand = YES;
//                    self.selectedIndexPath = indexPath;
//                    //                    [self.tableView reloadSections:self.selectedIndexPath withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
//            
//        } else {
//            self.isExpand = YES;
//            self.selectedIndexPath = indexPath;
//        }
//        
//    }
//    
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    if ([_allType[indexPath.section] isEqualToString:@"0"]) {
//        [KSLikeSportTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
//            //
//            if ([result count] == 0) {
//                liveFrame.live.isGoalEnpty = YES;
//                
//                NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//                if (self.isExpand == YES && self.selectedIndexPath == indexPath) {
//                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
//            //            _more = [result mutableCopy];
//            liveFrame.live.more = [result mutableCopy];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//            
//        }failure:^(NSError *error) {
//            
//        }];
//    }
//    
//    if (indexPath.section+1 == [_allData count] && indexPath.row+1 == [_allData[indexPath.section] count]) {
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        
//        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
//                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//      
//    }
//    
//    
//    }
//    }
    
 // }
}
- (NSArray *)indexPathsForExpandRow:(NSInteger)row withSection:(NSInteger)section{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row + i inSection:section];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}

- (void)followTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{

//    NSLog(@"点击关注");
    KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
    if (_isExpand && _selectedIndexPath.section == indexPath.section && _selectedIndexPath.row < indexPath.row) {
        liveF = _allData[indexPath.section][indexPath.row-1];
    } else {
        liveF = _allData[indexPath.section][indexPath.row];
    }
//    NSLog(@"赛事类型%@  type%li id%li",liveF.live.matchtypefullname,(long)_type,(long)liveF.live.match_id);
    NSInteger state;
    if (liveF.live.is_follow == 0) {
        state = 1;
    } else if (liveF.live.is_follow == 1){
        state = 2;
    }
    //    [_dataSource mutableCopy];
    [KSKuaiShouTool forceMatchWithState:state Type:[_allType[indexPath.section] integerValue] withMatchID:liveF.live.match_id withCompleted:^(id result) {
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
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }failure:^(NSError *error) {
        
    }];
}


#pragma mark tabelView点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

        } else {
            liveF = _allData[indexPath.section][indexPath.row];
        }
        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
        footballDetailVc.matchID = liveF.live.match_id;
        footballDetailVc.type = [_allType[indexPath.section] integerValue];
        if ([liveF.live.state isEqualToString:@"W"]) {
            footballDetailVc.state = 1;
        }
        [footballDetailVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:footballDetailVc animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark private method

- (UITableView *)createTableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStylePlain];
        
        if ([self isNotchScreen]) {
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64-83) style:UITableViewStylePlain];
        }
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = NO;
        UIView* footview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80.0f)];
        [footview setBackgroundColor:[UIColor whiteColor]];
        tableView.tableFooterView =footview;
        [tableView registerClass:[KSLiveCell class] forCellReuseIdentifier:@"KSLiveCell"];
        [tableView registerClass:[KSExpansionCell class] forCellReuseIdentifier:@"KSExpansionCell"];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)refreshData{
    [self setDataWithMatchID:0];

    self.isExpand = NO;
    self.selectedIndexPath = nil;
}



// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth-220)/2 , 150, 220, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = 2;
        label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
        [self.tableView addSubview:label];
        [self.view insertSubview:label atIndex:1];
        _label = label;
    }
    return _label;
}



#pragma mark 分类即时比分变化数据请求
- (void)updateLastLive
{
    if ([_allData[0] count] != 0) {
        [self loadFootballLive];
    }
    
    if ([_allData[1] count] != 0) {
        [self loadBasketballLive];
    }
    
//    if ([_allData[2] count] != 0) {
//        [self loadTennisLive];
//    }
}

// 篮球最新变化
- (void)loadBasketballLive {
    [KSKuaiShouTool getBasketballAndTennisLiveWithType:1 withFlagNum:_basketID withCompleted:^(id responseObject) {
        LiveResult *last = [LiveResult mj_objectWithKeyValues:responseObject];
        self.live = [last.result mutableCopy];

        if (self.live.count > 0) {
            NSString *liveD = _live[0].d;
            _basketID = self.live[0].flag_num;
            
            NSMutableArray *match = [[liveD componentsSeparatedByString:@"@"] mutableCopy];
            for (int i = 0; i < match.count; i++) {
                
                [self.lastLive removeAllObjects];
                self.lastLive = [[match[i] componentsSeparatedByString:@"|"] mutableCopy];
                NSMutableArray *liveFrame;
                if ([_allType containsObject:@"0"]) {
                    liveFrame = _allData[1];
                } else {
                    liveFrame = _allData[0];
                }
                
                for (int i = 0; i < liveFrame.count; i++) {
                    KSLiveFrame *liveF = liveFrame[i];
                    //                NSLog(@"%@ ---- %i",self.lastLive[0],liveF.live.match_id);
                    if ([_lastLive[0] intValue] == liveF.live.match_id) {
                        
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
                        
                        if ([_allType containsObject:@"0"]) {
                            [_allData[1] mutableCopy];
                        } else {
                            [_allData[0] mutableCopy];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self reloadTableView];

                            [self.tableView reloadData];
                        });
                        
                    }
                }
            }
        }
        
    }failure:^(NSError *error) {
        
    }];
}

- (void)loadTennisLive {
    [KSKuaiShouTool getBasketballAndTennisLiveWithType:2 withFlagNum:_tennisID withCompleted:^(id responseObject) {
        LiveResult *last = [LiveResult mj_objectWithKeyValues:responseObject];

        self.live = [last.result mutableCopy];
        if (self.live.count > 0) {

            NSString *liveD = _live[0].d;
            _tennisID = self.live[0].flag_num;
            NSMutableArray *match = [[liveD componentsSeparatedByString:@"@"] mutableCopy];
            for (int i = 0; i < match.count; i++) {
                
                [self.lastLive removeAllObjects];
                self.lastLive = [[match[i] componentsSeparatedByString:@"|"] mutableCopy];
                NSMutableArray *liveFrame;
                if ([_allType containsObject:@"0"] && [_allType containsObject:@"1"]) {
                    liveFrame = _allData[2];
                } else if ([_allType containsObject:@"0"] || [_allType containsObject:@"1"]) {
                    liveFrame = _allData[1];
                } else if ([_allType containsObject:@"2"]){
                    liveFrame = _allData[0];
                }
                
                for (int i = 0; i < liveFrame.count; i++) {
                    KSLiveFrame *liveF = liveFrame[i];
                    NSLog(@"%@ ---- %li",self.lastLive[0],(long)liveF.live.match_id);
                    if ([_lastLive[0] intValue] == liveF.live.match_id) {
                        
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

                        
                        if ([_allType containsObject:@"0"] && [_allType containsObject:@"1"]) {
                            [_allData[2] mutableCopy];
                        } else if ([_allType containsObject:@"0"] || [_allType containsObject:@"1"]) {
                            [_allData[1] mutableCopy];
                        } else {
                            [_allData[0] mutableCopy];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self reloadTableView];

                            [self.tableView reloadData];
                        });

                    }
                }
            }
        }
    }failure:^(NSError *error) {
        
    }];
}


- (void)getID {
    // 取到数据就把ID加1，取不到数据就继续取
    
    // 获取变化ID
    [KSHttpTool GETWithURL:@"http://app.likesport.com/api/live/match_flagid_json_get?" params:nil success:^(id responseObject) {
        NSInteger matchid = [[responseObject objectForKey:@"result"] intValue];
        if (_matchID != matchid) {
            _matchID = matchid;
            [self loadFootballLive];
        }
        
    }failure:nil];
    //    [self reload];
    
    //    [self dataUpdate];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
}

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
        [self setDataWithMatchID:[Fn intValue]];
        
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<C>.*?</C>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *array = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    for (NSTextCheckingResult *result in array) {
        NSString *C = [searchText substringWithRange:result.range];
        C = [C stringByReplacingOccurrencesOfString:@"<C>" withString:@""];
        C = [C stringByReplacingOccurrencesOfString:@"</C>" withString:@""];
        
        NSMutableArray *lastLive = [[C componentsSeparatedByString:@"|"] mutableCopy];
        NSMutableArray *liveFrame;
        if ([_allType containsObject:@"0"]) {
            liveFrame = _allData[0];
        }
        
        for (int i = 0; i < liveFrame.count; i++) {
            KSLiveFrame *liveF = liveFrame[i];
            NSLog(@"%li----%@",(long)liveF.live.match_id,lastLive[0]);
            //            KSLiveFrame *liveF = self.liveFrames[i];
            if ([lastLive[0] intValue] == liveF.live.match_id) {
                
                //
                NSLog(@"之前主队%ld",(long)liveF.live.total_h);
                NSLog(@"之前客队%ld",(long)liveF.live.total_c);
                
                if (liveF.live.total_h  != [lastLive[2] integerValue] || liveF.live.total_c  != [lastLive[3] integerValue]) {
                    [liveF.live setValue:lastLive[2] forKey:@"total_h"];
                    [liveF.live setValue:lastLive[3] forKey:@"total_c"];
                    
                }
                [liveF.live setValue:lastLive[1] forKey:@"state"];
                [liveF.live setValue:lastLive[4] forKey:@"rcard_h"];
                [liveF.live setValue:lastLive[5] forKey:@"rcard_c"];
                
                [_allData mutableCopy];
                NSLog(@"之后主队%ld",(long)liveF.live.total_h);
                NSLog(@"之后客队%ld",(long)liveF.live.total_c);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self reloadTableView];
                    NSIndexPath *idxPth = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];//                    [self.tableView reloadData];
                });
            }
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
            NSString *Fn = [FnElement stringValue];
//            [self updateDataWithPage:0 with:[Fn intValue]];

            [self setDataWithMatchID:[Fn intValue]];
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
        NSMutableArray *liveFrame;
        if ([_allType containsObject:@"0"]) {
            liveFrame = _allData[0];
        }
        
        for (int i = 0; i < liveFrame.count; i++) {
            KSLiveFrame *liveF = liveFrame[i];
            NSLog(@"%li----%@",(long)liveF.live.match_id,lastLive[0]);
            //            KSLiveFrame *liveF = self.liveFrames[i];
            if ([lastLive[0] intValue] == liveF.live.match_id) {
                
                //
                NSLog(@"之前主队%ld",(long)liveF.live.total_h);
                NSLog(@"之前客队%ld",(long)liveF.live.total_c);
 
                if (liveF.live.total_h  != [lastLive[2] integerValue] || liveF.live.total_c  != [lastLive[3] integerValue]) {
                    [liveF.live setValue:lastLive[2] forKey:@"total_h"];
                    [liveF.live setValue:lastLive[3] forKey:@"total_c"];
                    
                }
                [liveF.live setValue:lastLive[1] forKey:@"state"];
                [liveF.live setValue:lastLive[4] forKey:@"rcard_h"];
                [liveF.live setValue:lastLive[5] forKey:@"rcard_c"];

                [_allData mutableCopy];
                NSLog(@"之后主队%ld",(long)liveF.live.total_h);
                NSLog(@"之后客队%ld",(long)liveF.live.total_c);
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self reloadTableView];
                    NSIndexPath *idxPth = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];//                    [self.tableView reloadData];
                });
            }
        }
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
//    self.isExpand = NO;
//    self.selectedIndexPath = nil;
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




- (NSMutableArray *)lastLive {
    if (!_lastLive) {
        _lastLive = [@[] mutableCopy];
    }
    return _lastLive;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [cell.layer setBorderWidth:0.2f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//        if (_isTimer) {
            [self removeTimer];
//        }
//        if (_isMinuteTimer) {
            [self removeMinuteTimer];
//        }
    
    // 隐藏导航条下边的黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

    typeBtn.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    if (_currentPage == 0 && !_isTimer) {
    [self checkIfMatchIsComing];
    [self addTimer];
    //    }
    //    if (_currentPage == 0 && !_isMinuteTimer) {
    [self addMinuteTimer];
    //    }
    // 隐藏导航条下边的黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    
    // 应用开始活动时自动刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    typeBtn.hidden = NO;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    BOOL isFollow = [defaults boolForKey:@"followView"];
    if (isFollow) {
        [self updateDataWithMatchID:0];
        [defaults setBool:NO forKey:@"followView"];
        [defaults synchronize];
    }
}

- (void)pushAction {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //pushName 通知必传值，根据他是否为空来判断是否有通知
    NSString *pushName = [app.pushInfo objectForKey:@"action"];
    if([pushName isEqualToString:@"follow"]){
        app.pushInfo = nil;
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    if (time - _nowSp > 60) {

        [self updateDataWithMatchID:0];

        _nowSp = time;
    }
    

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{


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