//
//  PlayingController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "PlayingController.h"
#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "KSLiveFrame.h"
#import "KSExpansionCell.h"
#import "KSLiveCell.h"
#import "MJRefresh.h"
#import "FootballDetailController.h"
#import "GDataXMLNode.h"
#import "KSChoose.h"
#import "KSNetworkTool.h"
#import "FSPagerView-Swift.h"
#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#define ExpandCount 1

@interface PlayingController ()<UITableViewDelegate,UITableViewDataSource,KSLiveCellDelegate, FSPagerViewDataSource,FSPagerViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *allData;
@property (nonatomic, strong) NSArray *footballSource;
@property (nonatomic, strong) NSArray *basketSource;
@property (nonatomic, strong) NSArray *tennisSource;

@property (nonatomic, assign) NSTimeInterval footballSp;
@property (nonatomic, assign) NSTimeInterval basketSp;
@property (nonatomic, assign) NSTimeInterval tennisSp;

@property (weak, nonatomic) UILabel *label;
@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) NSInteger matchID;
@property (nonatomic, assign) NSInteger basketID;
@property (nonatomic, assign) NSInteger tennisID;
// 最新变化
@property (nonatomic, strong) NSMutableArray *lastLive;
@property (nonatomic, strong) NSMutableArray<KSLive *> *live;
@property (nonatomic, strong) NSMutableArray<KSMore *> *more;


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *minuteTimer;


@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic, assign) BOOL isMinuteTimer;

@property (nonatomic, strong) UIView *scrollBar;
@property (nonatomic, assign) BOOL isScrollBar;

@property (nonatomic, assign) CGPoint lastPosition;

@property (nonatomic, strong) NSArray *chooseArray;
@property (nonatomic, assign) NSInteger ballType;   // 赛事筛选 0为足球，1为篮球
@property (nonatomic, assign) NSInteger chooseType; // 0为没有筛选，1为赛事，2为国家
@property (weak, nonatomic) UIButton *refreshBtn;


@property (strong, nonatomic) NSArray<NSString *> *sectionTitles;
@property (strong, nonatomic) NSArray<NSString *> *configurationTitles;
@property (strong, nonatomic) NSArray<NSString *> *decelerationDistanceOptions;
@property (strong, nonatomic) NSArray<NSString *> *imageURL;
@property (strong, nonatomic) NSArray<NSString *> *openURL;
@property (strong, nonatomic) NSMutableArray<NSData *> *imageData;
@property (assign, nonatomic) NSInteger numberOfItems;

@property (strong ,nonatomic) FSPagerView *pagerView;
@property (strong ,nonatomic) FSPageControl *pageControl;

@end

@implementation PlayingController
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setData];
    [self createTableView];
//    [self.tableView.mj_header beginRefreshing];
    // 隐藏暂无数据
    self.label.hidden = YES;
    
    [self updateDataWithMatchID:0];
    
    [self addTimer];
    
    [self setScrollBar];
    
    _footballSp = [[NSDate date] timeIntervalSince1970];
    

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
    
    
    int a = count*(location.y-45)/(self.tableView.frame.size.height-40);
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
        
        if (centerPoint.y > 45 && centerPoint.y < self.tableView.frame.size.height) {
            //            //        self.scrollBar.center = centerPoint;
            self.scrollBar.center = CGPointMake(kSceenWidth-20, centerPoint.y);
            //            CGFloat y = (centerPoint.y - 80)/self.tableView.frame.size.height * self.tableView.contentSize.height;
            //            self.scrollBar.center = CGPointMake(kSceenWidth-20, y+80);
        }
        
    }
    
}

#pragma mark -- 切换赛事类别
- (void)initWithType:(NSInteger)type{
    self.label.hidden = YES;
    _type = type;
    self.isExpand = NO;
    self.selectedIndexPath = nil;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"网络状态%lu",(unsigned long)[KSNetworkTool getNetworkLinkType]);
    if ([KSNetworkTool getNetworkLinkType] == 0) {
        
        [self networkHasError];
        
    } else {
        
        self.refreshBtn.hidden = YES;
        switch (type) {
            case 0:
                if (time - _footballSp > 40 || _footballSource.count == 0) {
                    [self updateDataWithMatchID:0];
                    
                    //                [self.tableView.mj_header beginRefreshing];
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
                if (time - _basketSp > 40 || _basketSource.count == 0) {
                    //                [self.tableView.mj_header beginRefreshing];
                    [self updateDataWithMatchID:0];
                    
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
                if (time - _tennisSp > 40 || _tennisSource.count == 0) {
                    //                [self.tableView.mj_header beginRefreshing];
                    [self updateDataWithMatchID:0];
                    
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

#pragma mark -- 菊花更新数据
- (void)updateDataWithMatchID:(NSInteger)matchID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//    hud.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });

    NSMutableArray *liveFrames = [NSMutableArray array];
    NSInteger type = _type;
    [KSKuaiShouTool getLiveWithType:_type ofState:@"live" withMatchID:matchID WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        
        _matchID = last.result.flag_num;
        
        
        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.isMatch = YES;
                
                live.type = _type;
                liveF.live = live;
                [liveFrames addObject:liveF];
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
            
//            [self.tableView.mj_header endRefreshing];
            self.isExpand = NO;
            self.selectedIndexPath = nil;
            [self.tableView reloadData];
            self.refreshBtn.hidden = YES;

            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataSource.count == 0) {
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                    self.label.hidden = NO;
                } else if (_dataSource.count > 0) {
                    self.label.hidden = YES;
                }
                [hud hideAnimated:YES];

            });
        } else {
            [self networkHasError];
            [hud hideAnimated:YES];

        }
        
    } failure:^(NSError *error) {
        [self networkHasError];
        [hud hideAnimated:YES];

    }];
    
}



- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

#pragma mark -- 下拉更新数据
- (void)setDataWithMatchID:(NSInteger)matchID {
    NSMutableArray *liveFrames = [NSMutableArray array];
    NSInteger type = _type;
    [KSKuaiShouTool getLiveWithType:_type ofState:@"live" withMatchID:matchID WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];

        _matchID = last.result.flag_num;

        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.isMatch = YES;

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
            self.isExpand = NO;
            self.selectedIndexPath = nil;
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
        
        // Set the annular determinate mode to show task progress.
        
        [self networkHasError];

    }];
    
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
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        [hud hideAnimated:YES afterDelay:1.f];
//        hud.label.numberOfLines = 3;
//        hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//    } else {
//        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//        self.label.hidden = NO;
//    }
//}

#pragma mark -- 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 80, kSceenWidth-20, 40)];
        label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
//        [self.view insertSubview:label atIndex:1];
        [self.tableView addSubview:label];
        _label = label;
        
        UIImage *emptyImage = [UIImage imageNamed:@"clip-3"];
        UIImageView *emptyImageView = [[UIImageView alloc] init];
        emptyImageView.contentMode = UIViewContentModeScaleAspectFill;
        emptyImageView.image = emptyImage;
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

- (void)updateData {
    [self updateDataWithMatchID:0];
}


#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section == 0) {
    //        return 1;
    //    } else if (section == 1) {
    //        return 2;
    //    } else if (section == 2) {
    //        return 1;
    //    }
//    NSArray * rowArr = _dataSource[section];
//    if (self.isExpand && self.selectedIndexPath.section == section) {
//        return 1 + 1; //多个数量
//    }
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

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];

    
    cell.delegate = self;

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
//    self.scrollBar.hidden = NO;
    //    NSInteger count = [_dataSource count];
    //    NSIndexPath *path =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    
    //    CGFloat y = 50+(self.tableView.frame.size.height-40)*path.section/(count-self.tableView.frame.size.height/65+1);
    CGFloat y = 45 + scrollView.contentOffset.y/(scrollView.contentSize.height-self.tableView.frame.size.height) * (self.tableView.frame.size.height-40);
    
    //    NSLog(@"location=%f,tableFrame=%f",tableView.height,y);
    
    if (!_isScrollBar) {
        self.scrollBar.center = CGPointMake(kSceenWidth-20, y);
    }
    
    if (self.dataSource.count > 40 && (scrollView.contentOffset.y - 30 > _lastPosition.y || scrollView.contentOffset.y - 30 < _lastPosition.y)) {
        self.scrollBar.hidden = NO;
        //        self.scrollBar.center = CGPointMake(kSceenWidth-20, y);
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

#pragma mark 点击扩展
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    
    if (_type==0) {
        
        if (self.dataSource.count==0) {
            
            self.tableView.tableFooterView =[[UIView alloc]init];
        }
        if (self.dataSource.count>=8) {
            
            UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,80)];
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
        if (_type == 0) {
            
            [KSKuaiShouTool getLiveMoreMatchID:liveFrame.live.match_id WithCompleted:^(id result) {
                
                if ([result count] == 0) {
                    liveFrame.live.isGoalEnpty = YES;
                    
                    NSIndexPath *idxPth = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                    if (self.isExpand == YES && self.selectedIndexPath == indexPath) {
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPth,nil] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }
                }
                liveFrame.live.more = [result mutableCopy];
                if (targetindexpath==nil) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath,] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath,targetindexpath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }failure:^(NSError *error) {
                
            }];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        CGRect rect=[self.tableView convertRect:[tableView cellForRowAtIndexPath:indexPath].frame toView:[UIApplication sharedApplication].keyWindow];
        NSLog(@"%@",NSStringFromCGRect(rect));
        if (CGRectGetMaxY(rect)>=[UIScreen mainScreen].bounds.size.height-64) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
        }
        
    }else{

   
    KSLiveFrame *liveFrame = _dataSource[indexPath.section];
    liveFrame.isExpand = !liveFrame.isExpand;
    if (_type == 0) { // 展开一条时关闭之前展开的那一行
        if (self.selectedIndexPath) {
            if (self.isExpand) {
                if (self.selectedIndexPath.section == indexPath.section) {
                    self.isExpand = NO;
                    self.selectedIndexPath = nil;
                } else {
                    KSLiveFrame *select = _dataSource[self.selectedIndexPath.section];
                    select.isExpand = NO;
                    //[self.tableView reloadData];
                    
                    
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
            liveFrame.live.more = [result mutableCopy];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if (indexPath.section+1 == [_dataSource count] && indexPath.section > (kSceenHeight-100)/65) {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                
                [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
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

- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    //获得UIImage实例
    [defaults synchronize];
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
        if ([[result objectForKey:@"ret_code"] integerValue] == 0) {
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
//        _followMatch = 1;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"follow"];
        [defaults setBool:YES forKey:@"followView"];
        [defaults synchronize];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
    }failure:^(NSError *error) {
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    KSLiveFrame *liveF = _dataSource[indexPath.section];
    if (self.detailBlock) {
        self.detailBlock(_type,liveF.live.match_id,0);
    }

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
        [cell.layer setBorderWidth:0.5f];
  
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView
{
//    NSData *data = [@"LeanCloud" dataUsingEncoding:NSUTF8StringEncoding];
//    // resume.txt 是文件名
//    AVFile *file = [AVFile fileWithData:data name:@"abstract-3.png"];

    self.imageData = [[NSMutableArray alloc] initWithCapacity:[self.imageURL count]];
    for (int i=0; i<[self.imageURL count]; ++i)
        [self.imageData addObject:[NSNull null]];
    return [self.imageURL count];
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    
    
    if (self.imageData[index] == [NSNull null]) {
        NSURL *url = [NSURL URLWithString:self.imageURL[index]];
        
        // 建立Request請求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        // 配置Request請求
        // 設定請求方法
        [request setHTTPMethod:@"GET"];
        // 設定請求超時 預設超時時間60s
        [request setTimeoutInterval:10.0];
        // 設定頭部引數
        [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        //或者下面這種方式 新增所有請求頭資訊
        request.allHTTPHeaderFields=@{@"Content-Encoding":@"gzip"};
        //設定快取策略
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        // 構造NSURLSessionConfiguration
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 構造NSURLSession，網路會話；
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        // 構造NSURLSessionTask，會話任務；
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 請求失敗，列印錯誤資訊
            if (error) {
                NSLog(@"get error :%@",error.localizedDescription);
            }
            //請求成功，解析資料
            else {
                NSLog(@"get success");
                // 解析成功，處理資料，通過GCD獲取主佇列，在主執行緒中重新整理介面。
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 重新整理介面....
                    self.imageData[index] = data;
                    cell.imageView.image = [UIImage imageWithData:data];
                });
            }
        }];
        
        [task resume];
    } else {
        cell.imageView.image = [UIImage imageWithData:self.imageData[index]];
    }
    
    
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
//    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@(index),@(index)];
    return cell;
}

#pragma mark - FSPagerView Delegate

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
    if (![self.openURL[index] isEqualToString:@""]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openURL[index]]];
    }
    
    
}

- (void)pagerViewWillEndDragging:(FSPagerView *)pagerView targetIndex:(NSInteger)targetIndex
{
    self.pageControl.currentPage = targetIndex;
}

- (void)pagerViewDidEndScrollAnimation:(FSPagerView *)pagerView
{
    self.pageControl.currentPage = pagerView.currentIndex;
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
        CGFloat bannerHeight = 250;
        
        self.sectionTitles = @[@"Configurations", @"Deceleration Distance", @"Item Size", @"Interitem Spacing", @"Number Of Items"];
        self.configurationTitles = @[@"Automatic sliding", @"Infinite"];
        self.decelerationDistanceOptions = @[@"Automatic", @"1", @"2"];
        self.imageURL = @[];
        self.numberOfItems = 7;
        
        UIView *bannerView = [[UIView alloc] init];
        bannerView.frame = CGRectMake(0, 30, kSceenWidth, bannerHeight);
//        bannerView.backgroundColor = [UIColor redColor];
        [self.view addSubview:bannerView];
        
        
        AVQuery *query = [AVQuery queryWithClassName:@"Banner"];
        NSArray *objs = [query findObjects];
        
        NSMutableArray *mutImageUrlArr = [[NSMutableArray alloc] init];
        NSMutableArray *mutUrlArr = [[NSMutableArray alloc] init];
        for (AVObject *obj in objs) {
            NSString *imageUrl = [obj objectForKey:@"imageUrl"];
            NSString *openUrl = [obj objectForKey:@"url"];
            [mutImageUrlArr addObject:imageUrl];
            [mutUrlArr addObject:openUrl];
        }
        self.imageURL = [mutImageUrlArr copy];
        self.openURL = [mutUrlArr copy];
        
        FSPagerView *pagerView = [[FSPagerView alloc] init];
        [pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
        CGSize const FSPagerViewAutomaticSize = { .width = 0, .height = 0 };
        pagerView.itemSize = FSPagerViewAutomaticSize;
        pagerView.delegate = self;
        pagerView.dataSource = self;
        pagerView.automaticSlidingInterval = 3.0;
        
        
        pagerView.frame = CGRectMake(0, 0, kSceenWidth, bannerHeight);
        [bannerView addSubview:pagerView];
        pagerView.isInfinite = YES;
        
        self.pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.pageControl.center = bannerView.center;
        self.pageControl.frame = CGRectMake(bannerView.center.x, bannerView.frame.size.height - 20, 30, 20);
        self.pageControl.numberOfPages = self.imageURL.count;
        self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        
        
        [bannerView addSubview:_pageControl];
        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30 + bannerHeight, kSceenWidth, kSceenHeight-140-bannerHeight) style:UITableViewStylePlain];
        
        if ([self isNotchScreen]) tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30 + bannerHeight, kSceenWidth, kSceenHeight-30-87-83-bannerHeight) style:UITableViewStylePlain];
        //        tableView.tableFooterView = [[UIView alloc] init];
        if (self.dataSource.count==0) {
            self.tableView.tableFooterView =[[UIView alloc]init];
        }

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

#pragma mark -- 下拉刷新
- (void)refreshData {
//    self.label.hidden = YES;
    
    //    [self setHorizontalMenuView];
    self.isExpand = NO;
    self.selectedIndexPath = nil;
    
//    if(_isDatePicker){
//        [self chooseDataWithTimeSp:_dateSpArray[_dateIndex]];
//    } else {
//        if (_pageIndex < 5 && _pageIndex > 0) {
//            [self chooseDataWithTimeSp:_timeSpArray[_pageIndex]];
//        } else if (_pageIndex == 0) {
//            [self setData];
//        } else if (_pageIndex == 5) {
//            [self chooseDataWithTimeSp:_datePickerSp];
//        }
//    }
    [self.tableView.mj_header endRefreshing];
    
}

#pragma mark -- 分类即时比分变化数据请求
- (void)updateLastLive
{
    if (_type == 0) {
        [self loadFootballLive];
    } else if (_type == 1 || _type == 2) {
        [self loadBasketballLive];
    }
    
}

// 篮球最新变化
- (void)loadBasketballLive {
    NSInteger flagNum;
    if (_type == 1) {
        flagNum = _basketID;
    } else if (_type == 2) {
        flagNum = _tennisID;
    }
    [KSKuaiShouTool getBasketballAndTennisLiveWithType:_type withFlagNum:_matchID withCompleted:^(id responseObject) {
        LiveResult *last = [LiveResult mj_objectWithKeyValues:responseObject];
        //        self.live = [responseObject objectForKey:@"result"];
        
        self.live = [last.result mutableCopy];
        if (self.live.count >0) {
//            if (_type == 1) {
//                _basketID = self.live[0].flag_num;
//            } else if (_type == 2) {
//                _tennisID = self.live[0].flag_num;
//            }
            _matchID = self.live[0].flag_num;
            //        NSLog(@"篮球%@",_live[0].d);
            NSString *liveD = _live[0].d;
            //        NSString *liveD = [result[0] mj_objectWithKeyValues:@"d"];
            //        NSLog(@"篮球%@",result[0].MJKeyValue);
            
            NSMutableArray *match = [[liveD componentsSeparatedByString:@"@"] mutableCopy];
            for (int i = 0; i < match.count; i++) {
                
                [self.lastLive removeAllObjects];
                self.lastLive = [[match[i] componentsSeparatedByString:@"|"] mutableCopy];
//                NSMutableArray *liveFrame;
//                if (_type == 1) {
//                    liveFrame = _dataSource;
//                }  else if (_type == 2) {
//                    liveFrame = _dataSource;
//                }
                for (int i = 0; i < _dataSource.count; i++) {
                    KSLiveFrame *liveF = _dataSource[i];
                    
                    if ([_lastLive[0] intValue] == liveF.live.match_id) {
                        //                        NSLog(@"之前时间实际%@",self.live[i].realstarttime);
                        //                        NSLog(@"之前时间%@",self.live[i].starttime);
                        //                    NSLog(@"之前主队%li",(long)liveF.live.total_h);
                        //                    NSLog(@"之前客队%li",(long)liveF.live.total_c);
                        
                        
                        if (_type == 1) {
                            
                            if (liveF.live.total_h != [_lastLive[3] integerValue] || liveF.live.total_c != [_lastLive[4] integerValue]) {
                                [liveF.live setValue:_lastLive[3] forKey:@"total_h"];
                                [liveF.live setValue:_lastLive[4] forKey:@"total_c"];
                            }
                            
//                            if (_lastLive[1] ) {
//                                <#statements#>
//                            }
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
                            
                            [_dataSource mutableCopy];
                            
                        } else if (_type == 2) {
                            //                        liveF.live.isTenH = NO;
                            //                        liveF.live.isTenC = NO;
                            //                        // 设置比分变化标志
                            //                        if (liveF.live.total_h < [_lastLive[3] integerValue]) {
                            //                            liveF.live.isTenH = YES;
                            //                        }
                            //
                            //                        if (liveF.live.total_c < [_lastLive[4] integerValue]) {
                            //                            liveF.live.isTenC = YES;
                            //                        }
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
                            [_dataSource mutableCopy];
                        }
                        
                        //                        NSLog(@"之后时间实际%@",self.live[i].realstarttime);
                        //                        NSLog(@"之后时间%@",self.live[i].starttime);
                        NSLog(@"之后主队%ld",(long)liveF.live.total_h);
                        NSLog(@"之后客队%ld",(long)liveF.live.total_c);
                        
                        [self.tableView reloadData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        UITableView *table = _scrollTableViews[0];
                            //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:i];
                            //                        [table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        });
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
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
        NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"即时变化%@",result);
//        if (![data isEqual:@"<>"]) {
//            [self analysisXML:data];
//        }
        [self handAnalysisXML:data];
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
        [self updateDataWithMatchID:[Fn intValue]];

    }

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<C>.*?</C>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *array = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    for (NSTextCheckingResult *result in array) {
        NSString *C = [searchText substringWithRange:result.range];
        C = [C stringByReplacingOccurrencesOfString:@"<C>" withString:@""];
        C = [C stringByReplacingOccurrencesOfString:@"</C>" withString:@""];
        
        NSMutableArray *lastLive = [[C componentsSeparatedByString:@"|"] mutableCopy];
        for (int i = 0; i < _dataSource.count; i++) {
            KSLiveFrame *liveF = _dataSource[i];
//            NSLog(@"%li----%@",(long)liveF.live.match_id,lastLive[0]);
            if ([lastLive[0] intValue] == liveF.live.match_id) {
                
                if (liveF.live.total_h  != [lastLive[2] integerValue] || liveF.live.total_c  != [lastLive[3] integerValue]) {
                    [liveF.live setValue:lastLive[2] forKey:@"total_h"];
                    [liveF.live setValue:lastLive[3] forKey:@"total_c"];

                }
                [liveF.live setValue:lastLive[1] forKey:@"state"];
                [liveF.live setValue:lastLive[4] forKey:@"rcard_h"];
                [liveF.live setValue:lastLive[5] forKey:@"rcard_c"];

                [_dataSource mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
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
        NSLog(@"Rst=%@",Rst);
        if ([Rst isEqualToString:@"Y"]  || [Rst isEqualToString:@"L"]) {
            GDataXMLElement *FnElement = [[user elementsForName:@"Fn"] objectAtIndex:0];
            NSString *Fn = [FnElement stringValue];
//            [self setDataWithMatchID:[Fn intValue]];
            [self updateDataWithMatchID:[Fn intValue]];
            //            NSLog(@"------------刷全盘");
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
        [self.lastLive removeAllObjects];
        self.lastLive = [[C componentsSeparatedByString:@"|"] mutableCopy];
        //        NSLog(@"matchID%@",_lastLive[0]);
        //        NSLog(@"-------------有新数据");
        
        
        //        NSLog(@"count = %lu",(unsigned long)self.live.count);
        
//        NSMutableArray *liveFrame = _dataSource;
        for (int i = 0; i < _dataSource.count; i++) {
            KSLiveFrame *liveF = _dataSource[i];
            NSLog(@"%li----%@",(long)liveF.live.match_id,_lastLive[0]);
            //            KSLiveFrame *liveF = self.liveFrames[i];
            if ([_lastLive[0] intValue] == liveF.live.match_id) {

                if (liveF.live.total_h  != [_lastLive[2] integerValue] || liveF.live.total_c  != [_lastLive[3] integerValue]) {
                    [liveF.live setValue:_lastLive[2] forKey:@"total_h"];
                    [liveF.live setValue:_lastLive[3] forKey:@"total_c"];
                    
                }
                [liveF.live setValue:_lastLive[1] forKey:@"state"];
                [liveF.live setValue:_lastLive[4] forKey:@"rcard_h"];
                [liveF.live setValue:_lastLive[5] forKey:@"rcard_c"];
                //                [liveF.live setValue:_lastLive[19] forKey:@"realstarttime"];
                //                [liveF.live setValue:_lastLive[20] forKey:@"starttime"];
                
                
                //                [self.liveFrames mutableCopy];
                [_dataSource mutableCopy];
                //                NSLog(@"之后主队%ld",(long)liveF.live.total_h);
                //                NSLog(@"之后客队%ld",(long)liveF.live.total_c);
                
                [self.tableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
            }
        }
    }
    
}

#pragma mark -- 当前日不筛选 
- (void)selectTodayAllData {
    _chooseType = 0;
    _dataSource = [_allData mutableCopy];
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
//                    if (match.rid == liveF.live.matchtype_id) {
                    if ([match.name isEqualToString:liveF.live.matchtypefullname]) {
                        [current addObject:liveF];
                    }
                }
                if (self.dataSource.count == 0) {
                    self.label.hidden = NO;
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                    
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

#pragma mark 添加或移除定时器
- (void)addTimer {
    if (!_isTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateLastLive) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        _isTimer = YES;
//        NSLog(@"添加进行中定时器1");
    }
}

- (void)addMinuteTimer
{
    if (!_isMinuteTimer) {
        self.minuteTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.minuteTimer forMode:NSRunLoopCommonModes];
        _isMinuteTimer = YES;
//        NSLog(@"添加进行中定时器2");
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    NSLog(@"playingminuteTimer");
}

- (void)removeTimer {
    if (_isTimer) {
        [self.timer invalidate];
        _isTimer = NO;
//        NSLog(@"移除进行中定时器1");
    }
    
}

- (void)removeMinuteTimer
{
    if (_isMinuteTimer) {
        [self.minuteTimer invalidate];
        _isMinuteTimer = NO;
//        NSLog(@"移除进行中定时器2");
    }
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self addTimer];
    [self addMinuteTimer];
    
    [self.tableView reloadData];
    self.scrollBar.hidden = YES;
    NSLog(@"play我出来了");
    
    __weak typeof(self) weekself=self;
    self.removeaction=^(){
        [weekself removeTimer];
        [weekself removeMinuteTimer];
    };
    
    if (self.dataSource.count==0) {
        
        self.tableView.tableFooterView =[[UIView alloc]init];
    }
    if (self.dataSource.count>=8) {
        
        UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,80)];
        [footview setBackgroundColor:[UIColor whiteColor]];
        self.tableView.tableFooterView=footview;
        
    }else if(self.dataSource.count!=0){
        
        UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,200)];
        [footview setBackgroundColor:[UIColor whiteColor]];
//        self.tableView.tableFooterView=footview;
    }

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeTimer];
    [self removeMinuteTimer];
    NSLog(@"play我消失了");

}


@end
