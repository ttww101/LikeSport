//
//  FollowController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/16.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "FollowController.h"
#import "KSKuaiShouTool.h"
#import "KSLastestParamResult.h"
#import "KSLiveFrame.h"
#import "KSExpansionCell.h"
#import "KSLiveCell.h"
#import "MJRefresh.h"
#import "FootballDetailController.h"
#import "GDataXMLNode.h"
#define ExpandCount 1

@interface FollowController()<UITableViewDelegate,UITableViewDataSource,KSLiveCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *footballSource;
@property (nonatomic, strong) NSArray *basketSource;
@property (nonatomic, strong) NSArray *tennisSource;

@property (nonatomic, assign) NSTimeInterval footballSp;
@property (nonatomic, assign) NSTimeInterval basketSp;
@property (nonatomic, assign) NSTimeInterval tennisSp;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger matchID;

@property (weak, nonatomic) UILabel *label;
@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
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

@end

@implementation FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataWithMatchID:0];
    [self createTableView];
    
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

- (void)initWithType:(NSInteger)type{
    _type = type;
    self.isExpand = NO;
    self.selectedIndexPath = nil;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    switch (type) {
        case 0:
            if (time - _footballSp > 60) {
                [self.tableView.mj_header beginRefreshing];
                _footballSp = time;
            } else {
                _dataSource = nil;
                [self.tableView reloadData];
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
            break;
            
        case 1:
            if (time - _basketSp > 60) {
                [self.tableView.mj_header beginRefreshing];
                _basketSp = time;
            } else {
                _dataSource = nil;
                [self.tableView reloadData];
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
            break;
            
        case 2:
            if (time - _tennisSp > 60) {
                [self.tableView.mj_header beginRefreshing];
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

- (void)setDataWithMatchID:(NSInteger)matchID {
    NSInteger type = _type;
    NSMutableArray *liveFrames = [NSMutableArray array];
    [KSKuaiShouTool getLiveWithType:_type ofState:@"follow" withMatchID:matchID WithCompleted:^(id result) {
        KSLastestParamResult *last = [KSLastestParamResult mj_objectWithKeyValues:result];
        _matchID = last.result.flag_num;
        
        if ([last.ret_code intValue] == 0) {
            for (KSLive *live in last.result.data) {
                KSLiveFrame *liveF = [[KSLiveFrame alloc] init];
                live.isFollowView = YES;

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
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];

//            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataSource.count == 0) {
                    self.label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
                    self.label.hidden = NO;

                } else if (_dataSource.count > 0) {
                    self.label.hidden = YES;
                }
                
//            });
        } else {
            [self.tableView.mj_header endRefreshing];

            [self networdError];
//            self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//            self.label.hidden = NO;
            
        }
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            _dataSource = nil;
//            _footballSource = nil;
//            _basketSource = nil;
//            _tennisSource = nil;
            [self.tableView.mj_header endRefreshing];
            
            [self networdError];
//            self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
//            self.label.hidden = NO;
        });

    }];
    
}

#pragma mark -- 网络出错
-(void)networdError {
    if (_dataSource.count > 0) {
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

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 200, kSceenWidth-20, 40)];
        label.text = NSLocalizedStringFromTable(@"Temporarily no game!", @"InfoPlist", nil);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view insertSubview:label atIndex:1];
        //        [self.navigationController.view addSubview:label];
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
    return 1;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSLiveFrame *liveF = _dataSource[indexPath.section];
    
    if (liveF.isExpand) {
        if (_type == 0) {
            //            if (self.isExpand) {
            return (liveF.live.more.count + 1 ) * 20 + 5 + 65;
            //            }
        } else if (_type == 1 || _type == 2) {
            return 125;
        } else {
            return 160;
        }
    } else {
        return 65;
    }
//    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row != 0) {
//        
//        if (_type == 1) {
//            if (liveF.live.hascourts == 2) {
//                if (liveF.live.st3_h == -1) {
//                    return 45;
//                } else {
//                    return 65;
//                }
//            } else {
//                if (liveF.live.st2_h == -1) {
//                    return 45;
//                } else if (liveF.live.st3_h == -1) {
//                    return 85;
//                } else if (liveF.live.st4_h == -1) {
//                    return 105;
//                } else if (liveF.live.ot_h != -1) {
//                    return 170;
//                } else {
//                    return 150;
//                }
//            }
//        } else if (_type == 2) {
//            //            KSLiveFrame *liveF = _dataSource[_currentPage][indexPath.section];
//            if (liveF.live.hascourts == 3) { // hascourts
//                if (liveF.live.isDouble) {
//                    if (liveF.live.st1_h == -1) {
//                        return 50;
//                    } else if (liveF.live.st2_h == -1) {
//                        return 70;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 90;
//                    } else {
//                        return 110;
//                    }
//                } else {
//                    if (liveF.live.st1_h == -1) {
//                        return 30;
//                    } else if (liveF.live.st2_h == -1) {
//                        return 50;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 70;
//                    } else {
//                        return 90;
//                    }
//                }
//            } else if (liveF.live.hascourts == 5) {
//                if (liveF.live.isDouble) {
//                    if (liveF.live.st1_h == -1) {
//                        return 50;
//                    } else if (liveF.live.st2_h == -1) {
//                        return 70;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 90;
//                    } else if (liveF.live.st4_h == -1) {
//                        return 110;
//                    } else if (liveF.live.st5_h == -1) {
//                        return 130;
//                    } else {
//                        return 150;
//                    }
//                    return 150;
//                } else {
//                    if (liveF.live.st1_h == -1) {
//                        return 30;
//                    } else if (liveF.live.st2_h == -1) {
//                        return 50;
//                    } else if (liveF.live.st3_h == -1) {
//                        return 70;
//                    } else if (liveF.live.st4_h == -1) {
//                        return 90;
//                    } else if (liveF.live.st5_h == -1) {
//                        return 110;
//                    } else {
//                        return 130;
//                    }
//                }
//            }
//            return 110;
//        } else {
//            return (_more.count + 1 ) * 20 + 5;
//        }
//    } else {
//        return 65;
//    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 20;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 5;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //    UILabel *label = [[UILabel alloc] init];
    //    if (section == 0) {
    //        label.backgroundColor = [UIColor colorWithRed:31/255.0 green:101/255.0 blue:74/255.0 alpha:1];
    //    } else if (section == 1) {
    //        label.backgroundColor = [UIColor colorWithRed:178/255.0 green:123/255.0 blue:5/255.0 alpha:1];
    //    }
    
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.textColor = [UIColor lightGrayColor];
    
    
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    KSLiveCell *cell = [KSLiveCell cellWithTableView:tableView];
//    KSExpansionCell *expansionCell = [[KSExpansionCell alloc] init];
//    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row != 0) {     // Expand Cell
//        if (_type == 1 || _type == 2) {
//            KSLiveFrame *liveF = _dataSource[indexPath.section];
//            
//            expansionCell.liveF = liveF;
//            expansionCell.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//            //        cell = lcell;
//            return expansionCell;
//        } else {
//            KSExpansionCell *footballCell = [[KSExpansionCell alloc] init];
//            KSLiveFrame *liveF = _dataSource[indexPath.section];
//            //                NSLog(@"hteamname%@",liveF.live.hteamname);
//            footballCell.live = liveF.live;
//            footballCell.more = _more;
//            //            expansionCell.count = 1;
//            footballCell.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//            return footballCell;
//            //            liveF.live.isOver = NO;
//        }
//        
//        
//    } else {    // Normal cell
//        
//        cell.delegate = self;
//        
//        KSLiveFrame *liveF = _dataSource[indexPath.section];
//        cell.liveF = liveF;
//        return cell;
//        
//    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
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

#pragma mark -- 点击扩展
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
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
            //            _more = [result mutableCopy];
            liveFrame.live.more = [result mutableCopy];
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
            //            switch (type) {
            //                case 0:
            //                    [_footballSource[_currentPage] mutableCopy];
            //                    break;
            //                case 1:
            //                    [_basketballSource[_currentPage] mutableCopy];
            //                    break;
            //                case 2:
            //                    [_tennisSource[_currentPage] mutableCopy];
            //                    break;
            //                default:
            //                    break;
            //            }
        }
        //        _followMatch = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [table reloadData];
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        });
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
    NSInteger state = 0;
    if ([liveF.live.state isEqualToString:@"W"]) {
        state = 1;
    }
    if (liveF.live.type != 2) {
        if (self.detailBlock) {
            self.detailBlock(_type,liveF.live.match_id,state);
        }
    }
    //    if (_type == 0 || _type == 1) {
    //        KSLiveFrame *liveF = _dataSource[indexPath.section];
    //        FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
    //        footballDetailVc.matchID = liveF.live.match_id;
    //        footballDetailVc.type = _type;
    //        if ([liveF.live.state isEqualToString:@"W"]) {
    //            footballDetailVc.state = 1;
    //        }
    //        [footballDetailVc setHidesBottomBarWhenPushed:YES];
    //        [self.navigationController pushViewController:footballDetailVc animated:YES];
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
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)refreshData{
    
    self.isExpand = NO;
    self.selectedIndexPath = nil;

    [self setDataWithMatchID:0];
}

- (UITableView *)createTableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kSceenWidth, kSceenHeight-140) style:UITableViewStylePlain];
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        //        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark -- 分类即时比分变化数据请求
- (void)updateLastLive
{
    if (_type == 0) {
        [self loadFootballLive];
    } else if (_type == 1 || _type == 2) {
        //@194942|0:04|4|96|98|20|27|22|20|42(-5)|47(89)|27|25|27|26|96(-2)|98(194)||
        [self loadBasketballLive];
    }
}

// 篮球最新变化
- (void)loadBasketballLive {
//    NSInteger flagNum;
//    if (_type == 1) {
//        flagNum = _basketID;
//    } else if (_type == 2) {
//        flagNum = _tennisID;
//    }
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
        
    }failure:^(NSError *error) {
        
    } ];
}

// 获取足球最新变化
- (void)loadFootballLive{
    
    //1. url
    NSString *urlStr = [NSString stringWithFormat:@"http://s.likesport.com/updateData/%li.xml",(long)_matchID];
    
//    NSLog(@"follow之前ID=%li",(long)_matchID);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    //2. 请求
    //3. 连接
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"关注%@",data);
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
        if ([Rst isEqualToString:@"Y"] || [Rst isEqualToString:@"L"]) {
            GDataXMLElement *FnElement = [[user elementsForName:@"Fn"] objectAtIndex:0];
            NSString *Fn = [FnElement stringValue];
            [self setDataWithMatchID:[Fn intValue]];
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
                
                //
                //                NSLog(@"之前主队%ld",(long)liveF.live.total_h);
                //                NSLog(@"之前客队%ld",(long)liveF.live.total_c);
                //                liveF.live.isFootH = NO;
                //                liveF.live.isFootC = NO;
                //                // 设置比分变化标志
                //                if (liveF.live.total_h  < [_lastLive[2] integerValue]) {
                //                    liveF.live.isFootH = YES;
                //                }
                //
                //                if (liveF.live.total_c  < [_lastLive[3] integerValue]) {
                //                    liveF.live.isFootC = YES;
                //                }
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
                
//                [self.tableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
                    
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
        NSLog(@"添加关注定时器1");
    }
}

- (void)addMinuteTimer
{
    if (!_isMinuteTimer) {
        self.minuteTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.minuteTimer forMode:NSRunLoopCommonModes];
        _isMinuteTimer = YES;
        NSLog(@"添加关注定时器2");
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)removeTimer {
    if (_isTimer) {
        [self.timer invalidate];
        _isTimer = NO;
        NSLog(@"移除关注定时器1");
    }
    
}

- (void)removeMinuteTimer
{
    if (_isMinuteTimer) {
        [self.minuteTimer invalidate];
        _isMinuteTimer = NO;
        NSLog(@"移除关注定时器2");
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];

    [self addTimer];
    [self addMinuteTimer];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    BOOL isFollow = [defaults boolForKey:@"follow"];
    if (isFollow) {
        [self.tableView.mj_header beginRefreshing];
        [defaults setBool:NO forKey:@"follow"];
        [defaults synchronize];
    }
    
    self.scrollBar.hidden = YES;
//    NSLog(@"follow我出来了");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeTimer];
    [self removeMinuteTimer];
//    NSLog(@"follow我消失了");
    
    
}



@end
