//
//  ResultController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "ResultController.h"
#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "KSLiveFrame.h"
#import "KSExpansionCell.h"
#import "KSLiveCell.h"
#import "MJRefresh.h"
//#import "HorizontalMenuView.h"
#import "UWDatePickerView.h"
#import "KSChoose.h"
#import "KSNetworkTool.h"
#import "Masonry.h"

#define ExpandCount 1

@interface ResultController()<UITableViewDelegate,UITableViewDataSource,KSLiveCellDelegate,HorizontalMenuDelegate,UWDatePickerViewDelegate>
{
    UWDatePickerView *_pickerView;
}


@property (nonatomic, strong) NSArray *footballSource;
@property (nonatomic, strong) NSArray *basketSource;
@property (nonatomic, strong) NSArray *tennisSource;

@property (nonatomic, assign) NSTimeInterval footballSp;
@property (nonatomic, assign) NSTimeInterval basketSp;
@property (nonatomic, assign) NSTimeInterval tennisSp;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *allData;
@property (nonatomic, assign) NSInteger matchID;

@property (weak, nonatomic)  UILabel *label;
@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray<KSMore *> *more;
// 时间戳
@property (nonatomic, strong) NSMutableArray *timeSpArray;
@property (nonatomic, copy) NSString *datePickerSp;
@property (nonatomic, strong) NSMutableArray *dateSpArray; // 选中日期相隔两天的时间数组
@property (nonatomic, assign) NSInteger dateIndex;





@property (nonatomic, strong) UIView *scrollBar;
@property (nonatomic, assign) BOOL isScrollBar;

@property (nonatomic, assign) CGPoint lastPosition;

@property (nonatomic, strong) NSArray *chooseArray;
@property (nonatomic, assign) NSInteger ballType;   // 赛事筛选 0为足球，1为篮球
@property (nonatomic, assign) NSInteger chooseType; // 0为没有筛选，1为赛事，2为国家

@property (nonatomic, assign) NSInteger dateBallType; // 筛选类别
@property (nonatomic, assign) NSInteger dateChooseType; // 1为赛事筛选 2为国家筛选
@property (nonatomic, strong) NSArray *dateChooseArray; // 日期筛选数组
@property (weak, nonatomic) UIButton *refreshBtn;

@property (nonatomic, strong) NSMutableDictionary *livedic;


@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [self updateData];

    _pageIndex = 4;
    [self setHorizontalMenuView];
    
    [self setScrollBar];
    
    _footballSp = [[NSDate date] timeIntervalSince1970];
    
    self.livedic=[NSMutableDictionary dictionary];

}

#pragma mark -- 切换类别
- (void)initWithType:(NSInteger)type{
    _type = type;
    self.isExpand = NO;
    self.selectedIndexPath = nil;
    [_horizontalMenuView setBtnWithTag:4];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    if ([KSNetworkTool getNetworkLinkType] == 0) {
        
        [self networkHasError];
        
    } else {
        
        self.refreshBtn.hidden = YES;
        
        
        
        switch (type) {
            case 0:
                if (time - _footballSp > 60) {
                    [self updateData];
                    _footballSp = time;
                } else {
                    _dataSource = nil;
                    [self.tableView reloadData];
                    if (_chooseType == 1 && _ballType == _type) {
                        [self conditionTadayArray:_chooseArray withChooseType:_chooseType];
                        
                    } else {
                        _dataSource = [_footballSource mutableCopy];
                        [self.tableView reloadData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_footballSource.count == 0) {
                                self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                                self.label.hidden = NO;
                            } else if (_footballSource.count > 0) {
                                self.label.hidden = YES;
                                
                            }
                        });
                    }
                    
                    
                }
                break;
                
            case 1:
                if (time - _basketSp > 60) {
                    [self updateData];
                    _basketSp = time;
                } else {
                    _dataSource = nil;
                    [self.tableView reloadData];
                    if (_chooseType == 1 && _ballType == _type) {
                        [self conditionTadayArray:_chooseArray withChooseType:_chooseType];
                    } else {
                        _dataSource = [_basketSource mutableCopy];
                        [self.tableView reloadData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_basketSource.count == 0) {
                                self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                                self.label.hidden = NO;
                            } else if (_basketSource.count > 0) {
                                self.label.hidden = YES;
                                
                            }
                        });
                    }
                }
                break;
                
            case 2:
                if (time - _tennisSp > 60) {
                    [self updateData];
                    _tennisSp = time;
                } else {
                    _dataSource = nil;
                    [self.tableView reloadData];
                    _dataSource = [_tennisSource mutableCopy];
                    [self.tableView reloadData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_tennisSource.count == 0) {
                            self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                            self.label.hidden = NO;
                            [self.tableView reloadData];
                        } else if (_tennisSource.count > 0) {
                            self.label.hidden = YES;
                            
                        }
                    });
                }
                
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark -- 设置滚动条
- (void)setScrollBar {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //    [scrollBarView addGestureRecognizer:pan];
    //    [self.view addSubview:scrollBarView];
    
    _scrollBar = [[UIView alloc] initWithFrame:CGRectMake(kSceenWidth-40, 80, 40, 40)];
    [_scrollBar addGestureRecognizer:pan];
    _scrollBar.alpha = 0.7;
    //    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollBar"]];
    //    [_scrollBar setBackgroundColor:bgColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 3, 34, 34)];
    imageView.image = [UIImage imageNamed:@"scrollBar"];
    [_scrollBar addSubview:imageView];
    [self.view addSubview:_scrollBar];
    self.scrollBar.hidden = YES;
}

/* 识别拖动 */
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    [self drawImageForGestureRecognizer:gestureRecognizer atPoint:location underAdditionalSituation:nil];
    //    gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + location.x, gestureRecognizer.view.center.y + location.y);
    [gestureRecognizer setTranslation:location inView:self.view];
    NSInteger count = [_dataSource count];

    
    int a = count*(location.y-80)/(self.tableView.frame.size.height-40);
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:a];//第a个区域里的第b行。
    NSLog(@"a=%i",a);
    if (a >= 0 && a <= count-1) {
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
//    CGFloat y = (location.y - 80)/self.tableView.frame.size.height * (self.tableView.contentSize.height - self.tableView.frame.size.height);
//    [self.tableView setContentOffset:CGPointMake(0, y)];
    
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
        
        if (centerPoint.y > 80 && centerPoint.y < self.tableView.frame.size.height+45) {
//            //        self.scrollBar.center = centerPoint;
            self.scrollBar.center = CGPointMake(kSceenWidth-20, centerPoint.y);
//            CGFloat y = (centerPoint.y - 80)/self.tableView.frame.size.height * self.tableView.contentSize.height;
//            self.scrollBar.center = CGPointMake(kSceenWidth-20, y+80);
        }

    }
    
}

#pragma mark -- 水平日期菜单
- (void)setHorizontalMenuView {
    // 日期水平菜单
    HorizontalMenuView *menuView = [[HorizontalMenuView alloc] init];
    menuView.frame = CGRectMake(0, 30, kSceenWidth, 35);
    menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSTimeInterval  interval =24*60*60*1; //1:天数
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    _timeSpArray = [NSMutableArray arrayWithCapacity:5];
    if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        [dateformatter setDateFormat:@" EE\nMM-dd"];
    } else {
        [dateformatter setDateFormat:@" EE\ndd/MM"];
    }
    
    NSMutableArray *menuArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 4; i >= 0; i--) {
        
        NSDate *time = [NSDate dateWithTimeIntervalSinceNow:-i*interval];
        NSString *timeStr = [dateformatter stringFromDate:time];
        if (i == 0) {
            NSDateFormatter *datefor=[[NSDateFormatter alloc] init];
            if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
                [datefor setDateFormat:@"MM-dd"];
            } else {
                [datefor setDateFormat:@"dd/MM"];
            }
            timeStr = [NSString stringWithFormat:@"%@\n%@",NSLocalizedStringFromTable(@"Today", @"InfoPlist", nil),[datefor stringFromDate:time]];
        }
        [menuArray addObject:timeStr];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[time timeIntervalSince1970]];
        [_timeSpArray addObject:timeSp];
    }
    [menuArray addObject:@"."];
    
//    if (_isDatePicker) {
//        [_horizontalMenuView setNameWithArray:menuArray andIndex:5];
//        _isDatePicker = NO;
//    } else {
        [menuView setNameWithArray:menuArray andIndex:_pageIndex];
//    }
    
    menuView.delegate = self;
//    menuView.hidden = YES;
    [self.view addSubview:menuView];
    _horizontalMenuView = menuView;

}

#pragma mark -- 根据日期选择器生成水平日期菜单
- (void)setHorizontalMenuViewWithSp:(NSString *)timeSp {
    // 日期水平菜单
    HorizontalMenuView *menuView = [[HorizontalMenuView alloc] init];
    menuView.frame = CGRectMake(0, 30, kSceenWidth, 35);
    menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    NSTimeInterval  interval =24*60*60*1; //1:天数
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    _dateSpArray = [NSMutableArray arrayWithCapacity:5];
    if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        [dateformatter setDateFormat:@" EE\nMM-dd"];
    } else {
        [dateformatter setDateFormat:@" EE\ndd/MM"];
    }
    
    NSMutableArray *menuArray = [NSMutableArray arrayWithCapacity:5];

    for (int i = -2; i < 3; i++) {
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:[timeSp intValue]+i*86400]; // 一天有86400秒

//        NSDate *time = [NSDate dateWithTimeIntervalSinceNow:-i*interval];
        NSString *timeStr = [dateformatter stringFromDate:time];
//        if (i == 0) {
//            NSDateFormatter *datefor=[[NSDateFormatter alloc] init];
//            [datefor setDateFormat:@"MM-dd"];
//            timeStr = [NSString stringWithFormat:@" %@\n%@",NSLocalizedStringFromTable(@"Today", @"InfoPlist", nil),[datefor stringFromDate:time]];
//        }
        [menuArray addObject:timeStr];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[time timeIntervalSince1970]];
        [_dateSpArray addObject:timeSp];
    }
    [menuArray addObject:@"."];
    
    //    if (_isDatePicker) {
    //        [_horizontalMenuView setNameWithArray:menuArray andIndex:5];
    //        _isDatePicker = NO;
    //    } else {
    [menuView setNameWithArray:menuArray andIndex:2];
    //    }
    
    menuView.delegate = self;
    //    menuView.hidden = YES;
    [self.view addSubview:menuView];
    _horizontalMenuView = menuView;
    
}

#pragma mark -- 日期横向菜单代理
- (void)getTag:(NSInteger)tag {
    if (tag == 4) {
        if (self.isTodayBlock) { // 筛选数目显示
            self.isTodayBlock();
        }
    } else {
        if (self.dateChooseBlock) { // 日期筛选清除
            self.dateChooseBlock();
        }
    }
    
    
    _dateChooseType = 0;
    _dateChooseArray = nil;
    
    self.isExpand = NO;
    self.selectedIndexPath = nil;
//    NSLog(@"tag=%i",tag);
    if (_isDatePicker && tag != 5) {
        [self updateDataWithTimeSp:_dateSpArray[tag]];
    } else {
        if (tag == 5) {
            [self setupDateView:DateTypeOfStart];
        } else {
            _pageIndex = tag;
            [self updateAllData];
        }
    }

}

#pragma mark -- 下拉赛程赛果网络请求
- (void)chooseDataWithTimeSp:(NSString *)timeSp {
    NSMutableArray *liveFrames = [NSMutableArray array];
    
    //    [_horizontalMenuView setBtnEnabled];
    NSInteger type = _type;
    NSInteger page = _pageIndex;
    [KSKuaiShouTool getMatchWithType:_type ofState:@"all" withMDay:timeSp WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        
        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.type = _type;
                live.isMatch = YES;
                liveF.live = live;
                [liveFrames addObject:liveF];
                
            }
            if (type == _type && page == _pageIndex) {
                _dataSource = [liveFrames mutableCopy];
                _allData = [liveFrames mutableCopy];
            }
            
            if (_dateChooseType != 0 && _type == _dateBallType) {
                [self conditionDateChooseArray:_dateChooseArray withChooseType:_dateChooseType];
            }
            self.isExpand = NO;
            self.selectedIndexPath = nil;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.refreshBtn.hidden = YES;

            dispatch_async(dispatch_get_main_queue(), ^{
                //            [self.tableView reloadData];
                
                
                // 没有数据时显示label  (kSceenWidth/2-40 , 70, 80, 40)
                NSArray *live = _dataSource;
                if (live.count == 0) {
                    self.label.hidden = NO;
                    //                if (_chooseType == 0) {
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
 
                } else if (live.count > 0) {
                    self.label.hidden = YES;
                }
 
            });
        } else {
            [self.tableView.mj_header endRefreshing];
            [self networkHasError];

        }
        
    } failure:^(NSError *error) {

        [self.tableView.mj_header endRefreshing];
        [self networkHasError];


    }];
}

#pragma mark -- 指示器赛程赛果请求数据
- (void)updateDataWithTimeSp:(NSString *)timeSp {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });
    
    NSMutableArray *liveFrames = [NSMutableArray array];
    
    //    [_horizontalMenuView setBtnEnabled];
    NSInteger type = _type;
    NSInteger page = _pageIndex;
    [KSKuaiShouTool getMatchWithType:_type ofState:@"all" withMDay:timeSp WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        
        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.type = _type;
                live.isMatch = YES;
                liveF.live = live;
                [liveFrames addObject:liveF];
                
            }
            if (type == _type && page == _pageIndex) {
                _dataSource = [liveFrames mutableCopy];
                _allData = [liveFrames mutableCopy];
            }
            
            if (_dateChooseType != 0 && _type == _dateBallType) {
                [self conditionDateChooseArray:_dateChooseArray withChooseType:_dateChooseType];
            }
            
            self.isExpand = NO;
            self.selectedIndexPath = nil;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
            self.refreshBtn.hidden = YES;

            dispatch_async(dispatch_get_main_queue(), ^{
            
                // 没有数据时显示label  (kSceenWidth/2-40 , 70, 80, 40)
                NSArray *live = _dataSource;
                if (live.count == 0) {
                    self.label.hidden = NO;
                    //                if (_chooseType == 0) {
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
       
                } else if (live.count > 0) {
                    self.label.hidden = YES;
                }
 
            });
        } else {
            [hud hideAnimated:YES];
            [self networkHasError];


            
        }
        
    } failure:^(NSError *error) {

        [hud hideAnimated:YES];
        [self networkHasError];


    }];
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

#pragma mark -- 网络出错
- (void) networkHasError{
    _dataSource = nil;
    [self.tableView reloadData];
    self.refreshBtn.hidden = NO;
    self.label.hidden = YES;
}

//-(void)networdError {
//    if (_dataSource.count > 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        [hud hideAnimated:YES afterDelay:1.f];
//        hud.label.numberOfLines = 3;
//        hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//    } else {
//        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//        self.label.hidden = NO;
//    }
//}


#pragma mark -- 日期选择器
- (void)setupDateView:(DateType)type {
    
    _pickerView = [UWDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    _pickerView.delegate = self;
    _pickerView.type = type;
    [self.view addSubview:_pickerView];
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    //    NSLog(@"时间 : %@",date);
    self.isExpand = NO;
    self.selectedIndexPath = nil;
    NSLog(@"today=%@,%@",date,_timeSpArray[4]);

    switch (type) {
        case DateTypeOfStart:
            // TODO 日期确定选择
            _datePickerSp = date;
            NSInteger tag = [self updateTimeForDate:[date integerValue]];
            if (tag < 0) { // 选中的日期是当前日期菜单中有的，跳转到相应位置
                if (tag > -5) {
                    if (_isDatePicker) {
                        _isDatePicker = NO;
                        [_horizontalMenuView removeFromSuperview];
                        [self setHorizontalMenuView];
                    }
                    [_horizontalMenuView setBtnWithTag:tag+4];
                    _pageIndex = tag+4;
                    [self updateAllData];
                } else { // 选中的日期已经超过当前菜单，将生成新的日期菜单
                    _pageIndex = 5;
                    _dateIndex = 2;
                    _isDatePicker = YES;
                    [_horizontalMenuView removeFromSuperview];
                    [self setHorizontalMenuViewWithSp:date];
//                    [self updateAllData];
                    [self updateDataWithTimeSp:_dateSpArray[2]];
                }
            } else if (tag > 0) {  // 选中的日期是赛程日期的
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:_datePickerSp forKey:@"datePickerSp"];
                [defaults synchronize];
                if (self.dateBlock) {
                    self.dateBlock(tag);
                }
            } else { // 选中的日期为当天
                if (_isDatePicker) {
                    _isDatePicker = NO;
                    [_horizontalMenuView removeFromSuperview];
                    [self setHorizontalMenuView];
                }
                _pageIndex = 4;
                [self initWithType:_type];
                [_horizontalMenuView setBtnWithTag:4];
            }

//            NSLog(@"today=%@,%i",date,[self updateTimeForDate:[date intValue]]);
//
//            [_horizontalMenuView setBtnWithTag:5];
//            
//            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//            
//            if ([date intValue]-1000 > time) {
//                _isDatePicker = YES;
//
//                [_horizontalMenuView setBtnWithTag:6];
//            } else if ([date intValue] < time-1000) {
//                _isDatePicker = YES;
//
//                [_horizontalMenuView setBtnWithTag:6];
//                
//            }
            break;
            
        case DateTypeOfEnd:
            // TODO 日期取消选择
            //            if (_dataSource.count == 0) {
            //                [self.navigationController popViewControllerAnimated:YES];
            //            }
//            [currentTable.mj_header endRefreshing];
//            if (_currentPage == 1) {
            if (!_isDatePicker) {
                [_horizontalMenuView setBtnWithTag:_pageIndex];
            }
//            } else if (_currentPage == 2) {
//                [_horizontalMenuView setBtnWithTag:_pageIndex2];
//            }
            break;
        default:
            
            break;
    }
}

/** 通过时间戳, 返回与当前时间相差几天 */
- (NSInteger)updateTimeForDate:(NSTimeInterval)date {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间差
    NSTimeInterval time = date - currentTime;
    if (date > currentTime) {
        time = date - currentTime + 10;
    } else {
        time = date - currentTime - 10;
    }
    
    //秒转天数
    NSInteger days = time/3600/24;
    
    //    if (days < 5 && days > -5) {
    //        return days;
    //    }
    if (days != 0) {
        return days;
    } else {
        return 0;
    }
    
    return 5;
//    // 秒转小时
//    NSInteger hours = time/3600;
//    if (hours<24) {
//        return [NSString stringWithFormat:@"%ld小时前",hours];
//    }
    

//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",(long)years];
    
}

#pragma mark -- 下拉刷新
- (void)refreshData {
    
    self.isExpand = NO;
    self.selectedIndexPath = nil;

    if (_isDatePicker) {
        [self chooseDataWithTimeSp:_dateSpArray[_dateIndex]];
    } else {
        if (_pageIndex < 4) {
            [self chooseDataWithTimeSp:_timeSpArray[_pageIndex]];
        } else if (_pageIndex == 4) {
            [self setData];
        } else if (_pageIndex == 5) {
            [self chooseDataWithTimeSp:_datePickerSp];
        }

    }
    
}

#pragma mark -- 指示器刷新
- (void)updateAllData { // 根据不同情况来更新数据
    self.label.hidden = YES;
    //    [self setHorizontalMenuView];
    self.isExpand = NO;
    self.selectedIndexPath = nil;
//    if (_isDatePicker) {

//        if (_pageIndex < 4) {
//            [self updateDataWithTimeSp:_timeSpArray[_pageIndex]];
//        } else if (_pageIndex == 4) {
//            [self updateData];
//        } else if (_pageIndex == 5) {
//            [self updateDataWithTimeSp:_datePickerSp];
//        }
//    } else {
        if (_pageIndex < 4) {
            [self updateDataWithTimeSp:_timeSpArray[_pageIndex]];
        } else if (_pageIndex == 4) {
            [self updateData];
        } else if (_pageIndex == 5) {
            [self updateDataWithTimeSp:_datePickerSp];
        }
//    }

}

#pragma mark -- 下拉初始化数据
- (void)setData {
    NSInteger type = _type;
    NSMutableArray *liveFrames = [NSMutableArray array];
    [KSKuaiShouTool getLiveWithType:_type ofState:@"ending" withMatchID:0 WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        _matchID = last.result.flag_num;
        
        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.type = _type;
                liveF.live = live;
                [liveFrames addObject:liveF];
                live.timeH = 1;
                live.timeC = 1;
            }
            if (type == _type) {
                _dataSource = [liveFrames mutableCopy];
                _allData = [liveFrames mutableCopy];
            }
            
            switch (type) {
                case 0:
                    _footballSource = [liveFrames mutableCopy];
                    break;
                    
                case 1:
                    _basketSource = [liveFrames mutableCopy];
                    break;
                    
                case 2:
                    _tennisSource = [liveFrames mutableCopy];
                    break;
                    
                default:
                    break;
            }
            
            if (_chooseType != 0 && _type == _ballType) {
                [self conditionTadayArray:_chooseArray withChooseType:_chooseType];
            }
            
            [self.tableView.mj_header endRefreshing];

            [self.tableView reloadData];
            self.refreshBtn.hidden = YES;

            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataSource.count == 0) {
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                    self.label.hidden = NO;

                } else if (_dataSource.count > 0) {
                    self.label.hidden = YES;
                }
                
            });
        } else {
            [self.tableView.mj_header endRefreshing];

            [self networkHasError];


        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self networkHasError];


    }];
    
}
-(void)setmore:(KSLiveFrame*)liveFrame{
    
    
        [KSKuaiShouTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
           
            if ([result count] == 0) {
                liveFrame.live.isGoalEnpty = YES;
            }
           
            liveFrame.live.more=[result mutableCopy];
            
         
        }failure:^(NSError *error) {
            
           
        }];
    

}
#pragma mark -- 指示器初始化数据
- (void)updateData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//    
//        [self doSomeWork];
//    });
    
    NSInteger type = _type;
    NSMutableArray *liveFrames = [NSMutableArray array];
    [KSKuaiShouTool getLiveWithType:_type ofState:@"ending" withMatchID:0 WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        _matchID = last.result.flag_num;
        
        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.type = _type;
                liveF.live = live;
                [liveFrames addObject:liveF];
                live.timeH = 1;
                live.timeC = 1;
                if (_type==0) {
                    [self setmore:liveF];
                }
            }
            if (type == _type) {
                _dataSource = [liveFrames mutableCopy];
                _allData = [liveFrames mutableCopy];
            }
            
            if (_chooseType != 0 && _type == _ballType) {
                [self conditionTadayArray:_chooseArray withChooseType:_chooseType];
            }
            
            switch (type) {
                case 0:
                    _footballSource = [liveFrames mutableCopy];
                    break;
                    
                case 1:
                    _basketSource = [liveFrames mutableCopy];
                    break;
                    
                case 2:
                    _tennisSource = [liveFrames mutableCopy];
                    break;
                    
                default:
                    break;
            }
            
            [hud hideAnimated:YES];
            
            //[self.tableView reloadData];
             //self.refreshBtn.hidden = YES;
            
                [self.tableView reloadData];
                self.refreshBtn.hidden = YES;
                if (_dataSource.count == 0) {
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                    self.label.hidden = NO;
                    
                } else if (_dataSource.count > 0) {
                    self.label.hidden = YES;
                }
                
            
        } else {
            [hud hideAnimated:YES];
            [self networkHasError];
        }
        
    } failure:^(NSError *error) {
        

            [hud hideAnimated:YES];
            [self networkHasError];


      
    }];
    
//    if (_type==0) {
//        for (KSLiveFrame* subframe in self.dataSource) {
//            [self setmore:subframe];
//        }
//    }
   
}

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 200, kSceenWidth-20, 40)];
        label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:label];
        _label = label;
        
        UIImage *emptyImage = [UIImage imageNamed:@"clip-3"];
        UIImageView *emptyImageView = [[UIImageView alloc] init];
        emptyImageView.image = emptyImage;
        emptyImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_label addSubview:emptyImageView];
        emptyImageView.bounds = CGRectMake(0, 0, 200, 200);
        emptyImageView.center = CGPointMake(_label.center.x, _label.center.y);

    }
    return _label;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 , 80, kSceenWidth-20, 40)];
        [btn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:NSLocalizedStringFromTable(@"Network error, click refresh", @"InfoPlist", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.tableView addSubview:btn];
        _refreshBtn = btn;
    }
    return _refreshBtn;
}


#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    KSLiveFrame *liveF = _dataSource[indexPath.section];

    if (liveF.isExpand) {
        if (_type == 0) {
            return (liveF.live.more.count + 1 ) * 20 + 5 + 65;
        } else if (_type == 1 || _type == 2) {
            return 125;
        } else {
            return 160;
        }
    } else {
        return 65 + 28;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *view1 = [UIView new];
    [view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
        make.height.equalTo(@5);
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];
    
        cell.delegate = self;
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        KSLiveFrame *liveF = _dataSource[indexPath.section];
        cell.liveF = liveF;
    
    if (liveF.isExpand && _type == 0) {
        KSLiveCell *footballCell = [[KSLiveCell alloc] init];
        footballCell.delegate = self;
        footballCell.liveF = liveF;
        return footballCell;
    }
        return cell;
        
    
}

#pragma mark -- 视图滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat y = 85 + scrollView.contentOffset.y/(scrollView.contentSize.height-self.tableView.frame.size.height) * (self.tableView.frame.size.height-40);
    
    
    if (!_isScrollBar) {
        self.scrollBar.center = CGPointMake(kSceenWidth-20, y);
    }
    
    if (self.dataSource.count > 40 && (scrollView.contentOffset.y - 30 > _lastPosition.y || scrollView.contentOffset.y - 30 < _lastPosition.y)) {
        self.scrollBar.hidden = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        
    } else {
        self.tableView.showsVerticalScrollIndicator = YES;
        
    }

}

// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.scrollBar.hidden = YES;
    _lastPosition = scrollView.contentOffset;
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    self.scrollBar.hidden = YES;
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数（减速停止，结束拖动）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    self.scrollBar.hidden = YES;

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
    
//    self.scrollBar.hidden = YES;
}


#pragma mark 点击扩展
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    
  if (_type==0) {
      
            if (self.dataSource.count==0) {
      
                self.tableView.tableFooterView =[[UIView alloc]init];
            }
            if (self.dataSource.count>=8) {
      
                UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,50)];
                [footview setBackgroundColor:[UIColor whiteColor]];
                self.tableView.tableFooterView=footview;
      
            }else if(self.dataSource.count!=0){
      
                UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,200)];
                [footview setBackgroundColor:[UIColor whiteColor]];
                self.tableView.tableFooterView=footview;
            }
      
      
          
    
            NSIndexPath* targetindexpath;
            for (int i=0; i<_dataSource.count; i++) {
                KSLiveFrame *subliveFrame = _dataSource[i];
                if (subliveFrame.isExpand==YES&&i!=indexPath.section) {
                    subliveFrame.isExpand=NO;
                    targetindexpath=[NSIndexPath indexPathForRow:0 inSection:i];
                }
            }

      
    KSLiveFrame *liveFrame = _dataSource[indexPath.section];
    liveFrame.isExpand = !liveFrame.isExpand;
      if (liveFrame.live.more==nil) {
           __weak typeof(self) weekself=self;
    [KSKuaiShouTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
    liveFrame.live.more = [result mutableCopy];
        if (targetindexpath!=nil) {
            [_tableView reloadRowsAtIndexPaths:@[indexPath,targetindexpath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
          
                    }
        failure:^(NSError *error) {
                        
                    }];

      }else{
          NSArray* indexpaths=@[indexPath];
          if (targetindexpath!=nil) {
              indexpaths=@[indexPath,targetindexpath];
          }
          
              
          
          [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
          
      }
      
      CGRect rect=[self.tableView convertRect:[tableView cellForRowAtIndexPath:indexPath].frame toView:[UIApplication sharedApplication].keyWindow];
      NSLog(@"%@",NSStringFromCGRect(rect));
      if (CGRectGetMaxY(rect)>=[UIScreen mainScreen].bounds.size.height-64) {
          NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
          [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                                           atScrollPosition:UITableViewScrollPositionBottom
                                                   animated:YES];
      }
                   
//      if (indexPath.section+1 == [_dataSource count]||) {
//          NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//          
//          [self.tableView scrollToRowAtIndexPath:scrollIndexPath
//                                atScrollPosition:UITableViewScrollPositionNone
//                                        animated:NO];
//      }

    
 /**
      if (self.dataSource.count==0) {
          
          self.tableView.tableFooterView =[[UIView alloc]init];
      }
      if (self.dataSource.count>=8) {
          
          UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,50)];
          [footview setBackgroundColor:[UIColor whiteColor]];
          self.tableView.tableFooterView=footview;
          
      }else if(self.dataSource.count!=0){
          
          UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,200)];
          [footview setBackgroundColor:[UIColor whiteColor]];
          self.tableView.tableFooterView=footview;
      }

      
    NSIndexPath* targetindexpath;
       
    for (int i=0; i<_dataSource.count; i++) {
        
        KSLiveFrame *subliveFrame = _dataSource[i];
        if (subliveFrame.isExpand==YES&&i!=indexPath.section) {
            subliveFrame.isExpand=NO;
            targetindexpath=[NSIndexPath indexPathForRow:0 inSection:i];
        }
    }
       
    __weak typeof(self) weekself=self;
       
    KSLiveFrame *liveFrame = _dataSource[indexPath.section];
    liveFrame.isExpand = !liveFrame.isExpand;
        if (_type == 0) {
     
        [KSLikeSportTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
            
            if ([result count] == 0) {
                liveFrame.live.isGoalEnpty = YES;
                
                NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                if (weekself.isExpand == YES && weekself.selectedIndexPath == indexPath) {
                    
                    
                        [weekself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                   
                    
                    
                }
            }
            liveFrame.live.more = [result mutableCopy];
            
            if (targetindexpath==nil) {
                
                    [weekself.tableView reloadRowsAtIndexPaths:@[indexPath,] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
               
                [weekself.tableView reloadRowsAtIndexPaths:@[indexPath,targetindexpath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        }failure:^(NSError *error) {
            
        }];
          
        [weekself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

       
    if (indexPath.section==_allData.count-1||indexPath.section==_allData.count-2) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                              atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
   
       **/
   }else{

    
    KSLiveFrame *liveFrame = _dataSource[indexPath.section];
    liveFrame.isExpand = !liveFrame.isExpand;
    if (_type == 0) {
        if (self.selectedIndexPath) {
            if (self.isExpand) {
                if (self.selectedIndexPath.section == indexPath.section) {
                    self.isExpand = NO;
                    self.selectedIndexPath = nil;
                } else {
                    KSLiveFrame *select = _dataSource[self.selectedIndexPath.section];
                    select.isExpand = NO;
                    
                [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
     
                    
                    
                    self.isExpand = YES;
                    self.selectedIndexPath = indexPath;
                   // [self.tableView reloadSections:self.selectedIndexPath withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
        } else {
            self.isExpand = YES;
            self.selectedIndexPath = indexPath;
        }

    }
    
    
  
   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (_type == 0) {
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
//
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];


        }failure:^(NSError *error) {
            
        }];
    }
  
    
    if (indexPath.section+1 == [_dataSource count] && indexPath.section > (kSceenHeight-100)/65) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
   }
}

- (void)followTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    //    NSLog(@"点击关注");
    KSLiveFrame *liveF = _dataSource[indexPath.section];
    //    NSLog(@"赛事类型%@  type%li id%li",liveF.live.matchtypefullname,(long)_type,(long)liveF.live.match_id);
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

            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        });
    }failure:^(NSError *error) {
        
    }];
}


#pragma mark tabelView点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    KSLiveFrame *liveF = _dataSource[indexPath.section];
    
//    if (liveF.live.type != 2) {
        if (self.detailBlock) {
            self.detailBlock(_type,liveF.live.match_id,0);
        }
//    }
    
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

//养成习惯在WillDisplayCell中处理数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [cell.layer setBorderWidth:0.2f];

}

#pragma mark -- 获取筛选日期
- (NSString *)getChooseDate {
    if (_isDatePicker) {
        return _dateSpArray[_dateIndex];
    } else {
        if (_pageIndex == 4) {
            return @"0";
        } else if (_pageIndex == 5) {
            return _datePickerSp;
        } else {
            return _timeSpArray[_pageIndex];
        }
    }
}

#pragma mark -- 指定日期筛选
- (void)conditionDateChooseArray:(NSArray *)array withChooseType:(NSInteger)chooseType {
    _dateChooseArray = [array mutableCopy];
    _dateChooseType = chooseType;
    _dateBallType = _type;
    
    NSMutableArray *current = [NSMutableArray arrayWithCapacity:4];
//    NSMutableArray *data = _dataSource[page];
    if (_allData.count > 0) {
        for (int j = 0; j < _allData.count; j++) {
            KSLiveFrame *liveF = _allData[j];
            //                if (i != 3) {
            if (chooseType == 1) { // 赛事筛选
                for (int k = 0; k < array.count; k++) {
                    //                        NSLog(@"%i----------%li",[array[k] intValue],(long)liveF.live.matchtype_id);
                    
                    Matchtypes *match = array[k];
//                    if (match.rid == liveF.live.matchtype_id) {
                    if ([match.name isEqualToString:liveF.live.matchtypefullname]) {
                        [current addObject:liveF];
                        //                            NSLog(@"第%i页筛选id=%i",i,liveF.live.matchtype_id);
                    }
                }
            } else if (chooseType == 2) {
                for (int k = 0; k < array.count; k++) {
                    Matchtypes *match = array[k];
                    if (match.rid == liveF.live.tregion_id) {
                        [current addObject:liveF];
                    }
                }
                
            }
        }
        
        if (_pageIndex != 4) {
            _dataSource = [current mutableCopy];
            [self.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_dataSource.count == 0) {
                    self.label.hidden = NO;
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);;
                } else if (_dataSource.count > 0) {
                    self.label.hidden = YES;
                }
            });
        }
    }
}

#pragma mark -- 当前日不筛选
- (void)selectTodayAllData {
    _chooseType = 0;
    switch (_type) {
        case 0:
            _dataSource = [_footballSource mutableCopy];
            break;
            
        case 1:
            _dataSource = [_basketSource mutableCopy];
            break;
            
        case 2:
            _dataSource = [_tennisSource mutableCopy];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
    if (self.dataSource.count == 0) {
        self.label.hidden = NO;
        self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);;
        
    } else if (self.dataSource.count > 0) {
        self.label.hidden = YES;
    }
}


#pragma mark -- 当前日筛选
- (void)conditionTadayArray:(NSArray *)array withChooseType:(NSInteger)chooseType {
    NSMutableArray *current = [NSMutableArray arrayWithCapacity:4];
    _chooseArray = [array mutableCopy];
    _chooseType = chooseType;
    _ballType = _type;
    
    switch (_type) {
        case 0:
            _allData = [_footballSource mutableCopy];
            break;
            
        case 1:
            _allData = [_basketSource mutableCopy];
            break;
            
        case 2:
            _allData = [_tennisSource mutableCopy];
            break;
            
        default:
            break;
    }
   
    if (self.allData.count > 0) {
        for (int j = 0; j < self.allData.count; j++) {
            KSLiveFrame *liveF = self.allData[j];
            //                if (i != 3) {
            if (chooseType == 1) { // 赛事筛选
                for (int k = 0; k < array.count; k++) {
                    
                    Matchtypes *match = array[k];
                    if ([match.name isEqualToString:liveF.live.matchtypefullname]) {
//                    if (match.rid == liveF.live.matchtypefullname) {
                        [current addObject:liveF];
                    }
                }
                if (self.dataSource.count == 0) {
                    self.label.hidden = NO;
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);;

                } else if (self.dataSource.count > 0) {
                    self.label.hidden = YES;
                }
            } else if (chooseType == 2) {
                for (int k = 0; k < array.count; k++) {
                    Matchtypes *match = array[k];
                    if (match.rid == liveF.live.tregion_id) {
                        [current addObject:liveF];
                    }
                }
                
            }
        }
        _dataSource = [current mutableCopy];
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        if (self.dataSource.count == 0) {
            self.label.hidden = NO;
            self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);;
            
        } else if (self.dataSource.count > 0) {
            self.label.hidden = YES;
        }
    }
    
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

- (UITableView *)createTableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, kSceenWidth, kSceenHeight-175) style:UITableViewStylePlain];
        if ([self isNotchScreen]) tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, kSceenWidth, kSceenHeight-83-87-65) style:UITableViewStylePlain];
        
//        if (self.dataSource.count==0) {
//            tableView.tableFooterView =[[UIView alloc]init];
//        }
       // tableView.tableFooterView =[[UIView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        //        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *datePickerSp = [defaults objectForKey:@"datePickerSp"];
    if (datePickerSp == nil && _pageIndex != 4) {
        _pageIndex = 4;
        if (_isDatePicker) {
            [_horizontalMenuView removeFromSuperview];
            [self setHorizontalMenuView];
            _isDatePicker = NO;
        }
        [_horizontalMenuView setBtnWithTag:4];
        [self updateAllData];
    } else if (datePickerSp != nil) {
        if (_isDatePicker) {
            _dateIndex = 2;
            [_horizontalMenuView removeFromSuperview];
            [self setHorizontalMenuViewWithSp:datePickerSp];
            //                    [self updateAllData];
            [self updateDataWithTimeSp:_dateSpArray[2]];
        } else {
            _datePickerSp = datePickerSp;
            [self updateAllData];
        }
        
        [defaults removeObjectForKey:@"datePickerSp"];
        [defaults synchronize];
    }
    
    self.scrollBar.hidden = YES;

    self.selectedaction=^(){
        KSLiveFrame *liveF = _dataSource[0];
        
       
        if (self.detailBlock) {
            self.detailBlock(_type,liveF.live.match_id,0);
        }
        

    };
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
