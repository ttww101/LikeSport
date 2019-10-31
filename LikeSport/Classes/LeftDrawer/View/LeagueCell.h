//
//  LeagueCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@protocol LeagueCellDelegate <NSObject>

@optional
- (void)followMatch:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

@interface LeagueCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) T0 *t0; // 联赛
@property (nonatomic, strong) T0 *t1; // 球队

@property (weak, nonatomic) id<LeagueCellDelegate> delegate;

@end
