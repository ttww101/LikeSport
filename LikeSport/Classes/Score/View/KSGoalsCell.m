//
//  KSGoalsCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/28.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSGoalsCell.h"
#import "KSAnalyse.h"
@interface KSGoalsCell ()
@property (weak, nonatomic) IBOutlet UILabel *hHalf1;
@property (weak, nonatomic) IBOutlet UILabel *hHalf2;
@property (weak, nonatomic) IBOutlet UILabel *cHalf1;
@property (weak, nonatomic) IBOutlet UILabel *cHalf2;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *h;
@property (weak, nonatomic) IBOutlet UILabel *c;

@property (weak, nonatomic) IBOutlet UILabel *t_sH;
@property (weak, nonatomic) IBOutlet UILabel *t_xH;
@property (weak, nonatomic) IBOutlet UILabel *h_sH;
@property (weak, nonatomic) IBOutlet UILabel *h_xH;
@property (weak, nonatomic) IBOutlet UILabel *c_sH;
@property (weak, nonatomic) IBOutlet UILabel *c_xH;

@property (weak, nonatomic) IBOutlet UILabel *t_sC;
@property (weak, nonatomic) IBOutlet UILabel *t_xC;
@property (weak, nonatomic) IBOutlet UILabel *h_sC;
@property (weak, nonatomic) IBOutlet UILabel *h_xC;
@property (weak, nonatomic) IBOutlet UILabel *c_sC;
@property (weak, nonatomic) IBOutlet UILabel *c_xC;
@end

@implementation KSGoalsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _hHalf1.text = NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
    _hHalf2.text = NSLocalizedStringFromTable(@"2nd Half",  @"InfoPlist", nil);
    _cHalf1.text = NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
    _cHalf2.text = NSLocalizedStringFromTable(@"2nd Half",  @"InfoPlist", nil);
    _total.text = NSLocalizedStringFromTable(@"Total", @"InfoPlist", nil);
    _h.text = NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil);
    _c.text = NSLocalizedStringFromTable(@"Away", @"InfoPlist", nil);
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"goalsCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setNh:(N_H *)nh {
    _nh = nh;
    _t_sH.text = nh.t_s;
    _t_xH.text = nh.t_x;
    _h_sH.text = nh.h_s;
    _h_xH.text = nh.h_x;
    _c_sH.text = nh.c_s;
    _c_xH.text = nh.c_x;
    
}

- (void)setNc:(N_H *)nc {
    _nc = nc;
    _t_sC.text = nc.t_s;
    _t_xC.text = nc.t_x;
    _h_sC.text = nc.h_s;
    _h_xC.text = nc.h_x;
    _c_sC.text = nc.c_s;
    _c_xC.text = nc.c_x;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
