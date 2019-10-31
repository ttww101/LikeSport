//
//  KSScoreCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/23.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSScoreCell.h"
@interface KSScoreCell ()

@end
@implementation KSScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"scoreCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
