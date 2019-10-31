//
//  KSLiveTableViewCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLiveTableViewCell.h"
@interface KSLiveTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *matchtypefullname;
@property (weak, nonatomic) IBOutlet UILabel *halfcourttime;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *hteamname;
@property (weak, nonatomic) IBOutlet UILabel *cteamname;
@property (weak, nonatomic) IBOutlet UILabel *full_h;
@property (weak, nonatomic) IBOutlet UILabel *full_c;
@property (weak, nonatomic) IBOutlet UILabel *rcard_h;
@property (weak, nonatomic) IBOutlet UILabel *rcard_c;
@property (weak, nonatomic) IBOutlet UILabel *neutralgreen;


@property (weak, nonatomic) IBOutlet UIButton *forceBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end


@implementation KSLiveTableViewCell


- (void)setLive:(KSLive *)live {
    _live = live;
    
    


//    self.starttime.text = live.starttime;
    self.matchtypefullname.text = live.matchtypefullname;
    
    self.hteamname.text = live.hteamname;
    
    self.cteamname.text = live.cteamname;
    
    
    
    
    [self.full_h setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.full_c setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];



    // 是否中场
    if ([live.neutralgreen isEqualToString:@"[中]"]) {
        self.neutralgreen.text = [NSString stringWithFormat:@"[%@]",NSLocalizedStringFromTable(@"N", @"InfoPlist", nil)];
    } else {
        self.neutralgreen.hidden = YES;
    }
    
    
    
    // 红牌
    self.rcard_h.text = [NSString stringWithFormat:@"%li",(long)live.rcard_h];
    self.rcard_c.text = [NSString stringWithFormat:@"%li",(long)live.rcard_c];
    if (live.rcard_h > 0) {
        self.rcard_h.backgroundColor = [UIColor redColor];
        self.rcard_h.hidden = NO;
    } else {
        self.rcard_h.hidden = YES;

    }
    if (live.rcard_c > 0) {
        self.rcard_c.backgroundColor = [UIColor redColor];
        self.rcard_c.hidden = NO;
    } else {
        self.rcard_c.hidden = YES;
    }
    
    self.state.text = live.state;
    

    
}

- (IBAction)didClickedExpensionBtn:(UIButton *)sender {
    //获取点击的button的父视图
    KSLiveTableViewCell *cell = (KSLiveTableViewCell *)[[sender superview] superview];
    //获取table
    UITableView *table = (UITableView *)[[cell superview] superview];

    NSIndexPath *index = [table indexPathForCell:cell];
    
    NSLog(@"点击了第%li行",(long)index.row);
//    
//    self.live.isOpen = !self.live.isOpen;
//    
//    sender.selected = self.live.isOpen;
    
    
    if ([self.delegate respondsToSelector:@selector(expansionTable:indexPath:)]) {
        [self.delegate expansionTable:table indexPath:index];
    }
    
}


// 得分变色
- (void)changeColor {
    self.full_h.textColor = [UIColor blueColor];
    self.full_c.textColor = [UIColor blueColor];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
