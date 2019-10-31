//
//  KSLineUpCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/19.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSFootballDetail.h"
@interface KSLineUpCell : UITableViewCell
@property (nonatomic, strong) Elected *elected;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
