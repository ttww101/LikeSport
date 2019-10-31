//
//  KSStatisticsCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/19.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSStatisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zhong;
@property (weak, nonatomic) IBOutlet UILabel *zuo;
@property (weak, nonatomic) IBOutlet UILabel *you;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
