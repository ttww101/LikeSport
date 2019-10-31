//
//  KSSingleDoubleCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/31.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class O_H;
@interface KSSingleDoubleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, strong) O_H *oh;
@property (nonatomic, strong) O_H *oc;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
