//
//  KSGoalsCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/28.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class N_H;
@interface KSGoalsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hteam;
@property (weak, nonatomic) IBOutlet UILabel *cteam;
@property (nonatomic, strong) N_H *nh;
@property (nonatomic, strong) N_H *nc;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
