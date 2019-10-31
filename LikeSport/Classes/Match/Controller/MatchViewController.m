//
//  MatchViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/5.
//  Copyright © 2016年 likesport. All rights reserved.
//

#import "MatchViewController.h"
#import "KSMatchView.h"
#import "KSLiveTableViewCell.h"

#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "BaseViewController.h"

#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"

#import "KSLiveTableViewCell.h"

#import "UIViewAdditions.h"

#import "KSHttpTool.h"


#import "FootballDetailController.h"
#import "KSLive.h"
#import "KSMore.h"
#import "GDataXMLNode.h"
#import "KSLiveFrame.h"
#import "KSLiveExpansionCell.h"
#import "KSLiveCell.h"

#import "KSExpansionFrame.h"
#import "KSExpansionCell.h"
#import "KSChooseController.h"

#import "KSChooseController.h"
#import "CalendarViewController.h"
#import "MJRefresh.h"
#import "KSChoose.h"

#define ExpandCount 1
#define TOPHEIGHT 35

@interface MatchViewController ()<UITableViewDataSource, UITableViewDelegate,KSLiveCellDelegate , UIScrollViewDelegate,ChooseDelegate,UITabBarDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, weak)UITableView *tableView;


@property (nonatomic, strong) NSMutableArray<KSLastestParamResult *> *liveGroup;



@property (nonatomic, strong) NSMutableArray *allVC;
//@property (nonatomic, weak) UIButton *leftButton;

// 最新变化
@property (nonatomic, strong) NSMutableArray *lastLive;
@property (nonatomic, strong) NSMutableArray<KSLive *> *live;
@property (nonatomic, strong) NSMutableArray<KSMore *> *more;
@property (nonatomic, strong) NSMutableArray *liveFrames;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *minuteTimer;


@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic, assign) BOOL isMinuteTimer;



@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
//@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectedIndexPath;

@property (weak, nonatomic) UILabel *label;

///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

///@brife 下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;
@property (nonatomic, strong) NSMutableArray *labelViews;


///@brife TableViews的数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *basketballSource;
@property (nonatomic, strong) NSMutableArray *footballSource;
@property (nonatomic, strong) NSMutableArray *tennisSource;
@property (nonatomic, strong) NSMutableArray *selectArray;



///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 下面滑动的View
@property (strong, nonatomic) UIView *slideView;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;
@property (assign) NSInteger tabCount;

// 请求日期
@property (nonatomic, strong) NSMutableArray *allDate;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger chooseType;
@property (nonatomic, assign) NSInteger ballChoose;
@property (nonatomic, assign) NSInteger pageChoose;

@property (nonatomic, strong) NSMutableArray *chooseSource;

//@property (nonatomic, assign) BOOL canceled;
@end
static NSString *reuseid = @"useid";

//static NSInteger type = 0;

@implementation MatchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initSegmentedControl];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 应用开始活动时自动刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDataSource) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
//    [self setupRefresh];
    
    
    // 初始化表格
    [self initHorizontalView];

    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 30, 30)];
    [chooseButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(didClickedChooseButton) forControlEvents:UIControlEventTouchUpInside];
//        [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *chooseBtn =[[UIBarButtonItem alloc] initWithCustomView:chooseButton];
    
    UIButton *calendarButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 30, 30)];
    [calendarButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(didClickedCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    
//        [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *calendarBtn =[[UIBarButtonItem alloc] initWithCustomView:calendarButton];
    NSArray *buttonArray = [[NSArray alloc]initWithObjects:chooseBtn,calendarBtn, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    
    self.tabBarController.delegate = self;
    
}

- (void)didClickedChooseButton {
    KSChooseController *chooseVc = [[KSChooseController alloc] init];
    if (_type == 0 || _type == 1) {
        //        KSLiveFrame *liveF = _footballSource[_currentPage][indexPath.section];
        //        footballDetailVc.matchID = liveF.live.match_id;
        //        footballDetailVc.type = type;
        chooseVc.type = _type;
        chooseVc.MDay = _allDate[_currentPage];
        chooseVc.delegate = self;
        if (_ballChoose == _type && _pageChoose == _currentPage) {
            chooseVc.chooseArray = _selectArray;
            chooseVc.isMatch = _chooseType;
        }
        //        chooseVc.chooseType = _chooseType;
        [chooseVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chooseVc animated:YES];
    }

}


- (void)didClickedCalendarButton {
    CalendarViewController *calendarVC = [[CalendarViewController alloc] init];
    [calendarVC setHidesBottomBarWhenPushed:YES]; 
    [self.navigationController pushViewController:calendarVC animated:YES];
}

// 筛选后返回的数组
- (void)chooseArray:(NSArray *)array chooseType:(NSInteger)chooseType type:(NSInteger)type selectIndex:(NSArray *)index{
    _chooseSource = [array mutableCopy];
    _chooseType = chooseType;
    _ballChoose = type;
    _selectArray = index;
    
    [self conditionArray:array withData:_dataSource[_currentPage]];
    _ballChoose = _type;
    _pageChoose = _currentPage;
}

- (void)conditionArray:(NSArray *)array withData:(NSArray *)data {
    NSMutableArray *current = [NSMutableArray arrayWithCapacity:4];
    
        current = [NSMutableArray array];
        if (data.count > 0) {
            for (int j = 0; j < data.count; j++) {
                KSLiveFrame *liveF = data[j];
                //                if (i != 3) {
                if (_chooseType == 1) { // 赛事筛选
                    for (int k = 0; k < array.count; k++) {
                        //                        NSLog(@"%i----------%li",[array[k] intValue],(long)liveF.live.matchtype_id);
                        Matchtypes *match = array[k];
                        if ([match.name isEqualToString:liveF.live.matchtypefullname]) {
//                        if (match.rid == liveF.live.matchtype_id) {
                            [current addObject:liveF];
                        }
                    }
                } else if (_chooseType == 2) {
                    for (int k = 0; k < array.count; k++) {
                        Matchtypes *match = array[k];
                        if (match.rid == liveF.live.tregion_id) {
                            [current addObject:liveF];
                        }
                    }
                }
        }
    }
    _dataSource[_currentPage] = current;
    
    UITableView *currentTable = _scrollTableViews[_currentPage%2];
    [currentTable reloadData];
}



- (void) initHorizontalView
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 30;
    _mViewFrame = screenBound;
    _tabCount = 7;
    _topViews = [[NSMutableArray alloc] init];
    _scrollTableViews = [[NSMutableArray alloc] init];
    
    [self initScrollView];
    
    [self initTopTabs];
    
    [self initDownTables];
    
    [self initDataSource];
    
    [self initSlideView];
    
    // 设置默认页
    [_scrollView setContentOffset:CGPointMake(2 * _mViewFrame.size.width, 0) animated:YES];
}



#pragma mark -- 初始化表格的数据源
-(void) initDataSource{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    _footballSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    _basketballSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    _tennisSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    
    for (int i = 0; i < _tabCount ; i++) {
        [self updateDataWithPage:i];
    }
}


#pragma mark -- 更新单个表格的数据源
- (void)updateDataWithPage:(NSUInteger)page {
    NSMutableArray *liveFrames = [NSMutableArray array];
    if (_dataSource.count < 7) {
        [_dataSource addObject:liveFrames];
    }
    if (_footballSource.count < 7) {
        [_footballSource addObject:liveFrames];
    }
    if (_basketballSource.count < 7) {
        [_basketballSource addObject:liveFrames];
    }
    if (_tennisSource.count < 7) {
        [_tennisSource addObject:liveFrames];
    }
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.userInteractionEnabled = NO;
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        [self doSomeWork];
//    });
    
    
    [KSKuaiShouTool getMatchWithType:_type ofState:@"all" withMDay:_allDate[page] WithCompleted:^(id result) {
        
        //        self.live = [result mutableCopy];
        NSLog(@"type== %li",(long)_type);
        for (KSLive *live in result) {
            KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
            live.type = _type;
            live.isMatch = YES;
            liveF.live = live;
            [liveFrames addObject:liveF];
        }
        
        
        switch (_type) {
            case 0:
                [_footballSource replaceObjectAtIndex:page withObject:liveFrames];
                    _dataSource = _footballSource;

//                if (_chooseType == 0) {
//                    _dataSource = _footballSource;
//                } else if (_ballChoose == 0 ) {
//                    [self conditionArray:_chooseSource withData:_footballSource];
//                }
                break;
            case 1:
                [_basketballSource replaceObjectAtIndex:page withObject:liveFrames];
                    _dataSource = _basketballSource;

//                if (_chooseType == 0) {
//                    _dataSource = _basketballSource;
//                } else if (_ballChoose == 1) {
//                    [self conditionArray:_chooseSource withData:_basketballSource];
//                }
                break;
            case 2:
                [_tennisSource replaceObjectAtIndex:page withObject:liveFrames];
                _dataSource = _tennisSource;

//                if (_chooseType == 1 || _chooseType == 2) {
//                    [self conditionArray:_chooseSource withData:_tennisSource];
//                } else {
//                    _dataSource = _tennisSource;
//                }
                break;
                
            default:
                break;
        }
        
        //        [_dataSource replaceObjectAtIndex:page withObject:liveFrames];
        
        [_dataSource mutableCopy];
        //            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.tableView reloadData];
            UITableView *currentTable = _scrollTableViews[_currentPage%2];
            [currentTable reloadData];
            [currentTable.mj_header endRefreshing];
            
            // 没有数据时显示label  (kSceenWidth/2-40 , 70, 80, 40)
            
            NSArray *live = _dataSource[_currentPage];
            if (live.count == 0) {
                self.label.hidden = NO;
                if (_chooseType == 0) {
                    self.label.text = @"暂无数据";
                } else {
                    self.label.text = @"没有符合筛选条件的赛事";
                }
            } else if (live.count > 0) {
                self.label.hidden = YES;
            }
            
//            [hud hideAnimated:YES];
            
            //            UITableView *table = _scrollTableViews[0];
            //            [table reloadData];
        });
    } failure:^(NSError *error) {
//        [hud hideAnimated:YES];
        self.label.text = [error localizedDescription];
//        hud.label.text = [error localizedDescription];
        UITableView *currentTable = _scrollTableViews[_currentPage%2];

        [currentTable.mj_header endRefreshing];

    }];
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mViewFrame.origin.y + 5, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - 60);
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}


#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    
    CGFloat width = _mViewFrame.size.width / 5.5;
    
    if(self.tabCount <=6){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT - 2, width, 2)];
    [_slideView setBackgroundColor:[UIColor colorWithRed:254/255.0 green:198/255.0 blue:22/255.0 alpha:1]];
    [_topScrollView addSubview:_slideView];
}


#pragma mark -- 实例化顶部的tab
-(void) initTopTabs{
    CGFloat width = _mViewFrame.size.width / 5.5;
    
    if(self.tabCount <=6){
        width = _mViewFrame.size.width  / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = YES;
    
    _topScrollView.bounces = NO;
    
    _topScrollView.delegate = self;
    
    if (_tabCount >= 6) {
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, TOPHEIGHT);

    } else {
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, TOPHEIGHT);
    }
    
    
    [self.view addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
//    NSDate *now=[NSDate date];
    NSTimeInterval  interval =24*60*60*1; //1:天数
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    _allDate = [NSMutableArray arrayWithCapacity:_tabCount];
    
    if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        [dateformatter setDateFormat:@"EE MM-dd"];
    } else {
        [dateformatter setDateFormat:@"EE dd/MM"];
    }

//    NSString *today=[dateformatter stringFromDate:now];

    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:7];
    for (int i = 3; i > -4; i--) {
        NSDate *time = [NSDate dateWithTimeIntervalSinceNow:-i*interval];
        NSString *timeStr = [dateformatter stringFromDate:time];
        [dates addObject:timeStr];
        
         NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[time timeIntervalSince1970]];
        [_allDate addObject:timeSp];

    }
    

    
    NSLog(@"dates:%@",dates);
    // 标题
    
//    NSArray *title = @[NSLocalizedStringFromTable(@"Playing", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Result", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Fllow", @"InfoPlist", nil)];
    _topMainView.backgroundColor = KSBlue;
    for (int i = 0; i < _tabCount; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, TOPHEIGHT)];
        
//        view.backgroundColor = KSBlue;//[UIColor lightGrayColor];
        
        //        if (i % 2) {
        //            view.backgroundColor = KSBlue;//[UIColor grayColor];
        //        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, TOPHEIGHT)];
        button.tag = i;
        
        button.titleLabel.numberOfLines = 2;
//        [button setTitle:[NSString stringWithFormat:@"  %@%@", weeks[i],dates[i]] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"  %@",dates[i]] forState:UIControlStateNormal];

        button.titleLabel.font =[UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
}


#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    UIButton *button = sender;
    [_scrollView setContentOffset:CGPointMake(button.tag * _mViewFrame.size.width, 0) animated:YES];
    [self updateDataWithPage:_currentPage];

}

#pragma mark --初始化下方的TableViews
-(void) initDownTables{
    
    for (int i = 0; i < 2; i ++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * kSceenWidth, 5, kSceenWidth, kSceenHeight - TOPHEIGHT - 110)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        //没有内容时不显示分隔线
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];

        
        
//        UIRefreshControl *control=[[UIRefreshControl alloc]init];
//        [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
//        [tableView addSubview:control];
//        [control beginRefreshing];
//        [self refreshStateChange:control];
        
        [tableView registerClass:[KSLiveCell class] forCellReuseIdentifier:@"KSLiveCell"];
        [tableView registerClass:[KSExpansionCell class] forCellReuseIdentifier:@"KSExpansionCell"];
        //        [tableView registerNib:[UINib nibWithNibName:@"KSLiveExpansionCell" bundle:nil] forCellReuseIdentifier:@"KSLiveExpansionCell"];
        
        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
        
        //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth/2 - 40) + i * kSceenWidth, 50, 80, 40)];
        //        label.text = @"暂无数据";
        //        label.tag = i;
        //        label.hidden = YES;
        //        [_labelViews addObject:label];
        //        [_scrollView addSubview:label];
        
    }
    
}

- (void)refreshData {
    [self updateDataWithPage:_currentPage];
}


#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    int tabviewTag = pageNumber % 2;
    
    CGRect tableNewFrame = CGRectMake(pageNumber * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT - 110);
    
    UITableView *reuseTableView = _scrollTableViews[tabviewTag];
    reuseTableView.frame = tableNewFrame;
    
    [reuseTableView reloadData];
    
}




#pragma mark -- scrollView的代理方法

-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            sumStep = width * (count + 1);
        }
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
}

//停止拖拽的时候开始执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];

}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
    

    // 切换视图时请求更新数据
    NSLog(@"滚动页数%ld",(long)_currentPage);

}

//减速停止的时候开始执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
//    self.isExpand = NO;
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandSection:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView endUpdates];
//    self.selectedIndexPath = nil;
    
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        // 切换视图时请求更新数据
        //        [self updateDataWithPage:_currentPage];
        
        [self updateTableWithPageNumber:_currentPage];
        self.isExpand = NO;
        self.selectedIndexPath = nil;
        
        UITableView *currentTable = _scrollTableViews[_currentPage%2];
        [currentTable.mj_header beginRefreshing];
        return;
        
    }
    [self modifyTopScrollViewPositiong:scrollView];
    
    

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        
        if (self.tabCount <= 6) {
            frame.origin.x = scrollView.contentOffset.x/_tabCount;
        } else {
            frame.origin.x = scrollView.contentOffset.x/5.5;
            
        }
        
        
        _slideView.frame = frame;
    }
    
    
    
}



/**
 *  下拉刷新
 */
//-(void)setupRefresh
//{
//    //1.添加刷新控件
//    UIRefreshControl *control=[[UIRefreshControl alloc]init];
//    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:control];
//    
//    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
//    [control beginRefreshing];
//    
//    // 3.加载数据
//    [self refreshStateChange:control];
//    
//    NSLog(@"W = %i",[@"F" intValue]);
//}
//
///**
// *  UIRefreshControl进入刷新状态：加载最新的数据
// */
//-(void)refreshStateChange:(UIRefreshControl *)control
//{
//    //    [self reload];
//    //2.刷新表格
//    [self updateDataWithPage:_currentPage];
//    
//    self.isExpand = NO;
//    self.selectedIndexPath = nil;
//    
//    
//    // 3. 结束刷新
//    [control endRefreshing];
//}



- (void)updateFootballTable
{
    UITableView *currentTable = _scrollTableViews[0];
    [currentTable reloadData];
}



#pragma mark - Table view  delegate & data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *lives = _dataSource[_currentPage];
    return lives.count;
//    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isExpand && self.selectedIndexPath.section == section) {
        return 1 + ExpandCount; //多个数量
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row != 0) {
        
        if (_type == 1) {
            
            return 150;
        } else if (_type == 2) {
            return 110;
        } else {
            return (_more.count + 1 ) * 20 + 5;
        }
    } else {
        return 65;
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell;
    KSExpansionCell *expansionCell = [KSExpansionCell cellWithTableView:tableView];
    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];
    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row != 0) {     // Expand Cell
        if (_type == 1 || _type == 2) {
            KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
            
            expansionCell.liveF = liveF;
            //        expansionCell.backgroundColor = [UIColor lightGrayColor];
            //        cell = lcell;
            return expansionCell;
        } else {
            KSExpansionCell *footballCell = [[KSExpansionCell alloc] init];
            KSLiveFrame *liveF = _footballSource[_currentPage][indexPath.section];
            NSLog(@"hteamname%@",liveF.live.hteamname);
            footballCell.live = liveF.live;
            footballCell.more = _more;
            //            expansionCell.count = 1;
            return footballCell;
        }
        
    } else {    // Normal cell
        
        cell.delegate = self;
        if ([tableView isEqual:_scrollTableViews[_currentPage%2]]) {
            if ((unsigned long)[_dataSource[_currentPage] count] != 0) {
                KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
                cell.liveF = liveF;
                
                //                liveF.live.isFootH = NO;
                //                liveF.live.isFootC = NO;
                //                liveF.live.isBasH = NO;
                //                liveF.live.isBasC = NO;
                //                liveF.live.isTenH = NO;
                //                liveF.live.isTenC = NO;
            }
            //            cell = lcell;
        }
        
        
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色

    return cell;
}



#pragma mark 点击扩展
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath %ld-------%ld selectIndexPath",(long)indexPath.section,(long)self.selectedIndexPath.section);
    if (!self.selectedIndexPath) {
        [_more removeAllObjects];
        if (_type == 0) {
            // 请求足球进球数据
            KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
            NSLog(@"htname%@",liveF.live.hteamname);
            [KSKuaiShouTool getLiveMoreMatchID:liveF.live.match_id WithCompleted:^(id result) {
                _more = [result mutableCopy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UITableView *table = _scrollTableViews[_currentPage%2];
                    //                    [table reloadData];
                    NSIndexPath *idxPth = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                    if (self.selectedIndexPath.length > 1) {
                        
                        [table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }
                });
            } failure:^(NSError *error) {
                
            }];
            
        }
        
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:[self indexPathsForExpandSection:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
        
    } else {
        if (self.isExpand) {
            if (self.selectedIndexPath == indexPath) {
                self.isExpand = NO;
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[self indexPathsForExpandSection:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
                self.selectedIndexPath = nil;
            } else if (self.selectedIndexPath.row != indexPath.row && indexPath.section <= self.selectedIndexPath.section) {
                // Select the expand cell, do the relating dealing.
            }
            else if (self.selectedIndexPath.section != indexPath.section){ // 展开时点击其他cell打开其他cell
                [_more removeAllObjects];
                if (_type == 0) {
                    // 请求足球进球数据
                    KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
                    [KSKuaiShouTool getLiveMoreMatchID:liveF.live.match_id WithCompleted:^(id result) {
                        _more = [result mutableCopy];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UITableView *table = _scrollTableViews[_currentPage%2];
                            //                            [table reloadData];
                            NSIndexPath *idxPth = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                            if (self.selectedIndexPath.length > 1) {
                                
                                [table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                            }
                        });

                    } failure:^(NSError *error) {
                        
                    }];
                    
                }
                
                self.isExpand = NO;
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[self indexPathsForExpandSection:self.selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
                self.selectedIndexPath = nil;
                
                self.selectedIndexPath = indexPath;
                self.isExpand = YES;
                [tableView beginUpdates];
                [tableView insertRowsAtIndexPaths:[self indexPathsForExpandSection:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
            }
            else {
                self.isExpand = NO;
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[self indexPathsForExpandSection:self.selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
                self.selectedIndexPath = nil;
            }
        }
    }
}

- (void)followTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"点击关注");
    KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
    NSLog(@"赛事类型%@  type%li id%li",liveF.live.matchtypefullname,(long)_type,(long)liveF.live.match_id);
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
            
        } else {
            if (liveF.live.is_follow == 0) {
                liveF.live.is_follow = 1;
            } else if (liveF.live.is_follow == 1){
                liveF.live.is_follow = 0;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *table = _scrollTableViews[_currentPage%2];
            [table reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
    
}



- (NSArray *)indexPathsForExpandSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}

#pragma mark tabelView点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0 || _type == 1) {
        KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
        footballDetailVc.matchID = liveF.live.match_id;
        footballDetailVc.type = _type;
        if ([liveF.live.state isEqualToString:@"W"]) {
            footballDetailVc.state = 1;
        }
        [footballDetailVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:footballDetailVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark 体育分类选择
- (void)initSegmentedControl
{
    UIImage *image1 = [UIImage imageNamed:@"football"];
    UIImage *image2 = [UIImage imageNamed:@"basketball"];
    UIImage *image3 = [UIImage imageNamed:@"tennisball"];
    
    NSArray *segmentedData = [[NSArray alloc] initWithObjects:image1,image2,image3, nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(10, (kSceenWidth-90)/2, 90, 30.0);
    
    //设置按下按钮时的颜色
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    //设置字体的大小和颜色
    //    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithRed:52/255.0 green:98/255.0 blue:147/255.0 alpha:1],NSForegroundColorAttributeName, nil];
    //
    //    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //
    //
    //    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    //    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(dosomethingInSegment:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
}

- (void)dosomethingInSegment:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    UITableView *currentTable = _scrollTableViews[_currentPage%2];

    switch (index) {
        case 0:
            _type = 0;
            [self initDataSource];
//            [currentTable.mj_header beginRefreshing];

            self.isExpand = NO;
            self.selectedIndexPath = nil;
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            break;
            
        case 1:
            _type = 1;
            [self initDataSource];
//            [currentTable.mj_header beginRefreshing];

            self.isExpand = NO;
            self.selectedIndexPath = nil;
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            break;
            
        case 2:
            _type = 2;
//            [self initDataSource];
            [currentTable.mj_header beginRefreshing];

            self.isExpand = NO;
            self.selectedIndexPath = nil;
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}

- (NSMutableArray *)footballSource
{
    if (!_footballSource) {
        _footballSource = [@[] mutableCopy];
    }
    return _footballSource;
}

- (NSMutableArray *)basketballSource
{
    if (!_basketballSource) {
        _basketballSource = [@[] mutableCopy];
    }
    return _basketballSource;
}

- (NSMutableArray *)tennisSource
{
    if (!_tennisSource) {
        _tennisSource = [@[] mutableCopy];
    }
    return _tennisSource;
}

- (NSMutableArray *)lastLive {
    if (!_lastLive) {
        _lastLive = [@[] mutableCopy];
    }
    return _lastLive;
}

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [@[] mutableCopy];
    }
    return _selectArray;
}

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth-220)/2 , 70, 220, 40)];
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.scrollView addSubview:label];
        [self.view insertSubview:label atIndex:1];
        _label = label;
    }
    return _label;
}

-(NSMutableArray *)liveFrames
{
    if (_liveFrames == nil) {
        _liveFrames = [NSMutableArray array];
    }
    return _liveFrames;
}


//- (NSMutableArray<NSIndexPath *> *)selectedIndexPath{
//    if (!_selectedIndexPath) {
//        _selectedIndexPath = [@[] mutableCopy];
//    }
//    return _selectedIndexPath;
//}

// 分割线对齐左边
-(void)viewDidLayoutSubviews
{
    UITableView *tableView = _scrollTableViews[_currentPage%2];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 隐藏导航条下边的黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 隐藏导航条下边的黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
   
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UITableView *currentTable = _scrollTableViews[_currentPage%2];
    [currentTable.mj_header beginRefreshing];
}



- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, kSceenWidth, kSceenHeight-74) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = NO;
        
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 200)];
        //        tableView.tableHeaderView = view;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
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