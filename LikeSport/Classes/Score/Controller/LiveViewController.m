//
//  LiveViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "LiveViewController.h"

#import "PlayingController.h"
#import "NoStartController.h"

#import "FollowController.h"
#import "FootballDetailController.h"
#import "KSChooseController.h"
#import "SearchViewController.h"
#import "UIBarButtonItem+Badge.h"

@interface LiveViewController ()<SMPagerTabViewDelegate,ChooseDelegate>

@property (nonatomic, strong) NSMutableArray *allVC;


@property (weak, nonatomic) PlayingController *playingController;
@property (weak, nonatomic) NoStartController *noStartController;

@property (weak, nonatomic) FollowController *followController;
@property (nonatomic, assign) NSInteger type;
@property (weak, nonatomic) UISegmentedControl *segmentedControl;
// 时间戳，超过60秒左右滑动就自动刷新
@property (nonatomic, assign) NSTimeInterval nowSp;
@property (nonatomic, assign) NSString *chooseDate; // 筛选日期记录

// 当前页
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger chooseType; // 1为赛事筛选 2为国家筛选
@property (nonatomic, assign) NSInteger dateChooseType; // 1为日期赛事筛选 2为日期国家筛选
@property (nonatomic, assign) NSInteger ballChoose; // 类别筛选
@property (nonatomic, assign) NSInteger dateBallChoose; // 日期筛选
@property (nonatomic, strong) NSMutableArray *selectArray; // 当前日筛选选中行
@property (nonatomic, strong) NSMutableArray *selectDateArray; // 赛程赛果筛选选中行
@property (nonatomic, strong) NSMutableArray *dateChooseSource; // 日期筛选数组
@property (nonatomic, strong) NSMutableArray *chooseSource;
@property (nonatomic, assign) NSInteger today; // 当前日，用来判断日期菜单是否有变化
@property (nonatomic, copy) NSString *residueCount; // 未被选中的数量
@property (nonatomic, copy) NSString *residueDateCount; // 赛程赛果未被选中的数量
//@property (nonatomic, assign) NSInteger chooseDate; // 筛选日期记录

@property (weak, nonatomic) UIButton *chooseBtn;

//@property (nonatomic, strong)KSChooseController *chooseVc;
//@property (nonatomic, strong) NSMutableArray *chooseVcs;

@end

@implementation LiveViewController
//-(NSMutableArray*)chooseVcs{
//    if (_chooseVcs==nil) {
//        _chooseVcs=[[NSMutableArray alloc]init];
//        KSChooseController *chooseVc = [[KSChooseController alloc] init];
//        if (_currentPage == 1 && [[_allVC[1] getChooseDate] intValue] != 0) {
//            if (_chooseDate == [_allVC[1] getChooseDate]) {
//                chooseVc.chooseArray = _selectDateArray;
//            }
//            _chooseDate = [_allVC[1] getChooseDate];
//            chooseVc.MDay = _chooseDate;
//        } else if (_currentPage == 2 && [[_allVC[2] getChooseDate] intValue] != 0) {
//            if (_chooseDate == [_allVC[2] getChooseDate]) {
//                chooseVc.chooseArray = _selectDateArray;
//            }
//            _chooseDate = [_allVC[2] getChooseDate];
//            chooseVc.MDay = _chooseDate;
//            
//        } else {
//            if (_ballChoose == _type && _selectArray.count > 0) {
//                chooseVc.chooseArray = _selectArray;
//            }
//            chooseVc.chooseType = _chooseType;
//            _chooseDate = @"0";
//        }
//        chooseVc.type = _type;
//        //        chooseVc.MDay = _chooseDate;
//        chooseVc.delegate = self;
//        
//
//    }
//    return _chooseVcs;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSegmentedControl];

    // Do any additional setup after loading the view.
    [self initHorizontalMenu];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setChooseBtn];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    _nowSp = time;
    // 应用开始活动时自动刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    NSLog(@"today=%i",[self getToday]);
    _today = [self getToday];
    
    // 增加搜索按钮
    [self addRightBtnWithImgName:@"search" andSelector:@selector(search)];
    
    


//    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//    NSArray *ra = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    

}

#pragma mark -- 搜索
- (void)search{
//    UIControl * control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [control addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:control];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.type = _type;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
//    [self presentViewController:searchVC animated:NO completion:nil];
}



#pragma mark -- 获取当前日
-(NSInteger)getToday {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return [dateComponent day];
}

#pragma mark -- 后台切换回前台
- (void)applicationDidBecomeActive {
    if (_today != [self getToday]) {
        [_noStartController.horizontalMenuView removeAllSubviews];
        [_noStartController setHorizontalMenuView];
        [_resultController.horizontalMenuView removeAllSubviews];
        [_resultController setHorizontalMenuView];
        _today = [self getToday];
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    if (time - _nowSp > 90) {
        [_playingController initWithType:_type];
        [_noStartController initWithType:_type];
        [_resultController initWithType:_type];
        [_followController initWithType:_type];
        _nowSp = time;
//    }
    
#pragma mark -- 3D touch类别跳转
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSInteger segmentTag = [[defaults objectForKey:@"segmentTag"] intValue];
    if (segmentTag != 4) {
        //        [self dosomethingInSegment:(UISegmentedControl *)];
        self.segmentedControl.selectedSegmentIndex = segmentTag;
        [self dosomethingInSegment:self.segmentedControl];
        [defaults setObject:@"4" forKey:@"segmentTag"];
        [defaults synchronize];
    }
}

#pragma mark -- 筛选按钮
- (void) setChooseBtn {
//    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [followBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
//    [followBtn setImage:[UIImage imageNamed:@"followed"] forState:UIControlStateHighlighted];
//    [followBtn addTarget:self action:@selector(followTeam) forControlEvents:UIControlEventTouchUpInside];
//    //    [someButton setShowsTouchWhenHighlighted:YES];
//    _followBtn = followBtn;
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:followBtn];
    
//    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -10, 30, 30)];
//    [someButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
//    //    someButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -20, 0, 20);
////    [someButton setImage:[UIImage imageNamed:@"choose-2"] forState:UIControlStateHighlighted];
//    [someButton addTarget:self action:@selector(didClickedChooseButton) forControlEvents:UIControlEventTouchUpInside];
//    //    [someButton setShowsTouchWhenHighlighted:YES];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
//    _chooseBtn = someButton;
//    self.navigationItem.leftBarButtonItem = mailbutton;
//    [self addRightBtnWithImgName:@"chooseBtn" andSelector:@selector(didClickedChooseButton)];
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    if (self.navigationItem.leftBarButtonItem == nil) {
        UIImage *image2 = [UIImage imageNamed:@"chooseBtn"];
        UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithImage:image2
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(didClickedChooseButton)];
        self.navigationItem.leftBarButtonItem = navRightButton;
        self.navigationItem.leftBarButtonItem.badgeBGColor = [UIColor redColor];
        self.navigationItem.leftBarButtonItem.shouldHideBadgeAtZero = YES;
        self.navigationItem.leftBarButtonItem.badgePadding = 2;
        
    }
   
    // 筛选亮红点
    if (_chooseType != 0 && _ballChoose == _type) {
        
        self.navigationItem.leftBarButtonItem.badgeValue = _residueCount;
        
    } else if (_ballChoose != _type) {
        
        self.navigationItem.leftBarButtonItem.badgeValue = @"";
        //                [self setChooseBtnChangeWithState:NO];
    }
}

- (void)didClickedChooseButton {
    
//    NSLog(@"currentPage=%i,chooseDate=%@",_currentPage,[_resultController getChooseDate]);
    KSChooseController *chooseVc = [[KSChooseController alloc] init];
   //    if (_type == 0 || _type == 1) {
         if (_currentPage == 1 && [[_allVC[1] getChooseDate] intValue] != 0) {
             if (_chooseDate == [_allVC[1] getChooseDate]) {
                 chooseVc.chooseArray = _selectDateArray;
             }
            _chooseDate = [_allVC[1] getChooseDate];
            chooseVc.MDay = _chooseDate;
        } else if (_currentPage == 2 && [[_allVC[2] getChooseDate] intValue] != 0) {
            if (_chooseDate == [_allVC[2] getChooseDate]) {
                chooseVc.chooseArray = _selectDateArray;
            }
            _chooseDate = [_allVC[2] getChooseDate];
            chooseVc.MDay = _chooseDate;

        } else {
            if (_ballChoose == _type && _selectArray.count > 0) {
                chooseVc.chooseArray = _selectArray;
//                chooseVc.isMatch = _chooseType;
            }
            chooseVc.chooseType = _chooseType;
            
            _chooseDate = @"0";
        }
        chooseVc.type = _type;
//        chooseVc.MDay = _chooseDate;
        chooseVc.delegate = self;
        [chooseVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chooseVc animated:NO];
//    }
     
}

// 筛选后返回的数组
- (void)chooseArray:(NSArray *)array chooseType:(NSInteger)chooseType type:(NSInteger)type residueCount:(NSString *)count{
   
//    if (type != _type || chooseType == 0) {
//        <#statements#>
//    }
//    if ([_chooseDate intValue] == 0 && chooseType != 0) { // chooseType不为0说明有筛选
//        
//        [self setChooseBtnChangeWithState:YES];
//    } else if (type != _type || chooseType == 0) {
//        [self setChooseBtnChangeWithState:NO];
//        _chooseType = chooseType;
////        [self initDataSource];
//    }
    

    //    [self initDataSource];
    self.navigationItem.leftBarButtonItem.badgeValue = count;

    if (_currentPage == 1 && [_chooseDate intValue] != 0 && chooseType != 0) {
//        _dateBallChoose = type;
//        _dateChooseType = chooseType;
//        _dateChooseSource = [array mutableCopy];
//        [self conditionChooseArray:_dateChooseSource withPage:1];
        _selectDateArray = [array mutableCopy];
        _residueDateCount = count;
        [_noStartController conditionDateChooseArray:array withChooseType:chooseType];

    } else if (_currentPage == 2 && [_chooseDate intValue] != 0 && chooseType != 0) {
//        _dateBallChoose = type;
//        _dateChooseType = chooseType;
//        _dateChooseSource = [array mutableCopy];
//        NSLog(@"筛选");
        _selectDateArray = [array mutableCopy];
        _residueDateCount = count;
        [_resultController conditionDateChooseArray:array withChooseType:chooseType];
//        [self conditionChooseArray:_dateChooseSource withPage:2];
    } else if (chooseType != 0) {
        _selectArray = [array mutableCopy];
        
        _chooseType = chooseType;
        _ballChoose = type;
//        _chooseType = chooseType;
//        _ballChoose = type;
//        _chooseSource = [array mutableCopy];
        _selectArray = [array mutableCopy];
//        if (count>99) {
//            self.navigationItem.leftBarButtonItem.badgeValue = @"99+";
//            //        if (_chooseDate == 0) {
//            _residueCount = @"99+";
//            //        }
//            
//        } else if (count != 0){
//            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%li",(long)count];
//            //        if (_chooseDate == 0) {
//            _residueCount = [NSString stringWithFormat:@"%li",(long)count];
//            //        }
//            
//        } else if (count == 0){
//            self.navigationItem.leftBarButtonItem.badgeValue = @"0";
//            //        if (_chooseDate == 0) {
//            _residueCount = @"0";
//            //        }
//            
//        }
        _residueCount = count;

        [_playingController conditionTadayArray:array withChooseType:chooseType];
        [_noStartController conditionTadayArray:array withChooseType:chooseType];
        [_resultController conditionTadayArray:array withChooseType:chooseType];
        switch (_type) {
            case 0:
//                [self conditionArray:_chooseSource withData:_footballSource];
                break;
            case 1:
//                [self conditionArray:_chooseSource withData:_basketballSource];
                break;
                
            default:
                break;
        }
    } else {
        _selectArray = nil;
        _residueCount = @"0";
        [_playingController selectTodayAllData];
        [_noStartController selectTodayAllData];
        [_resultController selectTodayAllData];
    }
    
}

//#pragma mark -- 设置筛选小红点
//- (void)setChooseBtnChangeWithState:(BOOL)state {
//    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    if (state) {
//        _chooseBtn.highlighted = YES;
////        [someButton setImage:[UIImage imageNamed:@"choose-2"] forState:UIControlStateNormal];
//    } else {
//        _chooseBtn.highlighted = NO;
////        [someButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
//    }
////    [someButton addTarget:self action:@selector(didClickedChooseButton) forControlEvents:UIControlEventTouchUpInside];
////    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
////    self.navigationItem.leftBarButtonItem = mailbutton;
//
//}


#pragma mark -- 初始化顶部选项卡
- (void)initSegmentedControl
{
    UIImage *image1 = [UIImage imageNamed:@"football"];
    UIImage *image2 = [UIImage imageNamed:@"basketball"];
    UIImage *image3 = [UIImage imageNamed:@"tennisball"];
    
//    NSArray *segmentedData = [[NSArray alloc] initWithObjects:image1,image2, nil];
    NSArray *segmentedData = [[NSArray alloc] initWithObjects: @"足球", @"蓝球", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(10, (kSceenWidth-90)/2, 90, 30.0);
    
    //设置按下按钮时的颜色
    segmentedControl.tintColor = [UIColor whiteColor];
    
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSInteger segmentTag = [[defaults objectForKey:@"segmentTag"] intValue];
//    if (segmentTag > -1 && segmentTag < 3) {
//        segmentedControl.selectedSegmentIndex = segmentTag;//默认选中的按钮索引
//        [defaults setObject:@"4" forKey:@"3DTouchSegmentTag"];
//        [defaults synchronize];
//    }
    
    
//    [segmentedControl setImage:[[UIImage imageNamed:@"football"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(dosomethingInSegment:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    self.segmentedControl = segmentedControl;
    
}

#pragma mark -- 初始化所有数据
- (void) initDataSource {
//    for (int i = 0; i < 4; i++) {
//        [_allVC[i] initWithType:_type];
//    }
    [_playingController initWithType:_type];
    [_noStartController initWithType:_type];
    [_resultController initWithType:_type];
    [_followController initWithType:_type];
}

#pragma mark -- 切换比赛类别
- (void)dosomethingInSegment:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    
    // 切换类别时回到正在比赛中

    switch (index) {
        case 0:
            _type = 0;

//            [seg setImage:[[UIImage imageNamed:@"football"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
//            [seg setImage:[UIImage imageNamed:@"basketball"] forSegmentAtIndex:1];
//            [seg setImage:[UIImage imageNamed:@"tennisball"] forSegmentAtIndex:2];
            [self initDataSource];
            [_segmentView selectTabWithIndex:0 animate:YES];
//            self.navigationItem.leftBarButtonItem.customView.hidden = NO;
            // 筛选亮红点
            if (_chooseType != 0 && _ballChoose == _type) {
//                [self setChooseBtnChangeWithState:YES];
            } else if (_ballChoose != _type) {
//                [self setChooseBtnChangeWithState:NO];
            }
            [self setChooseBtn];
            break;
            
        case 1:
            _type = 1;
            
//            [seg setImage:[UIImage imageNamed:@"football"] forSegmentAtIndex:0];
//            [seg setImage:[[UIImage imageNamed:@"basketball2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
//            [seg setImage:[UIImage imageNamed:@"tennisball"] forSegmentAtIndex:2];
            [self initDataSource];
            [_segmentView selectTabWithIndex:0 animate:YES];
//            self.navigationItem.leftBarButtonItem.customView.hidden = NO;
            // 筛选亮红点
            if (_chooseType != 0 && _ballChoose == _type) {
//                [self setChooseBtnChangeWithState:YES];
            } else if (_ballChoose != _type) {
//                [self setChooseBtnChangeWithState:NO];
            }
            [self setChooseBtn];

            break;
            
        case 2:
            
            _type = 2;
        
            [seg setImage:[UIImage imageNamed:@"football"] forSegmentAtIndex:0];
            [seg setImage:[UIImage imageNamed:@"basketball"] forSegmentAtIndex:1];
            [seg setImage:[[UIImage imageNamed:@"tennisball2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:2];
            [self initDataSource];
            
            [_segmentView selectTabWithIndex:0 animate:YES];
//            self.navigationItem.leftBarButtonItem = nil;
            [self setChooseBtn];

            break;
            
        default:
            break;
    }
}

#pragma mark -- 比赛状态选项卡
- (void)initHorizontalMenu {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _allVC = [NSMutableArray array];
    PlayingController *playVC = [[PlayingController alloc]init];
    playVC.type = _type;
    playVC.detailBlock = ^(NSInteger type,NSInteger matchID,NSInteger state){
        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
        footballDetailVc.matchID = matchID;
        footballDetailVc.type = type;
        footballDetailVc.state = state;
        [footballDetailVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:footballDetailVc animated:YES];
    };
    playVC.moreBlock = ^(){
        // 点击展开详情时刷新界面
//        [_segmentView refreshView];
    };

//    one.matchID = _matchID;
//    one.type = _type;
//    one.basketResult = _basketResult;
    playVC.title = NSLocalizedStringFromTable(@"Playing", @"InfoPlist", nil);
    [_allVC addObject:playVC];
    _playingController = playVC;
    
    NoStartController *noStartVC = [[NoStartController alloc]init];
//    two.matchID = _matchID;
    noStartVC.type = _type;
    noStartVC.detailBlock = ^(NSInteger type,NSInteger matchID,NSInteger state){
        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
        footballDetailVc.matchID = matchID;
        footballDetailVc.type = type;
        footballDetailVc.state = state;
        [footballDetailVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:footballDetailVc animated:YES];
    };
    noStartVC.dateBlock = ^(NSInteger page){
        if (page > 0 && page < 5) {
            _resultController.pageIndex = page;
            [_resultController.horizontalMenuView setBtnWithTag:page];
        } else {
            _resultController.isDatePicker = YES;
//            _resultController.pageIndex = 5;
        }
        [_segmentView selectTabWithIndex:2 animate:YES];
    };
    noStartVC.dateChooseBlock = ^(){
        self.navigationItem.leftBarButtonItem.badgeValue = @"0";
    };
    noStartVC.isTodayBlock = ^(){
        self.navigationItem.leftBarButtonItem.badgeValue = _residueCount;
        //        [self setChooseBtn];
    };
    
    noStartVC.title = NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil);
    [_allVC addObject:noStartVC];
    _noStartController = noStartVC;
    
    ResultController *resultVC = [[ResultController alloc]init];
    resultVC.type = _type;
//    three.mid = _matchID;
    resultVC.detailBlock = ^(NSInteger type,NSInteger matchID,NSInteger state){
        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
        footballDetailVc.matchID = matchID;
        footballDetailVc.type = type;
        footballDetailVc.state = state;
        [footballDetailVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:footballDetailVc animated:YES];
    };
    resultVC.dateBlock = ^(NSInteger page){
        if (page > 0 && page < 5) {
            _noStartController.pageIndex = page;
            [_noStartController.horizontalMenuView setBtnWithTag:page];
        } else {
//            _noStartController.pageIndex = 5;
            _noStartController.isDatePicker = YES;
        }
        [_segmentView selectTabWithIndex:1 animate:YES];
    };
    resultVC.dateChooseBlock = ^(){
        self.navigationItem.leftBarButtonItem.badgeValue = @"0";
    };
    resultVC.isTodayBlock = ^(){
        self.navigationItem.leftBarButtonItem.badgeValue = _residueCount;
//        [self setChooseBtn];
    };
    
    resultVC.title = NSLocalizedStringFromTable(@"Result", @"InfoPlist", nil);
    [_allVC addObject:resultVC];
    _resultController = resultVC;
    
    
//    FollowController *followVC = [[FollowController alloc]init];
////    four.matchID = _matchID;
//    followVC.type = _type;
//    followVC.detailBlock = ^(NSInteger type,NSInteger matchID,NSInteger state){
//        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
//        footballDetailVc.matchID = matchID;
//        footballDetailVc.type = type;
//        footballDetailVc.state = state;
//        [footballDetailVc setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:footballDetailVc animated:YES];
//    };
//    
//    followVC.title = NSLocalizedStringFromTable(@"Follow", @"InfoPlist", nil);
//    [_allVC addObject:followVC];
//    _followController = followVC;
    
    
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //开始构建UI
    [_segmentView buildUI];
    
    
    //起始选择一个tab
    [_segmentView selectTabWithIndex:0 animate:NO];
    //显示红点，点击消失
    //    [_segmentView showRedDotWithIndex:3];
    
    // 添加子控件时刷新界面
//    [_segmentView refreshView];
}

#pragma mark - 选项卡代理  DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [_allVC count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}

//左右切换视图时
- (void)whenSelectOnPager:(NSUInteger)number;
{
    // 切换选项卡调用相应控制器的视图出现方法
    UIViewController* vc = _allVC[number];
    [vc viewWillAppear:YES];
    [vc viewDidDisappear:NO];
    _currentPage = number;
//    if (number == 3 || _type == 2) {
////        self.navigationItem.rightBarButtonItem = nil;
////        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
//        self.navigationItem.leftBarButtonItem = nil;
//    } else{
        [self setChooseBtn];
//    }
    if (number!=0) {
        PlayingController* pvc=(PlayingController*)_allVC[0];
        pvc.removeaction();
    }
    
}

// 水平菜单懒加载
- (SMPagerTabView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, -40, self.view.width, self.view.height)];
        self.segmentView.tabButtonFontSize = 15;
        self.segmentView.selectedLineWidth = 60;
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

// 隐藏导航条下边的黑线
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置状态栏为白色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSInteger segmentTag = [[defaults objectForKey:@"segmentTag"] intValue];
    
    if (segmentTag != 4) {
        //        [self dosomethingInSegment:(UISegmentedControl *)];
        self.segmentedControl.selectedSegmentIndex = segmentTag;
        [self dosomethingInSegment:self.segmentedControl];
        [defaults setObject:@"4" forKey:@"segmentTag"];
        [defaults synchronize];
    }
    
    [_playingController addTimer];
    [_playingController addMinuteTimer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
@end
