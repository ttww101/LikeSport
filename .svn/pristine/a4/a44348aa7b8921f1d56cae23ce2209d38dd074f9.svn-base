//
//  LeagueCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "LeagueCell.h"
@interface LeagueCell ()
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *matchNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end
@implementation LeagueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setFollowBtn];
//    _followBtn.highlighted = YES;
}

- (void)setFollowBtn
{
    UIButton *follow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    follow.frame = CGRectMake(kSceenWidth - 40, 0, 40, 30);
    [follow addTarget:self action:@selector(didClickedFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 图片不被渲染
    UIImage *image = [[UIImage imageNamed:@"followed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [follow setImage:image forState:UIControlStateNormal];
    [follow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateHighlighted];
    
    follow.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    //    [force setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateHighlighted];
    //    [force setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateHighlighted];
    _followBtn = follow;
    [self addSubview:follow];
}

- (void)didClickedFollowBtn:(id)sender
{
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
//    if (token.length > 0) {
//        _followBtn.highlighted = !_followBtn.highlighted;
//    } else {
//        _followBtn.highlighted = YES;
//    }
    LeagueCell *cell = (LeagueCell *)[sender superview];
    //获取table
    UITableView *table = (UITableView *)[[cell superview] superview];
    
    NSIndexPath *index = [table indexPathForCell:cell];
    //
    if ([self.delegate respondsToSelector:@selector(followMatch:indexPath:)]) {
        [self.delegate followMatch:table indexPath:index];
    }
    _followBtn.highlighted = !_followBtn.highlighted;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setT0:(T0 *)t0 {
    _t0 = t0;
    if ([t0.signcode isEqualToString:@"sa"] || [t0.signcode isEqualToString:@"fifa"]) {
        _flagImageView.image = [UIImage imageNamed:@"1"];
    } else {
        _flagImageView.image = [UIImage imageNamed:t0.signcode];
    }
    
    _matchNameLabel.text = t0.matchtypefullname;
    
    if (t0.is_follow == 0) {
        _followBtn.highlighted = NO;
    } else {
        _followBtn.highlighted = YES;
    }
}

- (void)setT1:(T0 *)t1 {
    _t1 = t1;
    if ([t1.signcode isEqualToString:@"sa"] || [t1.signcode isEqualToString:@"fifa"]) {
        _flagImageView.image = [UIImage imageNamed:@"1"];
    } else {
        _flagImageView.image = [UIImage imageNamed:t1.signcode];
    }
    
    _matchNameLabel.text = t1.teamname;
    
    if (t1.is_follow == 0) {
        _followBtn.highlighted = NO;
    } else {
        _followBtn.highlighted = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"leagueCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
@end
