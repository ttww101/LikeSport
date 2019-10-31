//
//  KSLiveCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/26.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLiveCell.h"
#import "KSLiveView.h"

#import "KSLive.h"
#import "KSLiveFrame.h"
#import "KSFootballExpansion.h"
#import "KSExpansionView.h"
#import "KSMore.h"
#import "BasketExpansionView.h"
#import "LoginViewController.h"
#import "KSTabBarController.h"
#import "KSNavigationController.h"

@interface KSLiveCell ()


@property(nonatomic,weak) KSExpansionView *expansionView;
@property (weak, nonatomic) KSFootballExpansion *footballExpansion;
@property (weak, nonatomic) BasketExpansionView *basketExpansion;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@end

@implementation KSLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [_liveView removeFromSuperview];
//       
//        _liveView = liveView;
        [self setUpAllChildView];

//        if (_liveView) {
            [self setMoreBtn:_moreBtn];
            
            [self setFollowBtn:_followBtn];
            
//        }
//        if (_liveF.live.type == 0) {
//            // 足球展开
//            KSFootballExpansion *footballExpansion = [[KSFootballExpansion alloc] init];
//            [self addSubview:footballExpansion];
//            footballExpansion.more = _liveF.live.more;
//            footballExpansion.hidden = YES;
//            _footballExpansion = footballExpansion;
////        } else {
//            KSExpansionView *expansionView = [[KSExpansionView alloc] initWithFrame:CGRectMake(0, 65, kSceenWidth, 60)];
//            [self addSubview:expansionView];
//            expansionView.hidden = YES;
//            _expansionView = expansionView;
//        }
    }
    
    return self;
}
- (void)setUpAllChildView{
    KSLiveView *liveView = [[KSLiveView alloc] init];
    [self addSubview:liveView];
    _liveView = liveView;
    
        // 足球展开
    KSFootballExpansion *footballExpansion = [[KSFootballExpansion alloc] init];
    footballExpansion.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [self addSubview:footballExpansion];
    footballExpansion.hidden = YES;
    _footballExpansion = footballExpansion;
    //    } else {
//    KSExpansionView *expansionView = [[KSExpansionView alloc] init];
//    expansionView.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    [self addSubview:expansionView];
//    expansionView.hidden = YES;
//    _expansionView = expansionView;
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 65, kSceenWidth, 1)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView];
    BasketExpansionView *basketExpansion = [[BasketExpansionView alloc] init];
    basketExpansion.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    [self addSubview:basketExpansion];
    basketExpansion.hidden = YES;
    _basketExpansion = basketExpansion;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [_liveView setMyLayout];
    }
    return self;
}

-(void)prepareForReuse {
    [_liveView setMyLayout];
}

- (void)setFollowBtn:(UIButton *)followBtn
{
    UIButton *follow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    follow.frame = CGRectMake(kSceenWidth - 40, 0, 40, 65);
    [follow addTarget:self action:@selector(didClickedFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [follow setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    
    // 图片不被渲染
    UIImage *image = [[UIImage imageNamed:@"starred"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [follow setImage:image forState:UIControlStateNormal];
    [follow setImage:[UIImage imageNamed:@"star"] forState:UIControlStateHighlighted];
    
    
//    follow.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 10, 5);
    follow.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    _followBtn = follow;
    [self addSubview:follow];
}

- (void)setMoreBtn:(UIButton *)moreBtn
{
    if (!_moreBtn) {
        UIButton *more = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        more.frame = CGRectMake(kSceenWidth - 85, 0, 45, 65);

        [more addTarget:self action:@selector(didClickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [more setImage:[UIImage imageNamed:@"DownAccessory"] forState:UIControlStateNormal];
        more.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);

//        [more setImage:[UIImage imageNamed:@"UpAccessory"] forState:UIControlStateHighlighted];

//        [more setBackgroundImage:[UIImage imageNamed:@"UpAccessory"] forState:UIControlStateHighlighted];
        [self addSubview:more];
        _moreBtn = more;
    }
}

- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    //获得UIImage实例
    [defaults synchronize];
}

- (void)didClickedFollowBtn:(id)sender
{
//    if (_followBtn.highlighted == 0) {
//        _followBtn.highlighted = YES;
//    } else if (_followBtn.highlighted == 1) {
//        _followBtn.highlighted = NO;
//    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    if (token.length > 0) {
    } else { // 跳转到登陆界面
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        loginVc.tokenBlock = ^(NSString *token){
            //            NSLog(@"loginToken%@",token);
            [self saveValue:token withKey:@"token"];
            //            [self getUserInfoWithToken:token];
            //            [self.tableView reloadData];
        };
        [loginVc setHidesBottomBarWhenPushed:YES];
        KSTabBarController *tabVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        KSNavigationController *NavVc = [tabVC selectedViewController];
        UIViewController *vc = [NavVc topViewController];
        [vc.navigationController pushViewController:loginVc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _followBtn.highlighted = YES;
        });
        
//        [sender setHighlighted:YES];

        return;
    }
    
    _followBtn.highlighted = !_followBtn.highlighted;
    
    
//    NSLog(@"hightted=%@",[_followBtn.highlighted?@"yes":@"no");
    
    KSLiveCell *cell = (KSLiveCell *)[sender superview];
    //获取table
    UITableView *table = (UITableView *)[cell superview];
    
    NSIndexPath *index = [table indexPathForCell:cell];

    if ([self.delegate respondsToSelector:@selector(followTable:indexPath:)]) {
        if (index) {

            [self.delegate followTable:table indexPath:index];
        }
    }
}

- (void)didClickedMoreBtn:(id)sender
{
    if (_liveF.isExpand) {
        if (_liveF.live.type == 0) {
//            _footballExpansion.hidden = NO;
//            // 足球展开
//            KSFootballExpansion *footballExpansion = [[KSFootballExpansion alloc] init];
//            [self addSubview:footballExpansion];
//            footballExpansion.more = _liveF.live.more;
//            _footballExpansion = footballExpansion;
//        } else {
//            KSExpansionView *expansionView = [[KSExpansionView alloc] initWithFrame:CGRectMake(0, 50, kSceenWidth, 50)];
//            [self addSubview:expansionView];
//            _expansionView = expansionView;
        } else {
//            _expansionView.hidden = NO;
        }
    } else {
//        _footballExpansion.hidden = YES;
//        _expansionView.hidden = YES;
//        [_footballExpansion removeFromSuperview];
//        [_expansionView removeFromSuperview];
    }

    if ([_liveF.live.state isEqualToString:@"W"] || [_liveF.live.state isEqualToString:@"C"] || [_liveF.live.state isEqualToString:@"Q"] || [_liveF.live.state isEqualToString:@"T"] || [_liveF.live.state isEqualToString:@"Y"] || [_liveF.live.state isEqualToString:@"D"]) {
        
    } else {
        KSLiveCell *cell = (KSLiveCell *)[sender superview];
        //获取table
        UITableView *table = (UITableView *)[[cell superview] superview];
        
        NSIndexPath *index = [table indexPathForCell:cell];
        //
        //    self.live.isOpen = !self.live.isOpen;
        //
        //    sender.selected = self.live.isOpen;
        
        if ([self.delegate respondsToSelector:@selector(moreTable:indexPath:)]) {
            if ([_liveF.live.state isEqualToString:@"W"]) {
               
            } else {
                if (index) {
                    [self.delegate moreTable:table indexPath:index];
                              // NSLog(@"log=%@",index);
                    _moreBtn.highlighted = !_moreBtn.highlighted;
                }
                
            }
            
        }
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"liveCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    return cell;
}

+ (instancetype)footballCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"footBallCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
    return cell;
}

/*
 问题：1.cell的高度应该提前计算出来
 2.cell的高度必须要先计算出每个子控件的frame，才能确定
 3.如果在cell的setStatus方法计算子控件的位置，会比较耗性能
 
 解决：MVVM思想
 M:模型
 V:视图
 VM:视图模型 （模型包装视图模型，模型+模型对应视图的frame）
 */

- (void)setLiveF:(KSLiveFrame *)liveF
{
    _liveF = liveF;
    
    if (liveF.isExpand) {
        if (liveF.live.type == 0) {
            _footballExpansion.frame = CGRectMake(0, 65, kSceenWidth, ([_liveF.live.more count]+1)*20+5);
            _footballExpansion.live = _liveF.live;
//            _footballExpansion.more = _liveF.live.more;
            _footballExpansion.hidden = NO;
            _basketExpansion.hidden = YES;
//            _expansionView.hidden = YES;
        } else if (liveF.live.type == 1 || liveF.live.type == 2) {
            _basketExpansion.frame = CGRectMake(0, 65, kSceenWidth, 60);
            _basketExpansion.live = _liveF.live;
            _basketExpansion.hidden = NO;
            _footballExpansion.hidden = YES;
//            _expansionView.hidden = YES;
        }
//        else {
//            _expansionView.frame = CGRectMake(0, 65, kSceenWidth, 60);
//            _expansionView.liveF = _liveF;
//            _expansionView.hidden = NO;
//            _footballExpansion.hidden = YES;
//            _basketExpansion.hidden = YES;
//        }
        
    } else {
        _footballExpansion.hidden = YES;
        _basketExpansion.hidden = YES;
//        if (liveF.live.type == 0) {
//            _footballExpansion.hidden = YES;
//        } else if (liveF.live.type == 1 || liveF.live.type == 2){
//            _basketExpansion.hidden = YES;
//        } else {
//            _expansionView.hidden = YES;
//        }
    }
    
    _liveView.frame = liveF.liveViewFrame;
    _liveView.liveF = liveF;
    _expansionView.frame = liveF.liveViewFrame;
    _expansionView.liveF = liveF;
    
    
    
    if (_liveF.live.is_follow == 0) {
        _followBtn.highlighted = YES;
    } else if (_liveF.live.is_follow == 1){
        _followBtn.highlighted = NO;
    }
    
    if ([_liveF.live.state isEqualToString:@"W"]) {
        _moreBtn.hidden = YES;
    }  else {
        _moreBtn.hidden = NO;
    }
    
    
    
    if (([_liveF.live.state isEqualToString:@"F"] || [_liveF.live.state isEqualToString:@"R"] || [_liveF.live.state isEqualToString:@"C"] || [_liveF.live.state isEqualToString:@"Q"] || [_liveF.live.state isEqualToString:@"T"] || [_liveF.live.state isEqualToString:@"Y"] || [_liveF.live.state isEqualToString:@"D"] || [_liveF.live.state isEqualToString:@"E"]) && !_liveF.live.isFollowView) {
        _moreBtn.frame = CGRectMake(kSceenWidth - 85, 0, 85, 65);
        _followBtn.hidden = YES;
    } else {
        _moreBtn.frame = CGRectMake(kSceenWidth - 85, 0, 45, 65);
        _followBtn.hidden = NO;
    }
    
    
}

- (void)setLive:(KSLive *)live
{
    _live = live;
    _footballExpansion.live = live;
    
}

- (void)setMore:(NSMutableArray<KSMore *> *)more
{
    _more = more;
    _footballExpansion.more = more;
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
//        [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"UpAccessory.png"] forState:UIControlStateNormal] ;
    }else
    {
//       [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"DownAccessory.png"] forState:UIControlStateNormal] ;
    }
}

//- (IBAction)didClickedMoreBtn:(UIButton *)sender {
//    //获取点击的button的父视图
//    KSLiveTableViewCell *cell = (KSLiveTableViewCell *)[[sender superview] superview];
//    //获取table
//    UITableView *table = (UITableView *)[[cell superview] superview];
//    
//    NSIndexPath *index = [table indexPathForCell:cell];
//    
//    NSLog(@"点击了第%li行",(long)index.row);
//    //
//    //    self.live.isOpen = !self.live.isOpen;
//    //
//    //    sender.selected = self.live.isOpen;
//    
//    
//    if ([self.delegate respondsToSelector:@selector(expansionTable:indexPath:)]) {
//        [self.delegate expansionTable:table indexPath:index];
//    }
//    
//}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted==YES) {
        [self.liveView setredcard:[UIColor redColor]];
    }
}



@end
