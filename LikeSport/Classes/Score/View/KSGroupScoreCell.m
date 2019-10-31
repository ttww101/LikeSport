//
//  KSGroupScoreCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/27.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSGroupScoreCell.h"
@interface KSGroupScoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *teamname;
@property (weak, nonatomic) IBOutlet UILabel *t_match;
@property (weak, nonatomic) IBOutlet UILabel *t_win;
@property (weak, nonatomic) IBOutlet UILabel *t_draw;
@property (weak, nonatomic) IBOutlet UILabel *t_loss;
@property (weak, nonatomic) IBOutlet UILabel *t_entermiss;
@property (weak, nonatomic) IBOutlet UILabel *t_jinsheng;
@property (weak, nonatomic) IBOutlet UILabel *Integral;


@end

@implementation KSGroupScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setXScore:(X_Score *)xScore {
    _xScore = xScore;
    if ([xScore.position intValue]== -1) {
        _position.text = NSLocalizedStringFromTable(@"Leave", @"InfoPlist", nil);
    } else {

        _position.text = xScore.position;
    }
    _teamname.text = xScore.teamname;
    _t_match.text = [NSString stringWithFormat:@"%li",(long)xScore.t_match];
    _t_win.text = [NSString stringWithFormat:@"%li",(long)xScore.t_win];
    _t_draw.text = [NSString stringWithFormat:@"%li",(long)xScore.t_draw];
    _t_loss.text = [NSString stringWithFormat:@"%li",(long)xScore.t_loss];
    _t_entermiss.text = [NSString stringWithFormat:@"%li/%li",(long)xScore.t_entergoals,(long)xScore.t_missgoals];
    _t_jinsheng.text = [NSString stringWithFormat:@"%li",(long)xScore.t_jinsheng];
    _Integral.text = [NSString stringWithFormat:@"%li",(long)xScore.Integral];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"groupScoreCell";
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
