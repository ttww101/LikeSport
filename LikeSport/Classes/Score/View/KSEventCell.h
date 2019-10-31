//
//  KSEventCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/19.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSMore.h"
@interface KSEventCell : UITableViewCell
@property (nonatomic, strong) KSMore *more;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
