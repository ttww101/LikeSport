//
//  ChooseCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/30.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "ChooseCell.h"
#import "KSChoose.h"
@interface ChooseCell()
@property (weak, nonatomic) IBOutlet UILabel *label;


@end
@implementation ChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self setFollowBtn];
    
    [self setChooseBtn];
    _followBtn.highlighted = YES;
//    [self setFlagView];
}


- (void)setMatch:(Matchtypes *)match {
    _match = match;
//    if (!_match.isMatch) {
//        _followBtn.hidden = YES;
//    }
    
    
    if (_match.is_follow == 0) {
        _followBtn.highlighted = YES;
    } else if (_match.is_follow == 1) {
        _followBtn.highlighted = NO;
    }
    
//    if (_match.isSelect) {
        _chooseBtn.highlighted = !_match.isSelect;
//    }
    
    _label.text = _match.name;
//    _flagView.image = [UIImage imageNamed:live.tsigncode];

}

//- (void)setFlagView{
//    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 18, 16)];
//    [self addSubview:flagView];
//    _flagView = flagView;
//}

- (void)setChooseBtn{
    UIButton *follow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    follow.frame = CGRectMake(kSceenWidth- 60, 0, 50, 40);
    [follow addTarget:self action:@selector(didClickedChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 图片不被渲染
    UIImage *image = [[UIImage imageNamed:@"checkTrue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [follow setImage:image forState:UIControlStateNormal];
//    UIImage *highImage = [[UIImage imageNamed:@"check_true-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [follow setImage:[UIImage imageNamed:@"checkFalse"] forState:UIControlStateHighlighted];
    //    [force setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    // [follow setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
        follow.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    //    [force setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateHighlighted];
    //    [force setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateHighlighted];
    _chooseBtn = follow;
    [self addSubview:follow];
}

- (void)didClickedChooseBtn:(id)sender
{
    
    ChooseCell *cell = (ChooseCell *)[sender superview];
    //获取table
//    UITableView *table = (UITableView *)[[cell superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    
    NSIndexPath *index = [table indexPathForCell:cell];
    //
    if ([self.delegate respondsToSelector:@selector(followMatch:indexPath:)]) {
        if (index) {
            
            [self.delegate chooseMatch:table indexPath:index];
        }
//        [self.delegate followMatch:table indexPath:index];
    }
    
}

- (void)setFollowBtn
{
    UIButton *follow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    follow.frame = CGRectMake(5, 0, 40, 40);
    [follow addTarget:self action:@selector(didClickedFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 图片不被渲染
    UIImage *image = [[UIImage imageNamed:@"followed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [follow setImage:image forState:UIControlStateNormal];
    [follow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateHighlighted];
    //    [force setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    // [follow setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
//    follow.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 10, 5);
    //    [force setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateHighlighted];
    //    [force setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateHighlighted];
    _followBtn = follow;
    [self addSubview:follow];
}

- (void)didClickedFollowBtn:(id)sender
{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    if (token.length > 0) {
        _followBtn.highlighted = !_followBtn.highlighted;
    } else {
        _followBtn.highlighted = YES;
    }
    ChooseCell *cell = (ChooseCell *)[sender superview];
    //获取table
    UITableView *table = (UITableView *)[[cell superview] superview];
    
    NSIndexPath *index = [table indexPathForCell:cell];
//
    if ([self.delegate respondsToSelector:@selector(followMatch:indexPath:)]) {
        if (index) {
            [self.delegate followMatch:table indexPath:index];
        }
    }
    
}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"chooseCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
