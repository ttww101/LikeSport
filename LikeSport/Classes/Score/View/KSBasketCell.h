//
//  KSBasketCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/20.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSBasketCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hteam;
@property (weak, nonatomic) IBOutlet UILabel *cteam;
@property (weak, nonatomic) IBOutlet UILabel *time;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
