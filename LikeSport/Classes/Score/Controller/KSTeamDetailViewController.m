//
//  KSTeamDetailViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 2017/5/3.
//  Copyright © 2017年 swordfish. All rights reserved.
//

#import "KSTeamDetailViewController.h"
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

@interface KSTeamDetailViewController ()<KSLiveCellDelegate,UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

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

@implementation KSTeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarController.view setBackgroundColor:[UIColor whiteColor]];
    
    //[self createTableView];
    
    [self setData];
    
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [followBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"followed"] forState:UIControlStateHighlighted];
    [followBtn addTarget:self action:@selector(followMatch) forControlEvents:UIControlEventTouchUpInside];
   
    _followBtn = followBtn;
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:followBtn];
    self.navigationItem.rightBarButtonItem = mailbutton;
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
        
        if (_allData.count!=0&&_allTitle.count!=0) {
            
            NSArray *alld = [[_allData reverseObjectEnumerator] allObjects];
            NSArray *allt = [[_allTitle reverseObjectEnumerator] allObjects];
            _allData=[NSMutableArray arrayWithArray:alld];
            _allTitle=[NSMutableArray arrayWithArray:allt];
        }
        
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
