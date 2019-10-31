//
//  KSBattleCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/24.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Pk_Data;
@class BasketPk_Data;

@interface KSBattleCell : UITableViewCell

@property (nonatomic, strong) Pk_Data *pkData;
@property (nonatomic, strong) BasketPk_Data *basketPkData;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
