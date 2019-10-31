//
//  KSGroupScoreCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/27.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSAnalyse.h"

@interface KSGroupScoreCell : UITableViewCell

@property (nonatomic, strong) X_Score *xScore;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
